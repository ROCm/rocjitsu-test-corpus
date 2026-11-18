# Extracted unchanged from triton 675c59878aa2280b31f722aaf42b825fcee21de8 python/tutorials/gluon/02-layouts.py
from triton.experimental import gluon
from triton.experimental.gluon import language as gl

@gluon.jit
def memcpy_1d_kernel(in_ptr, out_ptr, xnumel, XBLOCK: gl.constexpr, layout: gl.constexpr):
    pid = gl.program_id(0)
    start = pid * XBLOCK

    # The main difference between writing this kernel in Triton and Gluon is
    # we need to specify the layout of the 1D tensor. Layouts are propagated
    # forwards through type inference, so we only need to specify the layout for
    # the indices tensor.
    indices = gl.arange(0, XBLOCK, layout=layout)

    offsets = start + indices
    in_ptrs = in_ptr + offsets
    mask = offsets < xnumel

    value = gl.load(in_ptrs, mask=mask)
    out_ptrs = out_ptr + offsets
    gl.store(out_ptrs, value, mask=mask)


@gluon.jit
def get_mask_and_offsets(start_x, start_y, xnumel, ynumel, xstride, ystride,  #
                         XBLOCK: gl.constexpr, YBLOCK: gl.constexpr, layout: gl.constexpr):
    indices_x = start_x + gl.arange(0, XBLOCK, layout=gl.SliceLayout(dim=1, parent=layout))
    indices_y = start_y + gl.arange(0, YBLOCK, layout=gl.SliceLayout(dim=0, parent=layout))

    mask = (indices_x[:, None] < xnumel) & (indices_y[None, :] < ynumel)
    offsets = xstride * indices_x[:, None] + ystride * indices_y[None, :]
    return mask, offsets


@gluon.jit
def memcpy_2d_inout_kernel(in_ptr, out_ptr,  #
                           xnumel, ynumel, xstride_in, ystride_in, xstride_out, ystride_out,  #
                           layout_in: gl.constexpr, layout_out: gl.constexpr,  #
                           XBLOCK: gl.constexpr, YBLOCK: gl.constexpr):
    pid_x = gl.program_id(0)
    pid_y = gl.program_id(1)

    start_x = pid_x * XBLOCK
    start_y = pid_y * YBLOCK

    # We need two sets of indices and masks for each layout. If the layouts
    # happen to be the same, the compiler will optimize away the extra code and
    # layout conversion.
    mask_in, in_offsets = get_mask_and_offsets(start_x, start_y, xnumel, ynumel, xstride_in, ystride_in,  #
                                               XBLOCK, YBLOCK, layout_in)
    mask_out, out_offsets = get_mask_and_offsets(start_x, start_y, xnumel, ynumel, xstride_out, ystride_out,  #
                                                 XBLOCK, YBLOCK, layout_out)

    value = gl.load(in_ptr + in_offsets, mask=mask_in)

    # Use `gl.convert_layout` to perform layout conversions.
    value = gl.convert_layout(value, layout_out)

    gl.store(out_ptr + out_offsets, value, mask=mask_out)
