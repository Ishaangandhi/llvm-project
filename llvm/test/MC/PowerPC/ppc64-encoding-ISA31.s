# RUN: llvm-mc -triple powerpc64-unknown-linux-gnu --show-encoding %s | \
# RUN:   FileCheck -check-prefix=CHECK-BE %s
# RUN: llvm-mc -triple powerpc64le-unknown-linux-gnu --show-encoding %s | \
# RUN:   FileCheck -check-prefix=CHECK-LE %s

# CHECK-BE: plxv 63, 8589934591(0), 1       # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                         0xcf,0xe0,0xff,0xff]
# CHECK-LE: plxv 63, 8589934591(0), 1       # encoding: [0xff,0xff,0x11,0x04
# CHECK-LE-SAME:                                         0xff,0xff,0xe0,0xcf]
            plxv 63, 8589934591(0), 1
# CHECK-BE: plxv 33, -8589934592(31), 0     # encoding: [0x04,0x02,0x00,0x00
# CHECK-BE-SAME:                                         0xcc,0x3f,0x00,0x00]
# CHECK-LE: plxv 33, -8589934592(31), 0     # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                         0x00,0x00,0x3f,0xcc]
            plxv 33, -8589934592(31), 0
# CHECK-BE: pstxv 63, 8589934591(0), 1      # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                         0xdf,0xe0,0xff,0xff]
# CHECK-LE: pstxv 63, 8589934591(0), 1      # encoding: [0xff,0xff,0x11,0x04
# CHECK-LE-SAME:                                         0xff,0xff,0xe0,0xdf]
            pstxv 63, 8589934591(0), 1
# CHECK-BE: pstxv 33, -8589934592(31), 0    # encoding: [0x04,0x02,0x00,0x00
# CHECK-BE-SAME:                                         0xdc,0x3f,0x00,0x00]
# CHECK-LE: pstxv 33, -8589934592(31), 0    # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                         0x00,0x00,0x3f,0xdc]
            pstxv 33, -8589934592(31), 0
# CHECK-BE: paddi 1, 2, 8589934591, 0             # encoding: [0x06,0x01,0xff,0xff
# CHECK-BE-SAME:                                               0x38,0x22,0xff,0xff]
# CHECK-LE: paddi 1, 2, 8589934591, 0             # encoding: [0xff,0xff,0x01,0x06
# CHECK-LE-SAME:                                               0xff,0xff,0x22,0x38]
            paddi 1, 2, 8589934591, 0
# CHECK-BE: paddi 1, 0, -8589934592, 1            # encoding: [0x06,0x12,0x00,0x00
# CHECK-BE-SAME:                                               0x38,0x20,0x00,0x00]
# CHECK-LE: paddi 1, 0, -8589934592, 1            # encoding: [0x00,0x00,0x12,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x20,0x38]
            paddi 1, 0, -8589934592, 1
# CHECK-BE: pli 1, -8589934592                    # encoding: [0x06,0x02,0x00,0x00
# CHECK-BE-SAME:                                               0x38,0x20,0x00,0x00]
# CHECK-LE: pli 1, -8589934592                    # encoding: [0x00,0x00,0x02,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x20,0x38]
            pli 1, -8589934592
# CHECK-BE: pli 1, 8589934591                     # encoding: [0x06,0x01,0xff,0xff
# CHECK-BE-SAME:                                               0x38,0x20,0xff,0xff]
# CHECK-LE: pli 1, 8589934591                     # encoding: [0xff,0xff,0x01,0x06
# CHECK-LE-SAME:                                               0xff,0xff,0x20,0x38]
            pli 1, 8589934591
# CHECK-BE: pstfs 1, -134217728(3), 0             # encoding: [0x06,0x03,0xf8,0x00,
# CHECK-BE-SAME:                                               0xd0,0x23,0x00,0x00]
# CHECK-LE: pstfs 1, -134217728(3), 0             # encoding: [0x00,0xf8,0x03,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xd0]
            pstfs 1, -134217728(3), 0
# CHECK-BE: pstfs 1, 134217727(0), 1              # encoding: [0x06,0x10,0x07,0xff
# CHECK-BE-SAME:                                               0xd0,0x20,0xff,0xff]
# CHECK-LE: pstfs 1, 134217727(0), 1              # encoding: [0xff,0x07,0x10,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xd0]
            pstfs 1, 134217727(0), 1
# CHECK-BE: pstfd 1, -134217728(3), 0             # encoding: [0x06,0x03,0xf8,0x00,
# CHECK-BE-SAME:                                               0xd8,0x23,0x00,0x00]
# CHECK-LE: pstfd 1, -134217728(3), 0             # encoding: [0x00,0xf8,0x03,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xd8]
            pstfd 1, -134217728(3), 0
# CHECK-BE: pstfd 1, 134217727(0), 1              # encoding: [0x06,0x10,0x07,0xff
# CHECK-BE-SAME:                                               0xd8,0x20,0xff,0xff]
# CHECK-LE: pstfd 1, 134217727(0), 1              # encoding: [0xff,0x07,0x10,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xd8]
            pstfd 1, 134217727(0), 1
# CHECK-BE: pstxssp 1, -134217728(3), 0           # encoding: [0x04,0x03,0xf8,0x00,
# CHECK-BE-SAME:                                               0xbc,0x23,0x00,0x00]
# CHECK-LE: pstxssp 1, -134217728(3), 0           # encoding: [0x00,0xf8,0x03,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xbc]
            pstxssp 1, -134217728(3), 0
# CHECK-BE: pstxssp 1, 134217727(0), 1            # encoding: [0x04,0x10,0x07,0xff
# CHECK-BE-SAME:                                               0xbc,0x20,0xff,0xff]
# CHECK-LE: pstxssp 1, 134217727(0), 1            # encoding: [0xff,0x07,0x10,0x04,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xbc]
            pstxssp 1, 134217727(0), 1
# CHECK-BE: pstxsd 1, -134217728(3), 0            # encoding: [0x04,0x03,0xf8,0x00,
# CHECK-BE-SAME:                                               0xb8,0x23,0x00,0x00]
# CHECK-LE: pstxsd 1, -134217728(3), 0            # encoding: [0x00,0xf8,0x03,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xb8]
            pstxsd 1, -134217728(3), 0
# CHECK-BE: pstxsd 1, 134217727(0), 1             # encoding: [0x04,0x10,0x07,0xff
# CHECK-BE-SAME:                                               0xb8,0x20,0xff,0xff]
# CHECK-LE: pstxsd 1, 134217727(0), 1             # encoding: [0xff,0x07,0x10,0x04,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xb8]
            pstxsd 1, 134217727(0), 1
# CHECK-BE: plfs 1, -8589934592(3), 0             # encoding: [0x06,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xc0,0x23,0x00,0x00]
# CHECK-LE: plfs 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xc0]
            plfs 1, -8589934592(3), 0
# CHECK-BE: plfs 1, 8589934591(0), 1              # encoding: [0x06,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xc0,0x20,0xff,0xff]
# CHECK-LE: plfs 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xc0]
            plfs 1, 8589934591(0), 1
# CHECK-BE: plfd 1, -8589934592(3), 0             # encoding: [0x06,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xc8,0x23,0x00,0x00]
# CHECK-LE: plfd 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xc8]
            plfd 1, -8589934592(3), 0
# CHECK-BE: plfd 1, 8589934591(0), 1              # encoding: [0x06,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xc8,0x20,0xff,0xff]
# CHECK-LE: plfd 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xc8]
            plfd 1, 8589934591(0), 1
# CHECK-BE: plxssp 1, -8589934592(3), 0           # encoding: [0x04,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xac,0x23,0x00,0x00]
# CHECK-LE: plxssp 1, -8589934592(3), 0           # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xac]
            plxssp 1, -8589934592(3), 0
# CHECK-BE: plxssp 1, 8589934591(0), 1            # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xac,0x20,0xff,0xff]
# CHECK-LE: plxssp 1, 8589934591(0), 1            # encoding: [0xff,0xff,0x11,0x04,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xac]
            plxssp 1, 8589934591(0), 1
# CHECK-BE: plxsd 1, -8589934592(3), 0            # encoding: [0x04,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xa8,0x23,0x00,0x00]
# CHECK-LE: plxsd 1, -8589934592(3), 0            # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xa8]
            plxsd 1, -8589934592(3), 0
# CHECK-BE: plxsd 1, 8589934591(0), 1             # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xa8,0x20,0xff,0xff]
# CHECK-LE: plxsd 1, 8589934591(0), 1             # encoding: [0xff,0xff,0x11,0x04,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xa8]
            plxsd 1, 8589934591(0), 1
# CHECK-BE: pstb 1, -8589934592(3), 0             # encoding: [0x06,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0x98,0x23,0x00,0x00]
# CHECK-LE: pstb 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0x98]
            pstb 1, -8589934592(3), 0
# CHECK-BE: pstb 1, 8589934591(0), 1              # encoding: [0x06,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0x98,0x20,0xff,0xff]
# CHECK-LE: pstb 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0x98]
            pstb 1, 8589934591(0), 1
# CHECK-BE: psth 1, -8589934592(3), 0             # encoding: [0x06,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xb0,0x23,0x00,0x00]
# CHECK-LE: psth 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xb0]
            psth 1, -8589934592(3), 0
# CHECK-BE: psth 1, 8589934591(0), 1              # encoding: [0x06,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xb0,0x20,0xff,0xff]
# CHECK-LE: psth 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xb0]
            psth 1, 8589934591(0), 1
# CHECK-BE: pstw 1, -8589934592(3), 0             # encoding: [0x06,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0x90,0x23,0x00,0x00]
# CHECK-LE: pstw 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0x90]
            pstw 1, -8589934592(3), 0
# CHECK-BE: pstw 1, 8589934591(0), 1              # encoding: [0x06,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0x90,0x20,0xff,0xff]
# CHECK-LE: pstw 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x06,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0x90]
            pstw 1, 8589934591(0), 1
# CHECK-BE: pstd 1, -8589934592(3), 0             # encoding: [0x04,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xf4,0x23,0x00,0x00]
# CHECK-LE: pstd 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xf4]
            pstd 1, -8589934592(3), 0
# CHECK-BE: pstd 1, 8589934591(0), 1              # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xf4,0x20,0xff,0xff]
# CHECK-LE: pstd 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x04,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xf4]
            pstd 1, 8589934591(0), 1
# CHECK-BE: plbz 1, 8589934591(3), 0              # encoding: [0x06,0x01,0xff,0xff
# CHECK-BE-SAME:                                               0x88,0x23,0xff,0xff]
# CHECK-LE: plbz 1, 8589934591(3), 0              # encoding: [0xff,0xff,0x01,0x06
# CHECK-LE-SAME:                                               0xff,0xff,0x23,0x88]
            plbz 1, 8589934591(3), 0
# CHECK-BE: plbz 1, -8589934592(0), 1             # encoding: [0x06,0x12,0x00,0x00
# CHECK-BE-SAME:                                               0x88,0x20,0x00,0x00]
# CHECK-LE: plbz 1, -8589934592(0), 1             # encoding: [0x00,0x00,0x12,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x20,0x88]
            plbz 1, -8589934592(0), 1
# CHECK-BE: plhz 1, 8589934591(3), 0              # encoding: [0x06,0x01,0xff,0xff
# CHECK-BE-SAME:                                               0xa0,0x23,0xff,0xff]
# CHECK-LE: plhz 1, 8589934591(3), 0              # encoding: [0xff,0xff,0x01,0x06
# CHECK-LE-SAME:                                               0xff,0xff,0x23,0xa0]
            plhz 1, 8589934591(3), 0
# CHECK-BE: plhz 1, -8589934592(0), 1             # encoding: [0x06,0x12,0x00,0x00
# CHECK-BE-SAME:                                               0xa0,0x20,0x00,0x00]
# CHECK-LE: plhz 1, -8589934592(0), 1             # encoding: [0x00,0x00,0x12,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x20,0xa0]
            plhz 1, -8589934592(0), 1
# CHECK-BE: plha 1, 8589934591(3), 0              # encoding: [0x06,0x01,0xff,0xff
# CHECK-BE-SAME:                                               0xa8,0x23,0xff,0xff]
# CHECK-LE: plha 1, 8589934591(3), 0              # encoding: [0xff,0xff,0x01,0x06
# CHECK-LE-SAME:                                               0xff,0xff,0x23,0xa8]
            plha 1, 8589934591(3), 0
# CHECK-BE: plha 1, -8589934592(0), 1             # encoding: [0x06,0x12,0x00,0x00
# CHECK-BE-SAME:                                               0xa8,0x20,0x00,0x00]
# CHECK-LE: plha 1, -8589934592(0), 1             # encoding: [0x00,0x00,0x12,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x20,0xa8]
            plha 1, -8589934592(0), 1
# CHECK-BE: plwz 1, 8589934591(3), 0              # encoding: [0x06,0x01,0xff,0xff
# CHECK-BE-SAME:                                               0x80,0x23,0xff,0xff]
# CHECK-LE: plwz 1, 8589934591(3), 0              # encoding: [0xff,0xff,0x01,0x06
# CHECK-LE-SAME:                                               0xff,0xff,0x23,0x80]
            plwz 1, 8589934591(3), 0
# CHECK-BE: plwz 1, -8589934592(0), 1             # encoding: [0x06,0x12,0x00,0x00
# CHECK-BE-SAME:                                               0x80,0x20,0x00,0x00]
# CHECK-LE: plwz 1, -8589934592(0), 1             # encoding: [0x00,0x00,0x12,0x06
# CHECK-LE-SAME:                                               0x00,0x00,0x20,0x80]
            plwz 1, -8589934592(0), 1
# CHECK-BE: plwa 1, -8589934592(3), 0             # encoding: [0x04,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xa4,0x23,0x00,0x00]
# CHECK-LE: plwa 1, -8589934592(3), 0             # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xa4]
            plwa 1, -8589934592(3), 0
# CHECK-BE: plwa 1, 8589934591(0), 1              # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xa4,0x20,0xff,0xff]
# CHECK-LE: plwa 1, 8589934591(0), 1              # encoding: [0xff,0xff,0x11,0x04,
# CECHK-LE-SAME:                                               0xff,0xff,0x20,0xa4]
            plwa 1, 8589934591(0), 1
# CHECK-BE: pld 1, -8589934592(3), 0              # encoding: [0x04,0x02,0x00,0x00,
# CHECK-BE-SAME:                                               0xe4,0x23,0x00,0x00]
# CHECK-LE: pld 1, -8589934592(3), 0              # encoding: [0x00,0x00,0x02,0x04
# CHECK-LE-SAME:                                               0x00,0x00,0x23,0xe4]
            pld 1, -8589934592(3), 0
# CHECK-BE: pld 1, 8589934591(0), 1               # encoding: [0x04,0x11,0xff,0xff
# CHECK-BE-SAME:                                               0xe4,0x20,0xff,0xff]
# CHECK-LE: pld 1, 8589934591(0), 1               # encoding: [0xff,0xff,0x11,0x04,
# CHECK-LE-SAME:                                               0xff,0xff,0x20,0xe4]
            pld 1, 8589934591(0), 1
# CHECK-BE: vpdepd 1, 2, 0                        # encoding: [0x10,0x22,0x05,0xcd]
# CHECK-LE: vpdepd 1, 2, 0                        # encoding: [0xcd,0x05,0x22,0x10]
            vpdepd 1, 2, 0
# CHECK-BE: vpextd 1, 2, 0                        # encoding: [0x10,0x22,0x05,0x8d]
# CHECK-LE: vpextd 1, 2, 0                        # encoding: [0x8d,0x05,0x22,0x10]
            vpextd 1, 2, 0
# CHECK-BE: pdepd 1, 2, 4                         # encoding: [0x7c,0x41,0x21,0x38]
# CHECK-LE: pdepd 1, 2, 4                         # encoding: [0x38,0x21,0x41,0x7c]
            pdepd 1, 2, 4
# CHECK-BE: pextd 1, 2, 4                         # encoding: [0x7c,0x41,0x21,0x78]
# CHECK-LE: pextd 1, 2, 4                         # encoding: [0x78,0x21,0x41,0x7c]
            pextd 1, 2, 4
# CHECK-BE: vcfuged 1, 2, 4                       # encoding: [0x10,0x22,0x25,0x4d]
# CHECK-LE: vcfuged 1, 2, 4                       # encoding: [0x4d,0x25,0x22,0x10]
            vcfuged 1, 2, 4
# CHECK-BE: cfuged 1, 2, 4                        # encoding: [0x7c,0x41,0x21,0xb8]
# CHECK-LE: cfuged 1, 2, 4                        # encoding: [0xb8,0x21,0x41,0x7c]
            cfuged 1, 2, 4
# CHECK-BE: vgnb 1, 2, 2                          # encoding: [0x10,0x22,0x14,0xcc]
# CHECK-LE: vgnb 1, 2, 2                          # encoding: [0xcc,0x14,0x22,0x10]
            vgnb 1, 2, 2
# CHECK-BE: xxeval 32, 1, 2, 3, 2                 # encoding: [0x05,0x00,0x00,0x02,
# CHECK-BE-SAME:                                               0x88,0x01,0x10,0xd1]
# CHECK-LE: xxeval 32, 1, 2, 3, 2                 # encoding: [0x02,0x00,0x00,0x05,
# CHECK-LE-SAME:                                               0xd1,0x10,0x01,0x88]
            xxeval 32, 1, 2, 3, 2
# CHECK-BE: vclzdm 1, 2, 3                        # encoding: [0x10,0x22,0x1f,0x84]
# CHECK-LE: vclzdm 1, 2, 3                        # encoding: [0x84,0x1f,0x22,0x10]
            vclzdm 1, 2, 3
# CHECK-BE: vctzdm 1, 2, 3                        # encoding: [0x10,0x22,0x1f,0xc4]
# CHECK-LE: vctzdm 1, 2, 3                        # encoding: [0xc4,0x1f,0x22,0x10]
            vctzdm 1, 2, 3
# CHECK-BE: cntlzdm 1, 3, 2                       # encoding: [0x7c,0x61,0x10,0x76]
# CHECK-LE: cntlzdm 1, 3, 2                       # encoding: [0x76,0x10,0x61,0x7c]
            cntlzdm 1, 3, 2
# CHECK-BE: cnttzdm 1, 3, 2                       # encoding: [0x7c,0x61,0x14,0x76]
# CHECK-LE: cnttzdm 1, 3, 2                       # encoding: [0x76,0x14,0x61,0x7c]
            cnttzdm 1, 3, 2
# CHECK-BE: xxgenpcvbm 0, 1, 2                    # encoding: [0xf0,0x02,0x0f,0x28]
# CHECK-LE: xxgenpcvbm 0, 1, 2                    # encoding: [0x28,0x0f,0x02,0xf0]
            xxgenpcvbm 0, 1, 2
# CHECK-BE: xxgenpcvhm 0, 1, 2                    # encoding: [0xf0,0x02,0x0f,0x2a]
# CHECK-LE: xxgenpcvhm 0, 1, 2                    # encoding: [0x2a,0x0f,0x02,0xf0]
            xxgenpcvhm 0, 1, 2
# CHECK-BE: xxgenpcvwm 0, 1, 2                    # encoding: [0xf0,0x02,0x0f,0x68]
# CHECK-LE: xxgenpcvwm 0, 1, 2                    # encoding: [0x68,0x0f,0x02,0xf0]
            xxgenpcvwm 0, 1, 2
# CHECK-BE: xxgenpcvdm 0, 1, 2                    # encoding: [0xf0,0x02,0x0f,0x6a]
# CHECK-LE: xxgenpcvdm 0, 1, 2                    # encoding: [0x6a,0x0f,0x02,0xf0]
            xxgenpcvdm 0, 1, 2
# CHECK-BE: vclrlb 1, 4, 3                        # encoding: [0x10,0x24,0x19,0x8d]
# CHECK-LE: vclrlb 1, 4, 3                        # encoding: [0x8d,0x19,0x24,0x10]
            vclrlb 1, 4, 3
# CHECK-BE: vclrrb 1, 4, 3                        # encoding: [0x10,0x24,0x19,0xcd]
# CHECK-LE: vclrrb 1, 4, 3                        # encoding: [0xcd,0x19,0x24,0x10]
            vclrrb 1, 4, 3
