Harmon_Kardon_Control-
======================

Perl script to control Harmon Kardon AVR3650, AVR365, AVR2650, AVR265

if you want to use a local serial port:
- comment this line:
- - #use IO::Socket; $EnableTCP = "1"; my $port = &starttcp('192.168.1.10','36000');
- Uncomment this line and set your serial deivce:
- - use Device::SerialPort; $EnableTCP = "0"; my $port = &startserial('/dev/ttyUSB1');

If you want to use a remote serial port over tcp via ser2sock
- Uncomment this line and Set the IP address/port of the remote host running ser2sock::
- - use IO::Socket; $EnableTCP = "1"; my $port = &starttcp('192.168.1.10','36000'); 
- comment this line:
- - #use Device::SerialPort; $EnableTCP = "0"; my $port = &startserial('/dev/ttyUSB1');

To use the script:
- ./hkpl.pl cmd
- You can see a list of cmds in the "%CmdMsg" hash in the script


You can get ser2sock from here:
https://github.com/f34rdotcom/ser2sock/tree/binary_mode

use the following settings for ser2sock:

[ser2sock]
- Fork into the background?  Default: 0
daemonize = 1

- Serial device, Set to your serial device.
device = /dev/ttyAMA0

- Serial device baudrate
baudrate = 57600

- Port to listen for connections on.  Default: 10000
port = 36000

- This must be enabled in order to use with the hkpl script.
raw_device_mode = 1
