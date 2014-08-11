module dtk.widgets.menubutton;

import dtk.utils;
import dtk.widget;
public import dtk.widgets.menu;

class MenuButton : Widget
{
  this(Widget parent, string text, string[] args...) {
    class_name = "menubutton";
    super(parent,["-text ",text]~args);
  }  

  void set(Menu m) {
    cset("menu",m.name);
  }

  mixin generate_configure!("activebackground", "activeforeground", "anchor", "background", "bitmap", int,"borderwidth", "cursor", "direction", "disabledforeground", "font", "foreground", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", "image", "indicatorOn", "justify", "menu", int,"padx", int,"pady", "relief", "compound", "state", "takefocus", "underline", int,"width", "wraplength");
}
