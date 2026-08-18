// Replaces the stock idle state table, which never loads because it targets
// CPU definitions the firmware does not declare. This one covers the 16
// definitions that do exist.
//
// The header must keep the stock table's identifiers with a higher revision,
// or the kernel ignores this table.
//
// C2 uses the stock table's address despite the DSDT's processor block
// implying a different one. The C-state base address register (MSR
// 0xC0010073) reads 0x413, which places the idle registers at 0x414 and
// 0x415. C2's 400us latency is the stock value, conservative against measured
// wake times.
//
// C3 is published despite the FADT reporting it as unsupported, since the CPU
// enters it and exits with higher latency than C2, indicating a functional
// deeper state. C3's 600us latency is an estimated value, conservative
// against measured wake times.

DefinitionBlock ("", "SSDT", 1, "AMD", "AMD CPU", 0x00000002)
{
    External (\_PR.P000, ProcessorObj)
    External (\_PR.P001, ProcessorObj)
    External (\_PR.P002, ProcessorObj)
    External (\_PR.P003, ProcessorObj)
    External (\_PR.P004, ProcessorObj)
    External (\_PR.P005, ProcessorObj)
    External (\_PR.P006, ProcessorObj)
    External (\_PR.P007, ProcessorObj)
    External (\_PR.P008, ProcessorObj)
    External (\_PR.P009, ProcessorObj)
    External (\_PR.P00A, ProcessorObj)
    External (\_PR.P00B, ProcessorObj)
    External (\_PR.P00C, ProcessorObj)
    External (\_PR.P00D, ProcessorObj)
    External (\_PR.P00E, ProcessorObj)
    External (\_PR.P00F, ProcessorObj)

    Method (BCST, 0, NotSerialized)
    {
        Return (Package (0x04)
        {
            0x03,
            Package (0x04)
            {
                ResourceTemplate () { Register (FFixedHW, 0x02, 0x02, 0x0000000000000000,,) },
                0x01, 0x0001, 0x00000000
            },
            Package (0x04)
            {
                ResourceTemplate () { Register (SystemIO, 0x08, 0x00, 0x0000000000000414, 0x01,) },
                0x02, 0x0190, 0x00000000
            },
            Package (0x04)
            {
                ResourceTemplate () { Register (SystemIO, 0x08, 0x00, 0x0000000000000415, 0x01,) },
                0x03, 0x0258, 0x00000000
            }
        })
    }

    // One domain per physical core, both threads in it. Must match SSDT-PST.

    Scope (\_PR.P000)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000000, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P001)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000000, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P002)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000001, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P003)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000001, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P004)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000002, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P005)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000002, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P006)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000003, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P007)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000003, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P008)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000004, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P009)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000004, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P00A)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000005, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P00B)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000005, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P00C)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000006, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P00D)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000006, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P00E)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000007, 0x000000FE, 0x00000002 } })
    }

    Scope (\_PR.P00F)
    {
        Method (_CST, 0, NotSerialized) { Return (BCST ()) }
        Name (_CSD, Package (0x01) { Package (0x05) { 0x05, 0x00, 0x00000007, 0x000000FE, 0x00000002 } })
    }
}
