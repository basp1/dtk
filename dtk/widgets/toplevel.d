module dtk.widgets.toplevel;

import dtk.widget;

class Toplevel : Widget
{
  this(Widget parent, string title) {
    class_name = "toplevel";
    super(parent);
    this.title(title);
  }
  void destroy()
  {
    tk.eval("destroy", name);
  }

  alias destroy close;

  void title(string text)
  {
    tk.eval("wm title", name, text);
  }

  mixin generate_configure!("borderwidth", "menu", "relief", "screen", "use", "background", "colormap", "container", "cursor", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", int,"padx", int,"pady", "takefocus", "visual", int,"width");
}
