module dtk.widgets.canvas;

public {
  import dtk.utils;
  import dtk.tcl;
  import dtk.widget;
  import std.string;
  import std.conv;
  import std.math;
}
version(unittest) {
  import std.stdio;
}

alias string Item;

const string default_fill_color = "black";

enum TagCommand : string {overlapping = "overlapping", withtag="withtag", enclosed="enclosed"};

class CanvasObject : Widget
{
  Canvas parent;
  
  this(Canvas w, string name) {
    this.parent = w;
    this.name = name;
    this.tk = w.tk;
  }

  void fill(string color) {
    parent.itemconfigure(name,"fill",color);
  }
  void outline(string color) {
    parent.itemconfigure(name,"outline",color);
  }

  void width(uint x) {
    parent.itemconfigure(name,"width",to!(string)(x));
  }
  
  string[] tags() {
    return split(parent.itemcget(name,"tags"));
  }

}

class CanvasTag : Widget
{
  Canvas parent;
  
  this(Canvas w, string name, TagCommand command, string args = "") {
    this.parent = w;
    this.name = name;
    this.tk = w.tk;
    parent.add_tag(name, command, args);
  }
}

class CanvasGroup : CanvasTag
{
  CanvasObject[] items;

  this(Canvas w, CanvasObject item0, CanvasObject[] items...) {
    super(w, gensym("group"), TagCommand.withtag, item0.name);
    this.items = [item0] ~ items;

    tk.eval1({
	foreach(item; items) {
	  parent.add_tag(name, TagCommand.withtag, item.name);
	}
      });
  }
  
  void tearup() {
    parent.delete_tag(this.name);
  }

  void raise() {
    parent.raise(this.name);
  }
}

class Canvas : Widget
{
 private: 
  int objects_num;

 protected:
  CanvasObject new_object() {
    return new CanvasObject(this, to!(string)(++objects_num));
  }

 public:

  this(Widget parent, int width, int height) {
    objects_num = 0;
    class_name = "canvas";
    super(parent, "-width",to!(string)(width),"-height",to!(string)(height));
  }
  this(Widget parent) {
    this(parent,400,300);
  }

  int objects() { return objects_num; }

  void export_to(string file_name)
    in
      {
	assert(file_name.length > 0);
      }
  body
    {
      tk.eval(name, "postscript -file", file_name);
    }

  void clear() {
    tk.eval(name,"delete all");
  }

  CanvasObject line(string fill_color, int[] coords...) {
    tk.eval(name,"create line", join_with(coords), "-fill", fill_color);
    return new_object();
  }
  CanvasObject line(int[] coords...) {
    return line(default_fill_color, coords);
  }

  CanvasObject oval(string fill_color, int x0, int y0, int x1, int y1, string args="") {
    tk.eval(name,"create oval", join_with([x0,y0,x1,y1]), "-fill", fill_color, args);
    return new_object();
  }
  CanvasObject oval(int x0, int y0, int x1, int y1) {
    return oval(default_fill_color, x0,y0,x1,y1);
  }

  CanvasObject text(string color, string txt, int x, int y) {
    tk.eval(name,"create text", join_with([x,y]), "-text \"" ~ txt ~ "\"", "-fill", color);
    return new_object();
  }
  CanvasObject text(string txt, int x, int y) {
    return text(default_fill_color, txt, x,y);
  }

  
  void bind(T) (string event, T w, WidgetEventCallback f, string args="")
    if(is(T:CanvasTag) || is(T:CanvasObject))
      {
	auto cb_id = tk.add_event(w, f);
	tk.eval(name,"bind", w.name, event, "{sendevent", cb_id, "%x %y %k %K %w %h %X %Y}");
      }

  void add_tag(string tag_name, TagCommand command, string args = "")
  {
    tk.eval(name,"addtag", tag_name, command, args);
  }

  void delete_tag(string tag_name)
  {
    tk.eval(name, "dtag", tag_name);
  }

  void raise(T:string)(T tagOrId)
  {
    tk.eval(name,"raise", tagOrId);
  }
  void raise(T)(T tagOrId)
    if(is(T:CanvasTag) || is(T:CanvasObject)) {
	this.raise(tagOrId.name);
      }
      
  void move(T:Item)(T tagOrId, int dx, int dy)
  {
    tk.eval(name,"move", tagOrId, join_with([dx,dy]));
  }

  void move(T)(T tagOrId, int dx, int dy)
    if(is(T:CanvasTag) || is(T:CanvasObject)) {
	this.move(tagOrId.name, dx, dy);
      }

  int[] bbox(Item item) {
    return to!(int[])(split(tk.gets(name,"bbox",item)));
  }

  void coords(Item item, int[] coords...)
    {
      tk.eval(name, "coords", item, join_with(coords));
    }

  int[] coords(Item item)
  {
    int[] coords;

    foreach(xs; split(tk.gets(name,"coords",item))) {
      coords ~= lround(to!(double)(xs));
    }
    return coords;
  }

  void itemconfigure(Item item, string attr, string value)
  {
    tk.eval(name, "itemconfigure", item, "-"~attr, value);
  }

  string itemcget(Item item, string attr)
  {
    return tk.gets(name, "itemcget", item, "-"~attr);
  }

  mixin generate_configure!("background", int,"borderwidth", "closeenough", "confine", "cursor", int,"height", "highlightbackground", "highlightcolor", "highlightthickness", "insertbackground", "insertborderwidth", "insertofftime", "insertontime", "insertwidth", "offset", relief, "relief", "scrollregion", "selectbackground", "selectborderwidth", "selectforeground", "state", "takefocus", int,"width");

}
