module dtk.event;

import std.conv;

public struct Event
{
  int x, y,  keycode, character, width, height, root_x, root_y;
}

public Event make_event(char[][] xs)
in
  {
    assert(xs.length == Event.tupleof.length);
  }
body
  {
    Event e;
    foreach(i, field; e.tupleof) {
      alias typeof(field) T;
      try {
	e.tupleof[i] = to!(T)(xs[i]);
      } catch(Exception) {
	e.tupleof[i] = to!(T)(T.init);
      }
    }
    return e;
  }
