module dtk.widgets.table;

public {
  import dtk.widgets.grid;
}


class Table : Grid
{
 protected:
  public  string variable;
  Widget[][] table2;
  Widget add_cell(string value, int row=-1, int col=-1) {
    Entry e;
    tk.eval1({
	e = new Entry(this);
	e.textvariable = this.variable~"("~to!(string)(row)~","~to!(string)(col)~")";
	e = value;
      });
    return e;
  }
  Widget add_cell(string[] values, int row=-1, int col=-1) {
    MenuButton w;
    tk.eval1({
        w = new MenuButton(this, values[0]);
        auto m = new Menu(w); m.tearoff = 0;
        foreach(v; values[1..$]) {
	  v = v.length?v:"{}";
	  m.add(v,
		"-command","{"
		~w.name~" configure -text " ~ v ~ ";"
		~"global "~this.variable~";"
		~"set "~this.variable~"("~to!(string)(row)~","~to!(string)(col)~")",v,"}");
	}
        w.set(m);
      });
    return w;
  }

 public:
  this(Widget parent) {
    super(parent);
    this.variable = gensym(name);
  }

}
