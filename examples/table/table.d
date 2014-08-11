import dtk.tk;

import std.stdio;
import std.conv;
import std.process;
import std.string;

void main()
{
  auto tk = new Tk(8000,8001);

  tk.debug_mode(true);

  with(tk) {

    tk.eval1({
	auto gr = new Grid(root);
	gr.border = 1; gr.bordercolor = "darkgray";
	gr.add(["1","2"]);  gr.add(["4","5"]);
	gr.reset();
	gr.add(["1","2","3"]);  gr.add(["4","5","6"]);
	gr.add(["7","8","9"]);
	pack(gr);

	auto tbl = new Table(root);
	tbl.border = 1; tbl.bordercolor = "black";
	tbl.add([["yes","yes","no"],["false","true","false"]]);
	tbl.add(["42","17"]);
	pack(tbl);
	
	auto btn = new Button(root, "Reload", {
	    string[][] table;
	    auto strings = split(gets("global",tbl.variable,";","array get",tbl.variable));
	    table.length = 2;
	    foreach(inout t; table)
	      t.length = 2;
	    for(int i=0; i<strings.length; i+=2) {
	      auto keys = split(strings[i],",");
	      table[to!(int)(keys[0])][to!(int)(keys[1])] = strings[i+1];
	    }
	    writeln(table);
	  });
	pack(btn);
      });


    mainloop();
  }

  delete tk;
  
  return 0;
}
