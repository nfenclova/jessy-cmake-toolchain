ENTRY(main)

SECTIONS
{
  .init ALIGN(4K) : AT(ADDR (.init))
  {
    KEEP(*(.jessy_crti_init))
    KEEP(*(.init))
    KEEP(*(.jessy_crtn_init))
  }

  .fini ALIGN(4K) : AT(ADDR (.fini))
  {
    KEEP(*(.jessy_crti_fini))
    KEEP(*(.fini))
    KEEP(*(.jessy_crtn_fini))
  }

  .text ALIGN(4K) : AT(ADDR (.text))
  {
    *(.text*)
  }

  .rodata ALIGN(4K) : AT (ADDR (.rodata))
  {
    *(.rodata)
    *(.rodata.*)
  }

  .ctors ALIGN(4K) : AT (ADDR (.ctors))
  {
    KEEP(*crtbegin.o(.ctors))
    KEEP(*(EXCLUDE_FILE (*crtend.o) .ctors))
    KEEP(*(SORT(.ctors.*)))
    KEEP(*crtend.o(.ctors))
  }

  .dtors ALIGN(4K) : AT (ADDR (.dtors))
  {
    KEEP(*crtbegin.o(.dtors))
    KEEP(*(EXCLUDE_FILE (*crtend.o) .dtors))
    KEEP(*(SORT(.dtors.*)))
    KEEP(*crtend.o(.dtors))
  }

  .data ALIGN(4K) : AT (ADDR (.data))
  {
    *(.data)
  }

  .bss ALIGN(4K) : AT (ADDR (.bss))
  {
    *(COMMON)
    *(.bss*)
  }
}
