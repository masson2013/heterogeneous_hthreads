VC = iverilog
VVP = vvp
SRCS = sfa_2x2.v sfa_switch.v sfa_control.v sfa_interconnect.v sfa_5to1_mux.v sfa_bif.v

all: design vvp

design: $(SRCS)
	$(VC) -o design $(SRCS)

vvp:
	$(VVP) design

clean:
	rm design
	rm *.vcd
