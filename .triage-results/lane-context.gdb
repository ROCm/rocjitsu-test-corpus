# Dump the per-lane address array and lane mask of the faulting vector
# memory access, to see which lanes carry addresses outside any mapping.
set disable-randomization off
set pagination off
set confirm off

run

echo \n===== FAULT =====\n
printf "si_addr = %p\n", $_siginfo._sifields._sigfault.si_addr

echo \n===== STORE FRAME =====\n
frame function rocjitsu::amdgpu::L1VectorCache::store
up 2
info args
echo \n--- per-lane addresses ---\n
p/x *addrs@64

echo \n===== PIPELINE FRAME =====\n
frame function rocjitsu::amdgpu::GlobalMemPipeline::initiate_access
info args
p d
p wf.wf_size()
p inst.mnemonic()

quit
