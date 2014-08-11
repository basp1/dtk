import dtk.tk;

import std.stdio;
import std.conv;

void main()
{
  auto tk = new Tk(8000,8001);

  tk.debug_mode(true);
  tk.echo_mode(true); 
  
  with(tk) {
    auto btn = new Button(root,"{Hello world!}");

    puts("[expr {2 + 2}]");
    assert("4" == gets());
    
    btn.activebackground = "#d900d9";

    command(btn, { writefln(btn.text) ; });

    auto c = new Canvas(root);
    c.width = 300; c.height = 100;
    with(c) {
      line(0,0,42,42,21,73);
      oval("green", 130,70,170,95);
      text("hello world", 100,50);
    }

    pack(btn);
    pack(c);

    auto mb = new MenuButton(root, "menubutton");
    auto m = new Menu(mb); m.tearoff = 0;
    m.add("Option 1", { writefln("Option 1");});  m.add("Option 2", { writefln("Option 2");});
    mb.set(m);
    pack(mb);

    
    mainloop();
  }

  delete tk;
  
  return 0;
}
