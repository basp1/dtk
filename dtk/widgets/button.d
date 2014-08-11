module dtk.widgets.button;

import dtk.widget;

class Button : Widget
{
  this(Widget parent, string text) {
    class_name = "button";
    super(parent, "-text",text);
  } 

  this(Widget parent, string text, WidgetCallback f) {
    class_name = "button";
    super(parent, "-text",text);
    tk.command(this,f);
  } 

  mixin generate_configure!("activebackground", "activeforeground", "anchor", "bitmap", "compound", "disabledforeground", "font", "foreground", int,  "height", "highlightbackground", "highlightcolor", "highlightthickness", "image", "justify", "overrelief", int,"padx", int,"pady", "repeatdelay", "repeatinterval", "state", "takefocus", "text", "underline", int,"width", "wraplength");

}
