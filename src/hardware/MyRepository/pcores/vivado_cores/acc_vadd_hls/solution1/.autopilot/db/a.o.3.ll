; ModuleID = '/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores/acc_vadd_hls/solution1/.autopilot/db/a.o.3.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=33 type=[1 x i8]*]
@p_str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1 ; [#uses=2 type=[5 x i8]*]
@p_str3 = private unnamed_addr constant [5 x i8] c"bram\00", align 1 ; [#uses=3 type=[5 x i8]*]
@p_str4 = private unnamed_addr constant [12 x i8] c"RAM_1P_BRAM\00", align 1 ; [#uses=3 type=[12 x i8]*]
@p_str5 = private unnamed_addr constant [9 x i8] c"add_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@p_str6 = private unnamed_addr constant [9 x i8] c"sub_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@str = internal constant [13 x i8] c"acc_vadd_hls\00" ; [#uses=1 type=[13 x i8]*]

; [#uses=6]
define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

; [#uses=2]
define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

; [#uses=12]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

; [#uses=3]
define weak void @_ssdm_op_SpecMemCore(...) {
entry:
  ret void
}

; [#uses=0]
define void @acc_vadd_hls(i32* %cmd, i32* %resp, [4096 x i32]* %a, [4096 x i32]* %b, [4096 x i32]* %result) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %cmd) nounwind, !map !0
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %resp) nounwind, !map !6
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %a) nounwind, !map !10
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %b) nounwind, !map !16
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %result) nounwind, !map !20
  call void (...)* @_ssdm_op_SpecTopModule([13 x i8]* @str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %cmd}, i64 0, metadata !24), !dbg !35 ; [debug line = 32:35] [debug variable = cmd]
  call void @llvm.dbg.value(metadata !{i32* %resp}, i64 0, metadata !36), !dbg !37 ; [debug line = 32:54] [debug variable = resp]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %a}, i64 0, metadata !38), !dbg !42 ; [debug line = 32:64] [debug variable = a]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %b}, i64 0, metadata !43), !dbg !44 ; [debug line = 32:77] [debug variable = b]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %result}, i64 0, metadata !45), !dbg !46 ; [debug line = 32:90] [debug variable = result]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !47 ; [debug line = 34:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %cmd, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !49 ; [debug line = 35:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %resp, [5 x i8]* @p_str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !50 ; [debug line = 36:1]
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %a, [5 x i8]* @p_str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %b, [5 x i8]* @p_str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %result, [5 x i8]* @p_str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %a, [1 x i8]* @p_str1, [12 x i8]* @p_str4, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %b, [1 x i8]* @p_str1, [12 x i8]* @p_str4, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %result, [1 x i8]* @p_str1, [12 x i8]* @p_str4, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  %op = call i32 @_ssdm_op_Read.axis.volatile.i32P(i32* %cmd) nounwind, !dbg !51 ; [#uses=2 type=i32] [debug line = 47:2]
  call void @llvm.dbg.value(metadata !{i32 %op}, i64 0, metadata !52), !dbg !51 ; [debug line = 47:2] [debug variable = op]
  %end = call i32 @_ssdm_op_Read.axis.volatile.i32P(i32* %cmd) nounwind, !dbg !53 ; [#uses=4 type=i32] [debug line = 48:2]
  call void @llvm.dbg.value(metadata !{i32 %end}, i64 0, metadata !54), !dbg !53 ; [debug line = 48:2] [debug variable = end]
  %i_5 = call i32 @_ssdm_op_Read.axis.volatile.i32P(i32* %cmd) nounwind, !dbg !55 ; [#uses=2 type=i32] [debug line = 49:2]
  call void @llvm.dbg.value(metadata !{i32 %i_5}, i64 0, metadata !56), !dbg !57 ; [debug line = 58:18] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i_5}, i64 0, metadata !56), !dbg !59 ; [debug line = 51:18] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i_5}, i64 0, metadata !61), !dbg !55 ; [debug line = 49:2] [debug variable = start]
  %tmp = icmp eq i32 %op, 1, !dbg !62             ; [#uses=1 type=i1] [debug line = 50:2]
  br i1 %tmp, label %.preheader1.preheader, label %3, !dbg !62 ; [debug line = 50:2]

.preheader1.preheader:                            ; preds = %0
  %tmp_1 = add nsw i32 %end, -1, !dbg !63         ; [#uses=1 type=i32] [debug line = 53:7]
  br label %.preheader1, !dbg !59                 ; [debug line = 51:18]

.preheader1:                                      ; preds = %._crit_edge, %.preheader1.preheader
  %i = phi i32 [ %i_2, %._crit_edge ], [ %i_5, %.preheader1.preheader ] ; [#uses=4 type=i32]
  %tmp_3 = icmp slt i32 %i, %end, !dbg !59        ; [#uses=1 type=i1] [debug line = 51:18]
  br i1 %tmp_3, label %1, label %.loopexit2, !dbg !59 ; [debug line = 51:18]

; <label>:1                                       ; preds = %.preheader1
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str5) nounwind, !dbg !65 ; [debug line = 51:44]
  %tmp_5 = sext i32 %i to i64, !dbg !66           ; [#uses=3 type=i64] [debug line = 52:6]
  %a_addr = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp_5, !dbg !66 ; [#uses=1 type=i32*] [debug line = 52:6]
  %a_load = load i32* %a_addr, align 4, !dbg !66  ; [#uses=1 type=i32] [debug line = 52:6]
  %b_addr = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp_5, !dbg !66 ; [#uses=1 type=i32*] [debug line = 52:6]
  %b_load = load i32* %b_addr, align 4, !dbg !66  ; [#uses=1 type=i32] [debug line = 52:6]
  %tmp_6 = add nsw i32 %b_load, %a_load, !dbg !66 ; [#uses=1 type=i32] [debug line = 52:6]
  %result_addr = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp_5, !dbg !66 ; [#uses=1 type=i32*] [debug line = 52:6]
  store i32 %tmp_6, i32* %result_addr, align 4, !dbg !66 ; [debug line = 52:6]
  %tmp_7 = icmp eq i32 %i, %tmp_1, !dbg !63       ; [#uses=1 type=i1] [debug line = 53:7]
  br i1 %tmp_7, label %2, label %._crit_edge, !dbg !63 ; [debug line = 53:7]

; <label>:2                                       ; preds = %1
  call void @_ssdm_op_Write.axis.volatile.i32P(i32* %resp, i32 1) nounwind, !dbg !67 ; [debug line = 54:8]
  br label %._crit_edge, !dbg !69                 ; [debug line = 55:7]

._crit_edge:                                      ; preds = %2, %1
  %i_2 = add nsw i32 %i, 1, !dbg !70              ; [#uses=1 type=i32] [debug line = 51:38]
  call void @llvm.dbg.value(metadata !{i32 %i_2}, i64 0, metadata !56), !dbg !70 ; [debug line = 51:38] [debug variable = i]
  br label %.preheader1, !dbg !70                 ; [debug line = 51:38]

; <label>:3                                       ; preds = %0
  %tmp_2 = icmp eq i32 %op, 2, !dbg !71           ; [#uses=1 type=i1] [debug line = 57:7]
  br i1 %tmp_2, label %.preheader.preheader, label %.loopexit, !dbg !71 ; [debug line = 57:7]

.preheader.preheader:                             ; preds = %3
  %tmp_4 = add nsw i32 %end, -1, !dbg !72         ; [#uses=1 type=i32] [debug line = 60:7]
  br label %.preheader, !dbg !57                  ; [debug line = 58:18]

.preheader:                                       ; preds = %._crit_edge3, %.preheader.preheader
  %i_1 = phi i32 [ %i_3, %._crit_edge3 ], [ %i_5, %.preheader.preheader ] ; [#uses=4 type=i32]
  %tmp_8 = icmp slt i32 %i_1, %end, !dbg !57      ; [#uses=1 type=i1] [debug line = 58:18]
  br i1 %tmp_8, label %4, label %.loopexit, !dbg !57 ; [debug line = 58:18]

; <label>:4                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str6) nounwind, !dbg !74 ; [debug line = 58:44]
  %tmp_s = sext i32 %i_1 to i64, !dbg !75         ; [#uses=3 type=i64] [debug line = 59:6]
  %b_addr_1 = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp_s, !dbg !75 ; [#uses=1 type=i32*] [debug line = 59:6]
  %b_load_1 = load i32* %b_addr_1, align 4, !dbg !75 ; [#uses=1 type=i32] [debug line = 59:6]
  %a_addr_1 = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp_s, !dbg !75 ; [#uses=1 type=i32*] [debug line = 59:6]
  %a_load_1 = load i32* %a_addr_1, align 4, !dbg !75 ; [#uses=1 type=i32] [debug line = 59:6]
  %tmp_9 = add nsw i32 %a_load_1, %b_load_1, !dbg !75 ; [#uses=1 type=i32] [debug line = 59:6]
  %result_addr_1 = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp_s, !dbg !75 ; [#uses=1 type=i32*] [debug line = 59:6]
  store i32 %tmp_9, i32* %result_addr_1, align 4, !dbg !75 ; [debug line = 59:6]
  %tmp_10 = icmp eq i32 %i_1, %tmp_4, !dbg !72    ; [#uses=1 type=i1] [debug line = 60:7]
  br i1 %tmp_10, label %5, label %._crit_edge3, !dbg !72 ; [debug line = 60:7]

; <label>:5                                       ; preds = %4
  call void @_ssdm_op_Write.axis.volatile.i32P(i32* %resp, i32 1) nounwind, !dbg !76 ; [debug line = 61:8]
  br label %._crit_edge3, !dbg !78                ; [debug line = 62:7]

._crit_edge3:                                     ; preds = %5, %4
  %i_3 = add nsw i32 %i_1, 1, !dbg !79            ; [#uses=1 type=i32] [debug line = 58:38]
  call void @llvm.dbg.value(metadata !{i32 %i_3}, i64 0, metadata !56), !dbg !79 ; [debug line = 58:38] [debug variable = i]
  br label %.preheader, !dbg !79                  ; [debug line = 58:38]

.loopexit:                                        ; preds = %.preheader, %3
  br label %.loopexit2

.loopexit2:                                       ; preds = %.loopexit, %.preheader1
  ret void, !dbg !80                              ; [debug line = 64:1]
}

; [#uses=5]
define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; [#uses=3]
define weak i32 @_ssdm_op_Read.axis.volatile.i32P(i32*) {
entry:
  %empty = load i32* %0                           ; [#uses=1 type=i32]
  ret i32 %empty
}

; [#uses=2]
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
!24 = metadata !{i32 786689, metadata !25, metadata !"cmd", metadata !26, i32 16777248, metadata !29, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!25 = metadata !{i32 786478, i32 0, metadata !26, metadata !"acc_vadd_hls", metadata !"acc_vadd_hls", metadata !"_Z12acc_vadd_hlsPViS0_PiS1_S1_", metadata !26, i32 32, metadata !27, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !33, i32 32} ; [ DW_TAG_subprogram ]
!26 = metadata !{i32 786473, metadata !"acc_vadd_hls/.apc/acc_vadd_hls.cpp", metadata !"/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores", null} ; [ DW_TAG_file_type ]
!27 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !28, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!28 = metadata !{null, metadata !29, metadata !29, metadata !32, metadata !32, metadata !32}
!29 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !30} ; [ DW_TAG_pointer_type ]
!30 = metadata !{i32 786485, null, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !31} ; [ DW_TAG_volatile_type ]
!31 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!32 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !31} ; [ DW_TAG_pointer_type ]
!33 = metadata !{metadata !34}
!34 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!35 = metadata !{i32 32, i32 35, metadata !25, null}
!36 = metadata !{i32 786689, metadata !25, metadata !"resp", metadata !26, i32 33554464, metadata !29, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!37 = metadata !{i32 32, i32 54, metadata !25, null}
!38 = metadata !{i32 786689, metadata !25, metadata !"a", null, i32 32, metadata !39, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!39 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 131072, i64 32, i32 0, i32 0, metadata !31, metadata !40, i32 0, i32 0} ; [ DW_TAG_array_type ]
!40 = metadata !{metadata !41}
!41 = metadata !{i32 786465, i64 0, i64 4095}     ; [ DW_TAG_subrange_type ]
!42 = metadata !{i32 32, i32 64, metadata !25, null}
!43 = metadata !{i32 786689, metadata !25, metadata !"b", null, i32 32, metadata !39, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!44 = metadata !{i32 32, i32 77, metadata !25, null}
!45 = metadata !{i32 786689, metadata !25, metadata !"result", null, i32 32, metadata !39, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!46 = metadata !{i32 32, i32 90, metadata !25, null}
!47 = metadata !{i32 34, i32 1, metadata !48, null}
!48 = metadata !{i32 786443, metadata !25, i32 32, i32 105, metadata !26, i32 0} ; [ DW_TAG_lexical_block ]
!49 = metadata !{i32 35, i32 1, metadata !48, null}
!50 = metadata !{i32 36, i32 1, metadata !48, null}
!51 = metadata !{i32 47, i32 2, metadata !48, null}
!52 = metadata !{i32 786688, metadata !48, metadata !"op", metadata !26, i32 45, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 48, i32 2, metadata !48, null}
!54 = metadata !{i32 786688, metadata !48, metadata !"end", metadata !26, i32 45, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!55 = metadata !{i32 49, i32 2, metadata !48, null}
!56 = metadata !{i32 786688, metadata !48, metadata !"i", metadata !26, i32 45, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!57 = metadata !{i32 58, i32 18, metadata !58, null}
!58 = metadata !{i32 786443, metadata !48, i32 58, i32 13, metadata !26, i32 4} ; [ DW_TAG_lexical_block ]
!59 = metadata !{i32 51, i32 18, metadata !60, null}
!60 = metadata !{i32 786443, metadata !48, i32 51, i32 13, metadata !26, i32 1} ; [ DW_TAG_lexical_block ]
!61 = metadata !{i32 786688, metadata !48, metadata !"start", metadata !26, i32 45, metadata !31, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!62 = metadata !{i32 50, i32 2, metadata !48, null}
!63 = metadata !{i32 53, i32 7, metadata !64, null}
!64 = metadata !{i32 786443, metadata !60, i32 51, i32 43, metadata !26, i32 2} ; [ DW_TAG_lexical_block ]
!65 = metadata !{i32 51, i32 44, metadata !64, null}
!66 = metadata !{i32 52, i32 6, metadata !64, null}
!67 = metadata !{i32 54, i32 8, metadata !68, null}
!68 = metadata !{i32 786443, metadata !64, i32 53, i32 23, metadata !26, i32 3} ; [ DW_TAG_lexical_block ]
!69 = metadata !{i32 55, i32 7, metadata !68, null}
!70 = metadata !{i32 51, i32 38, metadata !60, null}
!71 = metadata !{i32 57, i32 7, metadata !48, null}
!72 = metadata !{i32 60, i32 7, metadata !73, null}
!73 = metadata !{i32 786443, metadata !58, i32 58, i32 43, metadata !26, i32 5} ; [ DW_TAG_lexical_block ]
!74 = metadata !{i32 58, i32 44, metadata !73, null}
!75 = metadata !{i32 59, i32 6, metadata !73, null}
!76 = metadata !{i32 61, i32 8, metadata !77, null}
!77 = metadata !{i32 786443, metadata !73, i32 60, i32 23, metadata !26, i32 6} ; [ DW_TAG_lexical_block ]
!78 = metadata !{i32 62, i32 7, metadata !77, null}
!79 = metadata !{i32 58, i32 38, metadata !58, null}
!80 = metadata !{i32 64, i32 1, metadata !48, null}
