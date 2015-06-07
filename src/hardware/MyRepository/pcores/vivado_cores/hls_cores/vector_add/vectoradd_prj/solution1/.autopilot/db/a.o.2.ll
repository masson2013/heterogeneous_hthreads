; ModuleID = '/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add/vectoradd_prj/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@.str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=33 type=[1 x i8]*]
@.str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1 ; [#uses=2 type=[5 x i8]*]
@.str3 = private unnamed_addr constant [5 x i8] c"bram\00", align 1 ; [#uses=3 type=[5 x i8]*]
@.str4 = private unnamed_addr constant [12 x i8] c"RAM_1P_BRAM\00", align 1 ; [#uses=3 type=[12 x i8]*]
@.str5 = private unnamed_addr constant [9 x i8] c"For_Loop\00", align 1 ; [#uses=3 type=[9 x i8]*]
@.str6 = private unnamed_addr constant [9 x i8] c"add_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@.str7 = private unnamed_addr constant [9 x i8] c"sub_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@str = internal constant [10 x i8] c"vectoradd\00" ; [#uses=1 type=[10 x i8]*]

; [#uses=6]
declare void @_ssdm_op_SpecInterface(...) nounwind

; [#uses=3]
declare void @_ssdm_op_SpecLoopName(...) nounwind

; [#uses=12]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
declare void @_ssdm_op_SpecTopModule(...)

; [#uses=1]
declare i32 @_ssdm_op_SpecLoopBegin(...)

; [#uses=1]
declare i32 @_ssdm_op_SpecRegionBegin(...)

; [#uses=1]
declare i32 @_ssdm_op_SpecRegionEnd(...)

; [#uses=3]
declare void @_ssdm_op_SpecMemCore(...)

; [#uses=0]
define void @vectoradd(i32* %cmd, i32* %resp, [4096 x i32]* %a, [4096 x i32]* %b, [4096 x i32]* %result) noreturn nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %cmd) nounwind, !map !15
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %resp) nounwind, !map !21
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %a) nounwind, !map !25
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %b) nounwind, !map !31
  call void (...)* @_ssdm_op_SpecBitsMap([4096 x i32]* %result) nounwind, !map !35
  call void (...)* @_ssdm_op_SpecTopModule([10 x i8]* @str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %cmd}, i64 0, metadata !39), !dbg !40 ; [debug line = 3:32] [debug variable = cmd]
  call void @llvm.dbg.value(metadata !{i32* %resp}, i64 0, metadata !41), !dbg !42 ; [debug line = 3:51] [debug variable = resp]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %a}, i64 0, metadata !43), !dbg !47 ; [debug line = 3:61] [debug variable = a]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %b}, i64 0, metadata !48), !dbg !49 ; [debug line = 3:74] [debug variable = b]
  call void @llvm.dbg.value(metadata !{[4096 x i32]* %result}, i64 0, metadata !50), !dbg !51 ; [debug line = 3:87] [debug variable = result]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @.str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !52 ; [debug line = 5:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %cmd, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !54 ; [debug line = 6:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %resp, [5 x i8]* @.str2, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind, !dbg !55 ; [debug line = 7:1]
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %a, [5 x i8]* @.str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %b, [5 x i8]* @.str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface([4096 x i32]* %result, [5 x i8]* @.str3, i32 0, i32 0, i32 0, i32 1024, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %a, [1 x i8]* @.str1, [12 x i8]* @.str4, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %b, [1 x i8]* @.str1, [12 x i8]* @.str4, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  call void (...)* @_ssdm_op_SpecMemCore([4096 x i32]* %result, [1 x i8]* @.str1, [12 x i8]* @.str4, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1, [1 x i8]* @.str1) nounwind
  br label %1, !dbg !56                           ; [debug line = 18:12]

; <label>:1                                       ; preds = %.loopexit2, %0
  %loop_begin = call i32 (...)* @_ssdm_op_SpecLoopBegin() nounwind ; [#uses=0 type=i32]
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @.str5) nounwind, !dbg !57 ; [debug line = 18:23]
  %tmp.11 = call i32 (...)* @_ssdm_op_SpecRegionBegin([9 x i8]* @.str5) nounwind, !dbg !59 ; [#uses=1 type=i32] [debug line = 18:57]
  %op = load volatile i32* %cmd, align 4, !dbg !60 ; [#uses=2 type=i32] [debug line = 19:3]
  call void @llvm.dbg.value(metadata !{i32 %op}, i64 0, metadata !61), !dbg !60 ; [debug line = 19:3] [debug variable = op]
  %end = load volatile i32* %cmd, align 4, !dbg !62 ; [#uses=4 type=i32] [debug line = 20:3]
  call void @llvm.dbg.value(metadata !{i32 %end}, i64 0, metadata !63), !dbg !62 ; [debug line = 20:3] [debug variable = end]
  %i.5 = load volatile i32* %cmd, align 4, !dbg !64 ; [#uses=2 type=i32] [debug line = 21:3]
  call void @llvm.dbg.value(metadata !{i32 %i.5}, i64 0, metadata !65), !dbg !66 ; [debug line = 29:19] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i.5}, i64 0, metadata !65), !dbg !68 ; [debug line = 23:19] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i.5}, i64 0, metadata !70), !dbg !64 ; [debug line = 21:3] [debug variable = start]
  %tmp = icmp eq i32 %op, 1, !dbg !71             ; [#uses=1 type=i1] [debug line = 22:3]
  br i1 %tmp, label %.preheader1.preheader, label %4, !dbg !71 ; [debug line = 22:3]

.preheader1.preheader:                            ; preds = %1
  %tmp.1 = add nsw i32 %end, -1, !dbg !72         ; [#uses=1 type=i32] [debug line = 25:8]
  br label %.preheader1, !dbg !68                 ; [debug line = 23:19]

.preheader1:                                      ; preds = %._crit_edge, %.preheader1.preheader
  %i = phi i32 [ %i.2, %._crit_edge ], [ %i.5, %.preheader1.preheader ] ; [#uses=4 type=i32]
  %tmp.3 = icmp slt i32 %i, %end, !dbg !68        ; [#uses=1 type=i1] [debug line = 23:19]
  br i1 %tmp.3, label %2, label %.loopexit2, !dbg !68 ; [debug line = 23:19]

; <label>:2                                       ; preds = %.preheader1
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @.str6) nounwind, !dbg !74 ; [debug line = 23:39]
  %tmp.5 = sext i32 %i to i64, !dbg !75           ; [#uses=3 type=i64] [debug line = 24:7]
  %a.addr = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp.5, !dbg !75 ; [#uses=1 type=i32*] [debug line = 24:7]
  %a.load = load i32* %a.addr, align 4, !dbg !75  ; [#uses=1 type=i32] [debug line = 24:7]
  %b.addr = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp.5, !dbg !75 ; [#uses=1 type=i32*] [debug line = 24:7]
  %b.load = load i32* %b.addr, align 4, !dbg !75  ; [#uses=1 type=i32] [debug line = 24:7]
  %tmp.6 = add nsw i32 %b.load, %a.load, !dbg !75 ; [#uses=1 type=i32] [debug line = 24:7]
  %result.addr = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp.5, !dbg !75 ; [#uses=1 type=i32*] [debug line = 24:7]
  store i32 %tmp.6, i32* %result.addr, align 4, !dbg !75 ; [debug line = 24:7]
  %tmp.7 = icmp eq i32 %i, %tmp.1, !dbg !72       ; [#uses=1 type=i1] [debug line = 25:8]
  br i1 %tmp.7, label %3, label %._crit_edge, !dbg !72 ; [debug line = 25:8]

; <label>:3                                       ; preds = %2
  store volatile i32 1, i32* %resp, align 4, !dbg !76 ; [debug line = 26:11]
  br label %._crit_edge, !dbg !76                 ; [debug line = 26:11]

._crit_edge:                                      ; preds = %3, %2
  %i.2 = add nsw i32 %i, 1, !dbg !77              ; [#uses=1 type=i32] [debug line = 23:33]
  call void @llvm.dbg.value(metadata !{i32 %i.2}, i64 0, metadata !65), !dbg !77 ; [debug line = 23:33] [debug variable = i]
  br label %.preheader1, !dbg !77                 ; [debug line = 23:33]

; <label>:4                                       ; preds = %1
  %tmp.2 = icmp eq i32 %op, 2, !dbg !78           ; [#uses=1 type=i1] [debug line = 28:8]
  br i1 %tmp.2, label %.preheader.preheader, label %.loopexit, !dbg !78 ; [debug line = 28:8]

.preheader.preheader:                             ; preds = %4
  %tmp.4 = add nsw i32 %end, -1, !dbg !79         ; [#uses=1 type=i32] [debug line = 31:8]
  br label %.preheader, !dbg !66                  ; [debug line = 29:19]

.preheader:                                       ; preds = %._crit_edge3, %.preheader.preheader
  %i.1 = phi i32 [ %i.3, %._crit_edge3 ], [ %i.5, %.preheader.preheader ] ; [#uses=4 type=i32]
  %tmp.8 = icmp slt i32 %i.1, %end, !dbg !66      ; [#uses=1 type=i1] [debug line = 29:19]
  br i1 %tmp.8, label %5, label %.loopexit, !dbg !66 ; [debug line = 29:19]

; <label>:5                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @.str7) nounwind, !dbg !81 ; [debug line = 29:39]
  %tmp. = sext i32 %i.1 to i64, !dbg !82          ; [#uses=3 type=i64] [debug line = 30:7]
  %a.addr.1 = getelementptr [4096 x i32]* %a, i64 0, i64 %tmp., !dbg !82 ; [#uses=1 type=i32*] [debug line = 30:7]
  %a.load.1 = load i32* %a.addr.1, align 4, !dbg !82 ; [#uses=1 type=i32] [debug line = 30:7]
  %b.addr.1 = getelementptr [4096 x i32]* %b, i64 0, i64 %tmp., !dbg !82 ; [#uses=1 type=i32*] [debug line = 30:7]
  %b.load.1 = load i32* %b.addr.1, align 4, !dbg !82 ; [#uses=1 type=i32] [debug line = 30:7]
  %tmp.9 = sub nsw i32 %a.load.1, %b.load.1, !dbg !82 ; [#uses=1 type=i32] [debug line = 30:7]
  %result.addr.1 = getelementptr [4096 x i32]* %result, i64 0, i64 %tmp., !dbg !82 ; [#uses=1 type=i32*] [debug line = 30:7]
  store i32 %tmp.9, i32* %result.addr.1, align 4, !dbg !82 ; [debug line = 30:7]
  %tmp.10 = icmp eq i32 %i.1, %tmp.4, !dbg !79    ; [#uses=1 type=i1] [debug line = 31:8]
  br i1 %tmp.10, label %6, label %._crit_edge3, !dbg !79 ; [debug line = 31:8]

; <label>:6                                       ; preds = %5
  store volatile i32 1, i32* %resp, align 4, !dbg !83 ; [debug line = 32:11]
  br label %._crit_edge3, !dbg !83                ; [debug line = 32:11]

._crit_edge3:                                     ; preds = %6, %5
  %i.3 = add nsw i32 %i.1, 1, !dbg !84            ; [#uses=1 type=i32] [debug line = 29:33]
  call void @llvm.dbg.value(metadata !{i32 %i.3}, i64 0, metadata !65), !dbg !84 ; [debug line = 29:33] [debug variable = i]
  br label %.preheader, !dbg !84                  ; [debug line = 29:33]

.loopexit:                                        ; preds = %.preheader, %4
  br label %.loopexit2

.loopexit2:                                       ; preds = %.loopexit, %.preheader1
  %7 = call i32 (...)* @_ssdm_op_SpecRegionEnd([9 x i8]* @.str5, i32 %tmp.11) nounwind, !dbg !85 ; [#uses=0 type=i32] [debug line = 36:2]
  br label %1, !dbg !86                           ; [debug line = 36:30]
}

; [#uses=5]
declare void @_ssdm_op_SpecBitsMap(...)

!llvm.dbg.cu = !{!0}
!llvm.map.gv = !{}

!0 = metadata !{i32 786449, i32 0, i32 1, metadata !"/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add/vectoradd_prj/solution1/.autopilot/db/vectoradd_top.pragma.2.c", metadata !"/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !1} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"vectoradd", metadata !"vectoradd", metadata !"", metadata !6, i32 3, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !13, i32 3} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"vectoradd_top.c", metadata !"/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add", null} ; [ DW_TAG_file_type ]
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
!39 = metadata !{i32 786689, metadata !5, metadata !"cmd", metadata !6, i32 16777219, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!40 = metadata !{i32 3, i32 32, metadata !5, null}
!41 = metadata !{i32 786689, metadata !5, metadata !"resp", metadata !6, i32 33554435, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!42 = metadata !{i32 3, i32 51, metadata !5, null}
!43 = metadata !{i32 786689, metadata !5, metadata !"a", null, i32 3, metadata !44, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!44 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 131072, i64 32, i32 0, i32 0, metadata !11, metadata !45, i32 0, i32 0} ; [ DW_TAG_array_type ]
!45 = metadata !{metadata !46}
!46 = metadata !{i32 786465, i64 0, i64 4095}     ; [ DW_TAG_subrange_type ]
!47 = metadata !{i32 3, i32 61, metadata !5, null}
!48 = metadata !{i32 786689, metadata !5, metadata !"b", null, i32 3, metadata !44, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!49 = metadata !{i32 3, i32 74, metadata !5, null}
!50 = metadata !{i32 786689, metadata !5, metadata !"result", null, i32 3, metadata !44, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!51 = metadata !{i32 3, i32 87, metadata !5, null}
!52 = metadata !{i32 5, i32 1, metadata !53, null}
!53 = metadata !{i32 786443, metadata !5, i32 3, i32 102, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!54 = metadata !{i32 6, i32 1, metadata !53, null}
!55 = metadata !{i32 7, i32 1, metadata !53, null}
!56 = metadata !{i32 18, i32 12, metadata !53, null}
!57 = metadata !{i32 18, i32 23, metadata !58, null}
!58 = metadata !{i32 786443, metadata !53, i32 18, i32 22, metadata !6, i32 1} ; [ DW_TAG_lexical_block ]
!59 = metadata !{i32 18, i32 57, metadata !58, null}
!60 = metadata !{i32 19, i32 3, metadata !58, null}
!61 = metadata !{i32 786688, metadata !53, metadata !"op", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!62 = metadata !{i32 20, i32 3, metadata !58, null}
!63 = metadata !{i32 786688, metadata !53, metadata !"end", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!64 = metadata !{i32 21, i32 3, metadata !58, null}
!65 = metadata !{i32 786688, metadata !53, metadata !"i", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!66 = metadata !{i32 29, i32 19, metadata !67, null}
!67 = metadata !{i32 786443, metadata !58, i32 29, i32 14, metadata !6, i32 4} ; [ DW_TAG_lexical_block ]
!68 = metadata !{i32 23, i32 19, metadata !69, null}
!69 = metadata !{i32 786443, metadata !58, i32 23, i32 14, metadata !6, i32 2} ; [ DW_TAG_lexical_block ]
!70 = metadata !{i32 786688, metadata !53, metadata !"start", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!71 = metadata !{i32 22, i32 3, metadata !58, null}
!72 = metadata !{i32 25, i32 8, metadata !73, null}
!73 = metadata !{i32 786443, metadata !69, i32 23, i32 38, metadata !6, i32 3} ; [ DW_TAG_lexical_block ]
!74 = metadata !{i32 23, i32 39, metadata !73, null}
!75 = metadata !{i32 24, i32 7, metadata !73, null}
!76 = metadata !{i32 26, i32 11, metadata !73, null}
!77 = metadata !{i32 23, i32 33, metadata !69, null}
!78 = metadata !{i32 28, i32 8, metadata !58, null}
!79 = metadata !{i32 31, i32 8, metadata !80, null}
!80 = metadata !{i32 786443, metadata !67, i32 29, i32 38, metadata !6, i32 5} ; [ DW_TAG_lexical_block ]
!81 = metadata !{i32 29, i32 39, metadata !80, null}
!82 = metadata !{i32 30, i32 7, metadata !80, null}
!83 = metadata !{i32 32, i32 11, metadata !80, null}
!84 = metadata !{i32 29, i32 33, metadata !67, null}
!85 = metadata !{i32 36, i32 2, metadata !58, null}
!86 = metadata !{i32 36, i32 30, metadata !58, null}
