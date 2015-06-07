VC = iverilog
VVP = vvp
SRCS = sm_timer_64.v sm_timer_64_tb.v

all: design vvp

design: $(SRCS)
	$(VC) -o design $(SRCS)

vvp:
	$(VVP) design

clean:
	rm design
	rm *.vcd
