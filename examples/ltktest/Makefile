include ../../config.in

all:
	$(DMD) $(LIB) $(INC) -unittest -ofa.out -od/tmp ltktest.d;

test:
	../../server.tcl & (sleep 1; ./a.out)

clean:
	rm ./a.out

