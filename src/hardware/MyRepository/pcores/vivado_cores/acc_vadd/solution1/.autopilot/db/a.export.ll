; ModuleID = '/home/sma/Desktop/Projects/C_HLS/acc_vadd/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1
@str = internal constant [9 x i8] c"acc_vadd\00"

define void @acc_vadd(i32* %sI1, i32* %sI2, i32* %mO1) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %sI1) nounwind, !map !0
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %sI2) nounwind, !map !6
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %mO1) nounwind, !map !10
  call void (...)* @_ssdm_op_SpecTopModule([9 x i8]* @str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %sI1, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %sI2, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %mO1, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  %sI1_read = call i32 @_ssdm_op_Read.axis.i32P(i32* %sI1) nounwind
  %sI2_read = call i32 @_ssdm_op_Read.axis.i32P(i32* %sI2) nounwind
  %mO1_assign = add nsw i32 %sI2_read, %sI1_read
  call void @_ssdm_op_Write.axis.i32P(i32* %mO1, i32 %mO1_assign) nounwind
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_Read.axis.i32P(i32*) {
entry:
  %empty = load i32* %0
  ret i32 %empty
}

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
