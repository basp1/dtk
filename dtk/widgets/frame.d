module dtk.widgets.frame;

public import dtk.widget;

class Frame : Widget
{
  this(Widget parent) {
    class_name = "frame";
    super(parent);
  }

  mixin generate_configure!(int,"borderwidth", relief,"relief", "background", "colormap", "container", "cursor", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", int,"padx", int,"pady", "takefocus", "visual", int,"width");
}
