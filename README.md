# bc250-acpi-fix

ACPI table overrides providing CPU idle states and frequency scaling for the AMD BC-250 on Linux.

Works on stock 6-core and [unlocked](https://github.com/rw-r-r-0644/bc250-core-unlock) 8-core boards across all BIOS versions.

## Issues

1. The stock idle table targets CPU definitions the firmware does not declare, so it never loads.
2. Frequency scaling is not published at all, despite hardware support for eight states from 800 MHz to 3.2 GHz.
3. Some control methods the firmware calls are left undefined, producing ACPI errors at boot.

BIOS 1.00, 2.00, 3.00 and 5.00 share the same DSDT. This means updating the firmware does not help, but on the other hand that makes these tables compatible with all releases.

## Fixes

- **SSDT-CPU** replaces the broken idle state table.
- **SSDT-PST** publishes the frequency states.
- **SSDT-STUBS** defines the missing methods as no-ops.

The tables cover all 16 CPU definitions declared by the firmware (one per thread). Stock boards use 12, while unlocked boards use all of them.

## Installation

The tables are loaded from the initrd through [ACPI table upgrade](https://docs.kernel.org/admin-guide/acpi/initrd_table_override.html), which most distribution kernels enable via `CONFIG_ACPI_TABLE_UPGRADE`.

Prebuilt tables are attached to each release. To build from source, install `acpica` and run:

```sh
make
```

This generates the `.aml` tables and the `acpi_override.cpio` archive in the current directory.

Make sure to remove any previously installed tables before proceeding; duplicates will fail to load.

### GRUB

Note `tee -a`, not `tee`:

```sh
sudo cp acpi_override.cpio /boot/
echo 'GRUB_EARLY_INITRD_LINUX_CUSTOM="acpi_override.cpio"' | sudo tee -a /etc/default/grub
sudo update-grub
```

#### Fedora distributions (e.g., Nobara)

The path is relative to the GRUB config in `/boot/grub2/`.

```sh
sudo cp acpi_override.cpio /boot/
echo 'GRUB_EARLY_INITRD_LINUX_CUSTOM="../../acpi_override.cpio"' | sudo tee -a /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

#### Universal Blue distributions (e.g., Bazzite)

```sh
sudo cp acpi_override.cpio /boot/
echo 'GRUB_EARLY_INITRD_LINUX_CUSTOM="../../acpi_override.cpio"' | sudo tee -a /etc/default/grub
ujust regenerate-grub
```

### systemd-boot

Copy `acpi_override.cpio` to your EFI system partition, then add it as the first `initrd` line in your entry under `loader/entries/`:

```
title   Linux
linux   /vmlinuz-linux
initrd  /acpi_override.cpio
initrd  /initramfs-linux.img
options root=...
```

Paths are relative to the EFI system partition. Some distributions discard added lines when regenerating entries on kernel updates.

### mkinitcpio (e.g., CachyOS, Arch)

```sh
sudo mkdir -p /etc/initcpio/acpi_override
sudo cp SSDT-*.aml /etc/initcpio/acpi_override/
sudo sed -i '/^HOOKS=/ { /acpi_override/q; s/microcode/& acpi_override/; q }' /etc/mkinitcpio.conf
sudo mkinitcpio -P
```

Reboot to apply.

## Verification

```sh
sudo dmesg | grep -iE 'ACPI.*(SSDT|Table Upgrade)'
```

All three tables should load, with `AMD CPU` listed once as an override.

```sh
cpupower idle-info
```

Idle states should be POLL, C1 and C2, with C2 at address `0x414` and its usage rising while the board sits idle.

```sh
cpupower frequency-info
```

Frequency scaling should offer eight steps from 800 MHz to 3.2 GHz.

Cores idle at 800 MHz and boost to around 3.5 GHz under load, above the 3.2 GHz maximum the tables publish.

## Acknowledgements

- [shinf1x](https://github.com/bc250-collective/bc250-acpi-fix) for the original tables.
- [rw-r-r-0644](https://github.com/rw-r-r-0644/bc250-acpi-fix) for diagnosing and replacing the broken table, and for clearing the remaining ACPI errors.
- [mendesrr](https://github.com/mendesrr/bc250-acpi-fix-updated-8c) for extending the tables to 8 cores.

## License

[MIT](./LICENSE)
