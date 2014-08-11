module dtk.widgets.label;

import dtk.widget;

class Label : Widget
{
  string text;
  this(Widget parent, string text) {
    class_name = "label";
    super(parent,"-text",text);
    this.text = text;
  }

  mixin generate_configure!("activebackground", "activeforeground", "anchor", "background", "bitmap", int,"borderwidth", "compound", "cursor", "disabledforeground", "font", "foreground", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", "image", "justify", int,"padx", int,"pady", "relief", "state", "takefocus", "underline", int,"width", "wraplength");
}
