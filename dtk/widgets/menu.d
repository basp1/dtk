module dtk.widgets.menu;

import dtk.utils;
import dtk.widget;

class Menu : Widget
{
  class MenuCommand : Widget {
    string label;
    /// it's a dymmy widget
    void register_widget(string[]) { ; }
    this(Widget parent,string l) {
      super(parent);
      label = l;
    }
  }
  this(Widget parent) {
    init();
    super(parent);
  }

  void init()
  {
    class_name = "menu";
  }

  void set()
  {
    tk.eval(parent.name, "configure", "-menu", name);
  }

  /// separator
  void add()
  {
    tk.eval(name, "add separator");    
  }

  /// dummy label
  void add(string text, string[] attrs...)
  {
    auto m = new MenuCommand(this, text);
    tk.eval(name, "add command -label {" ~ text ~ "}", join_with(attrs));
  }

  /// command
  void add(string text, WidgetCallback f, string[] attrs...)
  {
    auto m = new MenuCommand(this, text);
    auto cb_id = tk.add_callback(m,f);
    this.add(text, "-command {callback", cb_id, "}", join_with(attrs));
  }
  
  /// cascade
  void add(string text, Menu m, string[] attrs...)
  {
    tk.eval(name, "add cascade -label", text, "-menu", m.name, join_with(attrs));
  }

  mixin generate_configure!("activebackground", "activeborderwidth", "activeforeground", "background", int,"borderwidth", "cursor", "disabledforeground", "font", "foreground", "postcommand", "relief", "selectcolor", "takefocus", int, "tearoff", "tearoffcommand", "title", "type");
}
