# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=100 -resource-pressure=false -timeline -timeline-max-iterations=2 < %s | FileCheck %s

## Sets register RAX.
imulq $5, %rcx, %rax

## Kills the previous definition of RAX.
## The upper portion of RAX is cleared.
lzcnt %ecx, %eax

## The AND can start immediately after the LZCNT.
## It doesn't need to wait for the IMUL.
and   %rcx, %rax
bsf   %rax, %rcx

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      400
# CHECK-NEXT: Total Cycles:      663
# CHECK-NEXT: Total uOps:        1000

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    1.51
# CHECK-NEXT: IPC:               0.60
# CHECK-NEXT: Block RThroughput: 5.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      6     4.00                        imulq	$5, %rcx, %rax
# CHECK-NEXT:  1      1     0.50                        lzcntl	%ecx, %eax
# CHECK-NEXT:  1      1     0.50                        andq	%rcx, %rax
# CHECK-NEXT:  7      4     4.00                        bsfq	%rax, %rcx

# CHECK:      Timeline view:
# CHECK-NEXT:                     012345
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeER .    .   imulq	$5, %rcx, %rax
# CHECK-NEXT: [0,1]     DeE-----R .    .   lzcntl	%ecx, %eax
# CHECK-NEXT: [0,2]     .DeE-----R.    .   andq	%rcx, %rax
# CHECK-NEXT: [0,3]     . DeeeeE-R.    .   bsfq	%rax, %rcx
# CHECK-NEXT: [1,0]     .    D=eeeeeeER.   imulq	$5, %rcx, %rax
# CHECK-NEXT: [1,1]     .    .D=eE----R.   lzcntl	%ecx, %eax
# CHECK-NEXT: [1,2]     .    .D==eE----R   andq	%rcx, %rax
# CHECK-NEXT: [1,3]     .    . D==eeeeER   bsfq	%rax, %rcx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     1.5    0.5    0.0       imulq	$5, %rcx, %rax
# CHECK-NEXT: 1.     2     1.5    1.0    4.5       lzcntl	%ecx, %eax
# CHECK-NEXT: 2.     2     2.0    0.0    4.5       andq	%rcx, %rax
# CHECK-NEXT: 3.     2     2.0    0.0    0.5       bsfq	%rax, %rcx
# CHECK-NEXT:        2     1.8    0.4    2.4       <total>
