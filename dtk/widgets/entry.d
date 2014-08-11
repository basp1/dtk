module dtk.widgets.entry;

import dtk.widget;

alias Entry Edit;

class Entry : Widget
{
  this(Widget parent) {
    class_name = "entry";
    super(parent);
  }
  void clear()
  {
    tk.eval(name, "delete 0 end");
  }
  void value(string text)
  {
    clear();
    tk.eval(name, "insert 0", text);
  }
  string value()
  {
    return tk.gets(name,"get");
  }
  string opAssign(T)(T v)
  {
    string s = to!(string)(v);
    value(s);
    return s;
  }


  mixin generate_configure!("background", int,"borderwidth", "cursor", "disabledbackground", "disabledforeground", "exportselection", "font", "foreground", "highlightbackground", "highlightcolor", "highlightthickness", "insertbackground", "insertborderwidth", "insertofftime", "insertontime", "insertwidth", "invalidcommand", "justify", "readonlybackground", "relief", "selectbackground", "selectborderwidth", "selectforeground", "show", "state", "takefocus", "textvariable", "validate", "validatecommand", int,"width");
}
