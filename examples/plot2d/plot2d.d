import std.stdio;
import std.conv;
import std.math;

import dtk.utils;
import dtk.tk;
import dtk.widgets.plotter;

void main()
{
  auto tk = new Tk(8000, 8001);

  tk.debug_mode(true);

  with(tk)
    {
      auto c = new Plotter(root, 640, 480);
      double x_begin = 1.0, x_end = 10.0;
      double y_begin = -10.0, y_end = 10.0;
      with(c) {
	draw_grid(x_begin, x_end, y_begin, y_end);
	plot2d(new Plot2d([1.0,3.0,5.0,7.0,9.0], [1.0,2.0,4.0,4.0,7.5], x_begin, x_end, y_begin, y_end));
	auto sin2d = new Plot2d(delegate double(double x) {
	    return 7.0*sin(x);
	  }, x_begin, x_end, 0.1);
	sin2d.color = "blue";  sin2d.vertex_color = "maroon";
	sin2d.y_min = y_begin; sin2d.y_max = y_end;
	plot2d(sin2d);
	plot_text(sin2d, "4.2;4.2", 4.2,4.2);
      }

      pack(c, expand.yes);
      mainloop();
    }

  delete tk;

  return 0;
}
