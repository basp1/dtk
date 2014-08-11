module dtk.widgets.text;

import dtk.widget;
import dtk.utils;

class Text : Widget
{
  this(Widget parent, string[] args...) {
    class_name = "text";
    super(parent,args);
  }

  string[] get() {
    tk.puts("[",name,"get 0.0 end ]");
    tk.put_end_of_block();
    return tk.get_block();
  }

  void clear() {
    tk.eval(name,"delete 0.0 end");
  }

  void insert(uint x, uint y, string str) {
    tk.eval(name, "insert", join_with([x,y],"."), str);
  }

  mixin generate_configure!("autoseparators", "background", int, "borderwidth", "cursor", "exportselection", "font", "foreground", int, "height", "highlightbackground", "highlightcolor", "highlightthickness", "insertbackground", "insertborderwidth", "insertofftime", "insertontime", "insertwidth", "maxundo", int, "padx", int, "pady", "relief", "selectbackground", "selectborderwidth", "selectforeground", "setgrid", "spacing1", "spacing2", "spacing3", "state", "tabs", "takefocus", "undo", int, "width", "wrap", "xscrollcommand", "yscrollcommand");
}
