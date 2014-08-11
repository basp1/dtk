#!/usr/bin/tclsh

proc DataServer {port} {
    global srv
    set srv(data_main) [socket -server DataServerAccept $port]
}

proc DataServerAccept {sock addr port} {
    global srv
    global data_socket
    set data_socket $sock 
    puts "Accept $sock from $addr port $port"
    set srv(data_addr,$sock) [list $addr $port]
    fconfigure $sock -buffering line
    fileevent $sock readable [list DataServerReaction $sock]
}

proc DataServerReaction {sock} {
    global srv
    global data_socket
    global events_socket
    global debug
    global environment

    if {[eof $sock] || [catch {gets $sock line}]} {
	close $srv(data_main)
	close $srv(events_main)
	puts "Close $srv(data_addr,$sock)"
	exit
    } else {
	if {[string compare $line "quit"] == 0} {
	    close $srv(data_main)
	    close $srv(events_main)
	    exit
	} else {
	    if {0 == $debug} {
		eval "$line"
	    } else {
		puts "$line"
		if { [catch {eval "$line"} msg] } {
		    puts $data_socket "%Error: $msg"
		    puts $events_socket "%Error: $msg"
		    global errorInfo
		    error $msg $errorInfo
		}
	    }
	}
    }
}

proc EventsServer {port} {
    global srv
    set srv(events_main) [socket -server EventsServerAccept $port]
}

proc EventsServerAccept {sock addr port} {
    global srv
    global events_socket
    puts "Accept $sock from $addr port $port"
    set srv(events_addr,$sock) [list $addr $port]
    fconfigure $sock -buffering line
    set events_socket $sock
    fileevent $sock readable
}

set debug 0
set data_port 8000
set events_port 8001

set data_socket {}
set events_socket {}

set i 0
if {[llength $argv] && [lindex $argv $i] == "-debug"} {
    set debug 1
    incr i
}

if {[llength $argv] && [lindex $argv $i] > 0} {
    set port [lindex $argv 0]
}

DataServer $data_port
EventsServer $events_port
vwait forever