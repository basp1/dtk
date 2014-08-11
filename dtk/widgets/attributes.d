module dtk.widgets.attributes;

public import std.typetuple;
import std.metastrings;

template enumval() {
  enum string enumval = "";
}
template enumval(string name, U...) {
  enum string enumval = "," ~ name ~ "=" ~ "\"" ~ name ~ "\"" ~ enumval!(U);
}
template defenum(string name, T...) {
  enum string defenum = "enum " ~ name ~ " : string {init=" ~ "\"" ~ name ~"\"" ~ enumval!(T) ~ "}";
}

template enumint(int begin, int end) {
  static if (begin > end) {
    enum string enumint = "";
  } else {
    enum string enumint = ", _" ~ ToString!(begin) ~ "=\"" ~ ToString!(begin) ~ "\"" ~enumint!(begin+1, end);
  }
}
template defenum(string name, int begin, int end) {
  enum string defenum = "enum " ~ name ~ ": string {init=" ~ "\"" ~ name ~"\"" ~ enumint!(begin,end) ~ "}";
}
/// pack attributes
mixin(defenum!("fill","none","x","y","both"));
mixin(defenum!("side","top","bottom","left","right"));
mixin(defenum!("anchor","n", "ne","e","se","s", "sw","w","nw","center"));
mixin(defenum!("ipadx", 0,10));
mixin(defenum!("ipady", 0,10));
mixin(defenum!("padx" , 0,10));
mixin(defenum!("pady" , 0,10));
enum expand : string {init="expand", no="0", yes="1"};

alias TypeTuple!(fill,side,expand, anchor, ipady, ipadx, pady, padx) PackAttributes;

/// common attributes
mixin(defenum!("relief","flat","groove","raised","ridge","solid","sunken"));
mixin(defenum!("orient","horizontal","vertical"));


string convert_attributes_to_string(T...)(T args)
{
  string s;
  foreach(i,arg;args)
    s ~= "-" ~ T[i].init ~ " " ~ arg ~ " ";
  return s;
}
