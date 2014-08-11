module dtk.widgets.radiobutton;

import dtk.widget;
import dtk.widgets.radioframe;

class RadioButton : Widget
{
  this(RadioFrame parent, string text, string value) {
    class_name = "radiobutton";
    super(parent, "-text",text,"-value",value);
    parent.add(this);
  }

  mixin generate_configure!("activebackground", "activeforeground", "anchor", "background", "bitmap", int,"borderwidth", "compound", "cursor", "disabledforeground", "font", "foreground", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", "image", "indicatorOn", "justify", "offrelief", "overrelief", int,"padx", int,"pady", "relief", "selectcolor", "selectimage", "state", "takefocus", "underline", int,"width", int,"wraplength");
}
