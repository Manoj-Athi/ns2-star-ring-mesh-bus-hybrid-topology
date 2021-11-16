#This Program will create a ring topology using less number of statements in TCL Language
set ns [new Simulator]
#$ns rtproto DV
$ns color 1 blue
$ns color 2 red

set nf [open ring.nam w]
$ns namtrace-all $nf

proc finish {} {
        global ns nf
        $ns flush-trace
        close $nf
        exec nam ring.nam
        exit 0
        }

#Creating Nodes
for {set i 0} {$i<8} {incr i} {
set n($i) [$ns node]
}

#Creating Links
for {set i 0} {$i<8} {incr i} {
$ns duplex-link $n($i) $n([expr ($i+1)%8]) 512Kb 5ms DropTail
}

#$ns duplex-link-op $n(0) $n(1) queuePos 1
#$ns duplex-link-op $n(0) $n(6) queuePos 1

$ns duplex-link-op $n(0) $n(1) orient right
$ns duplex-link-op $n(1) $n(2) orient right-down
$ns duplex-link-op $n(2) $n(3) orient down
$ns duplex-link-op $n(3) $n(4) orient left-down
$ns duplex-link-op $n(4) $n(5) orient left
$ns duplex-link-op $n(5) $n(6) orient left-up
$ns duplex-link-op $n(6) $n(7) orient up
$ns duplex-link-op $n(7) $n(0) orient right-up

#Creating UDP agent and attching to node 0
#set udp0 [new Agent/UDP]
#$ns attach-agent $n(0) $udp0

#Creating Null agent and attaching to node 3
#set null0 [new Agent/Null]
#$ns attach-agent $n(3) $null0

#$ns connect $udp0 $null0


#Creating a CBR agent and attaching it to udp0
#set cbr0 [new Application/Traffic/CBR]
#$cbr0 set packetSize_ 1024
#$cbr0 set interval_ 0.01
#$cbr0 attach-agent $udp0

set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $n(4) $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n(7) $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 set packetSize_ 1000
$ftp0 attach-agent $tcp0

#$ns rtmodel-at 0.4 down $n(2) $n(3)
#$ns rtmodel-at 1.0 up $n(2) $n(3)

$ns at 0.01 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"

$ns at 2.0 "finish"
$ns run