; ModuleID = '/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores/acc_vadd_hls/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1
@p_str3 = private unnamed_addr constant [5 x i8] c"bram\00", align 1
@p_str4 = private unnamed_addr constant [12 x i8] c"RAM_1P_BRAM\00", align 1
@p_str5 = private unnamed_addr constant [9 x i8] c"add_Loop\00", align 1
@p_str6 = private unnamed_addr constant [9 x i8] c"sub_Loop\00", align 1
@str = internal constant [13 x i8] c"acc_vadd_hls\00"

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak void @_ssdm_op_SpecMemCore(...) {
entry:
  ret void
}

define void @acc_vadd_hls(i32* %cmd, i32* %resp, [4096 x i32]* %a, [4096 x i32]* %b, [4096 x i32]* %result) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %cmd) nounwind, !map !0
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %resp) nounwind, !map !6
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %a) nounwind, !map !10
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %b) nounwind, !map !16
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %result) nounwind, !map !20
  call void (...)* @_ssdm_op_SpecTopModule([13 x i8]* @str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %cmd, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %resp, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %a, [5 x i8]* @p_str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %b, [5 x i8]* @p_str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %result, [5 x i8]* @p_str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %a, [1 x i8]* @p_str1, [12 x i8]* @p_str4, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %b, [1 x i8]* @p_str1, [12 x i8]* @p_str4, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %result, [1 x i8]* @p_str1, [12 x i8]* @p_str4, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  %op = call i32 @_ssdm_op_Read.axis.volatile.i32P(i32* %cmd) nounwind
  %end = call i32 @_ssdm_op_Read.axis.volatile.i32P(i32* %cmd) nounwind
  %i_5 = call i32 @_ssdm_op_Read.axis.volatile.i32P(i32* %cmd) nounwind
  %tmp = icmp eq i32 %op, 1
  br i1 %tmp, label %.preheader1.preheader, label %3

.preheader1.preheader:                            ; preds = %0
  %tmp_1 = add nsw i32 %end, -1
  br label %.preheader1

.preheader1:                                      ; preds = %._crit_edge, %.preheader1.preheader
  %i = phi i32 [ %i_2, %._crit_edge ], [ %i_5, %.preheader1.preheader ]
  %tmp_3 = icmp slt i32 %i, %end
  br i1 %tmp_3, label %1, label %.loopexit2

; <label>:1                                       ; preds = %.preheader1
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str5) nounwind
  %tmp_5 = sext i32 %i to i64
  %a_addr = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp_5
  %a_load = load i32* %a_addr, align 4
  %b_addr = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp_5
  %b_load = load i32* %b_addr, align 4
  %tmp_6 = add nsw i32 %b_load, %a_load
  %result_addr = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp_5
  store i32 %tmp_6, i32* %result_addr, align 4
  %tmp_7 = icmp eq i32 %i, %tmp_1
  br i1 %tmp_7, label %2, label %._crit_edge

; <label>:2                                       ; preds = %1
  call void @_ssdm_op_Write.axis.volatile.i32P(i32* %resp, i32 1) nounwind
  br label %._crit_edge

._crit_edge:                                      ; preds = %2, %1
  %i_2 = add nsw i32 %i, 1
  br label %.preheader1

; <label>:3                                       ; preds = %0
  %tmp_2 = icmp eq i32 %op, 2
  br i1 %tmp_2, label %.preheader.preheader, label %.loopexit

.preheader.preheader:                             ; preds = %3
  %tmp_4 = add nsw i32 %end, -1
  br label %.preheader

.preheader:                                       ; preds = %._crit_edge3, %.preheader.preheader
  %i_1 = phi i32 [ %i_3, %._crit_edge3 ], [ %i_5, %.preheader.preheader ]
  %tmp_8 = icmp slt i32 %i_1, %end
  br i1 %tmp_8, label %4, label %.loopexit

; <label>:4                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str6) nounwind
  %tmp_s = sext i32 %i_1 to i64
  %b_addr_1 = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp_s
  %b_load_1 = load i32* %b_addr_1, align 4
  %a_addr_1 = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp_s
  %a_load_1 = load i32* %a_addr_1, align 4
  %tmp_9 = add nsw i32 %a_load_1, %b_load_1
  %result_addr_1 = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp_s
  store i32 %tmp_9, i32* %result_addr_1, align 4
  %tmp_10 = icmp eq i32 %i_1, %tmp_4
  br i1 %tmp_10, label %5, label %._crit_edge3

; <label>:5                                       ; preds = %4
  call void @_ssdm_op_Write.axis.volatile.i32P(i32* %resp, i32 1) nounwind
  br label %._crit_edge3

._crit_edge3:                                     ; preds = %5, %4
  %i_3 = add nsw i32 %i_1, 1
  br label %.preheader

.loopexit:                                        ; preds = %.preheader, %3
  br label %.loopexit2

.loopexit2:                                       ; preds = %.preheader1, %.loopexit
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_Read.axis.volatile.i32P(i32*) {
entry:
  %empty = load i32* %0
  ret i32 %empty
}

define weak void @_ssdm_op_Write.axis.volatile.i32P(i32*, i32) {
entry:
  store i32 %1, i32* %0
  ret void
}

!llvm.map.gv = !{}

!0 = metadata !{metadata !1}
!1 = metadata !{i32 0, i32 31, metadata !2}
!2 = metadata !{metadata !3}
!3 = metadata !{metadata !"cmd", metadata !4, metadata !"int"}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 0, i32 0, i32 1}
!6 = metadata !{metadata !7}
!7 = metadata !{i32 0, i32 31, metadata !8}
!8 = metadata !{metadata !9}
!9 = metadata !{metadata !"resp", metadata !4, metadata !"int"}
!10 = metadata !{metadata !11}
!11 = metadata !{i32 0, i32 31, metadata !12}
!12 = metadata !{metadata !13}
!13 = metadata !{metadata !"a", metadata !14, metadata !"int"}
!14 = metadata !{metadata !15}
!15 = metadata !{i32 0, i32 4095, i32 1}
!16 = metadata !{metadata !17}
!17 = metadata !{i32 0, i32 31, metadata !18}
!18 = metadata !{metadata !19}
!19 = metadata !{metadata !"b", metadata !14, metadata !"int"}
!20 = metadata !{metadata !21}
!21 = metadata !{i32 0, i32 31, metadata !22}
!22 = metadata !{metadata !23}
!23 = metadata !{metadata !"result", metadata !14, metadata !"int"}
