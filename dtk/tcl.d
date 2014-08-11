module dtk.tcl;

public import std.socket;
public import std.stream;
public import std.socketstream;

import dtk.utils;

class TclException : Exception {
  public this(char[] message) {
    super(cast(string)message);
  }
  public this(string message) {
    super(message);
  }
}


interface Tcl_interface
{
  void disconnect();
  void init();
  void eval(string[] text...);
  void eval1(void delegate());

  void commit();
  void delay();

  string gets();
  void puts(string[] text...);
  string gets(string[] question...);

  void debug_mode(bool);
  bool debug_mode();
}

package const string error_string = "%Error:";
package const string end_of_block = "\1";
package const string echo_string = "%";

class Tcl : Tcl_interface
{
protected:
  Socket data_socket;
  Stream data_stream;

  bool debugp;
  bool echop;

  int delayed;
  string delayed_expr;

 protected:
  void write_line(string text) {
    data_stream.writeLine(text);
  }
  string echo_puts() {
    return "puts $sock \"" ~ echo_string ~"\";";
  }
  void echo() {
    write_line(echo_puts());
  }
  void read_echo() {
    auto msg = gets();
    if(echo_string != msg) { /// error occured
      throw new TclException("Read echo exception. Last message was `" ~ msg ~ "`");
    }
  }

  this() {
    init();
  }

 public:
  this(int data_port, string domain = "localhost")
  {
    data_socket = new TcpSocket(new InternetAddress(domain, data_port));
    data_stream = new SocketStream(data_socket);
    init();
  }
 

  ~this()
  {
    disconnect();
  }

  void disconnect()
  {
    if(data_socket.isAlive) data_socket.close();
  }

  void debug_mode(bool b) { 
    eval("global debug; set debug " ~ (b?"1":"0"));
    debugp = b;
  } 
  bool debug_mode() { return debugp; }
  
  void echo_mode(bool b) { 
    echop = b;
  } 
  bool echo_mode() { return echop; }

  void delay() { delayed += 1; }

  string gets()
  {    
    return cast(string)data_stream.readLine();
  }

  string[] get_block()
  {
    string[] block;
    string buf = gets();
    while(end_of_block != buf && !data_stream.eof()) {
      block ~= buf;
      buf = gets();
    }
    return block;
  }

  void init() {
    debugp = false;
    delayed = 0;
  }


  void eval(string[] args...) {
    string text = join_with(args);
    if(delayed) {
      delayed_expr ~= text ~ " ;\n\t";
    } else {
      write_line(text);
      if (echo_mode()) {
	echo();
	read_echo();
      }
    }
  }

  void eval1(void delegate() expr) {
    delay();
    expr();
    commit();
  }

  void commit() {
    delayed -= 1;
    if(delayed <= 0) { 
      delayed = 0;
      eval(delayed_expr);
      delayed_expr = "";
    }
  }

  string gets(string[] question...) {
    puts(cast(string)"["~question~cast(string)"]");
    return gets();
  }

  void puts(string[] args...) {
    string text = join_with(args);
    if(echo_mode()) {
      write_line("set tmp " ~ text ~ "; " ~ echo_puts()  ~ " puts $sock $tmp; flush $sock");
      read_echo();
    } else {
      write_line("puts $sock " ~ text ~ "; flush $sock");
    }
  }

  void put_end_of_block() {
    //NB. explicit!
    puts(end_of_block);
  }
}
