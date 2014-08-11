module dtk.widgets.tile.combobox;

import dtk.utils;
import dtk.widget;

class ComboBox : VariabledWidget
{
  this(Widget parent, string[] values...) {
    class_name = "combobox";
    super(parent, "-values [list", join_with(values), "]");
    textvariable = variable();
  }

  mixin generate_configure!("state","textvariable");
}