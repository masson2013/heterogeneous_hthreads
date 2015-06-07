; ModuleID = '/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores/acc_vadd_hls/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@.str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=33 type=[1 x i8]*]
@.str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1 ; [#uses=2 type=[5 x i8]*]
@.str3 = private unnamed_addr constant [5 x i8] c"bram\00", align 1 ; [#uses=3 type=[5 x i8]*]
@.str4 = private unnamed_addr constant [12 x i8] c"RAM_1P_BRAM\00", align 1 ; [#uses=3 type=[12 x i8]*]
@.str5 = private unnamed_addr constant [9 x i8] c"add_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@.str6 = private unnamed_addr constant [9 x i8] c"sub_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@str = internal constant [13 x i8] c"acc_vadd_hls\00" ; [#uses=1 type=[13 x i8]*]

; [#uses=6]
declare void @_ssdm_op_SpecInterface(...) nounwind

; [#uses=2]
declare void @_ssdm_op_SpecLoopName(...) nounwind

; [#uses=12]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
declare void @_ssdm_op_SpecTopModule(...)

; [#uses=3]
declare void @_ssdm_op_SpecMemCore(...)

; [#uses=0]
define void @acc_vadd_hls(i32* %cmd, i32* %resp, [4096 x i32]* %a, [4096 x i32]* %b, [4096 x i32]* %result) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %cmd) nounwind, !map !15
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %resp) nounwind, !map !21
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %a) nounwind, !map !25
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %b) nounwind, !map !31
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %result) nounwind, !map !35
  call void (...)* @_ssdm_op_SpecTopModule([13 x i8]* @str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %cmd}, i64 0, metadata !39), !dbg !40 ; [debug line = 32:35] [debug variable = cmd]
  call void @llvm.dbg.value(metadata !{i32* %resp}, i64 0, metadata !41), !dbg !42 ; [debug line = 32:54] [debug variable = resp]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %a}, i64 0, metadata !43), !dbg !47 ; [debug line = 32:64] [debug variable = a]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %b}, i64 0, metadata !48), !dbg !49 ; [debug line = 32:77] [debug variable = b]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %result}, i64 0, metadata !50), !dbg !51 ; [debug line = 32:90] [debug variable = result]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @.str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !52 ; [debug line = 34:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %cmd, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !54 ; [debug line = 35:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %resp, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 16, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !55 ; [debug line = 36:1]
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %a, [5 x i8]* @.str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %b, [5 x i8]* @.str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %result, [5 x i8]* @.str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %a, [1 x i8]* @.str1, [12 x i8]* @.str4, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %b, [1 x i8]* @.str1, [12 x i8]* @.str4, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %result, [1 x i8]* @.str1, [12 x i8]* @.str4, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  %op = load volatile i32* %cmd, align 4, !dbg !56 ; [#uses=2 type=i32] [debug line = 47:2]
  call void @llvm.dbg.value(metadata !{i32 %op}, i64 0, metadata !57), !dbg !56 ; [debug line = 47:2] [debug variable = op]
  %end = load volatile i32* %cmd, align 4, !dbg !58 ; [#uses=4 type=i32] [debug line = 48:2]
  call void @llvm.dbg.value(metadata !{i32 %end}, i64 0, metadata !59), !dbg !58 ; [debug line = 48:2] [debug variable = end]
  %i.5 = load volatile i32* %cmd, align 4, !dbg !60 ; [#uses=2 type=i32] [debug line = 49:2]
  call void @llvm.dbg.value(metadata !{i32 %i.5}, i64 0, metadata !61), !dbg !62 ; [debug line = 58:18] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i.5}, i64 0, metadata !61), !dbg !64 ; [debug line = 51:18] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i.5}, i64 0, metadata !66), !dbg !60 ; [debug line = 49:2] [debug variable = start]
  %tmp = icmp eq i32 %op, 1, !dbg !67             ; [#uses=1 type=i1] [debug line = 50:2]
  br i1 %tmp, label %.preheader1.preheader, label %3, !dbg !67 ; [debug line = 50:2]

.preheader1.preheader:                            ; preds = %0
  %tmp.1 = add nsw i32 %end, -1, !dbg !68         ; [#uses=1 type=i32] [debug line = 53:7]
  br label %.preheader1, !dbg !64                 ; [debug line = 51:18]

.preheader1:                                      ; preds = %._crit_edge, %.preheader1.preheader
  %i = phi i32 [ %i.2, %._crit_edge ], [ %i.5, %.preheader1.preheader ] ; [#uses=4 type=i32]
  %tmp.3 = icmp slt i32 %i, %end, !dbg !64        ; [#uses=1 type=i1] [debug line = 51:18]
  br i1 %tmp.3, label %1, label %.loopexit2, !dbg !64 ; [debug line = 51:18]

; <label>:1                                       ; preds = %.preheader1
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @.str5) nounwind, !dbg !70 ; [debug line = 51:44]
  %tmp.5 = sext i32 %i to i64, !dbg !71           ; [#uses=3 type=i64] [debug line = 52:6]
  %a.addr = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp.5, !dbg !71 ; [#uses=1 type=i32*] [debug line = 52:6]
  %a.load = load i32* %a.addr, align 4, !dbg !71  ; [#uses=1 type=i32] [debug line = 52:6]
  %b.addr = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp.5, !dbg !71 ; [#uses=1 type=i32*] [debug line = 52:6]
  %b.load = load i32* %b.addr, align 4, !dbg !71  ; [#uses=1 type=i32] [debug line = 52:6]
  %tmp.6 = add nsw i32 %b.load, %a.load, !dbg !71 ; [#uses=1 type=i32] [debug line = 52:6]
  %result.addr = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp.5, !dbg !71 ; [#uses=1 type=i32*] [debug line = 52:6]
  store i32 %tmp.6, i32* %result.addr, align 4, !dbg !71 ; [debug line = 52:6]
  %tmp.7 = icmp eq i32 %i, %tmp.1, !dbg !68       ; [#uses=1 type=i1] [debug line = 53:7]
  br i1 %tmp.7, label %2, label %._crit_edge, !dbg !68 ; [debug line = 53:7]

; <label>:2                                       ; preds = %1
  store volatile i32 1, i32* %resp, align 4, !dbg !72 ; [debug line = 54:8]
  br label %._crit_edge, !dbg !74                 ; [debug line = 55:7]

._crit_edge:                                      ; preds = %2, %1
  %i.2 = add nsw i32 %i, 1, !dbg !75              ; [#uses=1 type=i32] [debug line = 51:38]
  call void @llvm.dbg.value(metadata !{i32 %i.2}, i64 0, metadata !61), !dbg !75 ; [debug line = 51:38] [debug variable = i]
  br label %.preheader1, !dbg !75                 ; [debug line = 51:38]

; <label>:3                                       ; preds = %0
  %tmp.2 = icmp eq i32 %op, 2, !dbg !76           ; [#uses=1 type=i1] [debug line = 57:7]
  br i1 %tmp.2, label %.preheader.preheader, label %.loopexit, !dbg !76 ; [debug line = 57:7]

.preheader.preheader:                             ; preds = %3
  %tmp.4 = add nsw i32 %end, -1, !dbg !77         ; [#uses=1 type=i32] [debug line = 60:7]
  br label %.preheader, !dbg !62                  ; [debug line = 58:18]

.preheader:                                       ; preds = %._crit_edge3, %.preheader.preheader
  %i.1 = phi i32 [ %i.3, %._crit_edge3 ], [ %i.5, %.preheader.preheader ] ; [#uses=4 type=i32]
  %tmp.8 = icmp slt i32 %i.1, %end, !dbg !62      ; [#uses=1 type=i1] [debug line = 58:18]
  br i1 %tmp.8, label %4, label %.loopexit, !dbg !62 ; [debug line = 58:18]

; <label>:4                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @.str6) nounwind, !dbg !79 ; [debug line = 58:44]
  %tmp. = sext i32 %i.1 to i64, !dbg !80          ; [#uses=3 type=i64] [debug line = 59:6]
  %b.addr.1 = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp., !dbg !80 ; [#uses=1 type=i32*] [debug line = 59:6]
  %b.load.1 = load i32* %b.addr.1, align 4, !dbg !80 ; [#uses=1 type=i32] [debug line = 59:6]
  %a.addr.1 = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp., !dbg !80 ; [#uses=1 type=i32*] [debug line = 59:6]
  %a.load.1 = load i32* %a.addr.1, align 4, !dbg !80 ; [#uses=1 type=i32] [debug line = 59:6]
  %tmp.9 = add nsw i32 %a.load.1, %b.load.1, !dbg !80 ; [#uses=1 type=i32] [debug line = 59:6]
  %result.addr.1 = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp., !dbg !80 ; [#uses=1 type=i32*] [debug line = 59:6]
  store i32 %tmp.9, i32* %result.addr.1, align 4, !dbg !80 ; [debug line = 59:6]
  %tmp.10 = icmp eq i32 %i.1, %tmp.4, !dbg !77    ; [#uses=1 type=i1] [debug line = 60:7]
  br i1 %tmp.10, label %5, label %._crit_edge3, !dbg !77 ; [debug line = 60:7]

; <label>:5                                       ; preds = %4
  store volatile i32 1, i32* %resp, align 4, !dbg !81 ; [debug line = 61:8]
  br label %._crit_edge3, !dbg !83                ; [debug line = 62:7]

._crit_edge3:                                     ; preds = %5, %4
  %i.3 = add nsw i32 %i.1, 1, !dbg !84            ; [#uses=1 type=i32] [debug line = 58:38]
  call void @llvm.dbg.value(metadata !{i32 %i.3}, i64 0, metadata !61), !dbg !84 ; [debug line = 58:38] [debug variable = i]
  br label %.preheader, !dbg !84                  ; [debug line = 58:38]

.loopexit:                                        ; preds = %.preheader, %3
  br label %.loopexit2

.loopexit2:                                       ; preds = %.loopexit, %.preheader1
  ret void, !dbg !85                              ; [debug line = 64:1]
}

; [#uses=5]
declare void @_ssdm_op_SpecBitsMap(...)

!llvm.dbg.cu = !{!0}
!llvm.map.gv = !{}

!0 = metadata !{i32 786449, i32 0, i32 4, metadata !"/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores/acc_vadd_hls/solution1/.autopilot/db/acc_vadd_hls.pragma.2.cpp", metadata !"/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !1} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"acc_vadd_hls", metadata !"acc_vadd_hls", metadata !"_Z12acc_vadd_hlsPViS0_PiS1_S1_", metadata !6, i32 32, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !13, i32 32} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"acc_vadd_hls/.apc/acc_vadd_hls.cpp", metadata !"/home/senma/Desktop/heterogeneous_hthreads_latest/src/hardware/MyRepository/pcores/vivado_cores", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null, metadata !9, metadata !9, metadata !12, metadata !12, metadata !12}
!9 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!10 = metadata !{i32 786485, null, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_volatile_type ]
!11 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!15 = metadata !{metadata !16}
!16 = metadata !{i32 0, i32 31, metadata !17}
!17 = metadata !{metadata !18}
!18 = metadata !{metadata !"cmd", metadata !19, metadata !"int"}
!19 = metadata !{metadata !20}
!20 = metadata !{i32 0, i32 0, i32 1}
!21 = metadata !{metadata !22}
!22 = metadata !{i32 0, i32 31, metadata !23}
!23 = metadata !{metadata !24}
!24 = metadata !{metadata !"resp", metadata !19, metadata !"int"}
!25 = metadata !{metadata !26}
!26 = metadata !{i32 0, i32 31, metadata !27}
!27 = metadata !{metadata !28}
!28 = metadata !{metadata !"a", metadata !29, metadata !"int"}
!29 = metadata !{metadata !30}
!30 = metadata !{i32 0, i32 4095, i32 1}
!31 = metadata !{metadata !32}
!32 = metadata !{i32 0, i32 31, metadata !33}
!33 = metadata !{metadata !34}
!34 = metadata !{metadata !"b", metadata !29, metadata !"int"}
!35 = metadata !{metadata !36}
!36 = metadata !{i32 0, i32 31, metadata !37}
!37 = metadata !{metadata !38}
!38 = metadata !{metadata !"result", metadata !29, metadata !"int"}
!39 = metadata !{i32 786689, metadata !5, metadata !"cmd", metadata !6, i32 16777248, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!40 = metadata !{i32 32, i32 35, metadata !5, null}
!41 = metadata !{i32 786689, metadata !5, metadata !"resp", metadata !6, i32 33554464, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!42 = metadata !{i32 32, i32 54, metadata !5, null}
!43 = metadata !{i32 786689, metadata !5, metadata !"a", null, i32 32, metadata !44, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!44 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 131072, i64 32, i32 0, i32 0, metadata !11, metadata !45, i32 0, i32 0} ; [ DW_TAG_array_type ]
!45 = metadata !{metadata !46}
!46 = metadata !{i32 786465, i64 0, i64 4095}     ; [ DW_TAG_subrange_type ]
!47 = metadata !{i32 32, i32 64, metadata !5, null}
!48 = metadata !{i32 786689, metadata !5, metadata !"b", null, i32 32, metadata !44, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!49 = metadata !{i32 32, i32 77, metadata !5, null}
!50 = metadata !{i32 786689, metadata !5, metadata !"result", null, i32 32, metadata !44, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!51 = metadata !{i32 32, i32 90, metadata !5, null}
!52 = metadata !{i32 34, i32 1, metadata !53, null}
!53 = metadata !{i32 786443, metadata !5, i32 32, i32 105, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!54 = metadata !{i32 35, i32 1, metadata !53, null}
!55 = metadata !{i32 36, i32 1, metadata !53, null}
!56 = metadata !{i32 47, i32 2, metadata !53, null}
!57 = metadata !{i32 786688, metadata !53, metadata !"op", metadata !6, i32 45, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!58 = metadata !{i32 48, i32 2, metadata !53, null}
!59 = metadata !{i32 786688, metadata !53, metadata !"end", metadata !6, i32 45, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!60 = metadata !{i32 49, i32 2, metadata !53, null}
!61 = metadata !{i32 786688, metadata !53, metadata !"i", metadata !6, i32 45, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!62 = metadata !{i32 58, i32 18, metadata !63, null}
!63 = metadata !{i32 786443, metadata !53, i32 58, i32 13, metadata !6, i32 4} ; [ DW_TAG_lexical_block ]
!64 = metadata !{i32 51, i32 18, metadata !65, null}
!65 = metadata !{i32 786443, metadata !53, i32 51, i32 13, metadata !6, i32 1} ; [ DW_TAG_lexical_block ]
!66 = metadata !{i32 786688, metadata !53, metadata !"start", metadata !6, i32 45, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!67 = metadata !{i32 50, i32 2, metadata !53, null}
!68 = metadata !{i32 53, i32 7, metadata !69, null}
!69 = metadata !{i32 786443, metadata !65, i32 51, i32 43, metadata !6, i32 2} ; [ DW_TAG_lexical_block ]
!70 = metadata !{i32 51, i32 44, metadata !69, null}
!71 = metadata !{i32 52, i32 6, metadata !69, null}
!72 = metadata !{i32 54, i32 8, metadata !73, null}
!73 = metadata !{i32 786443, metadata !69, i32 53, i32 23, metadata !6, i32 3} ; [ DW_TAG_lexical_block ]
!74 = metadata !{i32 55, i32 7, metadata !73, null}
!75 = metadata !{i32 51, i32 38, metadata !65, null}
!76 = metadata !{i32 57, i32 7, metadata !53, null}
!77 = metadata !{i32 60, i32 7, metadata !78, null}
!78 = metadata !{i32 786443, metadata !63, i32 58, i32 43, metadata !6, i32 5} ; [ DW_TAG_lexical_block ]
!79 = metadata !{i32 58, i32 44, metadata !78, null}
!80 = metadata !{i32 59, i32 6, metadata !78, null}
!81 = metadata !{i32 61, i32 8, metadata !82, null}
!82 = metadata !{i32 786443, metadata !78, i32 60, i32 23, metadata !6, i32 6} ; [ DW_TAG_lexical_block ]
!83 = metadata !{i32 62, i32 7, metadata !82, null}
!84 = metadata !{i32 58, i32 38, metadata !63, null}
!85 = metadata !{i32 64, i32 1, metadata !53, null}
