# Catch the simulator SIGSEGV and dump the faulting GPU address, the
# translation arguments, and the process mappings at fault time.
# ASLR stays on because the crash does not reproduce without it.
set disable-randomization off
set pagination off
set confirm off
set follow-fork-mode child
set detach-on-fork off

run

echo \n===== FAULT =====\n
printf "si_addr = %p\n", $_siginfo._sifields._sigfault.si_addr
echo \n===== BACKTRACE =====\n
bt 25
echo \n===== TRANSLATION FRAMES =====\n
frame function rocjitsu::amdgpu::GpuMemory::read_mapped
info args
echo \n===== READ_BLOCK FRAME =====\n
frame function rocjitsu::amdgpu::GpuMemory::read_block
info args
echo \n===== L2 SEND_BACKING FRAME =====\n
frame function rocjitsu::amdgpu::L2Cache::send_backing
info args
echo \n===== MAPPINGS =====\n
info proc mappings
quit
