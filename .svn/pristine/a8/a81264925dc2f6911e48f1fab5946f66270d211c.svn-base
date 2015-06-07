set moduleName acc_vadd_hls
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_none
set isOneStateSeq 0
set C_modelName acc_vadd_hls
set C_modelType { void 0 }
set C_modelArgList { 
	{ cmd int 32 regular {axi_s 0 volatile  { cmd data } }  }
	{ resp int 32 regular {axi_s 1 volatile  { resp data } }  }
	{ a int 32 regular {bram 4096 { 1 } 1 1 }  }
	{ b int 32 regular {bram 4096 { 1 } 1 1 }  }
	{ result int 32 regular {bram 4096 { 0 } 0 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "cmd", "interface" : "axis", "bitwidth" : 32,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "cmd","cData": "int","cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "resp", "interface" : "axis", "bitwidth" : 32,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "resp","cData": "int","cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "a", "interface" : "bram", "bitwidth" : 32 ,"direction" : "READONLY" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "a","cData": "int","cArray": [{"low" : 0,"up" : 4095,"step" : 1}]}]}]} , 
 	{ "Name" : "b", "interface" : "bram", "bitwidth" : 32 ,"direction" : "READONLY" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "b","cData": "int","cArray": [{"low" : 0,"up" : 4095,"step" : 1}]}]}]} , 
 	{ "Name" : "result", "interface" : "bram", "bitwidth" : 32 ,"direction" : "WRITEONLY" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "result","cData": "int","cArray": [{"low" : 0,"up" : 4095,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 29
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ cmd_TDATA sc_in sc_lv 32 signal 0 } 
	{ cmd_TVALID sc_in sc_logic 1 invld 0 } 
	{ cmd_TREADY sc_out sc_logic 1 inacc 0 } 
	{ resp_TDATA sc_out sc_lv 32 signal 1 } 
	{ resp_TVALID sc_out sc_logic 1 outvld 1 } 
	{ resp_TREADY sc_in sc_logic 1 outacc 1 } 
	{ a_Addr_A sc_out sc_lv 32 signal 2 } 
	{ a_EN_A sc_out sc_logic 1 signal 2 } 
	{ a_WEN_A sc_out sc_lv 4 signal 2 } 
	{ a_Din_A sc_out sc_lv 32 signal 2 } 
	{ a_Dout_A sc_in sc_lv 32 signal 2 } 
	{ a_Clk_A sc_out sc_logic 1 signal 2 } 
	{ a_Rst_A sc_out sc_logic 1 signal 2 } 
	{ b_Addr_A sc_out sc_lv 32 signal 3 } 
	{ b_EN_A sc_out sc_logic 1 signal 3 } 
	{ b_WEN_A sc_out sc_lv 4 signal 3 } 
	{ b_Din_A sc_out sc_lv 32 signal 3 } 
	{ b_Dout_A sc_in sc_lv 32 signal 3 } 
	{ b_Clk_A sc_out sc_logic 1 signal 3 } 
	{ b_Rst_A sc_out sc_logic 1 signal 3 } 
	{ result_Addr_A sc_out sc_lv 32 signal 4 } 
	{ result_EN_A sc_out sc_logic 1 signal 4 } 
	{ result_WEN_A sc_out sc_lv 4 signal 4 } 
	{ result_Din_A sc_out sc_lv 32 signal 4 } 
	{ result_Dout_A sc_in sc_lv 32 signal 4 } 
	{ result_Clk_A sc_out sc_logic 1 signal 4 } 
	{ result_Rst_A sc_out sc_logic 1 signal 4 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "cmd_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "cmd", "role": "TDATA" }} , 
 	{ "name": "cmd_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "cmd", "role": "TVALID" }} , 
 	{ "name": "cmd_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "cmd", "role": "TREADY" }} , 
 	{ "name": "resp_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "resp", "role": "TDATA" }} , 
 	{ "name": "resp_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "resp", "role": "TVALID" }} , 
 	{ "name": "resp_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "resp", "role": "TREADY" }} , 
 	{ "name": "a_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a", "role": "Addr_A" }} , 
 	{ "name": "a_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "EN_A" }} , 
 	{ "name": "a_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a", "role": "WEN_A" }} , 
 	{ "name": "a_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a", "role": "Din_A" }} , 
 	{ "name": "a_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a", "role": "Dout_A" }} , 
 	{ "name": "a_Clk_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "Clk_A" }} , 
 	{ "name": "a_Rst_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a", "role": "Rst_A" }} , 
 	{ "name": "b_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "b", "role": "Addr_A" }} , 
 	{ "name": "b_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "EN_A" }} , 
 	{ "name": "b_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "b", "role": "WEN_A" }} , 
 	{ "name": "b_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "b", "role": "Din_A" }} , 
 	{ "name": "b_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "b", "role": "Dout_A" }} , 
 	{ "name": "b_Clk_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "Clk_A" }} , 
 	{ "name": "b_Rst_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "b", "role": "Rst_A" }} , 
 	{ "name": "result_Addr_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "result", "role": "Addr_A" }} , 
 	{ "name": "result_EN_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "result", "role": "EN_A" }} , 
 	{ "name": "result_WEN_A", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "result", "role": "WEN_A" }} , 
 	{ "name": "result_Din_A", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "result", "role": "Din_A" }} , 
 	{ "name": "result_Dout_A", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "result", "role": "Dout_A" }} , 
 	{ "name": "result_Clk_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "result", "role": "Clk_A" }} , 
 	{ "name": "result_Rst_A", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "result", "role": "Rst_A" }}  ]}
set Spec2ImplPortList { 
	cmd { axis {  { cmd_TDATA in_data 0 32 }  { cmd_TVALID in_vld 0 1 }  { cmd_TREADY in_acc 1 1 } } }
	resp { axis {  { resp_TDATA out_data 1 32 }  { resp_TVALID out_vld 1 1 }  { resp_TREADY out_acc 0 1 } } }
	a { bram {  { a_Addr_A mem_address 1 32 }  { a_EN_A mem_ce 1 1 }  { a_WEN_A mem_we 1 4 }  { a_Din_A mem_din 1 32 }  { a_Dout_A mem_dout 0 32 }  { a_Clk_A mem_clk 1 1 }  { a_Rst_A mem_rst 1 1 } } }
	b { bram {  { b_Addr_A mem_address 1 32 }  { b_EN_A mem_ce 1 1 }  { b_WEN_A mem_we 1 4 }  { b_Din_A mem_din 1 32 }  { b_Dout_A mem_dout 0 32 }  { b_Clk_A mem_clk 1 1 }  { b_Rst_A mem_rst 1 1 } } }
	result { bram {  { result_Addr_A mem_address 1 32 }  { result_EN_A mem_ce 1 1 }  { result_WEN_A mem_we 1 4 }  { result_Din_A mem_din 1 32 }  { result_Dout_A mem_dout 0 32 }  { result_Clk_A mem_clk 1 1 }  { result_Rst_A mem_rst 1 1 } } }
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
