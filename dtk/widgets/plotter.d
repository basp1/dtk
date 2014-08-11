module dtk.widgets.plotter;

import std.algorithm;
import std.math;
import dtk.tk;
import dtk.widgets.canvas;

version(unittest) {
  import std.stdio;
}

package  double point_to_point (double src_from, double src_end, double dest_from, double dest_end, double point) {
  return (dest_from +  (((dest_end - dest_from) * (point - src_from)) / (src_end - src_from)));
}
package  int x_transform (int screen_width, double points_from, double points_end, double x) {
  return cast(int)point_to_point(points_from, points_end, 0, cast(double)screen_width, x);
}
package  int y_transform (int screen_height, double points_from, double points_end, double y) {
  return (screen_height - cast(int)point_to_point(points_from, points_end, 0, cast(double)screen_height, y));
}


class Plot2d
{
  double[] xs;
  double[] ys;
  double x_min, x_max;
  double y_min, y_max;

  string color;
  string vertex_color;
  bool points, lines;

  this(double[] xs, double[] ys, double x_min, double x_max, double y_min, double y_max)
  in
    {
      assert(xs.length == ys.length);
      assert(x_max >= x_min);
      assert(y_max >= y_min);
    }
  body
    {
      this.xs = xs[]; this.ys = ys[];
      this.x_min = x_min;  this.x_max = x_max;
      this.y_min = y_min;  this.y_max = y_max;
      
      color = "black"; vertex_color = "black";
      points = true; lines = true;
    }
  
  this(double[] xs, double[] ys) {
    this(xs,ys,
	 reduce!(min)(xs[0],xs[1..$]), reduce!(max)(xs[0],xs[1..$]),
	 reduce!(min)(ys[0],ys[1..$]), reduce!(max)(ys[0],ys[1..$]));
  }

  this(double[] xs, double delegate (double) dg)
  {
    double[] ys;
    foreach(x;xs)
      ys ~= dg(x);

    this(xs,ys);
  }
  this(double delegate(double) dg, double x_begin, double x_end, double x_step = double.init)
  {
    double[] xs;
    if(double.init != x_step) {
      xs.length = lround((x_end - x_begin) / x_step);
    } else {
      xs.length = 10;
      x_step = (x_end - x_begin) / xs.length;
    }

    foreach(inout x; xs) {
      x = x_begin;
      x_begin += x_step;
    }
    
    this(xs,dg);
  }

  int x_to_screen(double x, int width) {
    return x_transform(width, x_min, x_max, x);
  }
  int y_to_screen(double y, int height) {
    return y_transform(height, y_min, y_max, y);
  }
}


class Plotter : Canvas
{
 private:
  int width, height;
 public:
  this(Widget parent, int width, int height) {
    super(parent,width,height);
    this.width = width;
    this.height = height;
  }

  void refresh() {
    /// в родителе для определения осуществляется запрос к серверу
    this.width = super.width;
    this.height = super.height;
  }

  void draw_grid (double x_begin, double x_end, double y_begin, double y_end,
                  double screen_step_x = double.init, double screen_step_y = double.init)
  {
    draw_grid("gray", x_begin, x_end, y_begin, y_end, screen_step_x, screen_step_y);
  }

  void draw_grid (string color, double x_begin, double x_end, double y_begin, double y_end,
                  double screen_step_x = double.init, double screen_step_y = double.init)
  {
    screen_step_x = (!isnan(screen_step_x)) ? screen_step_x : ((x_end - x_begin) / 10);
    screen_step_y = (!isnan(screen_step_y)) ? screen_step_y : ((y_end - y_begin) / 10);

    tk.eval1({
	for(double i = x_begin; i<x_end; i += screen_step_x)
	  {
	    int x = x_transform(width, x_begin, x_end, i);
	    this.line(color, x, 0, x, height);
	    this.text(to!(string)(i), x+4, 10);
	    this.text(to!(string)(i), x+4, height-8);
	  }
	
	for(double i = y_begin; i<y_end; i += screen_step_y)
	  {
	    int y = y_transform(height, y_begin, y_end, i);
	    this.line(color, 0, y, width, y);
	    this.text(to!(string)(i), 10, y-6);
	    this.text(to!(string)(i), width-14, y-6);
	  }
      });
  }

  CanvasObject plot_text(Plot2d pl, string txt, double x, double y) {
    return this.text(pl.color, txt, pl.x_to_screen(x, width), pl.y_to_screen(y, height));
  }


  void plot2d(Plot2d pl)
  {
    int[] vertices;
    vertices.length = pl.xs.length * 2;

    tk.delay();

    for(int i=0, j=0; i<vertices.length; i+=2, j+=1) {
      vertices[i] = pl.x_to_screen(pl.xs[j], width);
      vertices[i+1] = pl.y_to_screen(pl.ys[j], height);
    }

    if(pl.lines)
      this.line(pl.color, vertices);
    if(pl.points) {
      for(int i=0; i<vertices.length; i+=2) {
	this.oval(pl.vertex_color, vertices[i]-2, vertices[i+1]-2, vertices[i]+2, vertices[i+1]+2);
      }
    }

    tk.commit();
  }
}
