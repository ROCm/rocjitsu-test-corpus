// Copyright (c) 2026 Advanced Micro Devices, Inc.
// SPDX-License-Identifier: MIT
#pragma once
#include <algorithm>
#include <cmath>
#include <stdexcept>
#include <string>
#include <vector>

namespace full_tensile {
// Inputs have periods 11 in i and 13 in j, but independent q/t/b variation.
// The oracle reads real A/B storage, not a copied device indexing implementation.
// Every product and every partial sum is an exact FP32 integer: |sum| <= K*L*30+3.
struct Host {
    int m, n, k, l, batches, beta;
    bool tensor;
    std::vector<float> a, b, c, expected;
    size_t aindex(int i, int q, int t, int batch) const {
        return tensor ? q + size_t(k)*(i + size_t(m)*(t + size_t(l)*batch))
                      : i + size_t(m)*(q + size_t(k)*batch);
    }
    size_t bindex(int q, int j, int t, int batch) const {
        return q + size_t(k)*(j + size_t(n)*(t + size_t(l)*batch));
    }
    size_t cindex(int i, int j, int batch) const {
        return i + size_t(m)*(j + size_t(n)*batch);
    }
    Host(int mm, int nn, int kk, int ll, int bb, int be, bool tt)
        : m(mm), n(nn), k(kk), l(ll), batches(bb), beta(be), tensor(tt) {
        if(m<=0 || n<=0 || k<=0 || l<=0 || batches<=0 || (beta!=0 && beta!=1)
           || double(k)*l*30+3 >= 16777216 || (!tensor && l!=1))
            throw std::invalid_argument("unsupported exact reference dimensions");
        a.resize(size_t(m)*k*l*batches); b.resize(size_t(n)*k*l*batches);
        c.resize(size_t(m)*n*batches); expected.resize(c.size());
        for(int z=0;z<batches;z++) {
            for(int t=0;t<l;t++) for(int q=0;q<k;q++) {
                for(int i=0;i<m;i++) a[aindex(i,q,t,z)]=int((3*i+5*q+2*t+7*z)%11)-5;
                for(int j=0;j<n;j++) b[bindex(q,j,t,z)]=int((7*q+2*j+3*t+5*z)%13)-6;
            }
            for(int j=0;j<n;j++) for(int i=0;i<m;i++)
                c[cindex(i,j,z)]=int((i+3*j+5*z)%7)-3;
            // Cache only the dot product; C varies independently across all outputs.
            double dots[11][13]{};
            for(int i=0;i<std::min(m,11);i++) for(int j=0;j<std::min(n,13);j++)
                for(int t=0;t<l;t++) for(int q=0;q<k;q++)
                    dots[i][j]+=double(a[aindex(i,q,t,z)])*b[bindex(q,j,t,z)];
            for(int j=0;j<n;j++) for(int i=0;i<m;i++) {
                auto index=cindex(i,j,z);
                expected[index]=float(dots[i%11][j%13]+beta*double(c[index]));
            }
        }
    }
    void validate(const std::vector<float>& output) const {
        if(output.size()!=expected.size()) throw std::runtime_error("output size mismatch");
        for(size_t i=0;i<output.size();i++)
            if(!std::isfinite(output[i]) || output[i]!=expected[i])
                throw std::runtime_error("full output reference mismatch at "+std::to_string(i));
    }
};

// Callbacks make the timing boundary independently host-testable; launch includes
// the entire solution vector and synchronization, never only the split-K main.
template<class Reset, class Launch, class Validate, class Clock>
std::vector<long long> measure(int warmups, int samples, Reset reset, Launch launch,
                               Validate validate, Clock clock) {
    if(warmups<0 || samples<=0) throw std::invalid_argument("invalid sampling");
    std::vector<long long> result;
    for(int i=0;i<warmups+samples;i++) {
        reset();
        if(i<warmups) {launch(); validate(); continue;}
        auto begin=clock();
        launch();
        auto elapsed=clock()-begin;
        if(elapsed<=0) throw std::runtime_error("nonpositive host duration");
        validate();
        result.push_back(elapsed);
    }
    return result;
}
} // namespace full_tensile
