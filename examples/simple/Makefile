include ../../config.in

all:
	$(DMD) $(LIB) $(INC) -unittest -ofa.out -od/tmp simple.d;

test:
	../../server.tcl & (sleep 1; ./a.out)

clean:
	rm ./a.out

