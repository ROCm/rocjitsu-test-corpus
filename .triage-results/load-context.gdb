# Dump the per-lane address array of a faulting vector load.
set disable-randomization off
set pagination off
set confirm off

run

echo \n===== FAULT =====\n
printf "si_addr = %p\n", $_siginfo._sifields._sigfault.si_addr

echo \n===== LOAD FRAME =====\n
frame function rocjitsu::amdgpu::L1VectorCache::load
up 2
info args
echo \n--- per-lane addresses ---\n
p/x *addrs@64

echo \n===== PIPELINE FRAME =====\n
frame function rocjitsu::amdgpu::GlobalMemPipeline::initiate_access
p d

quit
