; ModuleID = '/home/sma/Desktop/Projects/C_HLS/acc_vadd/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@.str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=12 type=[1 x i8]*]
@.str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1 ; [#uses=3 type=[5 x i8]*]
@str = internal constant [9 x i8] c"acc_vadd\00"  ; [#uses=1 type=[9 x i8]*]

; [#uses=0]
define void @acc_vadd(i32* %sI1, i32* %sI2, i32* %mO1) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %sI1) nounwind, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %sI2) nounwind, !map !19
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %mO1) nounwind, !map !23
  call void (...)* @_ssdm_op_SpecTopModule([9 x i8]* @str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %sI1}, i64 0, metadata !27), !dbg !28 ; [debug line = 2:20] [debug variable = sI1]
  call void @llvm.dbg.value(metadata !{i32* %sI2}, i64 0, metadata !29), !dbg !30 ; [debug line = 2:30] [debug variable = sI2]
  call void @llvm.dbg.value(metadata !{i32* %mO1}, i64 0, metadata !31), !dbg !32 ; [debug line = 2:40] [debug variable = mO1]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @.str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !33 ; [debug line = 4:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %sI1, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !35 ; [debug line = 6:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %sI2, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !36 ; [debug line = 7:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %mO1, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !37 ; [debug line = 8:1]
  %sI1.load = load i32* %sI1, align 4, !dbg !38   ; [#uses=1 type=i32] [debug line = 10:2]
  %sI2.load = load i32* %sI2, align 4, !dbg !38   ; [#uses=1 type=i32] [debug line = 10:2]
  %mO1.assign = add nsw i32 %sI2.load, %sI1.load, !dbg !38 ; [#uses=1 type=i32] [debug line = 10:2]
  store i32 %mO1.assign, i32* %mO1, align 4, !dbg !38 ; [debug line = 10:2]
  ret void, !dbg !39                              ; [debug line = 12:1]
}

; [#uses=4]
declare void @_ssdm_op_SpecInterface(...) nounwind

; [#uses=3]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
declare void @_ssdm_op_SpecTopModule(...)

; [#uses=3]
declare void @_ssdm_op_SpecBitsMap(...)

!llvm.dbg.cu = !{!0}
!llvm.map.gv = !{}

!0 = metadata !{i32 786449, i32 0, i32 1, metadata !"/home/sma/Desktop/Projects/C_HLS/acc_vadd/solution1/.autopilot/db/acc_vadd.pragma.2.c", metadata !"/home/sma/Desktop/Projects/C_HLS", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !1} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"acc_vadd", metadata !"acc_vadd", metadata !"", metadata !6, i32 2, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32*, i32*)* @acc_vadd, null, null, metadata !11, i32 3} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"acc_vadd/acc_vadd.c", metadata !"/home/sma/Desktop/Projects/C_HLS", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null, metadata !9, metadata !9, metadata !9}
!9 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!10 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 0, i32 31, metadata !15}
!15 = metadata !{metadata !16}
!16 = metadata !{metadata !"sI1", metadata !17, metadata !"int"}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 0, i32 0, i32 1}
!19 = metadata !{metadata !20}
!20 = metadata !{i32 0, i32 31, metadata !21}
!21 = metadata !{metadata !22}
!22 = metadata !{metadata !"sI2", metadata !17, metadata !"int"}
!23 = metadata !{metadata !24}
!24 = metadata !{i32 0, i32 31, metadata !25}
!25 = metadata !{metadata !26}
!26 = metadata !{metadata !"mO1", metadata !17, metadata !"int"}
!27 = metadata !{i32 786689, metadata !5, metadata !"sI1", metadata !6, i32 16777218, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!28 = metadata !{i32 2, i32 20, metadata !5, null}
!29 = metadata !{i32 786689, metadata !5, metadata !"sI2", metadata !6, i32 33554434, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!30 = metadata !{i32 2, i32 30, metadata !5, null}
!31 = metadata !{i32 786689, metadata !5, metadata !"mO1", metadata !6, i32 50331650, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!32 = metadata !{i32 2, i32 40, metadata !5, null}
!33 = metadata !{i32 4, i32 1, metadata !34, null}
!34 = metadata !{i32 786443, metadata !5, i32 3, i32 1, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!35 = metadata !{i32 6, i32 1, metadata !34, null}
!36 = metadata !{i32 7, i32 1, metadata !34, null}
!37 = metadata !{i32 8, i32 1, metadata !34, null}
!38 = metadata !{i32 10, i32 2, metadata !34, null}
!39 = metadata !{i32 12, i32 1, metadata !34, null}
