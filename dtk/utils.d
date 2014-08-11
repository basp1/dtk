module dtk.utils;

public import std.conv;
public import std.string;

version(unittest) {
  public import std.stdio;
}

string gensym(string s="")
{
  static int sym = 0;
  s = replace(s, ".", "_");
  return s  ~ to!(string)(++sym);
}

string join_with(T)(T[] xs, string sep = " ")
{
  if(xs.length == 0) return "";
  string s;
  foreach(x; xs)
    s ~= to!(string)(x) ~ sep;
  return s[0..$-sep.length];
}

bool isIn(T)(T x, T[] ys)
{
  foreach(y;ys)
    if(x == y) return true;
  return false;
}

class DummyStream
{
protected:
  string[] data;
public:
  this() {;}
  void write(string s) {
    data ~= s;
  }
  string read() {
    if(data.length == 0) return "";
    string s = data[$-1];
    data = data[0..$-1];
    return s;
  }
  bool eof() {
    return (data.length == 0);
  }
  string toString() {
    string result;
    foreach(s;data.reverse) result ~= s ~ "\n";
    return result;
  }
  void reset() {
    data.length = 0;
  }
}
