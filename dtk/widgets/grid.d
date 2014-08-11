module dtk.widgets.grid;

public {
  import dtk.widgets.frame;
  import dtk.widgets.label;
  import dtk.widgets.entry;
  import dtk.widgets.menubutton;
  import dtk.utils;
  import std.conv;
}

class Grid : Frame
{
 protected:
  int m_rows_num;
  int m_border;
  Widget[][] table;
  Widget add_cell(string value, int row=-1, int col=-1) {
    return new Label(this, value.length?value:"{}");
  }
  Widget add_cell(string[] values, int row=-1, int col=-1) {
    MenuButton w;
    tk.eval1({
	w = new MenuButton(this, values[0]);
	auto m = new Menu(w); m.tearoff = 0;
	foreach(v; values[1..$]) m.add(v.length?v:"{}");
	w.set(m);
      });
    return w;
  }
 public:
  int border() { return m_border; }
  void border(int border) { m_border = border; }
  alias background bordercolor;

  int rows() { return m_rows_num; }

  this(Widget parent) {
    m_rows_num = 0;
    m_border = 0;
    class_name = "frame";
    super(parent);
  }

  int add(string args, Widget[] ws...)
  {
    string r;
    foreach(w;ws) r ~= w.name ~ " ";
    tk.eval("grid", r, "-padx", to!(string)(m_border),"-pady", to!(string)(m_border), args);
    this.table ~= [ws];
    return ++this.m_rows_num;
  }

  Widget[] add(string[] values,string[] args...)
  {
    Widget[] ws;
    foreach(i,v; values) {
      ws ~= this.add_cell(v,this.rows,i);
    }
    add("-sticky ew " ~ join_with(args), ws);
    return ws;
  }

  Widget set(int x, int y, string value) {
    this.forget(x,y);
    Widget w = add_cell(value,x,y);
    table[x][y] = w;
    tk.eval("grid", w.name, "-row",to!(string)(x), "-column",to!(string)(y));
    return w;
  }

  Widget[] add(string[][] values, string[] args...)
  {
    Widget[] ws;
    foreach(i,v; values) {
      ws ~= this.add_cell(v,this.rows,i);
    }
    add("-sticky ew " ~ join_with(args), ws);
    return ws;
  }

  Widget get(int x, int y) {
    return table[x][y];
  }

  Widget set(int x, int y, string[] values) {
    this.forget(x,y);
    Widget w = add_cell(values,x,y);
    table[x][y] = w;
    tk.eval("grid", w.name, "-row",to!(string)(x), "-column",to!(string)(y));
    return w;
  }

  void reset() {
    tk.eval1({
	foreach(row; this.table)
	  foreach(w; row)
	    this.forget(w);
      });
    m_rows_num = 0;
  }

  void forget(Widget w)
    in {
      assert(w.parent == this);
    } body 
	{
	  tk.eval("grid forget",w.name);
	}

  void forget(int x, int y)
  {
    this.forget(table[x][y]);
  }

  void remove(Widget w)
    in {
      assert(w.parent == this);
    } body
	{
	  tk.eval("grid remove",w.name);
	}
  void remove(int x, int y) {
    this.remove(table[x][y]);
  }

  void configure(Widget w, string[] attrs...)
  {
    tk.eval("grid configure", w.name, join_with(attrs));
  }
  void rowconfigure(int c, string[] attrs...)
  {
    tk.eval("grid rowconfigure", name, to!(string)(c), join_with(attrs));
  }
  void columnconfigure(int c, string[] attrs...)
  {
    tk.eval("grid columnconfigure", name, to!(string)(c), join_with(attrs));
  }

}
