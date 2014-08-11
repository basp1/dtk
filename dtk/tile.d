module dtk.tile;

import std.string;
public import dtk.tk;
public import tile = dtk.tilewidgets;

version(unittest) {
  import std.stdio;
}

class Tile : Tk
{
  this(int data_port, int events_port, string domain = "localhost")
    {
      super(data_port,events_port, domain);
      require("tile");
    }

  string[] themes() {
    return cast(string[]) split(gets("style theme names"));
  }

  void theme(string t)
  {
    eval("tile::setTheme", t);
  }

  Widget register_widget(Widget w, string attrs="")
  {
    if(isIn(w.class_name, tile.widgets)) {
      w.class_name = tile.prefix ~ w.class_name;
    }
    return super.register_widget(w,attrs);
  }

}

class TileQt : Tile
{
  void style(string s) {
    eval("tile::theme::tileqt::applyStyle", s); 
  }
  this(int data_port, int events_port, string domain = "localhost")
    {
      super(data_port,events_port,domain);
      theme("tileqt");
    }
}