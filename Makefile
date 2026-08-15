TABLES  := SSDT-CPU SSDT-PST SSDT-STUBS
AML     := $(addsuffix .aml,$(TABLES))
CPIO    := acpi_override.cpio
IASL    ?= iasl

all: $(CPIO)

$(CPIO): $(AML)
	mkdir -p kernel/firmware/acpi
	cp $(AML) kernel/firmware/acpi/
	find kernel | cpio -H newc --create > $@
	rm -rf kernel

%.aml: %.dsl
	$(IASL) -p $* $<
	@test -f $@ || { echo "iasl produced no $@"; exit 1; }

check: $(AML)

clean:
	rm -rf kernel $(AML) $(CPIO)

.PHONY: all check clean
