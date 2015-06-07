; ModuleID = '/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add/vectoradd_prj/solution1/.autopilot/db/a.g.1.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@.str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=1 type=[1 x i8]*]
@.str2 = private unnamed_addr constant [5 x i8] c"axis\00", align 1 ; [#uses=1 type=[5 x i8]*]
@.str3 = private unnamed_addr constant [5 x i8] c"bram\00", align 1 ; [#uses=1 type=[5 x i8]*]
@.str4 = private unnamed_addr constant [12 x i8] c"RAM_1P_BRAM\00", align 1 ; [#uses=1 type=[12 x i8]*]
@.str5 = private unnamed_addr constant [9 x i8] c"For_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@.str6 = private unnamed_addr constant [9 x i8] c"add_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@.str7 = private unnamed_addr constant [9 x i8] c"sub_Loop\00", align 1 ; [#uses=1 type=[9 x i8]*]
@str = internal constant [10 x i8] c"vectoradd\00" ; [#uses=1 type=[10 x i8]*]

; [#uses=0]
define void @vectoradd(i32* %cmd, i32* %resp, i32* %a, i32* %b, i32* %result) noreturn nounwind uwtable {
  call void (...)* @_ssdm_op_SpecTopModule([10 x i8]* @str) nounwind
  call void @llvm.dbg.value(metadata !{i32* %cmd}, i64 0, metadata !15), !dbg !16 ; [debug line = 3:32] [debug variable = cmd]
  call void @llvm.dbg.value(metadata !{i32* %resp}, i64 0, metadata !17), !dbg !18 ; [debug line = 3:51] [debug variable = resp]
  call void @llvm.dbg.value(metadata !{i32* %a}, i64 0, metadata !19), !dbg !20 ; [debug line = 3:61] [debug variable = a]
  call void @llvm.dbg.value(metadata !{i32* %b}, i64 0, metadata !21), !dbg !22 ; [debug line = 3:74] [debug variable = b]
  call void @llvm.dbg.value(metadata !{i32* %result}, i64 0, metadata !23), !dbg !24 ; [debug line = 3:87] [debug variable = result]
  call void (...)* @_ssdm_SpecArrayDimSize(i32* %result, i32 4096) nounwind, !dbg !25 ; [debug line = 3:103]
  call void (...)* @_ssdm_SpecArrayDimSize(i32* %b, i32 4096) nounwind, !dbg !27 ; [debug line = 3:139]
  call void (...)* @_ssdm_SpecArrayDimSize(i32* %a, i32 4096) nounwind, !dbg !28 ; [debug line = 3:170]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, i8* getelementptr inbounds ([13 x i8]* @.str, i64 0, i64 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !29 ; [debug line = 5:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %cmd, i8* getelementptr inbounds ([5 x i8]* @.str2, i64 0, i64 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !30 ; [debug line = 6:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %resp, i8* getelementptr inbounds ([5 x i8]* @.str2, i64 0, i64 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !31 ; [debug line = 7:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %a, i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0), i32 0, i32 0, i32 0, i32 1024, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !32 ; [debug line = 8:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %b, i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0), i32 0, i32 0, i32 0, i32 1024, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !33 ; [debug line = 9:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %result, i8* getelementptr inbounds ([5 x i8]* @.str3, i64 0, i64 0), i32 0, i32 0, i32 0, i32 1024, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !34 ; [debug line = 10:1]
  call void (...)* @_ssdm_op_SpecResource(i32* %a, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8]* @.str4, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !35 ; [debug line = 12:1]
  call void (...)* @_ssdm_op_SpecResource(i32* %b, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8]* @.str4, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !36 ; [debug line = 13:1]
  call void (...)* @_ssdm_op_SpecResource(i32* %result, i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([12 x i8]* @.str4, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !37 ; [debug line = 14:1]
  br label %1, !dbg !38                           ; [debug line = 18:12]

; <label>:1                                       ; preds = %.loopexit2, %0
  %loop_begin = call i32 (...)* @_ssdm_op_SpecLoopBegin() nounwind ; [#uses=0 type=i32]
  call void (...)* @_ssdm_op_SpecLoopName(i8* getelementptr inbounds ([9 x i8]* @.str5, i64 0, i64 0)) nounwind, !dbg !39 ; [debug line = 18:23]
  %rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin(i8* getelementptr inbounds ([9 x i8]* @.str5, i64 0, i64 0)) nounwind, !dbg !41 ; [#uses=1 type=i32] [debug line = 18:57]
  %op = load volatile i32* %cmd, align 4, !dbg !42 ; [#uses=2 type=i32] [debug line = 19:3]
  call void @llvm.dbg.value(metadata !{i32 %op}, i64 0, metadata !43), !dbg !42 ; [debug line = 19:3] [debug variable = op]
  %end = load volatile i32* %cmd, align 4, !dbg !44 ; [#uses=4 type=i32] [debug line = 20:3]
  call void @llvm.dbg.value(metadata !{i32 %end}, i64 0, metadata !45), !dbg !44 ; [debug line = 20:3] [debug variable = end]
  %i.4 = load volatile i32* %cmd, align 4, !dbg !46 ; [#uses=2 type=i32] [debug line = 21:3]
  call void @llvm.dbg.value(metadata !{i32 %i.4}, i64 0, metadata !47), !dbg !48 ; [debug line = 29:19] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i.4}, i64 0, metadata !47), !dbg !50 ; [debug line = 23:19] [debug variable = i]
  call void @llvm.dbg.value(metadata !{i32 %i.4}, i64 0, metadata !52), !dbg !46 ; [debug line = 21:3] [debug variable = start]
  %tmp = icmp eq i32 %op, 1, !dbg !53             ; [#uses=1 type=i1] [debug line = 22:3]
  br i1 %tmp, label %.preheader1.preheader, label %4, !dbg !53 ; [debug line = 22:3]

.preheader1.preheader:                            ; preds = %1
  %tmp.1 = add nsw i32 %end, -1, !dbg !54         ; [#uses=1 type=i32] [debug line = 25:8]
  br label %.preheader1, !dbg !50                 ; [debug line = 23:19]

.preheader1:                                      ; preds = %._crit_edge, %.preheader1.preheader
  %i = phi i32 [ %i.2, %._crit_edge ], [ %i.4, %.preheader1.preheader ] ; [#uses=4 type=i32]
  %tmp.3 = icmp slt i32 %i, %end, !dbg !50        ; [#uses=1 type=i1] [debug line = 23:19]
  br i1 %tmp.3, label %2, label %.loopexit2.loopexit, !dbg !50 ; [debug line = 23:19]

; <label>:2                                       ; preds = %.preheader1
  call void (...)* @_ssdm_op_SpecLoopName(i8* getelementptr inbounds ([9 x i8]* @.str6, i64 0, i64 0)) nounwind, !dbg !56 ; [debug line = 23:39]
  %rbegin4 = call i32 (...)* @_ssdm_op_SpecRegionBegin(i8* getelementptr inbounds ([9 x i8]* @.str6, i64 0, i64 0)) nounwind, !dbg !57 ; [#uses=1 type=i32] [debug line = 23:73]
  %tmp.5 = sext i32 %i to i64, !dbg !58           ; [#uses=3 type=i64] [debug line = 24:7]
  %a.addr = getelementptr inbounds i32* %a, i64 %tmp.5, !dbg !58 ; [#uses=1 type=i32*] [debug line = 24:7]
  %a.load = load i32* %a.addr, align 4, !dbg !58  ; [#uses=2 type=i32] [debug line = 24:7]
  call void (...)* @_ssdm_SpecKeepArrayLoad(i32 %a.load) nounwind
  %b.addr = getelementptr inbounds i32* %b, i64 %tmp.5, !dbg !58 ; [#uses=1 type=i32*] [debug line = 24:7]
  %b.load = load i32* %b.addr, align 4, !dbg !58  ; [#uses=2 type=i32] [debug line = 24:7]
  call void (...)* @_ssdm_SpecKeepArrayLoad(i32 %b.load) nounwind
  %tmp.6 = add nsw i32 %b.load, %a.load, !dbg !58 ; [#uses=1 type=i32] [debug line = 24:7]
  %result.addr = getelementptr inbounds i32* %result, i64 %tmp.5, !dbg !58 ; [#uses=1 type=i32*] [debug line = 24:7]
  store i32 %tmp.6, i32* %result.addr, align 4, !dbg !58 ; [debug line = 24:7]
  %tmp.7 = icmp eq i32 %i, %tmp.1, !dbg !54       ; [#uses=1 type=i1] [debug line = 25:8]
  br i1 %tmp.7, label %3, label %._crit_edge, !dbg !54 ; [debug line = 25:8]

; <label>:3                                       ; preds = %2
  store volatile i32 1, i32* %resp, align 4, !dbg !59 ; [debug line = 26:11]
  br label %._crit_edge, !dbg !59                 ; [debug line = 26:11]

._crit_edge:                                      ; preds = %3, %2
  %rend5 = call i32 (...)* @_ssdm_op_SpecRegionEnd(i8* getelementptr inbounds ([9 x i8]* @.str6, i64 0, i64 0), i32 %rbegin4) nounwind, !dbg !60 ; [#uses=0 type=i32] [debug line = 27:3]
  %i.2 = add nsw i32 %i, 1, !dbg !61              ; [#uses=1 type=i32] [debug line = 23:33]
  call void @llvm.dbg.value(metadata !{i32 %i.2}, i64 0, metadata !47), !dbg !61 ; [debug line = 23:33] [debug variable = i]
  br label %.preheader1, !dbg !61                 ; [debug line = 23:33]

; <label>:4                                       ; preds = %1
  %tmp.2 = icmp eq i32 %op, 2, !dbg !62           ; [#uses=1 type=i1] [debug line = 28:8]
  br i1 %tmp.2, label %.preheader.preheader, label %.loopexit, !dbg !62 ; [debug line = 28:8]

.preheader.preheader:                             ; preds = %4
  %tmp.4 = add nsw i32 %end, -1, !dbg !63         ; [#uses=1 type=i32] [debug line = 31:8]
  br label %.preheader, !dbg !48                  ; [debug line = 29:19]

.preheader:                                       ; preds = %._crit_edge3, %.preheader.preheader
  %i.1 = phi i32 [ %i.3, %._crit_edge3 ], [ %i.4, %.preheader.preheader ] ; [#uses=4 type=i32]
  %tmp.8 = icmp slt i32 %i.1, %end, !dbg !48      ; [#uses=1 type=i1] [debug line = 29:19]
  br i1 %tmp.8, label %5, label %.loopexit.loopexit, !dbg !48 ; [debug line = 29:19]

; <label>:5                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName(i8* getelementptr inbounds ([9 x i8]* @.str7, i64 0, i64 0)) nounwind, !dbg !65 ; [debug line = 29:39]
  %rbegin6 = call i32 (...)* @_ssdm_op_SpecRegionBegin(i8* getelementptr inbounds ([9 x i8]* @.str7, i64 0, i64 0)) nounwind, !dbg !66 ; [#uses=1 type=i32] [debug line = 29:73]
  %tmp.10 = sext i32 %i.1 to i64, !dbg !67        ; [#uses=3 type=i64] [debug line = 30:7]
  %a.addr.1 = getelementptr inbounds i32* %a, i64 %tmp.10, !dbg !67 ; [#uses=1 type=i32*] [debug line = 30:7]
  %a.load.1 = load i32* %a.addr.1, align 4, !dbg !67 ; [#uses=2 type=i32] [debug line = 30:7]
  call void (...)* @_ssdm_SpecKeepArrayLoad(i32 %a.load.1) nounwind
  %b.addr.1 = getelementptr inbounds i32* %b, i64 %tmp.10, !dbg !67 ; [#uses=1 type=i32*] [debug line = 30:7]
  %b.load.1 = load i32* %b.addr.1, align 4, !dbg !67 ; [#uses=2 type=i32] [debug line = 30:7]
  call void (...)* @_ssdm_SpecKeepArrayLoad(i32 %b.load.1) nounwind
  %tmp.11 = sub nsw i32 %a.load.1, %b.load.1, !dbg !67 ; [#uses=1 type=i32] [debug line = 30:7]
  %result.addr.1 = getelementptr inbounds i32* %result, i64 %tmp.10, !dbg !67 ; [#uses=1 type=i32*] [debug line = 30:7]
  store i32 %tmp.11, i32* %result.addr.1, align 4, !dbg !67 ; [debug line = 30:7]
  %tmp.12 = icmp eq i32 %i.1, %tmp.4, !dbg !63    ; [#uses=1 type=i1] [debug line = 31:8]
  br i1 %tmp.12, label %6, label %._crit_edge3, !dbg !63 ; [debug line = 31:8]

; <label>:6                                       ; preds = %5
  store volatile i32 1, i32* %resp, align 4, !dbg !68 ; [debug line = 32:11]
  br label %._crit_edge3, !dbg !68                ; [debug line = 32:11]

._crit_edge3:                                     ; preds = %6, %5
  %rend7 = call i32 (...)* @_ssdm_op_SpecRegionEnd(i8* getelementptr inbounds ([9 x i8]* @.str7, i64 0, i64 0), i32 %rbegin6) nounwind, !dbg !69 ; [#uses=0 type=i32] [debug line = 33:3]
  %i.3 = add nsw i32 %i.1, 1, !dbg !70            ; [#uses=1 type=i32] [debug line = 29:33]
  call void @llvm.dbg.value(metadata !{i32 %i.3}, i64 0, metadata !47), !dbg !70 ; [debug line = 29:33] [debug variable = i]
  br label %.preheader, !dbg !70                  ; [debug line = 29:33]

.loopexit.loopexit:                               ; preds = %.preheader
  br label %.loopexit

.loopexit:                                        ; preds = %.loopexit.loopexit, %4
  br label %.loopexit2

.loopexit2.loopexit:                              ; preds = %.preheader1
  br label %.loopexit2

.loopexit2:                                       ; preds = %.loopexit2.loopexit, %.loopexit
  %rend = call i32 (...)* @_ssdm_op_SpecRegionEnd(i8* getelementptr inbounds ([9 x i8]* @.str5, i64 0, i64 0), i32 %rbegin) nounwind, !dbg !71 ; [#uses=0 type=i32] [debug line = 36:2]
  br label %1, !dbg !72                           ; [debug line = 36:30]
}

; [#uses=3]
declare void @_ssdm_SpecArrayDimSize(...) nounwind

; [#uses=6]
declare void @_ssdm_op_SpecInterface(...) nounwind

; [#uses=3]
declare void @_ssdm_op_SpecResource(...) nounwind

; [#uses=3]
declare void @_ssdm_op_SpecLoopName(...) nounwind

; [#uses=0]
declare void @_ssdm_RegionBegin(...) nounwind

; [#uses=0]
declare void @_ssdm_RegionEnd(...) nounwind

; [#uses=12]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=4]
declare void @_ssdm_SpecKeepArrayLoad(...)

; [#uses=1]
declare void @_ssdm_op_SpecTopModule(...)

; [#uses=1]
declare i32 @_ssdm_op_SpecLoopBegin(...)

; [#uses=3]
declare i32 @_ssdm_op_SpecRegionBegin(...)

; [#uses=3]
declare i32 @_ssdm_op_SpecRegionEnd(...)

; [#uses=0]
declare i32 @_ssdm_op_SpecRegionEnd.restore(...)

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, i32 0, i32 1, metadata !"/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add/vectoradd_prj/solution1/.autopilot/db/vectoradd_top.pragma.2.c", metadata !"/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !1} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"vectoradd", metadata !"vectoradd", metadata !"", metadata !6, i32 3, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32*, i32*, i32*, i32*)* @vectoradd, null, null, metadata !13, i32 3} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"vectoradd_top.c", metadata !"/home/abazar63/hthread/src/hardware/MyRepository/pcores/vivado_cores/hls_cores/vector_add", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null, metadata !9, metadata !9, metadata !12, metadata !12, metadata !12}
!9 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!10 = metadata !{i32 786485, null, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_volatile_type ]
!11 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!15 = metadata !{i32 786689, metadata !5, metadata !"cmd", metadata !6, i32 16777219, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!16 = metadata !{i32 3, i32 32, metadata !5, null}
!17 = metadata !{i32 786689, metadata !5, metadata !"resp", metadata !6, i32 33554435, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!18 = metadata !{i32 3, i32 51, metadata !5, null}
!19 = metadata !{i32 786689, metadata !5, metadata !"a", metadata !6, i32 50331651, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!20 = metadata !{i32 3, i32 61, metadata !5, null}
!21 = metadata !{i32 786689, metadata !5, metadata !"b", metadata !6, i32 67108867, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!22 = metadata !{i32 3, i32 74, metadata !5, null}
!23 = metadata !{i32 786689, metadata !5, metadata !"result", metadata !6, i32 83886083, metadata !12, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 3, i32 87, metadata !5, null}
!25 = metadata !{i32 3, i32 103, metadata !26, null}
!26 = metadata !{i32 786443, metadata !5, i32 3, i32 102, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 3, i32 139, metadata !26, null}
!28 = metadata !{i32 3, i32 170, metadata !26, null}
!29 = metadata !{i32 5, i32 1, metadata !26, null}
!30 = metadata !{i32 6, i32 1, metadata !26, null}
!31 = metadata !{i32 7, i32 1, metadata !26, null}
!32 = metadata !{i32 8, i32 1, metadata !26, null}
!33 = metadata !{i32 9, i32 1, metadata !26, null}
!34 = metadata !{i32 10, i32 1, metadata !26, null}
!35 = metadata !{i32 12, i32 1, metadata !26, null}
!36 = metadata !{i32 13, i32 1, metadata !26, null}
!37 = metadata !{i32 14, i32 1, metadata !26, null}
!38 = metadata !{i32 18, i32 12, metadata !26, null}
!39 = metadata !{i32 18, i32 23, metadata !40, null}
!40 = metadata !{i32 786443, metadata !26, i32 18, i32 22, metadata !6, i32 1} ; [ DW_TAG_lexical_block ]
!41 = metadata !{i32 18, i32 57, metadata !40, null}
!42 = metadata !{i32 19, i32 3, metadata !40, null}
!43 = metadata !{i32 786688, metadata !26, metadata !"op", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!44 = metadata !{i32 20, i32 3, metadata !40, null}
!45 = metadata !{i32 786688, metadata !26, metadata !"end", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!46 = metadata !{i32 21, i32 3, metadata !40, null}
!47 = metadata !{i32 786688, metadata !26, metadata !"i", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!48 = metadata !{i32 29, i32 19, metadata !49, null}
!49 = metadata !{i32 786443, metadata !40, i32 29, i32 14, metadata !6, i32 4} ; [ DW_TAG_lexical_block ]
!50 = metadata !{i32 23, i32 19, metadata !51, null}
!51 = metadata !{i32 786443, metadata !40, i32 23, i32 14, metadata !6, i32 2} ; [ DW_TAG_lexical_block ]
!52 = metadata !{i32 786688, metadata !26, metadata !"start", metadata !6, i32 16, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 22, i32 3, metadata !40, null}
!54 = metadata !{i32 25, i32 8, metadata !55, null}
!55 = metadata !{i32 786443, metadata !51, i32 23, i32 38, metadata !6, i32 3} ; [ DW_TAG_lexical_block ]
!56 = metadata !{i32 23, i32 39, metadata !55, null}
!57 = metadata !{i32 23, i32 73, metadata !55, null}
!58 = metadata !{i32 24, i32 7, metadata !55, null}
!59 = metadata !{i32 26, i32 11, metadata !55, null}
!60 = metadata !{i32 27, i32 3, metadata !55, null}
!61 = metadata !{i32 23, i32 33, metadata !51, null}
!62 = metadata !{i32 28, i32 8, metadata !40, null}
!63 = metadata !{i32 31, i32 8, metadata !64, null}
!64 = metadata !{i32 786443, metadata !49, i32 29, i32 38, metadata !6, i32 5} ; [ DW_TAG_lexical_block ]
!65 = metadata !{i32 29, i32 39, metadata !64, null}
!66 = metadata !{i32 29, i32 73, metadata !64, null}
!67 = metadata !{i32 30, i32 7, metadata !64, null}
!68 = metadata !{i32 32, i32 11, metadata !64, null}
!69 = metadata !{i32 33, i32 3, metadata !64, null}
!70 = metadata !{i32 29, i32 33, metadata !49, null}
!71 = metadata !{i32 36, i32 2, metadata !40, null}
!72 = metadata !{i32 36, i32 30, metadata !40, null}
