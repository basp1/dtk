import std.stdio;
import std.conv;
import std.math;
import std.perf; alias PerformanceCounter.interval_t interval_t;
import std.process;

import dtk.utils;
import dtk.tk;

Canvas _demo_canvas_;
string _demo_line_;
bool _do_rotate_;

double _angle_  = 0.0;
double _angle2_ = 0.0;
double _angle3_ = 0.0;

void rotate()
{
  int[] lines;
  double dx = 50 * sin(_angle2_);
  double dy = 50 * cos(_angle2_);
  double wx = sin(_angle3_);

  _angle_  += 0.1;
  _angle2_ += 0.03;
  _angle3_ += 0.01;
      
  for(int i=0; i<100; ++i)
    {
      double w = _angle_ + (i * 2.8001);
      int x = cast(int)(dx + 250.0 + (150.0 * sin(w) * wx));
      int y = cast(int)(dy + 200.0 + (150.0 * cos(w)));
      lines = y ~ lines;
      lines = x ~ lines;
    }
  _demo_canvas_.coords(_demo_line_, lines);
  system("sleep 0.025");
}

void main()
{
  auto tk = new Tk(8000,8001);
  tk.debug_mode(true);
  tk.echo_mode(true);

  with(tk)
    {
      auto bar = new Frame(root);

      auto fradio = new RadioFrame(bar);
      auto r1 = new RadioButton(fradio, "fried",  "1"); // "1" -> value
      auto r2 = new RadioButton(fradio, "stirred","2");
      auto r3 = new RadioButton(fradio, "cooked", "3");

      foreach(r;[r1,r2,r3])
	command(r, { writefln(fradio.value()); });

      auto fr = new Frame(bar);
      auto lr = new Label(fr, "Rotation:");
      auto bstart = new Button(fr, "Start",{
	  _do_rotate_ = true;
	  rotate();
	});
      auto bstop = new Button(fr, "Stop", { _do_rotate_ = false; });

      auto f = new Frame(bar);
      auto l = new Label(f, "Test:");
      auto b1 = new Button(f, "Ok.", {
	  auto timer = new PerformanceCounter;
	  timer.start();
	  for(int i=0; i<1000; ++i) {
	    rotate();
	  }
	  timer.stop();
	  writefln("test_rotation: ",timer.milliseconds,"ms");
	});

      auto e = new Entry(bar);
      auto b2 = new Button(bar, "get!", { writefln("content of entry:", e.value());});
      auto b3 = new Button(bar, "set!", { e = "{test of set}"; });

      auto fmain = new Frame(root);

      auto c = new Canvas(fmain, 300, 400); // :borderwidth 2 :relief :raised))
      int[] lines;

      auto mb = new Menu(root); mb.tearoff = 0;
      auto mfile = new Menu(mb);  mb.add("File", mfile);
      mfile.add("New", { new Toplevel(root,"hello"); });

      mfile.add();
      mfile.add("Load", { writefln("Load pressed");}, "-underline 1");
      mfile.add("Save", { writefln("Save pressed");}, "-underline 1");
      mb.set();
    
      auto mf_export = new Menu(mfile);  mfile.add("Export...",mf_export);
      mf_export.add("Postscript", {
	  c.export_to(getSaveFile("Сохранить как postscript"));
	});
      mf_export.add("jpeg", { writefln("Jpeg pressed");});
      mf_export.add("png", { writefln("Png pressed");});

      mfile.add();
      mfile.add("Exit", {exit_mainloop(true);}, "-underline 1  -accelerator {Alt X}");

      auto mp = new Menu(root);
      mp.add("Option 1", { writefln("Popup 1");});
      mp.add("Option 2", { writefln("Popup 2");});
      mp.add("Option 3", { writefln("Popup 3");});

      bind("<1>", c, delegate void (Widget,Event e) {
	  popup(mp, e.root_x, e.root_y);
	});


      bind("<Destroy>", root,
	   delegate void(Widget, Event) {
	     quit();
	   });
      
      c.borderwidth= 2;
      c.relief = relief.sunken;
      pack(c, side.left, fill.both, expand.yes);
      pack(fmain, fill.both, side.top, expand.yes);
      
      pack(bar, side.bottom);
      pack([r1, r2, r3], side.left);
      pack(fradio, side.left);

      pack(fr, side.left);      
      pack(lr, side.left);
      fr.borderwidth = 2;
      fr.relief = relief.sunken;
      
      pack(bstart, side.left);
      pack(bstop, side.left);
      f.borderwidth = 2;
      f.relief = relief.sunken;
      
      pack(f, fill.x, side.left);
      pack(side.left, l,b1,e,b2,b3);
      
      for(int i=0; i<100; ++i)
	{
	  double w = i * 2.8001;
	  auto x = 250 + (150.0 * sin(w));
	  auto y = 200 + (150.0 * cos(w));
	  lines = (cast(int)y) ~ lines;
	  lines = (cast(int)x) ~ lines;
	}
      _demo_line_ = (c.line(lines)).name;
      _demo_canvas_ = c;
      c.text("Dtk Demonstration", 80,15);
      mainloop();
    }

  delete tk;
  
  return 0;
}
