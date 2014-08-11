import std.stdio;
import std.conv;
import std.math;
import std.perf; alias PerformanceCounter.interval_t interval_t;
import std.process;

import dtk.utils;
import dtk.tile;

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
  auto tk = new TileQt(8000,8001);
  tk.debug_mode(true);

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
      auto bstart = new Button(fr, "Start",{ _do_rotate_ = true; rotate(); });
      auto bstop = new Button(fr, "Stop", { _do_rotate_ = false; });

      auto f = new Frame(bar);
      auto l = new Label(f, "Test:");
      auto b1 = new Button(f, "Ok.",  {
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
      auto b3 = new Button(bar, "set!", { e = "{test of set}";});

      auto pwmain = new PanedWindow(root, orient.horizontal);

      auto c = new Canvas(pwmain, 400, 400);
      c.borderwidth = 2; c.relief = relief.raised;
      pwmain.add(c);

      auto nb = new tile.Notebook(pwmain); pwmain.add(nb);
      auto lb = new Listbox(nb, themes());
      bind("<ButtonRelease-1>", lb, delegate void(Widget,Event) {
	  tk.theme(lb.current());
	});
      
      nb.add(lb,"themes");

      auto lb2 = new Listbox(nb, ["B3","CDE","Default","HighColor","HighContrast","Keramik","Motif","MotifPlus","Plastik", "Platinum","SGI","Windows"]);
      bind("<ButtonRelease-1>", lb2, delegate void(Widget,Event) {
	  tk.style(lb2.current());
	});
      
      nb.add(lb2,"styles");
      auto tab = new Grid(nb);
      auto e2 = new Entry(tab); 
      tab.add("-sticky w", new Label(tab, "qwqwqww:"), e2);
      auto cb1 = new tile.ComboBox(tab, "zero","one","two"); cb1.state = "readonly";
      tab.add("-sticky w", new Label(tab, "ererere:"), cb1);
      auto cb2 = new tile.ComboBox(tab);
      tab.add("-sticky w", new Label(tab, "dffdfdf:"), cb2);
      tab.add("-sticky w", new Label(tab,"{}"), new Button(tab, "Test", {
	    writefln("tab: ", e2.value(), " : ", cb1.value(), " : ", cb2.value());
	  }));
     
      nb.add(tab, "tab");
//       for(int i=1; i<=tab.rows; ++i)
// 	tab.rowconfigure(i,"-weight 1");
//       tab.columnconfigure(1,"-weight 1");

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
      mfile.add("Exit", {
	  exit_mainloop(true);
	}, "-underline 1  -accelerator {Alt X}");


      auto mp = new Menu(root);
      mp.add("Option 1", { writefln("Popup 1"); });
      mp.add("Option 2", { writefln("Popup 2");});
      mp.add("Option 3", { writefln("Popup 3");});

      bind("<1>", c, delegate void (Widget,Event e) {
	  popup(mp, e.root_x, e.root_y);
	});

      
      c.borderwidth = 2;  /// 2 равнозначых
      c.relief(relief.sunken); /// способа записи
      pack(pwmain, side.top, fill.both, expand.yes);
      
      pack(bar, side.bottom);
//       pack([r1, r2, r3], Side.left);
//       pack(fradio, Side.left);
     
      pack(side.left, fradio, r1, r2, r3);
      
      pack(side.left,fr,lr);
      fr.borderwidth = 2;
      fr.relief = relief.sunken;
      
      pack(bstart, side.left);
      pack(bstop, side.left);

      f.borderwidth = 2;
      f.relief = relief.sunken;
      
      pack(f, fill.x, side.left);
      pack(side.left, l,b1,e,b2,b3);
      
      int[] lines;
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
