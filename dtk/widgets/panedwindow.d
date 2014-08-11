module dtk.widgets.panedwindow;

import dtk.widget;

class PanedWindow : Widget
{
  this(Widget parent, orient o) {
    class_name = "panedwindow";
    super(parent, "-orient",o);
  }

  void add(Widget[] ws...)
  {
    foreach(w;ws)
      tk.eval(name,"add", w.name);
  }

  mixin generate_configure!("background", "borderwidth", "cursor", "handlepad", int,"handlesize", int,"height", int,"opaqueresize", "orient", "relief", "sashcursor", "sashpad", "sashrelief", int,"sashwidth", "showhandle", int, "width");
}
