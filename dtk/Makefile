include ../config.in

FILES = tk.d ./tcl.d ./tclserver.d  ./ctcl.d ./tkwidgets.d ./tile.d ./tilewidgets.d ./widgets/tile/notebook.d ./widgets/tile/combobox.d ./widgets/canvas.d ./widgets/listbox.d ./widgets/table.d ./widgets/grid.d ./widgets/menu.d ./widgets/menubutton.d ./widgets/plotter.d ./widgets/entry.d ./widgets/text.d ./widgets/attributes.d ./widgets/radiobutton.d ./widgets/panedwindow.d ./widgets/radioframe.d ./widgets/toplevel.d ./widgets/label.d ./widgets/button.d ./widgets/frame.d ./utils.d ./widget.d ./event.d

all:
	$(DMD) -unittest -oflibdtk.a -lib $(FILES)
	
test:
	$(DMD) -unittest -ofa.out -L-ltcl8.4 -L-ltk8.4 unittest.d $(FILES); ./a.out



release:
	$(DMD) -release -O -oflibdtk.a -lib $(FILES)
clean:
	rm libdtk.a
