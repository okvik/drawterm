const std = @import("std");

const Error = error{
    unsupported_os,
    unsupported_arch,
};

const Platform = enum {
    posix,
    win32,
};

const Gui = enum {
    x11,
    wl,
    win32,
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const platform = switch (target.getOsTag()) {
        .linux, .freebsd, .openbsd, .netbsd, .dragonfly => Platform.posix,
        .windows => Platform.win32,
        else => return Error.unsupported_os,
    };

    const cpu = switch (target.getCpuArch()) {
        .x86 => "386",
        .x86_64 => if (platform == .win32) "386" else "amd64",
        .arm => "arm",
        .aarch64 => "arm64",
        .riscv64 => "riscv64",
        else => return Error.unsupported_arch,
    };

    const gui = b.option(Gui, "gui", "GUI subsystem to use") orelse switch (platform) {
        .posix => Gui.x11,
        .win32 => Gui.win32,
    };

    const cflags = switch (platform) {
        .win32 => &[_][]const u8 {
            "-DWINDOWS",
            "-DUNICODE",
        },
        else => &[_][]const u8 {}
    };

    const libc = b.addStaticLibrary(.{
        .name = "libc",
        .target = target,
        .optimize = optimize,
    });

    libc.linkLibC();
    libc.addIncludePath(.{ .path = "include" });
    libc.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libc/atexit.c",
            "libc/charstod.c",
            "libc/cleanname.c",
            "libc/convD2M.c",
            "libc/convM2D.c",
            "libc/convM2S.c",
            "libc/convS2M.c",
            "libc/crypt.c",
            "libc/ctime.c",
            "libc/dial.c",
            "libc/dirfstat.c",
            "libc/dirfwstat.c",
            "libc/dirmodefmt.c",
            "libc/dirstat.c",
            "libc/dirwstat.c",
            "libc/dofmt.c",
            "libc/dorfmt.c",
            "libc/encodefmt.c",
            "libc/fcallfmt.c",
            "libc/fltfmt.c",
            "libc/fmt.c",
            "libc/fmtfd.c",
            "libc/fmtfdflush.c",
            "libc/fmtlock.c",
            "libc/fmtprint.c",
            "libc/fmtquote.c",
            "libc/fmtrune.c",
            "libc/fmtstr.c",
            "libc/fmtvprint.c",
            "libc/fprint.c",
            // "libc/frand.c",
            "libc/getenv.c",
            "libc/getfields.c",
            // "libc/lnrand.c",
            "libc/lock.c",
            // "libc/lrand.c",
            "libc/mallocz.c",
            // "libc/nan.h",
            "libc/nan64.c",
            "libc/netmkaddr.c",
            // "libc/nrand.c",
            "libc/nsec.c",
            "libc/pow10.c",
            // "libc/print.c",
            "libc/pushssl.c",
            "libc/pushtls.c",
            // "libc/rand.c",
            "libc/read9pmsg.c",
            "libc/readn.c",
            "libc/rune.c",
            "libc/runefmtstr.c",
            "libc/runeseprint.c",
            "libc/runesmprint.c",
            "libc/runesnprint.c",
            "libc/runesprint.c",
            // "libc/runestrcat.c",
            "libc/runestrchr.c",
            // "libc/runestrcmp.c",
            // "libc/runestrcpy.c",
            // "libc/runestrdup.c",
            // "libc/runestrecpy.c",
            "libc/runestrlen.c",
            // "libc/runestrncat.c",
            // "libc/runestrncmp.c",
            // "libc/runestrncpy.c",
            // "libc/runestrrchr.c",
            "libc/runestrstr.c",
            "libc/runetype.c",
            "libc/runevseprint.c",
            "libc/runevsmprint.c",
            "libc/runevsnprint.c",
            "libc/seprint.c",
            "libc/smprint.c",
            "libc/snprint.c",
            "libc/sprint.c",
            "libc/strecpy.c",
            "libc/strtod.c",
            "libc/strtoll.c",
            "libc/sysfatal.c",
            "libc/time.c",
            "libc/tokenize.c",
            "libc/truerand.c",
            "libc/u16.c",
            "libc/u32.c",
            "libc/u64.c",
            "libc/utfecpy.c",
            "libc/utflen.c",
            "libc/utfnlen.c",
            "libc/utfrrune.c",
            "libc/utfrune.c",
            "libc/utfutf.c",
            "libc/vfprint.c",
            "libc/vseprint.c",
            "libc/vsmprint.c",
            "libc/vsnprint.c",
        },
    });

    const kern = b.addStaticLibrary(.{
        .name = "kern",
        .target = target,
        .optimize = optimize,
    });
    kern.linkLibC();
    kern.addIncludePath(.{ .path = "include" });
    kern.addIncludePath(.{ .path = "kern" });
    kern.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "kern/allocb.c",
            "kern/alloc.c",
            "kern/chan.c",
            "kern/data.c",
            "kern/devaudio.c",
            // "kern/devaudio-none.c",
            // "kern/devaudio-alsa.c",
            // "kern/devaudio-pipewire.c",
            // "kern/devaudio-sndio.c",
            // "kern/devaudio-sun.c",
            // "kern/devaudio-unix.c",
            // "kern/devaudio-win32.c",
            "kern/dev.c",
            "kern/devcmd.c",
            "kern/devcons.c",
            "kern/devdraw.c",
            "kern/devenv.c",
            // "kern/devfs-posix.c",
            // "kern/devfs-win32.c",
            "kern/devip.c",
            // "kern/devip-posix.c",
            // "kern/devip-win32.c",
            "kern/devkbd.c",
            // "kern/devlfd-posix.c",
            // "kern/devlfd-win32.c",
            "kern/devmnt.c",
            "kern/devmouse.c",
            "kern/devpipe.c",
            "kern/devroot.c",
            "kern/devssl.c",
            "kern/devtab.c",
            "kern/devtls.c",
            "kern/error.c",
            // "kern/exportfs.c",
            "kern/parse.c",
            "kern/pgrp.c",
            // "kern/posix.c",
            "kern/procinit.c",
            "kern/qio.c",
            "kern/qlock.c",
            // "kern/rendez.c",
            "kern/rwlock.c",
            "kern/sleep.c",
            "kern/stub.c",
            "kern/sysfile.c",
            "kern/term.c",
            "kern/waserror.c",
            // "kern/win32.c",
        },
    });
    if (platform == .posix) {
        kern.addCSourceFiles(.{
            .flags = cflags,
            .files = &[_][]const u8{
                "kern/posix.c",
                "kern/devfs-posix.c",
                "kern/devip-posix.c",
                "kern/devlfd-posix.c",
            } });
        if (target.isLinux()) {
            kern.addCSourceFiles(.{ .flags = cflags, .files = &[_][]const u8{"kern/devaudio-pipewire.c"} });
            kern.linkSystemLibrary("libpipewire-0.3");
        } else {
            kern.addCSourceFiles(.{ .flags = cflags, .files = &[_][]const u8{"kern/devaudio-unix.c"} });
        }
    } else if (platform == .win32) {
        kern.addCSourceFiles(.{
            .flags = cflags,
            .files = &[_][]const u8{
                "kern/win32.c",
                "kern/devfs-win32.c",
                "kern/devip-win32.c",
                "kern/devlfd-win32.c",
                "kern/devaudio-win32.c",
            } });
    }

    const exportfs = b.addStaticLibrary(.{
        .name = "exportfs",
        .target = target,
        .optimize = optimize,
    });
    exportfs.linkLibC();
    exportfs.addIncludePath(.{ .path = "include" });
    exportfs.addIncludePath(.{ .path = "." });
    exportfs.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "exportfs/exportfs.c",
            "exportfs/exportsrv.c",
        } });

    const libsec = b.addStaticLibrary(.{
        .name = "libsec",
        .target = target,
        .optimize = optimize,
    });
    libsec.linkLibC();
    libsec.addIncludePath(.{ .path = "include" });
    libsec.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libsec/aes.c",
            "libsec/aesCBC.c",
            // "libsec/aesCFB.c",
            "libsec/aes_gcm.c",
            "libsec/aesni.c",
            // "libsec/aesOFB.c",
            // "libsec/aes_xts.c",
            // "libsec/blowfish.c",
            "libsec/ccpoly.c",
            "libsec/chachablock.c",
            "libsec/chacha.c",
            "libsec/curve25519.c",
            "libsec/curve25519_dh.c",
            // "libsec/decodepem.c",
            "libsec/des3CBC.c",
            "libsec/des.c",
            "libsec/desmodes.c",
            "libsec/dh.c",
            "libsec/ecc.c",
            "libsec/fastrand.c",
            "libsec/genrandom.c",
            "libsec/hkdf.c",
            "libsec/hmac.c",
            "libsec/jacobian.c",
            "libsec/md5block.c",
            "libsec/md5.c",
            "libsec/nfastrand.c",
            "libsec/pbkdf2.c",
            "libsec/poly1305.c",
            "libsec/prng.c",
            "libsec/rc4.c",
            // "libsec/readcert.c",
            "libsec/rsaalloc.c",
            "libsec/rsadecrypt.c",
            "libsec/rsaencrypt.c",
            "libsec/secp256k1.c",
            "libsec/secp256r1.c",
            "libsec/secp384r1.c",
            "libsec/sha1block.c",
            "libsec/sha1.c",
            "libsec/sha2_128.c",
            "libsec/sha2_64.c",
            "libsec/sha2block128.c",
            "libsec/sha2block64.c",
            // "libsec/thumb.c",
            "libsec/tlshand.c",
            "libsec/tsmemcmp.c",
            "libsec/x509.c",
        },
    });

    const libmp = b.addStaticLibrary(.{
        .name = "libmp",
        .target = target,
        .optimize = optimize,
    });
    libmp.linkLibC();
    libmp.addIncludePath(.{ .path = "include" });
    libmp.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libmp/betomp.c",
            "libmp/cnfield.c",
            "libmp/crt.c",
            // "libmp/crttest.c",
            "libmp/gmfield.c",
            "libmp/letomp.c",
            "libmp/mpadd.c",
            "libmp/mpaux.c",
            "libmp/mpcmp.c",
            "libmp/mpdigdiv.c",
            "libmp/mpdiv.c",
            "libmp/mpexp.c",
            "libmp/mpextendedgcd.c",
            "libmp/mpfactorial.c",
            "libmp/mpfield.c",
            "libmp/mpfmt.c",
            "libmp/mpinvert.c",
            "libmp/mpleft.c",
            "libmp/mplogic.c",
            "libmp/mpmod.c",
            "libmp/mpmodop.c",
            "libmp/mpmul.c",
            "libmp/mpnrand.c",
            "libmp/mprand.c",
            "libmp/mpright.c",
            "libmp/mpsel.c",
            "libmp/mpsub.c",
            "libmp/mptobe.c",
            "libmp/mptober.c",
            "libmp/mptoi.c",
            "libmp/mptole.c",
            "libmp/mptolel.c",
            "libmp/mptoui.c",
            "libmp/mptouv.c",
            "libmp/mptov.c",
            "libmp/mpvecadd.c",
            "libmp/mpveccmp.c",
            "libmp/mpvecdigmuladd.c",
            "libmp/mpvecsub.c",
            "libmp/mpvectscmp.c",
            "libmp/strtomp.c",
        },
    });

    const libauth = b.addStaticLibrary(.{
        .name = "libauth",
        .target = target,
        .optimize = optimize,
    });
    libauth.linkLibC();
    libauth.addIncludePath(.{ .path = "include" });
    libauth.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libauth/attr.c",
            "libauth/auth_attr.c",
            "libauth/auth_proxy.c",
            "libauth/auth_rpc.c",
        } });

    const libauthsrv = b.addStaticLibrary(.{
        .name = "libauthsrv",
        .target = target,
        .optimize = optimize,
    });
    libauthsrv.linkLibC();
    libauthsrv.addIncludePath(.{ .path = "include" });
    libauthsrv.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libauthsrv/_asgetpakkey.c",
            "libauthsrv/_asgetresp.c",
            "libauthsrv/_asgetticket.c",
            "libauthsrv/_asrdresp.c",
            "libauthsrv/_asrequest.c",
            // "libauthsrv/authdial.c",
            "libauthsrv/authpak.c",
            "libauthsrv/convA2M.c",
            "libauthsrv/convM2A.c",
            "libauthsrv/convM2PR.c",
            "libauthsrv/convM2T.c",
            "libauthsrv/convM2TR.c",
            "libauthsrv/convPR2M.c",
            "libauthsrv/convT2M.c",
            "libauthsrv/convTR2M.c",
            "libauthsrv/form1.c",
            "libauthsrv/nvcsum.c",
            "libauthsrv/passtokey.c",
            "libauthsrv/readcons.c",
            // "libauthsrv/readnvram.c",
        },
    });

    const libmemdraw = b.addStaticLibrary(.{
        .name = "libmemdraw",
        .target = target,
        .optimize = optimize,
    });
    libmemdraw.linkLibC();
    libmemdraw.addIncludePath(.{ .path = "include" });
    libmemdraw.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libmemdraw/alloc.c",
            "libmemdraw/arc.c",
            "libmemdraw/cload.c",
            "libmemdraw/cmap.c",
            "libmemdraw/cread.c",
            "libmemdraw/defont.c",
            "libmemdraw/draw.c",
            "libmemdraw/ellipse.c",
            "libmemdraw/fillpoly.c",
            "libmemdraw/hwdraw.c",
            "libmemdraw/line.c",
            "libmemdraw/load.c",
            // "libmemdraw/mkcmap.c",
            "libmemdraw/openmemsubfont.c",
            "libmemdraw/poly.c",
            "libmemdraw/read.c",
            "libmemdraw/string.c",
            "libmemdraw/subfont.c",
            "libmemdraw/unload.c",
            "libmemdraw/write.c",
        },
    });

    const libmemlayer = b.addStaticLibrary(.{
        .name = "libmemlayer",
        .target = target,
        .optimize = optimize,
    });
    libmemlayer.linkLibC();
    libmemlayer.addIncludePath(.{ .path = "include" });
    libmemlayer.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libmemlayer/draw.c",
            "libmemlayer/lalloc.c",
            "libmemlayer/layerop.c",
            "libmemlayer/ldelete.c",
            "libmemlayer/lhide.c",
            "libmemlayer/line.c",
            "libmemlayer/load.c",
            "libmemlayer/lorigin.c",
            "libmemlayer/lsetrefresh.c",
            "libmemlayer/ltofront.c",
            "libmemlayer/ltorear.c",
            "libmemlayer/unload.c",
        } });

    const libdraw = b.addStaticLibrary(.{
        .name = "libdraw",
        .target = target,
        .optimize = optimize,
    });
    libdraw.linkLibC();
    libdraw.addIncludePath(.{ .path = "include" });
    libdraw.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libdraw/alloc.c",
            "libdraw/arith.c",
            "libdraw/badrect.c",
            "libdraw/bytesperline.c",
            "libdraw/chan.c",
            "libdraw/defont.c",
            "libdraw/drawrepl.c",
            "libdraw/fmt.c",
            "libdraw/icossin2.c",
            "libdraw/icossin.c",
            "libdraw/rectclip.c",
            "libdraw/rgb.c",
        } });

    const libip = b.addStaticLibrary(.{
        .name = "libip",
        .target = target,
        .optimize = optimize,
    });
    libip.linkLibC();
    libip.addIncludePath(.{ .path = "include" });
    libip.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "libip/bo.c",
            "libip/classmask.c",
            "libip/eipfmt.c",
            "libip/ipaux.c",
            "libip/parseip.c",
        } });

    const gui_lib = b.addStaticLibrary(.{
        .name = "gui_lib",
        .target = target,
        .optimize = optimize,
    });
    switch (gui) {
        .x11 => {
            gui_lib.linkLibC();
            gui_lib.linkSystemLibrary("X11");
            gui_lib.addIncludePath(.{ .path = "include" });
            gui_lib.addIncludePath(.{ .path = "kern" });
            gui_lib.addCSourceFiles(.{
                .flags = cflags,
                .files = &[_][]const u8{
                    "gui-x11/keysym2ucs-x11.c",
                    "gui-x11/x11.c",
                } });
        },
        .wl => {
            // TODO
            unreachable;
        },
        .win32 => {
            gui_lib.linkLibC();
            gui_lib.addIncludePath(.{ .path = "include" });
            gui_lib.addIncludePath(.{ .path = "kern" });
            gui_lib.addIncludePath(.{ .path = "." });
            gui_lib.addCSourceFiles(.{
                .flags = cflags,
                .files = &[_][]const u8{
                    "gui-win32/screen.c",
                } });
        },
    }

    const libmachdep = b.addStaticLibrary(.{
        .name = "libmachdep",
        .target = target,
        .optimize = optimize,
    });
    libmachdep.linkLibC();
    libmachdep.addIncludePath(.{ .path = "include" });
    libmachdep.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            std.fmt.allocPrintZ(b.allocator, "{s}-{s}/getcallerpc.c", .{ @tagName(platform), cpu }) catch unreachable,
            std.fmt.allocPrintZ(b.allocator, "{s}-{s}/tas.c", .{ @tagName(platform), cpu }) catch unreachable,
        } });

    const drawterm = b.addExecutable(.{
        .name = "drawterm",
        .target = target,
        .optimize = optimize,
    });
    drawterm.linkLibC();
    drawterm.linkLibrary(libc);
    drawterm.linkLibrary(kern);
    drawterm.linkLibrary(exportfs);
    drawterm.linkLibrary(libsec);
    drawterm.linkLibrary(libmp);
    drawterm.linkLibrary(libauth);
    drawterm.linkLibrary(libauthsrv);
    drawterm.linkLibrary(libmemdraw);
    drawterm.linkLibrary(libmemlayer);
    drawterm.linkLibrary(libdraw);
    drawterm.linkLibrary(libip);
    drawterm.linkLibrary(gui_lib);
    drawterm.linkLibrary(libmachdep);
    switch (platform) {
        .win32 => {
            switch (target.getCpuArch()) {
                .x86 => {
                    gui_lib.linkSystemLibrary("kernel32");
                    gui_lib.linkSystemLibrary("advapi32");
                    gui_lib.linkSystemLibrary("gdi32");
                    gui_lib.linkSystemLibrary("mpr");
                    gui_lib.linkSystemLibrary("wsock32");
                    gui_lib.linkSystemLibrary("ws2_32");
                    gui_lib.linkSystemLibrary("msvcrt");
                    gui_lib.linkSystemLibrary("mingw32");
                    gui_lib.linkSystemLibrary("winmm");
                },
                .x86_64 => {
                    gui_lib.linkSystemLibrary("gdi32");
                    gui_lib.linkSystemLibrary("ws2_32");
                    gui_lib.linkSystemLibrary("winmm");
                },
                else => return Error.unsupported_arch
            }
            drawterm.addWin32ResourceFile(.{ .file = .{ .path = "drawterm.rc" } });
        },
        else => {}
    }
    drawterm.addIncludePath(.{ .path = "include" });
    drawterm.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            "main.c",
            "cpu.c",
            "aan.c",
            "secstore.c",
            "latin1.c",
        } });
    drawterm.addCSourceFiles(.{
        .flags = cflags,
        .files = &[_][]const u8{
            std.fmt.allocPrintZ(b.allocator, "{s}-factotum.c", .{@tagName(platform)}) catch unreachable
        } });

    b.installArtifact(drawterm);
}
