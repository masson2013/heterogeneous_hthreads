set moduleName acc_vadd
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_none
set isOneStateSeq 1
set C_modelName acc_vadd
set C_modelType { void 0 }
set C_modelArgList { 
	{ sI1 int 32 regular {axi_s 0 ""  { sI1 data } }  }
	{ sI2 int 32 regular {axi_s 0 ""  { sI2 data } }  }
	{ mO1 int 32 regular {axi_s 1 ""  { mO1 data } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "sI1", "interface" : "axis", "bitwidth" : 32,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "sI1","cData": "int","cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "sI2", "interface" : "axis", "bitwidth" : 32,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "sI2","cData": "int","cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "mO1", "interface" : "axis", "bitwidth" : 32,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "mO1","cData": "int","cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 11
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ sI1_TDATA sc_in sc_lv 32 signal 0 } 
	{ sI1_TVALID sc_in sc_logic 1 invld 0 } 
	{ sI1_TREADY sc_out sc_logic 1 inacc 0 } 
	{ sI2_TDATA sc_in sc_lv 32 signal 1 } 
	{ sI2_TVALID sc_in sc_logic 1 invld 1 } 
	{ sI2_TREADY sc_out sc_logic 1 inacc 1 } 
	{ mO1_TDATA sc_out sc_lv 32 signal 2 } 
	{ mO1_TVALID sc_out sc_logic 1 outvld 2 } 
	{ mO1_TREADY sc_in sc_logic 1 outacc 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "sI1_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "sI1", "role": "TDATA" }} , 
 	{ "name": "sI1_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "sI1", "role": "TVALID" }} , 
 	{ "name": "sI1_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "sI1", "role": "TREADY" }} , 
 	{ "name": "sI2_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "sI2", "role": "TDATA" }} , 
 	{ "name": "sI2_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "sI2", "role": "TVALID" }} , 
 	{ "name": "sI2_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "sI2", "role": "TREADY" }} , 
 	{ "name": "mO1_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mO1", "role": "TDATA" }} , 
 	{ "name": "mO1_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "mO1", "role": "TVALID" }} , 
 	{ "name": "mO1_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "mO1", "role": "TREADY" }}  ]}
set Spec2ImplPortList { 
	sI1 { axis {  { sI1_TDATA in_data 0 32 }  { sI1_TVALID in_vld 0 1 }  { sI1_TREADY in_acc 1 1 } } }
	sI2 { axis {  { sI2_TDATA in_data 0 32 }  { sI2_TVALID in_vld 0 1 }  { sI2_TREADY in_acc 1 1 } } }
	mO1 { axis {  { mO1_TDATA out_data 1 32 }  { mO1_TVALID out_vld 1 1 }  { mO1_TREADY out_acc 0 1 } } }
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
