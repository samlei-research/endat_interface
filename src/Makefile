#-fsynopsys

.PHONY: sim
sim:
	ghdl -a -fsynopsys -fexplicit absenc_pkg.vhdl absenc_utils.vhdl absenc_slave.vhdl absenc_slave_endat.vhdl absenc_master.vhdl absenc_master_endat.vhdl endat_tb.vhdl
	ghdl -r -fsynopsys -fexplicit endat_tb --wave=endat_tb.ghw # <-- the bug occurs with this command
	gtkwave -A endat_tb.ghw &

# Testbench targets
endat_tb: endat_tb.o absenc_master_endat.o absenc_master.o absenc_pkg.o absenc_utils.o
	ghdl -e $@

# Automate ghdl analyze
%.o:	%.vhdl
	ghdl -a $<

# dependencies
endat_tb.o: absenc_master_endat.o, absenc_master.o, absenc_pkg.o absenc_utils.o



