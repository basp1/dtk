module dtk.widget;

import dtk.utils;
import dtk.tk;
public import std.conv;
public import dtk.event;
public import dtk.widgets.attributes;

version(unittest) {
  import std.stdio;
}



class Widget
{
protected:
  string[string] config;
 public:
  Tk tk;

  string class_name;
  string name;
  Widget parent;

  void delegate() callback;
  void command(void delegate() dg) { callback = dg; }
  void command() { callback(); }

  void delegate(Widget,Event)[string] events;
  void event(string s, Event e)
    in
      {
	assert(s in events);
      }
  body
    {
      events[s](this,e); 
    }

  void event(string s, void delegate(Widget,Event) dg) { events[s] = dg; }

protected:
  void register_widget(string[] args)
  {
    name = parent.name;  name = (name == ".")? name : (name ~ ".") ;
    name ~= gensym(class_name);
    tk.register_widget(this, join_with(args));
  }

public:
  this() {;}
  this(Widget w, string[] args...){
    parent = w;
    tk = parent.tk;
    register_widget(args);
  }

  string cget(string attr)
  {
    return tk.gets(name, "cget -" ~ attr);
  }
  void cset(string attr, string value)
  {
    config[attr] = value;
    tk.eval(name,"configure","-"~attr, value);
  }
}

abstract class VariabledWidget : Widget
{
 protected:
  string m_variable;
 public:
  this(Widget parent, string[] args...) {
    m_variable = "environment("~gensym(name)~")";
    super(parent,args);
  }

  string value() {
    return tk.gets("safely_get "~variable()~" {}");
  }
  string variable() { return m_variable; } 
}

package 
template generate_configure(string Attr, U...)
{
  mixin("void " ~ Attr ~ "(string value) { cset(\"" ~ Attr ~"\", value); }");
  mixin("string " ~ Attr ~ "() { return cget(\"" ~ Attr ~"\"); }");
  static if(U.length > 0) {
    mixin generate_configure!(U);
  }
}
package
template generate_configure(T, string Attr, U...)
{
  static if(!is(T==enum)) {
      mixin("void " ~ Attr ~ "(T value) { cset(\"" ~ Attr ~"\", to!(string)(value)); }");
      mixin("T " ~ Attr ~ "() { return to!(T)(cget(\"" ~ Attr ~"\")); }");
    } else {
    static if(is(T : string)) {
      mixin("void " ~ Attr ~ "(T value) { cset(\"" ~ Attr ~"\", value); }");
    } else {
      mixin("void " ~ Attr ~ "(T value) { cset(\"" ~ Attr ~"\", to!(string)(value)); }");
    }
      mixin("T " ~ Attr ~ "() { return cast(T)cget(\"" ~ Attr ~"\"); }");
  }
  static if(U.length > 0) {
    mixin generate_configure!(U);
  }
}

public alias void delegate() WidgetCallback;
public alias void delegate(Widget,Event) WidgetEventCallback;