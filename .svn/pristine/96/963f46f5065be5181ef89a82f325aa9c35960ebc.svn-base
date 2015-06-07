; ModuleID = '/home/sma/Desktop/Projects/C_HLS/acc_vadd/solution1/.autopilot/db/a.o.3.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=12 type=[1 x i8]*]
@p_str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1 ; [#uses=3 type=[5 x i8]*]
@str = internal constant [9 x i8] c"acc_vadd\00"  ; [#uses=1 type=[9 x i8]*]

; [#uses=0]
define void @acc_vadd(i32* %sI1, i32* %sI2, i32* %mO1) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %sI1) nounwind, !map !0
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %sI2) nounwind, !map !6
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %mO1) nounwind, !map !10
  call void (...)* @_ssdm_op_SpecTopModule([9 x i8]* @str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %sI1}, i64 0, metadata !14), !dbg !23 ; [debug line = 2:20] [debug variable = sI1]
  call void @llvm.dbg.value(metadata !{i32* %sI2}, i64 0, metadata !24), !dbg !25 ; [debug line = 2:30] [debug variable = sI2]
  call void @llvm.dbg.value(metadata !{i32* %mO1}, i64 0, metadata !26), !dbg !27 ; [debug line = 2:40] [debug variable = mO1]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !28 ; [debug line = 4:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %sI1, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !30 ; [debug line = 6:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %sI2, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !31 ; [debug line = 7:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %mO1, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !32 ; [debug line = 8:1]
  %sI1_read = call i32 @_ssdm_op_Read.axis.i32P(i32* %sI1) nounwind, !dbg !33 ; [#uses=1 type=i32] [debug line = 10:2]
  %sI2_read = call i32 @_ssdm_op_Read.axis.i32P(i32* %sI2) nounwind, !dbg !33 ; [#uses=1 type=i32] [debug line = 10:2]
  %mO1_assign = add nsw i32 %sI2_read, %sI1_read, !dbg !33 ; [#uses=1 type=i32] [debug line = 10:2]
  call void @_ssdm_op_Write.axis.i32P(i32* %mO1, i32 %mO1_assign) nounwind, !dbg !33 ; [debug line = 10:2]
  ret void, !dbg !34                              ; [debug line = 12:1]
}

; [#uses=4]
define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

; [#uses=3]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

; [#uses=3]
define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; [#uses=2]
define weak i32 @_ssdm_op_Read.axis.i32P(i32*) {
entry:
  %empty = load i32* %0                           ; [#uses=1 type=i32]
  ret i32 %empty
}

; [#uses=1]
define weak void @_ssdm_op_Write.axis.i32P(i32*, i32) {
entry:
  store i32 %1, i32* %0
  ret void
}

!llvm.map.gv = !{}

!0 = metadata !{metadata !1}
!1 = metadata !{i32 0, i32 31, metadata !2}
!2 = metadata !{metadata !3}
!3 = metadata !{metadata !"sI1", metadata !4, metadata !"int"}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 0, i32 0, i32 1}
!6 = metadata !{metadata !7}
!7 = metadata !{i32 0, i32 31, metadata !8}
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !"sI2", metadata !4, metadata !"int"}
!10 = metadata !{metadata !11}
!11 = metadata !{i32 0, i32 31, metadata !12}
!12 = metadata !{metadata !13}
!13 = metadata !{metadata !"mO1", metadata !4, metadata !"int"}
!14 = metadata !{i32 786689, metadata !15, metadata !"sI1", metadata !16, i32 16777218, metadata !19, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!15 = metadata !{i32 786478, i32 0, metadata !16, metadata !"acc_vadd", metadata !"acc_vadd", metadata !"", metadata !16, i32 2, metadata !17, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32*, i32*)* @acc_vadd, null, null, metadata !21, i32 3} ; [ DW_TAG_subprogram ]
!16 = metadata !{i32 786473, metadata !"acc_vadd/acc_vadd.c", metadata !"/home/sma/Desktop/Projects/C_HLS", null} ; [ DW_TAG_file_type ]
!17 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !18, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!18 = metadata !{null, metadata !19, metadata !19, metadata !19}
!19 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !20} ; [ DW_TAG_pointer_type ]
!20 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!21 = metadata !{metadata !22}
!22 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!23 = metadata !{i32 2, i32 20, metadata !15, null}
!24 = metadata !{i32 786689, metadata !15, metadata !"sI2", metadata !16, i32 33554434, metadata !19, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!25 = metadata !{i32 2, i32 30, metadata !15, null}
!26 = metadata !{i32 786689, metadata !15, metadata !"mO1", metadata !16, i32 50331650, metadata !19, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!27 = metadata !{i32 2, i32 40, metadata !15, null}
!28 = metadata !{i32 4, i32 1, metadata !29, null}
!29 = metadata !{i32 786443, metadata !15, i32 3, i32 1, metadata !16, i32 0} ; [ DW_TAG_lexical_block ]
!30 = metadata !{i32 6, i32 1, metadata !29, null}
!31 = metadata !{i32 7, i32 1, metadata !29, null}
!32 = metadata !{i32 8, i32 1, metadata !29, null}
!33 = metadata !{i32 10, i32 2, metadata !29, null}
!34 = metadata !{i32 12, i32 1, metadata !29, null}
