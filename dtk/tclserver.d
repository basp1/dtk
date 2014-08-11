module dtk.tclserver;

public {
  import dtk.utils;
  import dtk.tcl;
  import dtk.ctcl;
  import std.stream;
  import std.thread;
}

class TclServer : Tcl
{
protected:
  DummyStream data_stream;
  Tcl_Interp* interp;
  Tk_Window window;
  
  void write_line(string text) {
    Tcl_Eval(interp,cast(char*)(text));
    if(interp.result)
      data_stream.write(to!(string)(interp.result));
  }

 public:
  this() {
    super();
    data_stream = new DummyStream();
    interp = Tcl_CreateInterp();
    if(Tcl_Init(interp) != TCL_OK || Tk_Init(interp) != TCL_OK) {
      if(*interp.result)
	throw new TclException(to!(string)(interp.result));
    }
    window = Tk_MainWindow(interp);
    if (!window)
      throw new TclException(to!(string)(interp.result));
  }

  void disconnect() {
    Tcl_DeleteInterp(interp);
  }

  void echo_mode(bool) {
    echop = false;
  }

  string gets() {
    return data_stream.read();
  }
  string gets(string[] question...) {
    this.write_line(join_with(question));
    return this.gets();
  }

  void puts(string[] args...) {
    string text = join_with(args);
    data_stream.write(text);
  }
}
