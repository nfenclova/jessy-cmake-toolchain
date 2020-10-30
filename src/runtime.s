.section .jessy_crti_init

.global _init
_init:
  pushq %rbp
  movq %rsp, %rbp

.section .jessy_crtn_init

  movq %rbp, %rsp
  popq %rbp
  retq

.section .jessy_crti_fini

.global _fini
_fini:
  pushq %rbp
  movq %rsp, %rbp

.section .jessy_crtn_fini

  movq %rbp, %rsp
  popq %rbp
  retq
