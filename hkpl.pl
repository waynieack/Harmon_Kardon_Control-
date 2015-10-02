#!/usr/bin/perl

#############################################################################
# Name: hkpl.pl Harmon Kardon Control
#
# Description: This script is able to control Harmon Kardon AVR3650, AVR365, AVR2650, AVR265
# via the serial port
#
# Depends IO::Socket
#
# Author: Wayne Gatlin (wayne@razorcla.ws)
# $Revision: $
# $Date: $
#
##############################################################################
# Copyright       Wayne Gatlin, 2013, All rights reserved
##############################################################################
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
###############################################################################

#use Digest::CRC qw(crc);
#use Device::SerialPort;
use IO::Socket;
my $EnableTCP; my $AckMsg;

#$EnableTCP = "0"; my $port = &startserial;
$EnableTCP = "1"; my $port = &starttcp;

my $ResponseTimeout = "10";
my $DEBUG = "0";
my $CmdArg = $ARGV[0];

%CmdMsg = (
"ON" => "8070C03F404F",
"OFF" => "80709F601F10",
"ON_Z2" => "807000000A00",
"OFF_Z2" => "807000001B00",
"GET_PWR_STAT" => "807000003600",
"GET_VOL_STAT" => "807000003700",
"GET_BASS_STAT" => "807000003800",
"GET_MUTE_STAT" => "807000003A00",
"SIRIUS_TUNE_UP" => "807000003200",
"SIRIUS_TUNE_DOWN" => "807000003300",
"AM_BAND" => "807000001201",
"FM_BAND" => "807000001202",
"SIRIUS_BAND" => "807000001203",
"VOL_UP" => "8070C7384748",
"VOL_DOWN" => "8070C8374847",
"MUTE" => "8070C13E414E",
"VOL_UP_Z2" => "86762BD4ADA2",
"VOL_DOWN_Z2" => "86762CD3AAA5",
"MUTE_Z2" => "86762AD5ACA3",
"MENU" => "807000002100",
"UP" => "807000002200",
"DOWN" => "807000002300",
"LEFT" => "807000002400",
"RIGHT" => "807000002500",
"OK" => "807000002600",
"0" => "807000003C00",
"1" => "807000003D00",
"2" => "807000003E00",
"3" => "807000003F00",
"4" => "807000004000",
"5" => "807000004100",
"6" => "807000004200",
"7" => "807000004200",
"8" => "807000004400",
"9" => "807000004500",
"MENU_Z2" => "807000002700",
"UP_Z2" => "807000002800",
"DOWN_Z2" => "807000002900",
"LEFT_Z2" => "807000002A00",
"RIGHT_Z2" => "807000002B00",
"OK_Z2" => "807000002C00",
"0_Z2" => "807000004600",
"1_Z2" => "807000004700",
"2_Z2" => "807000004800",
"3_Z2" => "807000004900",
"4_Z2" => "807000004A00",
"5_Z2" => "807000004B00",
"6_Z2" => "807000004C00",
"7_Z2" => "807000004D00",
"8_Z2" => "807000004E00",
"9_Z2" => "807000004F00",
"SAT" => "807000000901",
"BLURAY" => "807000000902",
"BRIDGE" => "807000000903",
"DVR" => "807000000904",
"SIRIUS" => "807000000906",
"FM" => "807000000907",
"AM" => "807000000908",
"TV" => "807000000909",
"GAME" => "80700000090A",
"MEDIA" => "80700000090B",
"AUX" => "80700000090C",
"INET_RADIO" => "80700000090D",
"NETWORK" => "80700000090E",
"SRC_A" => "80700000090F",
"SRC_B" => "807000000910",
"SRC_C" => "807000000911",
"SRC_D" => "807000000912",
"SAT_Z2" => "867600001B01",
"BLURAY_Z2" => "867600001B02",
"BRIDGE_Z2" => "867600001B03",
"DVR_Z2" => "867600001B04",
"SIRIUS_Z2" => "867600001B06",
"FM_Z2" => "867600001B07",
"AM_Z2" => "867600001B08",
"TV_Z2" => "867600001B09",
"GAME_Z2" => "867600001B0A",
"MEDIA_Z2" => "867600001B0B",
"AUX_Z2" => "867600001B0C",
"INET_RADIO_Z2" => "867600001B0D",
"NETWORK_Z2" => "867600001B0E",
"SRC_A_Z2" => "867600001B0F",
"SRC_B_Z2" => "867600001B10",
"SRC_C_Z2" => "867600001B11",
"SRC_D_Z2" => "867600001B12",
);

%CmdAck = (
"41565241434B020110" => "Z1_ON Z2_OFF",
"41565241434B020111" => "Z1_ON Z2_ON",
"41565241434B020100" => "Z1_OFF Z2_OFF",
"41565241434B020101" => "Z1_OFF Z2_ON",
"41565241434B0311" => "VOL_ACK",
"41565241434B0202" => "VOL_TOG_ACK",
"41565241434B0209" => "Z2_VOL_ACK",
"41565241434B020300" => "MUTE_TOG_OFF",
"41565241434B020301" => "MUTE_TOG_ON",
"41565241434B020A00" => "Z2_MUTE_TOG_OFF",
"41565241434B020A01" => "Z2_MUTE_TOG_ON",
"41565241434B03140100" => "Z1_MUTE_ON Z2_MUTE_OFF",
"41565241434B03140101" => "Z1_MUTE_ON Z2_MUTE_ON",
"41565241434B03140001" => "Z1_MUTE_OFF Z2_MUTE_ON",
"41565241434B03140000" => "Z1_MUTE_OFF Z2_MUTE_OFF",
"41565241434B020401" => "SAT" ,
"41565241434B020402" => "BLURAY",
"41565241434B020403" => "BRIDGE",
"41565241434B020404" => "DVR",
"41565241434B020406" => "SIRIUS",
"41565241434B020407" => "FM",
"41565241434B020408" => "AM",
"41565241434B020409" => "TV",
"41565241434B02040A" => "GAME",
"41565241434B02040B" => "MEDIA",
"41565241434B02040C" => "AUX",
"41565241434B02040D" => "INET_RADIO",
"41565241434B02040E" => "NETWORK",
"41565241434B02040F" => "SRC_A",
"41565241434B020410" => "SRC_B",
"41565241434B020411" => "SRC_C",
"41565241434B020412" => "SRC_D",
"41565241434B020801" => "SAT_Z2" ,
"41565241434B020802" => "BLURAY_Z2",
"41565241434B020803" => "BRIDGE_Z2",
"41565241434B020804" => "DVR_Z2",
"41565241434B020806" => "SIRIUS_Z2",
"41565241434B020807" => "FM_Z2",
"41565241434B020808" => "AM_Z2",
"41565241434B020809" => "TV_Z2",
"41565241434B02080A" => "GAME_Z2",
"41565241434B02080B" => "MEDIA_Z2",
"41565241434B02080C" => "AUX_Z2",
"41565241434B02080D" => "INET_RADIO_Z2",
"41565241434B02080E" => "NETWORK_Z2",
"41565241434B02080F" => "SRC_A_Z2",
"41565241434B020810" => "SRC_B_Z2",
"41565241434B020811" => "SRC_C_Z2",
"41565241434B020812" => "SRC_D_Z2",
);

my $r = '0';
my $Cmd = ($CmdMsg{"$CmdArg"});
#my @arr = (split(',',$Cmd));
$Cmd =~ s/,//g;

#foreach $byte(@arr) {
#  if ($r eq 0) {$crc1 = $byte}
#  if ($r eq 1) {$crc2 = $byte}
#  if ($r eq 2) {$crc1 = "$crc1$byte"}
#  if ($r eq 3) {$crc2 = "$crc2$byte"}
#  $r++
#  }
#  @oddeve = ("$crc1","$crc2");
#  $hash = '';
#   foreach $byte(@oddeve) {
#     $hash = $hash.'0x'.(sprintf '%02X', (crc((pack ('H*', $byte)),16,0x00,0x00,0,0x01,0,0))                                                                                                                                                 );
#   }

#$testbyte = '0x5A0x80';
#$hash = $hash.'0x'.(sprintf '%02X', (crc((pack ('H*', $testbyte)),16,0x00,0x00,0,0x01,0,0)));
#print "$hash\n";

  #$FullCmd = "504353454E440204$Cmd$hash";
   $FullCmd = "504353454E440204$Cmd";
   $FullCmd =~ s/0x//g;
   $ascii = pack('H*', $FullCmd);
  print "$ascii\n" if $DEGUG;
  print "$FullCmd\n" if $DEGUG;

if ($EnableTCP eq "1") {
  print $port $ascii;
} else {
  $port->lookclear;
  $port->write("$ascii");
  $response = $port->read(30);
}


$timeout = "0";
 while ($timeout < $ResponseTimeout) {
     if ($EnableTCP eq "1") {
       eval { 
            local $SIG{ALRM} = sub { die 'Timed Out'; }; alarm 1;
	    recv($port, $msg,  10, 0); alarm 0;
  	    };
  	  alarm 0; die "Error: timeout\n" if ( $@ && $@ =~ /Timed Out/ );
	  print "$msg\n" if $DEGUG;
        } else {
	 ($count, $msg) = $port->read(10);
        } 
        $rcvbuf = $msg.$rcvbuf;
       $hex = uc(unpack('H*', $rcvbuf));
                if ((length($hex)) eq "20") {
		 $AckMsg = ($CmdAck{"$hex"});
			if ($AckMsg eq '') { $AckMsg = ($CmdAck{(substr ($hex, 0, 18))});} # try stripping the checksum
			if ($AckMsg eq '') { $AckMsg = ($CmdAck{(substr ($hex, 0, 16))});} # strip last 2 for vol caculations
			#print "$AckMsg\n";
			$AckMsg = &GetAckMsg if &GetAckMsg; 
			
		 print "$AckMsg\n";
                  $port->close();
                 }
        $timeout++;
  }
$port->close();



sub startserial {
  my $port = new Device::SerialPort('/dev/ttyUSB1');
  $port->user_msg(ON);
  $port->baudrate(57600);
  $port->parity("none");
  $port->databits(8);
  $port->stopbits(1);
  $port->handshake("xoff");
  $port->write_settings;
  return $port;
}

sub GetAckMsg {
#print "$AckMsg BLAH\n";
 	if ($AckMsg eq 'VOL_ACK') {
                $RetAckMsg = "+".(hex((substr ((substr ($hex, 16)),0 , 2))));
              if ($RetAckMsg > 0 and $RetAckMsg < 10) {
                    } else {
                         $RetAckMsg = "-".($RetAckMsg - 128);
                    }
                  $RetAckMsg = "VOL_".$RetAckMsg;
		 return $RetAckMsg;
               }
	  if ($AckMsg eq 'Z2_VOL_ACK') {
                   $RetAckMsg = "+".(hex((substr ((substr ($hex, 16)),0 , 2))));
               if ($RetAckMsg > 0 and $RetAckMsg < 10) {
                      } else {
                         $RetAckMsg = "-".($RetAckMsg - 128);
                      }
                  $RetAckMsg = "Z2_VOL_".$RetAckMsg;
		  return $RetAckMsg;
               }
          if ($AckMsg eq 'VOL_TOG_ACK') {
                   $RetAckMsg = "+".(hex((substr ((substr ($hex, 16)),0 , 2))));
               if ($RetAckMsg > 0 and $RetAckMsg < 10) {
                      } else {
                         $RetAckMsg = "-".($RetAckMsg - 128);
                      }
                  $RetAckMsg = "VOL_TOG_".$RetAckMsg;
                  return $RetAckMsg;
               }
        return;
      }	


sub starttcp {
 my $port = new IO::Socket::INET (
                         PeerAddr => '192.168.1.1',
                         PeerPort => '36000',
                         Proto => 'tcp',
			 Timeout => 2
                                 );
  die "Could not create socket: $!\n" unless $port;
  return $port;
}
