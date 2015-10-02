Harmon_Kardon_Control-
======================

Perl script to control Harmon Kardon AVR3650, AVR365, AVR2650, AVR265
if you want to use a local serial port:
- set this line to your serial device:
- - my $port = new Device::SerialPort('/dev/ttyUSB1');
- comment this line:
- - $EnableTCP = "1"; my $port = &starttcp;
- Uncomment this line:
- - #$EnableTCP = "0"; my $port = &startserial;

If you want to use a remote serial port over tcp via ser2sock
- Uncomment this line:
- - $EnableTCP = "1"; my $port = &starttcp;
- comment this line:
- - #$EnableTCP = "0"; my $port = &startserial;
- Set this line to the IP address of the remote host running ser2sock
- - PeerAddr => '192.168.1.2'

To use the script:
- ./hkpl.pl cmd
- You can see a list of cmds in the "%CmdMsg" hash in the script
