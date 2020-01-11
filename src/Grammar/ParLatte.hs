{-# OPTIONS_GHC -w #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module Grammar.ParLatte where
import Grammar.AbsLatte
import Grammar.LexLatte
import Grammar.ErrM
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 ((Maybe (Int, Int), Ident))
	| HappyAbsSyn5 ((Maybe (Int, Int), Integer))
	| HappyAbsSyn6 ((Maybe (Int, Int), String))
	| HappyAbsSyn7 ((Maybe (Int, Int), Program (Maybe (Int, Int))))
	| HappyAbsSyn8 ((Maybe (Int, Int), TopDef (Maybe (Int, Int))))
	| HappyAbsSyn9 ((Maybe (Int, Int), [TopDef (Maybe (Int, Int))]))
	| HappyAbsSyn10 ((Maybe (Int, Int), Arg (Maybe (Int, Int))))
	| HappyAbsSyn11 ((Maybe (Int, Int), [Arg (Maybe (Int, Int))]))
	| HappyAbsSyn12 ((Maybe (Int, Int), Extends (Maybe (Int, Int))))
	| HappyAbsSyn13 ((Maybe (Int, Int), ClMember (Maybe (Int, Int))))
	| HappyAbsSyn14 ((Maybe (Int, Int), [ClMember (Maybe (Int, Int))]))
	| HappyAbsSyn15 ((Maybe (Int, Int), Block (Maybe (Int, Int))))
	| HappyAbsSyn16 ((Maybe (Int, Int), [Stmt (Maybe (Int, Int))]))
	| HappyAbsSyn17 ((Maybe (Int, Int), Stmt (Maybe (Int, Int))))
	| HappyAbsSyn18 ((Maybe (Int, Int), Item (Maybe (Int, Int))))
	| HappyAbsSyn19 ((Maybe (Int, Int), [Item (Maybe (Int, Int))]))
	| HappyAbsSyn20 ((Maybe (Int, Int), Type (Maybe (Int, Int))))
	| HappyAbsSyn21 ((Maybe (Int, Int), [Type (Maybe (Int, Int))]))
	| HappyAbsSyn22 ((Maybe (Int, Int), Expr (Maybe (Int, Int))))
	| HappyAbsSyn29 ((Maybe (Int, Int), [Expr (Maybe (Int, Int))]))
	| HappyAbsSyn30 ((Maybe (Int, Int), LValue (Maybe (Int, Int))))
	| HappyAbsSyn31 ((Maybe (Int, Int), AddOp (Maybe (Int, Int))))
	| HappyAbsSyn32 ((Maybe (Int, Int), MulOp (Maybe (Int, Int))))
	| HappyAbsSyn33 ((Maybe (Int, Int), RelOp (Maybe (Int, Int))))

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137 :: () => Int -> ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83,
 happyReduce_84 :: () => ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,533) ([0,0,0,8576,133,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,49152,17040,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,32768,0,0,0,0,0,0,0,0,0,0,8320,133,0,0,0,32768,0,0,0,0,8192,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,256,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,128,0,0,0,18464,33,0,0,0,35393,1,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2176,8260,63486,0,0,64,2,0,0,0,0,21000,8,0,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,8192,516,0,0,0,16384,2,0,0,0,20,118,0,0,0,0,0,1,0,0,64,0,0,0,51200,16,0,0,0,2,9344,56,0,4352,16392,50100,1,0,128,8192,3593,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,18464,33,0,17408,544,1168,7,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,129,4672,28,0,2048,0,0,0,0,0,2,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,16384,516,18688,112,0,0,0,0,0,0,1024,0,0,0,0,16,0,0,0,0,0,0,0,0,0,16,0,0,0,32768,0,0,0,0,0,0,2,0,1088,2,28745,0,0,0,0,0,0,4096,129,4672,28,0,2176,4,57490,0,0,0,0,0,0,8192,258,9344,56,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,1032,37376,224,0,0,0,0,0,0,0,0,0,0,0,2065,9216,449,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,2,0,0,0,0,2,0,0,8192,258,9344,56,0,8192,0,0,0,0,0,0,64,0,0,256,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,32,0,17408,32,1168,7,0,0,0,0,0,0,16516,0,0,0,0,0,0,0,0,16384,2,0,0,0,0,0,0,0,0,2048,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,512,0,0,0,32768,17416,65056,231,0,17408,544,16369,7,0,544,32769,14372,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,129,4672,28,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,16384,8708,65296,115,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProgram_internal","Ident","Integer","String","Program","TopDef","ListTopDef","Arg","ListArg","Extends","ClMember","ListClMember","Block","ListStmt","Stmt","Item","ListItem","Type","ListType","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","ListExpr","LValue","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&&'","'('","')'","')null'","'*'","'+'","'++'","','","'-'","'--'","'.'","'/'","';'","'<'","'<='","'='","'=='","'>'","'>='","'boolean'","'class'","'else'","'extends'","'false'","'if'","'int'","'new'","'return'","'string'","'true'","'void'","'while'","'{'","'||'","'}'","L_ident","L_integ","L_quoted","%eof"]
        bit_start = st * 75
        bit_end = (st + 1) * 75
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..74]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (56) = happyShift action_8
action_0 (57) = happyShift action_9
action_0 (62) = happyShift action_10
action_0 (65) = happyShift action_11
action_0 (67) = happyShift action_12
action_0 (72) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (8) = happyGoto action_5
action_0 (9) = happyGoto action_6
action_0 (20) = happyGoto action_7
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (72) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 _ = happyReduce_42

action_4 (75) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (56) = happyShift action_8
action_5 (57) = happyShift action_9
action_5 (62) = happyShift action_10
action_5 (65) = happyShift action_11
action_5 (67) = happyShift action_12
action_5 (72) = happyShift action_2
action_5 (4) = happyGoto action_3
action_5 (8) = happyGoto action_5
action_5 (9) = happyGoto action_15
action_5 (20) = happyGoto action_7
action_5 _ = happyReduce_7

action_6 _ = happyReduce_4

action_7 (72) = happyShift action_2
action_7 (4) = happyGoto action_14
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_40

action_9 (72) = happyShift action_2
action_9 (4) = happyGoto action_13
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_38

action_11 _ = happyReduce_39

action_12 _ = happyReduce_41

action_13 (59) = happyShift action_18
action_13 (12) = happyGoto action_17
action_13 _ = happyReduce_14

action_14 (38) = happyShift action_16
action_14 _ = happyFail (happyExpListPerState 14)

action_15 _ = happyReduce_8

action_16 (56) = happyShift action_8
action_16 (62) = happyShift action_10
action_16 (65) = happyShift action_11
action_16 (67) = happyShift action_12
action_16 (72) = happyShift action_2
action_16 (4) = happyGoto action_3
action_16 (10) = happyGoto action_21
action_16 (11) = happyGoto action_22
action_16 (20) = happyGoto action_23
action_16 _ = happyReduce_10

action_17 (69) = happyShift action_20
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (72) = happyShift action_2
action_18 (4) = happyGoto action_19
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_13

action_20 (14) = happyGoto action_27
action_20 _ = happyReduce_17

action_21 (44) = happyShift action_26
action_21 _ = happyReduce_11

action_22 (39) = happyShift action_25
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (72) = happyShift action_2
action_23 (4) = happyGoto action_24
action_23 _ = happyFail (happyExpListPerState 23)

action_24 _ = happyReduce_9

action_25 (69) = happyShift action_33
action_25 (15) = happyGoto action_32
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (56) = happyShift action_8
action_26 (62) = happyShift action_10
action_26 (65) = happyShift action_11
action_26 (67) = happyShift action_12
action_26 (72) = happyShift action_2
action_26 (4) = happyGoto action_3
action_26 (10) = happyGoto action_21
action_26 (11) = happyGoto action_31
action_26 (20) = happyGoto action_23
action_26 _ = happyReduce_10

action_27 (56) = happyShift action_8
action_27 (62) = happyShift action_10
action_27 (65) = happyShift action_11
action_27 (67) = happyShift action_12
action_27 (71) = happyShift action_30
action_27 (72) = happyShift action_2
action_27 (4) = happyGoto action_3
action_27 (13) = happyGoto action_28
action_27 (20) = happyGoto action_29
action_27 _ = happyFail (happyExpListPerState 27)

action_28 _ = happyReduce_18

action_29 (72) = happyShift action_2
action_29 (4) = happyGoto action_35
action_29 _ = happyFail (happyExpListPerState 29)

action_30 _ = happyReduce_6

action_31 _ = happyReduce_12

action_32 _ = happyReduce_5

action_33 (16) = happyGoto action_34
action_33 _ = happyReduce_20

action_34 (34) = happyShift action_52
action_34 (38) = happyShift action_53
action_34 (45) = happyShift action_54
action_34 (49) = happyShift action_55
action_34 (56) = happyShift action_8
action_34 (60) = happyShift action_56
action_34 (61) = happyShift action_57
action_34 (62) = happyShift action_10
action_34 (63) = happyShift action_58
action_34 (64) = happyShift action_59
action_34 (65) = happyShift action_11
action_34 (66) = happyShift action_60
action_34 (67) = happyShift action_12
action_34 (68) = happyShift action_61
action_34 (69) = happyShift action_33
action_34 (71) = happyShift action_62
action_34 (72) = happyShift action_2
action_34 (73) = happyShift action_63
action_34 (74) = happyShift action_64
action_34 (4) = happyGoto action_38
action_34 (5) = happyGoto action_39
action_34 (6) = happyGoto action_40
action_34 (15) = happyGoto action_41
action_34 (17) = happyGoto action_42
action_34 (20) = happyGoto action_43
action_34 (22) = happyGoto action_44
action_34 (23) = happyGoto action_45
action_34 (24) = happyGoto action_46
action_34 (25) = happyGoto action_47
action_34 (26) = happyGoto action_48
action_34 (27) = happyGoto action_49
action_34 (28) = happyGoto action_50
action_34 (30) = happyGoto action_51
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (38) = happyShift action_36
action_35 (49) = happyShift action_37
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (56) = happyShift action_8
action_36 (62) = happyShift action_10
action_36 (65) = happyShift action_11
action_36 (67) = happyShift action_12
action_36 (72) = happyShift action_2
action_36 (4) = happyGoto action_3
action_36 (10) = happyGoto action_21
action_36 (11) = happyGoto action_101
action_36 (20) = happyGoto action_23
action_36 _ = happyReduce_10

action_37 _ = happyReduce_15

action_38 (38) = happyShift action_100
action_38 (40) = happyReduce_42
action_38 (72) = happyReduce_42
action_38 _ = happyReduce_73

action_39 _ = happyReduce_47

action_40 _ = happyReduce_51

action_41 _ = happyReduce_23

action_42 _ = happyReduce_21

action_43 (72) = happyShift action_2
action_43 (4) = happyGoto action_97
action_43 (18) = happyGoto action_98
action_43 (19) = happyGoto action_99
action_43 _ = happyFail (happyExpListPerState 43)

action_44 _ = happyReduce_58

action_45 _ = happyReduce_60

action_46 (36) = happyShift action_94
action_46 (41) = happyShift action_95
action_46 (48) = happyShift action_96
action_46 (32) = happyGoto action_93
action_46 _ = happyReduce_62

action_47 (42) = happyShift action_91
action_47 (45) = happyShift action_92
action_47 (31) = happyGoto action_90
action_47 _ = happyReduce_64

action_48 (35) = happyShift action_83
action_48 (37) = happyShift action_84
action_48 (50) = happyShift action_85
action_48 (51) = happyShift action_86
action_48 (53) = happyShift action_87
action_48 (54) = happyShift action_88
action_48 (55) = happyShift action_89
action_48 (33) = happyGoto action_82
action_48 _ = happyReduce_66

action_49 (70) = happyShift action_81
action_49 _ = happyReduce_68

action_50 (49) = happyShift action_80
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (43) = happyShift action_76
action_51 (46) = happyShift action_77
action_51 (47) = happyShift action_78
action_51 (52) = happyShift action_79
action_51 _ = happyReduce_46

action_52 (38) = happyShift action_53
action_52 (60) = happyShift action_56
action_52 (63) = happyShift action_58
action_52 (66) = happyShift action_60
action_52 (72) = happyShift action_2
action_52 (73) = happyShift action_63
action_52 (74) = happyShift action_64
action_52 (4) = happyGoto action_66
action_52 (5) = happyGoto action_39
action_52 (6) = happyGoto action_40
action_52 (22) = happyGoto action_75
action_52 (30) = happyGoto action_68
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (34) = happyShift action_52
action_53 (38) = happyShift action_53
action_53 (45) = happyShift action_54
action_53 (56) = happyShift action_8
action_53 (60) = happyShift action_56
action_53 (62) = happyShift action_10
action_53 (63) = happyShift action_58
action_53 (65) = happyShift action_11
action_53 (66) = happyShift action_60
action_53 (67) = happyShift action_12
action_53 (72) = happyShift action_2
action_53 (73) = happyShift action_63
action_53 (74) = happyShift action_64
action_53 (4) = happyGoto action_38
action_53 (5) = happyGoto action_39
action_53 (6) = happyGoto action_40
action_53 (20) = happyGoto action_73
action_53 (22) = happyGoto action_44
action_53 (23) = happyGoto action_45
action_53 (24) = happyGoto action_46
action_53 (25) = happyGoto action_47
action_53 (26) = happyGoto action_48
action_53 (27) = happyGoto action_49
action_53 (28) = happyGoto action_74
action_53 (30) = happyGoto action_68
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (38) = happyShift action_53
action_54 (60) = happyShift action_56
action_54 (63) = happyShift action_58
action_54 (66) = happyShift action_60
action_54 (72) = happyShift action_2
action_54 (73) = happyShift action_63
action_54 (74) = happyShift action_64
action_54 (4) = happyGoto action_66
action_54 (5) = happyGoto action_39
action_54 (6) = happyGoto action_40
action_54 (22) = happyGoto action_72
action_54 (30) = happyGoto action_68
action_54 _ = happyFail (happyExpListPerState 54)

action_55 _ = happyReduce_22

action_56 _ = happyReduce_49

action_57 (38) = happyShift action_71
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (56) = happyShift action_8
action_58 (62) = happyShift action_10
action_58 (65) = happyShift action_11
action_58 (67) = happyShift action_12
action_58 (72) = happyShift action_2
action_58 (4) = happyGoto action_3
action_58 (20) = happyGoto action_70
action_58 _ = happyFail (happyExpListPerState 58)

action_59 (34) = happyShift action_52
action_59 (38) = happyShift action_53
action_59 (45) = happyShift action_54
action_59 (49) = happyShift action_69
action_59 (60) = happyShift action_56
action_59 (63) = happyShift action_58
action_59 (66) = happyShift action_60
action_59 (72) = happyShift action_2
action_59 (73) = happyShift action_63
action_59 (74) = happyShift action_64
action_59 (4) = happyGoto action_66
action_59 (5) = happyGoto action_39
action_59 (6) = happyGoto action_40
action_59 (22) = happyGoto action_44
action_59 (23) = happyGoto action_45
action_59 (24) = happyGoto action_46
action_59 (25) = happyGoto action_47
action_59 (26) = happyGoto action_48
action_59 (27) = happyGoto action_49
action_59 (28) = happyGoto action_67
action_59 (30) = happyGoto action_68
action_59 _ = happyFail (happyExpListPerState 59)

action_60 _ = happyReduce_48

action_61 (38) = happyShift action_65
action_61 _ = happyFail (happyExpListPerState 61)

action_62 _ = happyReduce_19

action_63 _ = happyReduce_2

action_64 _ = happyReduce_3

action_65 (34) = happyShift action_52
action_65 (38) = happyShift action_53
action_65 (45) = happyShift action_54
action_65 (60) = happyShift action_56
action_65 (63) = happyShift action_58
action_65 (66) = happyShift action_60
action_65 (72) = happyShift action_2
action_65 (73) = happyShift action_63
action_65 (74) = happyShift action_64
action_65 (4) = happyGoto action_66
action_65 (5) = happyGoto action_39
action_65 (6) = happyGoto action_40
action_65 (22) = happyGoto action_44
action_65 (23) = happyGoto action_45
action_65 (24) = happyGoto action_46
action_65 (25) = happyGoto action_47
action_65 (26) = happyGoto action_48
action_65 (27) = happyGoto action_49
action_65 (28) = happyGoto action_121
action_65 (30) = happyGoto action_68
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (38) = happyShift action_100
action_66 _ = happyReduce_73

action_67 (49) = happyShift action_120
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (47) = happyShift action_78
action_68 _ = happyReduce_46

action_69 _ = happyReduce_29

action_70 _ = happyReduce_52

action_71 (34) = happyShift action_52
action_71 (38) = happyShift action_53
action_71 (45) = happyShift action_54
action_71 (60) = happyShift action_56
action_71 (63) = happyShift action_58
action_71 (66) = happyShift action_60
action_71 (72) = happyShift action_2
action_71 (73) = happyShift action_63
action_71 (74) = happyShift action_64
action_71 (4) = happyGoto action_66
action_71 (5) = happyGoto action_39
action_71 (6) = happyGoto action_40
action_71 (22) = happyGoto action_44
action_71 (23) = happyGoto action_45
action_71 (24) = happyGoto action_46
action_71 (25) = happyGoto action_47
action_71 (26) = happyGoto action_48
action_71 (27) = happyGoto action_49
action_71 (28) = happyGoto action_119
action_71 (30) = happyGoto action_68
action_71 _ = happyFail (happyExpListPerState 71)

action_72 _ = happyReduce_56

action_73 (40) = happyShift action_118
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (39) = happyShift action_117
action_74 _ = happyFail (happyExpListPerState 74)

action_75 _ = happyReduce_57

action_76 (49) = happyShift action_116
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (49) = happyShift action_115
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (72) = happyShift action_2
action_78 (4) = happyGoto action_114
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (34) = happyShift action_52
action_79 (38) = happyShift action_53
action_79 (45) = happyShift action_54
action_79 (60) = happyShift action_56
action_79 (63) = happyShift action_58
action_79 (66) = happyShift action_60
action_79 (72) = happyShift action_2
action_79 (73) = happyShift action_63
action_79 (74) = happyShift action_64
action_79 (4) = happyGoto action_66
action_79 (5) = happyGoto action_39
action_79 (6) = happyGoto action_40
action_79 (22) = happyGoto action_44
action_79 (23) = happyGoto action_45
action_79 (24) = happyGoto action_46
action_79 (25) = happyGoto action_47
action_79 (26) = happyGoto action_48
action_79 (27) = happyGoto action_49
action_79 (28) = happyGoto action_113
action_79 (30) = happyGoto action_68
action_79 _ = happyFail (happyExpListPerState 79)

action_80 _ = happyReduce_33

action_81 (34) = happyShift action_52
action_81 (38) = happyShift action_53
action_81 (45) = happyShift action_54
action_81 (60) = happyShift action_56
action_81 (63) = happyShift action_58
action_81 (66) = happyShift action_60
action_81 (72) = happyShift action_2
action_81 (73) = happyShift action_63
action_81 (74) = happyShift action_64
action_81 (4) = happyGoto action_66
action_81 (5) = happyGoto action_39
action_81 (6) = happyGoto action_40
action_81 (22) = happyGoto action_44
action_81 (23) = happyGoto action_45
action_81 (24) = happyGoto action_46
action_81 (25) = happyGoto action_47
action_81 (26) = happyGoto action_48
action_81 (27) = happyGoto action_49
action_81 (28) = happyGoto action_112
action_81 (30) = happyGoto action_68
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (34) = happyShift action_52
action_82 (38) = happyShift action_53
action_82 (45) = happyShift action_54
action_82 (60) = happyShift action_56
action_82 (63) = happyShift action_58
action_82 (66) = happyShift action_60
action_82 (72) = happyShift action_2
action_82 (73) = happyShift action_63
action_82 (74) = happyShift action_64
action_82 (4) = happyGoto action_66
action_82 (5) = happyGoto action_39
action_82 (6) = happyGoto action_40
action_82 (22) = happyGoto action_44
action_82 (23) = happyGoto action_45
action_82 (24) = happyGoto action_46
action_82 (25) = happyGoto action_111
action_82 (30) = happyGoto action_68
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_84

action_84 (34) = happyShift action_52
action_84 (38) = happyShift action_53
action_84 (45) = happyShift action_54
action_84 (60) = happyShift action_56
action_84 (63) = happyShift action_58
action_84 (66) = happyShift action_60
action_84 (72) = happyShift action_2
action_84 (73) = happyShift action_63
action_84 (74) = happyShift action_64
action_84 (4) = happyGoto action_66
action_84 (5) = happyGoto action_39
action_84 (6) = happyGoto action_40
action_84 (22) = happyGoto action_44
action_84 (23) = happyGoto action_45
action_84 (24) = happyGoto action_46
action_84 (25) = happyGoto action_47
action_84 (26) = happyGoto action_48
action_84 (27) = happyGoto action_110
action_84 (30) = happyGoto action_68
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_79

action_86 _ = happyReduce_80

action_87 _ = happyReduce_83

action_88 _ = happyReduce_81

action_89 _ = happyReduce_82

action_90 (34) = happyShift action_52
action_90 (38) = happyShift action_53
action_90 (45) = happyShift action_54
action_90 (60) = happyShift action_56
action_90 (63) = happyShift action_58
action_90 (66) = happyShift action_60
action_90 (72) = happyShift action_2
action_90 (73) = happyShift action_63
action_90 (74) = happyShift action_64
action_90 (4) = happyGoto action_66
action_90 (5) = happyGoto action_39
action_90 (6) = happyGoto action_40
action_90 (22) = happyGoto action_44
action_90 (23) = happyGoto action_45
action_90 (24) = happyGoto action_109
action_90 (30) = happyGoto action_68
action_90 _ = happyFail (happyExpListPerState 90)

action_91 _ = happyReduce_74

action_92 _ = happyReduce_75

action_93 (34) = happyShift action_52
action_93 (38) = happyShift action_53
action_93 (45) = happyShift action_54
action_93 (60) = happyShift action_56
action_93 (63) = happyShift action_58
action_93 (66) = happyShift action_60
action_93 (72) = happyShift action_2
action_93 (73) = happyShift action_63
action_93 (74) = happyShift action_64
action_93 (4) = happyGoto action_66
action_93 (5) = happyGoto action_39
action_93 (6) = happyGoto action_40
action_93 (22) = happyGoto action_44
action_93 (23) = happyGoto action_108
action_93 (30) = happyGoto action_68
action_93 _ = happyFail (happyExpListPerState 93)

action_94 _ = happyReduce_78

action_95 _ = happyReduce_76

action_96 _ = happyReduce_77

action_97 (52) = happyShift action_107
action_97 _ = happyReduce_34

action_98 (44) = happyShift action_106
action_98 _ = happyReduce_36

action_99 (49) = happyShift action_105
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (34) = happyShift action_52
action_100 (38) = happyShift action_53
action_100 (45) = happyShift action_54
action_100 (60) = happyShift action_56
action_100 (63) = happyShift action_58
action_100 (66) = happyShift action_60
action_100 (72) = happyShift action_2
action_100 (73) = happyShift action_63
action_100 (74) = happyShift action_64
action_100 (4) = happyGoto action_66
action_100 (5) = happyGoto action_39
action_100 (6) = happyGoto action_40
action_100 (22) = happyGoto action_44
action_100 (23) = happyGoto action_45
action_100 (24) = happyGoto action_46
action_100 (25) = happyGoto action_47
action_100 (26) = happyGoto action_48
action_100 (27) = happyGoto action_49
action_100 (28) = happyGoto action_103
action_100 (29) = happyGoto action_104
action_100 (30) = happyGoto action_68
action_100 _ = happyReduce_69

action_101 (39) = happyShift action_102
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (69) = happyShift action_33
action_102 (15) = happyGoto action_130
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (44) = happyShift action_129
action_103 _ = happyReduce_70

action_104 (39) = happyShift action_128
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_24

action_106 (72) = happyShift action_2
action_106 (4) = happyGoto action_97
action_106 (18) = happyGoto action_98
action_106 (19) = happyGoto action_127
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (34) = happyShift action_52
action_107 (38) = happyShift action_53
action_107 (45) = happyShift action_54
action_107 (60) = happyShift action_56
action_107 (63) = happyShift action_58
action_107 (66) = happyShift action_60
action_107 (72) = happyShift action_2
action_107 (73) = happyShift action_63
action_107 (74) = happyShift action_64
action_107 (4) = happyGoto action_66
action_107 (5) = happyGoto action_39
action_107 (6) = happyGoto action_40
action_107 (22) = happyGoto action_44
action_107 (23) = happyGoto action_45
action_107 (24) = happyGoto action_46
action_107 (25) = happyGoto action_47
action_107 (26) = happyGoto action_48
action_107 (27) = happyGoto action_49
action_107 (28) = happyGoto action_126
action_107 (30) = happyGoto action_68
action_107 _ = happyFail (happyExpListPerState 107)

action_108 _ = happyReduce_59

action_109 (36) = happyShift action_94
action_109 (41) = happyShift action_95
action_109 (48) = happyShift action_96
action_109 (32) = happyGoto action_93
action_109 _ = happyReduce_61

action_110 _ = happyReduce_65

action_111 (42) = happyShift action_91
action_111 (45) = happyShift action_92
action_111 (31) = happyGoto action_90
action_111 _ = happyReduce_63

action_112 _ = happyReduce_67

action_113 (49) = happyShift action_125
action_113 _ = happyFail (happyExpListPerState 113)

action_114 (38) = happyShift action_124
action_114 _ = happyReduce_72

action_115 _ = happyReduce_27

action_116 _ = happyReduce_26

action_117 _ = happyReduce_55

action_118 _ = happyReduce_53

action_119 (39) = happyShift action_123
action_119 _ = happyFail (happyExpListPerState 119)

action_120 _ = happyReduce_28

action_121 (39) = happyShift action_122
action_121 _ = happyFail (happyExpListPerState 121)

action_122 (34) = happyShift action_52
action_122 (38) = happyShift action_53
action_122 (45) = happyShift action_54
action_122 (49) = happyShift action_55
action_122 (56) = happyShift action_8
action_122 (60) = happyShift action_56
action_122 (61) = happyShift action_57
action_122 (62) = happyShift action_10
action_122 (63) = happyShift action_58
action_122 (64) = happyShift action_59
action_122 (65) = happyShift action_11
action_122 (66) = happyShift action_60
action_122 (67) = happyShift action_12
action_122 (68) = happyShift action_61
action_122 (69) = happyShift action_33
action_122 (72) = happyShift action_2
action_122 (73) = happyShift action_63
action_122 (74) = happyShift action_64
action_122 (4) = happyGoto action_38
action_122 (5) = happyGoto action_39
action_122 (6) = happyGoto action_40
action_122 (15) = happyGoto action_41
action_122 (17) = happyGoto action_134
action_122 (20) = happyGoto action_43
action_122 (22) = happyGoto action_44
action_122 (23) = happyGoto action_45
action_122 (24) = happyGoto action_46
action_122 (25) = happyGoto action_47
action_122 (26) = happyGoto action_48
action_122 (27) = happyGoto action_49
action_122 (28) = happyGoto action_50
action_122 (30) = happyGoto action_51
action_122 _ = happyFail (happyExpListPerState 122)

action_123 (34) = happyShift action_52
action_123 (38) = happyShift action_53
action_123 (45) = happyShift action_54
action_123 (49) = happyShift action_55
action_123 (56) = happyShift action_8
action_123 (60) = happyShift action_56
action_123 (61) = happyShift action_57
action_123 (62) = happyShift action_10
action_123 (63) = happyShift action_58
action_123 (64) = happyShift action_59
action_123 (65) = happyShift action_11
action_123 (66) = happyShift action_60
action_123 (67) = happyShift action_12
action_123 (68) = happyShift action_61
action_123 (69) = happyShift action_33
action_123 (72) = happyShift action_2
action_123 (73) = happyShift action_63
action_123 (74) = happyShift action_64
action_123 (4) = happyGoto action_38
action_123 (5) = happyGoto action_39
action_123 (6) = happyGoto action_40
action_123 (15) = happyGoto action_41
action_123 (17) = happyGoto action_133
action_123 (20) = happyGoto action_43
action_123 (22) = happyGoto action_44
action_123 (23) = happyGoto action_45
action_123 (24) = happyGoto action_46
action_123 (25) = happyGoto action_47
action_123 (26) = happyGoto action_48
action_123 (27) = happyGoto action_49
action_123 (28) = happyGoto action_50
action_123 (30) = happyGoto action_51
action_123 _ = happyFail (happyExpListPerState 123)

action_124 (34) = happyShift action_52
action_124 (38) = happyShift action_53
action_124 (45) = happyShift action_54
action_124 (60) = happyShift action_56
action_124 (63) = happyShift action_58
action_124 (66) = happyShift action_60
action_124 (72) = happyShift action_2
action_124 (73) = happyShift action_63
action_124 (74) = happyShift action_64
action_124 (4) = happyGoto action_66
action_124 (5) = happyGoto action_39
action_124 (6) = happyGoto action_40
action_124 (22) = happyGoto action_44
action_124 (23) = happyGoto action_45
action_124 (24) = happyGoto action_46
action_124 (25) = happyGoto action_47
action_124 (26) = happyGoto action_48
action_124 (27) = happyGoto action_49
action_124 (28) = happyGoto action_103
action_124 (29) = happyGoto action_132
action_124 (30) = happyGoto action_68
action_124 _ = happyReduce_69

action_125 _ = happyReduce_25

action_126 _ = happyReduce_35

action_127 _ = happyReduce_37

action_128 _ = happyReduce_50

action_129 (34) = happyShift action_52
action_129 (38) = happyShift action_53
action_129 (45) = happyShift action_54
action_129 (60) = happyShift action_56
action_129 (63) = happyShift action_58
action_129 (66) = happyShift action_60
action_129 (72) = happyShift action_2
action_129 (73) = happyShift action_63
action_129 (74) = happyShift action_64
action_129 (4) = happyGoto action_66
action_129 (5) = happyGoto action_39
action_129 (6) = happyGoto action_40
action_129 (22) = happyGoto action_44
action_129 (23) = happyGoto action_45
action_129 (24) = happyGoto action_46
action_129 (25) = happyGoto action_47
action_129 (26) = happyGoto action_48
action_129 (27) = happyGoto action_49
action_129 (28) = happyGoto action_103
action_129 (29) = happyGoto action_131
action_129 (30) = happyGoto action_68
action_129 _ = happyReduce_69

action_130 _ = happyReduce_16

action_131 _ = happyReduce_71

action_132 (39) = happyShift action_136
action_132 _ = happyFail (happyExpListPerState 132)

action_133 (58) = happyShift action_135
action_133 _ = happyReduce_30

action_134 _ = happyReduce_32

action_135 (34) = happyShift action_52
action_135 (38) = happyShift action_53
action_135 (45) = happyShift action_54
action_135 (49) = happyShift action_55
action_135 (56) = happyShift action_8
action_135 (60) = happyShift action_56
action_135 (61) = happyShift action_57
action_135 (62) = happyShift action_10
action_135 (63) = happyShift action_58
action_135 (64) = happyShift action_59
action_135 (65) = happyShift action_11
action_135 (66) = happyShift action_60
action_135 (67) = happyShift action_12
action_135 (68) = happyShift action_61
action_135 (69) = happyShift action_33
action_135 (72) = happyShift action_2
action_135 (73) = happyShift action_63
action_135 (74) = happyShift action_64
action_135 (4) = happyGoto action_38
action_135 (5) = happyGoto action_39
action_135 (6) = happyGoto action_40
action_135 (15) = happyGoto action_41
action_135 (17) = happyGoto action_137
action_135 (20) = happyGoto action_43
action_135 (22) = happyGoto action_44
action_135 (23) = happyGoto action_45
action_135 (24) = happyGoto action_46
action_135 (25) = happyGoto action_47
action_135 (26) = happyGoto action_48
action_135 (27) = happyGoto action_49
action_135 (28) = happyGoto action_50
action_135 (30) = happyGoto action_51
action_135 _ = happyFail (happyExpListPerState 135)

action_136 _ = happyReduce_54

action_137 _ = happyReduce_31

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 ((Just (tokenLineCol happy_var_1), Ident (prToken happy_var_1))
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn5
		 ((Just (tokenLineCol happy_var_1), read (prToken happy_var_1))
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn6
		 ((Just (tokenLineCol happy_var_1), prToken happy_var_1)
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn7
		 ((fst happy_var_1, Grammar.AbsLatte.Program (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happyReduce 6 8 happyReduction_5
happyReduction_5 ((HappyAbsSyn15  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((fst happy_var_1, Grammar.AbsLatte.FnDef (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_4)(snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_6 = happyReduce 6 8 happyReduction_6
happyReduction_6 (_ `HappyStk`
	(HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.ClDef (Just (tokenLineCol happy_var_1)) (snd happy_var_2)(snd happy_var_3)(reverse (snd happy_var_5)))
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_1  9 happyReduction_7
happyReduction_7 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  9 happyReduction_8
happyReduction_8 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_2))
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_2  10 happyReduction_9
happyReduction_9 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn10
		 ((fst happy_var_1, Grammar.AbsLatte.Arg (fst happy_var_1)(snd happy_var_1)(snd happy_var_2))
	)
happyReduction_9 _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_0  11 happyReduction_10
happyReduction_10  =  HappyAbsSyn11
		 ((Nothing, [])
	)

happyReduce_11 = happySpecReduce_1  11 happyReduction_11
happyReduction_11 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  11 happyReduction_12
happyReduction_12 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  12 happyReduction_13
happyReduction_13 (HappyAbsSyn4  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn12
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.ClExtend (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_0  12 happyReduction_14
happyReduction_14  =  HappyAbsSyn12
		 ((Nothing, Grammar.AbsLatte.ClNoExt Nothing)
	)

happyReduce_15 = happySpecReduce_3  13 happyReduction_15
happyReduction_15 _
	(HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn13
		 ((fst happy_var_1, Grammar.AbsLatte.ClField (fst happy_var_1)(snd happy_var_1)(snd happy_var_2))
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happyReduce 6 13 happyReduction_16
happyReduction_16 ((HappyAbsSyn15  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 ((fst happy_var_1, Grammar.AbsLatte.ClMethod (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_4)(snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_0  14 happyReduction_17
happyReduction_17  =  HappyAbsSyn14
		 ((Nothing, [])
	)

happyReduce_18 = happySpecReduce_2  14 happyReduction_18
happyReduction_18 (HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((fst happy_var_1, flip (:) (snd happy_var_1)(snd happy_var_2))
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  15 happyReduction_19
happyReduction_19 _
	(HappyAbsSyn16  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn15
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Block (Just (tokenLineCol happy_var_1)) (reverse (snd happy_var_2)))
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_0  16 happyReduction_20
happyReduction_20  =  HappyAbsSyn16
		 ((Nothing, [])
	)

happyReduce_21 = happySpecReduce_2  16 happyReduction_21
happyReduction_21 (HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 ((fst happy_var_1, flip (:) (snd happy_var_1)(snd happy_var_2))
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  17 happyReduction_22
happyReduction_22 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Empty (Just (tokenLineCol happy_var_1)))
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  17 happyReduction_23
happyReduction_23 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Grammar.AbsLatte.BStmt (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  17 happyReduction_24
happyReduction_24 _
	(HappyAbsSyn19  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Grammar.AbsLatte.Decl (fst happy_var_1)(snd happy_var_1)(snd happy_var_2))
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happyReduce 4 17 happyReduction_25
happyReduction_25 (_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((fst happy_var_1, Grammar.AbsLatte.Ass (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_26 = happySpecReduce_3  17 happyReduction_26
happyReduction_26 _
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Grammar.AbsLatte.Incr (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  17 happyReduction_27
happyReduction_27 _
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Grammar.AbsLatte.Decr (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  17 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Ret (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  17 happyReduction_29
happyReduction_29 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.VRet (Just (tokenLineCol happy_var_1)))
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happyReduce 5 17 happyReduction_30
happyReduction_30 ((HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Cond (Just (tokenLineCol happy_var_1)) (snd happy_var_3)(snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 7 17 happyReduction_31
happyReduction_31 ((HappyAbsSyn17  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.CondElse (Just (tokenLineCol happy_var_1)) (snd happy_var_3)(snd happy_var_5)(snd happy_var_7))
	) `HappyStk` happyRest

happyReduce_32 = happyReduce 5 17 happyReduction_32
happyReduction_32 ((HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.While (Just (tokenLineCol happy_var_1)) (snd happy_var_3)(snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_33 = happySpecReduce_2  17 happyReduction_33
happyReduction_33 _
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Grammar.AbsLatte.SExp (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_33 _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Grammar.AbsLatte.NoInit (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  18 happyReduction_35
happyReduction_35 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Grammar.AbsLatte.Init (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  19 happyReduction_37
happyReduction_37 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Int (Just (tokenLineCol happy_var_1)))
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  20 happyReduction_39
happyReduction_39 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Str (Just (tokenLineCol happy_var_1)))
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  20 happyReduction_40
happyReduction_40 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Bool (Just (tokenLineCol happy_var_1)))
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  20 happyReduction_41
happyReduction_41 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Void (Just (tokenLineCol happy_var_1)))
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  20 happyReduction_42
happyReduction_42 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn20
		 ((fst happy_var_1, Grammar.AbsLatte.Class (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_0  21 happyReduction_43
happyReduction_43  =  HappyAbsSyn21
		 ((Nothing, [])
	)

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  21 happyReduction_45
happyReduction_45 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  22 happyReduction_46
happyReduction_46 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.ELValue (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  22 happyReduction_47
happyReduction_47 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.ELitInt (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  22 happyReduction_48
happyReduction_48 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.ELitTrue (Just (tokenLineCol happy_var_1)))
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  22 happyReduction_49
happyReduction_49 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.ELitFalse (Just (tokenLineCol happy_var_1)))
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happyReduce 4 22 happyReduction_50
happyReduction_50 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EApp (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_51 = happySpecReduce_1  22 happyReduction_51
happyReduction_51 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EString (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_2  22 happyReduction_52
happyReduction_52 (HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.ENewObj (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_52 _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  22 happyReduction_53
happyReduction_53 _
	(HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.ENull (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happyReduce 6 22 happyReduction_54
happyReduction_54 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EMethod (fst happy_var_1)(snd happy_var_1)(snd happy_var_3)(snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_55 = happySpecReduce_3  22 happyReduction_55
happyReduction_55 _
	(HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), snd happy_var_2)
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_2  23 happyReduction_56
happyReduction_56 (HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Neg (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_56 _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_2  23 happyReduction_57
happyReduction_57 (HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Not (Just (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_57 _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  23 happyReduction_58
happyReduction_58 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  24 happyReduction_59
happyReduction_59 (HappyAbsSyn22  happy_var_3)
	(HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EMul (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_3))
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  24 happyReduction_60
happyReduction_60 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  25 happyReduction_61
happyReduction_61 (HappyAbsSyn22  happy_var_3)
	(HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EAdd (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_3))
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  25 happyReduction_62
happyReduction_62 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  26 happyReduction_63
happyReduction_63 (HappyAbsSyn22  happy_var_3)
	(HappyAbsSyn33  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.ERel (fst happy_var_1)(snd happy_var_1)(snd happy_var_2)(snd happy_var_3))
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  26 happyReduction_64
happyReduction_64 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  27 happyReduction_65
happyReduction_65 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EAnd (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  27 happyReduction_66
happyReduction_66 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  28 happyReduction_67
happyReduction_67 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Grammar.AbsLatte.EOr (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  28 happyReduction_68
happyReduction_68 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, snd happy_var_1)
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_0  29 happyReduction_69
happyReduction_69  =  HappyAbsSyn29
		 ((Nothing, [])
	)

happyReduce_70 = happySpecReduce_1  29 happyReduction_70
happyReduction_70 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn29
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  29 happyReduction_71
happyReduction_71 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn29
		 ((fst happy_var_1, (:) (snd happy_var_1)(snd happy_var_3))
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  30 happyReduction_72
happyReduction_72 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 ((fst happy_var_1, Grammar.AbsLatte.ObjField (fst happy_var_1)(snd happy_var_1)(snd happy_var_3))
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  30 happyReduction_73
happyReduction_73 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn30
		 ((fst happy_var_1, Grammar.AbsLatte.Var (fst happy_var_1)(snd happy_var_1))
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_1  31 happyReduction_74
happyReduction_74 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Plus (Just (tokenLineCol happy_var_1)))
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_1  31 happyReduction_75
happyReduction_75 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Minus (Just (tokenLineCol happy_var_1)))
	)
happyReduction_75 _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_1  32 happyReduction_76
happyReduction_76 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Times (Just (tokenLineCol happy_var_1)))
	)
happyReduction_76 _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_1  32 happyReduction_77
happyReduction_77 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Div (Just (tokenLineCol happy_var_1)))
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_1  32 happyReduction_78
happyReduction_78 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.Mod (Just (tokenLineCol happy_var_1)))
	)
happyReduction_78 _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_1  33 happyReduction_79
happyReduction_79 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.LTH (Just (tokenLineCol happy_var_1)))
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_1  33 happyReduction_80
happyReduction_80 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.LE (Just (tokenLineCol happy_var_1)))
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_1  33 happyReduction_81
happyReduction_81 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.GTH (Just (tokenLineCol happy_var_1)))
	)
happyReduction_81 _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_1  33 happyReduction_82
happyReduction_82 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.GE (Just (tokenLineCol happy_var_1)))
	)
happyReduction_82 _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_1  33 happyReduction_83
happyReduction_83 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.EQU (Just (tokenLineCol happy_var_1)))
	)
happyReduction_83 _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_1  33 happyReduction_84
happyReduction_84 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn33
		 ((Just (tokenLineCol happy_var_1), Grammar.AbsLatte.NE (Just (tokenLineCol happy_var_1)))
	)
happyReduction_84 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 75 75 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 34;
	PT _ (TS _ 2) -> cont 35;
	PT _ (TS _ 3) -> cont 36;
	PT _ (TS _ 4) -> cont 37;
	PT _ (TS _ 5) -> cont 38;
	PT _ (TS _ 6) -> cont 39;
	PT _ (TS _ 7) -> cont 40;
	PT _ (TS _ 8) -> cont 41;
	PT _ (TS _ 9) -> cont 42;
	PT _ (TS _ 10) -> cont 43;
	PT _ (TS _ 11) -> cont 44;
	PT _ (TS _ 12) -> cont 45;
	PT _ (TS _ 13) -> cont 46;
	PT _ (TS _ 14) -> cont 47;
	PT _ (TS _ 15) -> cont 48;
	PT _ (TS _ 16) -> cont 49;
	PT _ (TS _ 17) -> cont 50;
	PT _ (TS _ 18) -> cont 51;
	PT _ (TS _ 19) -> cont 52;
	PT _ (TS _ 20) -> cont 53;
	PT _ (TS _ 21) -> cont 54;
	PT _ (TS _ 22) -> cont 55;
	PT _ (TS _ 23) -> cont 56;
	PT _ (TS _ 24) -> cont 57;
	PT _ (TS _ 25) -> cont 58;
	PT _ (TS _ 26) -> cont 59;
	PT _ (TS _ 27) -> cont 60;
	PT _ (TS _ 28) -> cont 61;
	PT _ (TS _ 29) -> cont 62;
	PT _ (TS _ 30) -> cont 63;
	PT _ (TS _ 31) -> cont 64;
	PT _ (TS _ 32) -> cont 65;
	PT _ (TS _ 33) -> cont 66;
	PT _ (TS _ 34) -> cont 67;
	PT _ (TS _ 35) -> cont 68;
	PT _ (TS _ 36) -> cont 69;
	PT _ (TS _ 37) -> cont 70;
	PT _ (TS _ 38) -> cont 71;
	PT _ (TV _) -> cont 72;
	PT _ (TI _) -> cont 73;
	PT _ (TL _) -> cont 74;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 75 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = (thenM)
happyReturn :: () => a -> Err a
happyReturn = (returnM)
happyThen1 m k tks = (thenM) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (returnM) a
happyError' :: () => ([(Token)], [String]) -> Err a
happyError' = (\(tokens, _) -> happyError tokens)
pProgram_internal tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn7 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    t:_ -> " before `" ++ id(prToken t) ++ "'"

myLexer = tokens

pProgram = (>>= return . snd) . pProgram_internal
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}







# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














































{-# LINE 7 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc/include/ghcversion.h" #-}















{-# LINE 7 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc8814_0/ghc_2.h" #-}








































































































































































{-# LINE 7 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 









{-# LINE 43 "templates/GenericTemplate.hs" #-}

data Happy_IntList = HappyCons Int Happy_IntList







{-# LINE 65 "templates/GenericTemplate.hs" #-}

{-# LINE 75 "templates/GenericTemplate.hs" #-}

{-# LINE 84 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 137 "templates/GenericTemplate.hs" #-}

{-# LINE 147 "templates/GenericTemplate.hs" #-}
indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 267 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 333 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
