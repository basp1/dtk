import std.stdio;
import std.conv;

import dtk.utils;
import dtk.tk;
import dtk.widgets.plotter;


void main()
{
  auto tk = new Tk(8000, 8001);
  tk.debug_mode(true);
  tk.echo_mode(true);
  
  int[] points;
  int plot_lastX = 0;
  int plot_lastY = 0;


  double x_begin = 0; double x_end = 1.0;
  double y_begin = 0; double y_end = 1.0;
  string oval_color = "red";

  with(tk)
    {
      auto c = new Plotter(root, 640, 480);
      c.draw_grid(x_begin, x_end, y_begin, y_end);

      bind("<ButtonPress-3>", c,
           delegate void(Widget, Event e)
	   {
             bool down = false;

	     with(c)
	       {
		 auto item = oval(oval_color, e.x-10, e.y-10, e.x+10, e.y+10);
		 auto point = new CanvasTag(c,"point", TagCommand.withtag, item.name);

		 bind("<ButtonPress-1>", point,
		      delegate void(Widget w, Event e)
		      {
			down = true;
			plot_lastX = e.x;
			plot_lastY = e.y;
			raise("current");
			delete_tag("selected");
			add_tag("selected", TagCommand.withtag, "current");
		      });

		 bind("<ButtonRelease-1>", point,
		      delegate void(Widget, Event) {
			down = false;
		      });

		 bind("<Motion>", point,
		      delegate void(Widget, Event e) {
			if(down) {
			  move("selected",
                               e.x - plot_lastX, e.y - plot_lastY);
			  plot_lastX = e.x;
			  plot_lastY = e.y;
			}
		      });
	       }
	   });

      pack(c);

      auto ch = new Menu(root);
      ch.add("Red",    { oval_color = "red";});
      ch.add("Blue",   { oval_color = "blue";});
      ch.add("Green",  { oval_color = "green";});
      ch.add("Yellow", { oval_color = "yellow";});
      ch.add("Black",  { oval_color = "black";});

      bind("<2>", c, delegate void (Widget,Event e) {
          popup(ch, e.root_x, e.root_y);
        });
      
      bind("<Destroy>", root,
	   delegate void(Widget, Event) {
	     quit();
	   });

      mainloop();
    }

  delete tk;
  
  return 0;
}
