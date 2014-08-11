module dtk.tk;

import std.stdio;
import std.string;
import std.conv;

public import dtk.utils;
public import dtk.tcl;
public import dtk.tkwidgets;

class TkException : TclException {
  public this(char[] message) {
    super(cast(string)message);
  }
  public this(string message) {
    super(message);
  }
}

package const string event_string = "%E";
package const string callback_string = "%C";

class Tk : Tcl
{
 protected:
  Socket events_socket;
  Stream events_stream;
  int objects_num;
  bool exitp;
  Widget root_widget;
  Widget[string] callbacks;
  Widget[string] events;


public:
  this(int data_port, int events_port, string domain = "localhost")
  {
    super(data_port, domain);

    events_socket = new TcpSocket(new InternetAddress(domain, events_port));
    events_stream = new SocketStream(events_socket);

    objects_num = 0;

    init();
  }
  this(int common_port, string domain="localhost") {
    this(common_port,common_port,domain);
  }


  ~this()
  {
    disconnect();
  }

  void disconnect()
  {
    if(data_socket.isAlive) data_socket.close();
    if(events_socket.isAlive) events_socket.close();
  }

  int objects() { return objects_num; }

  bool exit_mainloop() { return exitp; }
  void exit_mainloop(bool b) { exitp = b; }


  void callback(string s) {
    if(!(s in callbacks)) {
      throw new TkException("`"~s~"` is not a registred callback");
    } else {
      callbacks[s].command();
    }
  }
  string add_callback(Widget w, WidgetCallback f) {
    string gen_name = gensym(w.name);
    w.command(f);
    callbacks[gen_name] = w;
    return gen_name;
  }
  void remove_callback(string s) {
    if(!(s in callbacks)) {
      throw new TkException("`"~s~"` is not a registred callback");
    } else {
      callbacks.remove(s);
    }
  }

  void event(string s, dtk.event.Event e) {
    if(!(s in events)) {
      throw new TkException("`"~s~"` is not a registred event");
    } else {
      events[s].event(s,e);
    }
  }
  string add_event(Widget w, WidgetEventCallback f) {
    string gen_name = gensym(w.name);
    w.event(gen_name,f);
    events[gen_name] = w;
    return gen_name;
  }
  void remove_event(string s) {
    if(!(s in events)) {
      throw new TkException("`"~s~"` is not a registred event");
    } else {
      events.remove(s);
    }
  }

  void quit()
  {
    eval("quit");
    exit_mainloop(true);
    disconnect();
  }
  
  Widget root() { return root_widget; }

  void init()
  {
    root_widget = new Widget; root_widget.name = "."; root_widget.tk = this;    
    require("Tk");
    eval("proc sendevent {s x y keycode char width height root_x root_y} {global events_socket; puts $events_socket \"" ~ event_string  ~ " $s $x $y $keycode $char $width $height $root_x $root_y\"}");
    eval("proc callback {s} {global events_socket; puts $events_socket \"" ~  callback_string ~ " $s\"}");
    eval("proc safely_get {x default} { upvar $x x1; if {[info exists x1]} {return $x1} else {return $default};}");

    bind("<Destroy>", root_widget,
	 delegate void(Widget, Event) {
	   quit();
	 });
  }

  void set(string var, string value) {
    eval("set", var, value);
  }


  string get_event()
  {
    return cast(string)events_stream.readLine();
  }

protected:

public:

  void require(string pkg) {
    eval("package require", pkg, ";");
  }

  void mainloop()
  {
    commit();
    while(events_socket.isAlive && !events_stream.eof())
      {
	auto line = get_event();
	auto words = split(cast(string)line);
	if(words.length) {
	  if(debug_mode()) writefln(words);

	  switch(words[0]) {
	  case callback_string: { callback(words[1]); break; }
	  case event_string: {
	    event(words[1], make_event(cast(char[][])words[2..$])); 
	    break; 
	  }
	  case error_string: {
	    throw new TkException("Read echo exception. Last message was `" ~ line ~ "`");
	    break; 
	  }
	  }
	}
	if(exit_mainloop()) break;
      }
  }


  string getSaveFile(string title = "", string[] file_types = []) {
    return gets("tk_getSaveFile -parent . -title {" ~ title ~ "}");
  }

  string getOpenFile(string title = "", string[] file_types = []) {
    return gets("tk_getOpenFile -title {" ~ title ~ "}");
  }

  void configure(Widget w, string attr, string value)
  {
    eval(w.name, "configure -" ~ attr, value);
  }

  string cget(Widget w, string attr)
  {
    return gets(w.name, "cget -" ~ attr);
  }

  Widget register_widget(Widget w, string attrs = "") {
    eval(w.class_name, w.name, attrs);
    ++objects_num;
    return w;
  }

  void command(Widget w, string[] args...)
  {
    configure(w, "command", "{" ~ join_with(args) ~ "}");
  }
  void command(Widget w, WidgetCallback f)
  {
    auto cb_id = add_callback(w,f);
    this.command(w, "callback", cb_id );
  }

  void bind (string event, Widget w, string[] args...)
  {
    eval("bind", w.name, event, "{",join_with(args),"}");
  }
  void bind (string event, Widget w, WidgetEventCallback f)
  {
    auto cb_id = add_event(w, f);
    this.bind(event, w, "sendevent", cb_id, "%x %y %k %K %w %h %X %Y");
  }

  void pack(T...)(Widget w, T attrs)
    in 
      {
	foreach(t;T)
	  assert(indexOf!(t,PackAttributes) != -1);
      }
  body
    {
      eval("pack", w.name, convert_attributes_to_string(attrs));
    }

  void pack(T...)(Widget[] ws, T attrs)
  {
    foreach(w;ws)
      pack(w,attrs);
  }

  void pack(T)(T attr, Widget[] ws...)
    if (is(T == enum))
      {
	foreach(w;ws)
	  pack(w,attr);
      }

  void popup(Menu m, int x, int y) {
    eval("tk_popup", m.name, join_with([x,y]));
  }
}
