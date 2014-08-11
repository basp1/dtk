module dtk.widgets.radioframe;

import dtk.widget;
import dtk.widgets.radiobutton;


class RadioFrame : VariabledWidget
{
  this(Widget parent) {
    class_name = "frame";
    super(parent);
  }

  RadioButton add(RadioButton r)
  {
    tk.eval(r.name,"configure", "-variable",variable);
    return r;
  }
}
