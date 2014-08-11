module dtk.widgets.tile.notebook;

import dtk.widget;

class Notebook : Widget
{
  this(Widget parent) {
    class_name = "notebook";
    super(parent);
  }

  void add(Widget w, string text="{}")
    in
      {
	assert(w.parent == this);
      }
  body
    {
      tk.eval(name, "add", w.name, "-text", text);
    }
}
