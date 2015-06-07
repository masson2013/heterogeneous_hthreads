set language "C"
set globalAPint ""
set globalVariable ""
set staticVariable ""
set moduleName "vectoradd"
set moduleIsExternC "0"
set rawDecl [list "void" "vectoradd \( volatile int *cmd, volatile int *resp, int a\[4096\], int b\[4096\], int result\[4096\] \)"]
set argAPint ""
set returnAPint ""
set portList ""
set portName0 "cmd"
set portInterface0 "[list axis 0]"
set portData0 "int"
set portPointer0 "1"
set portArrayDim0 0
set portConst0 "0"
set portVolatile0 "1"
set portArrayOpt0 ""
set port0 [list $portName0 $portInterface0 $portData0 $portPointer0 $portArrayDim0 $portConst0 $portVolatile0 $portArrayOpt0]
lappend portList $port0
set portName1 "resp"
set portInterface1 "[list axis 0]"
set portData1 "int"
set portPointer1 "1"
set portArrayDim1 0
set portConst1 "0"
set portVolatile1 "1"
set portArrayOpt1 ""
set port1 [list $portName1 $portInterface1 $portData1 $portPointer1 $portArrayDim1 $portConst1 $portVolatile1 $portArrayOpt1]
lappend portList $port1
set portName2 "a"
set portInterface2 "memory"
set portData2 "int"
set portPointer2 "0"
set portArrayDim2 [list 4096]
set portConst2 "0"
set portVolatile2 "0"
set portArrayOpt2 ""
set port2 [list $portName2 $portInterface2 $portData2 $portPointer2 $portArrayDim2 $portConst2 $portVolatile2 $portArrayOpt2]
lappend portList $port2
set portName3 "b"
set portInterface3 "memory"
set portData3 "int"
set portPointer3 "0"
set portArrayDim3 [list 4096]
set portConst3 "0"
set portVolatile3 "0"
set portArrayOpt3 ""
set port3 [list $portName3 $portInterface3 $portData3 $portPointer3 $portArrayDim3 $portConst3 $portVolatile3 $portArrayOpt3]
lappend portList $port3
set portName4 "result"
set portInterface4 "memory"
set portData4 "int"
set portPointer4 "0"
set portArrayDim4 [list 4096]
set portConst4 "0"
set portVolatile4 "0"
set portArrayOpt4 ""
set port4 [list $portName4 $portInterface4 $portData4 $portPointer4 $portArrayDim4 $portConst4 $portVolatile4 $portArrayOpt4]
lappend portList $port4
set dataPackList ""
set module [list $moduleName $portList $rawDecl $argAPint $returnAPint $dataPackList]
set hasCPPAPInt 0
set hasCPPAPFix 0
set hasSCFix 0
set hasCPPComplex 0
set hasCBool 0
set isTemplateTop 0
set useIntT 0
