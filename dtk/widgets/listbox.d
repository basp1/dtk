module dtk.widgets.listbox;

import dtk.utils;
import dtk.widget;

class Listbox : VariabledWidget
{
  this(Widget parent, string[] values...) {
    class_name = "listbox";
    super(parent);
    listvariable = variable();
    tk.set(variable(), "[list " ~ join_with(values) ~ "]");
  }

  string current() {
    return tk.gets("lindex $" ~ variable, "[", name, "curselection]");
  }

  mixin generate_configure!("activestyle", "background", int,"borderwidth", "cursor", "disabledforeground", "exportselection", "font", "foreground", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", "listvariable", "relief", "selectbackground", "selectborderwidth", "selectforeground", "selectmode", "setgrid", "state", "takefocus", int,"width");
}