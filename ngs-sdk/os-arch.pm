sub OsArch {
    my ($UNAME, $HOST_OS, $HOST_ARCH, $MARCH);
    if ($^O eq 'MSWin32') {
        $UNAME = $HOST_OS = 'win';
    } else {
        $UNAME = `uname -s`;
        chomp $UNAME;
        if ($UNAME =~ /Darwin/) {
            $HOST_OS = 'mac';
        } elsif ($UNAME =~ /Linux/) {
            $HOST_OS = 'linux';
        } elsif ($UNAME =~ /SunOS/) {
            $HOST_OS = 'sun';
        } elsif ($UNAME =~ /xCYGWIN/) {
            $HOST_OS = 'win';
        } elsif ($UNAME =~ /xMINGW/) {
            $HOST_OS = 'win';
        }
        if ($HOST_OS eq 'mac') {
            $MARCH = $HOST_ARCH = MacArch();
        } else {
            $MARCH = `uname -m`;
            chomp $MARCH;
            if ($MARCH =~ /i386/) {
                $HOST_ARCH = 'i386';
            } elsif ($MARCH =~ /i486/) {
                $HOST_ARCH = 'i386';
            } elsif ($MARCH =~ /i586/) {
                $HOST_ARCH = 'i386';
            } elsif ($MARCH =~ /i686/) {
                if ($UNAME =~ /WOW64/) { # 64-bit capable Cygwin.
                     # Analyze the version of cl to set the correct architecture
                    my $CL = `cl.exe 2>&1 > /dev/null`;
                    if ($CL =~ /for x64/) {
                        $HOST_ARCH = 'x86_64';
                    } else {
                        $HOST_ARCH = 'i386';
                    }
                } else {
                    $HOST_ARCH = 'i386';
                }
            } elsif ($MARCH =~ /x86_64/) {
                $HOST_ARCH = 'x86_64';
            } elsif ($MARCH =~ /i86pc/) {
                $HOST_ARCH = 'x86_64';
            } elsif ($MARCH =~ /sun4v/) {
                $HOST_ARCH = 'sparc64';
            }
        }
    }
    ($HOST_OS, $HOST_ARCH, $UNAME, $MARCH);
}

sub MacArch {
    my $ARCH = `uname -m`;
    chomp $ARCH;
    if ($ARCH eq 'x86_64') {
        return $ARCH;
    } else {
        my $SYSCTL = '/usr/sbin/sysctl';
        $SYSCTL = '/sbin/sysctl' if (-x '/sbin/sysctl');

        my $CAP64 = `$SYSCTL -n hw.cpu64bit_capable`;
        chomp $CAP64;

        my $PADDR_BITS = `$SYSCTL -n machdep.cpu.address_bits.physical`;
        chomp $PADDR_BITS;

        my $VADDR_BITS = `$SYSCTL -n machdep.cpu.address_bits.virtual`;
        chomp $VADDR_BITS;
        
        if ($CAP64 != 0) {
            if ($PADDR_BITS > 32 && $VADDR_BITS > 32) {
                if ($ARCH eq 'i386' || $ARCH eq 'x86_64') {
                    return 'x86_64';
                } elsif ($ARCH eq 'Power Macintosh') {
                    return 'ppc64';
                } else {
                    return 'unrecognized';
                }
            }
        }

        if ($ARCH eq 'i386') {
            return 'i386';
        } elsif ($ARCH eq 'Power Macintosh') {
            return 'ppc32';
        } else {
            return 'unrecognized';
        }
    }
}

1
