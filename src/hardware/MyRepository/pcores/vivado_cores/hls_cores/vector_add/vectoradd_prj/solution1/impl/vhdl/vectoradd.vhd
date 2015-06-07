-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2014.2
-- Copyright (C) 2014 Xilinx Inc. All rights reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vectoradd is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    cmd_TDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    cmd_TVALID : IN STD_LOGIC;
    cmd_TREADY : OUT STD_LOGIC;
    resp_TDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    resp_TVALID : OUT STD_LOGIC;
    resp_TREADY : IN STD_LOGIC;
    a_Addr_A : OUT STD_LOGIC_VECTOR (31 downto 0);
    a_EN_A : OUT STD_LOGIC;
    a_WEN_A : OUT STD_LOGIC_VECTOR (3 downto 0);
    a_Din_A : OUT STD_LOGIC_VECTOR (31 downto 0);
    a_Dout_A : IN STD_LOGIC_VECTOR (31 downto 0);
    a_Clk_A : OUT STD_LOGIC;
    a_Rst_A : OUT STD_LOGIC;
    b_Addr_A : OUT STD_LOGIC_VECTOR (31 downto 0);
    b_EN_A : OUT STD_LOGIC;
    b_WEN_A : OUT STD_LOGIC_VECTOR (3 downto 0);
    b_Din_A : OUT STD_LOGIC_VECTOR (31 downto 0);
    b_Dout_A : IN STD_LOGIC_VECTOR (31 downto 0);
    b_Clk_A : OUT STD_LOGIC;
    b_Rst_A : OUT STD_LOGIC;
    result_Addr_A : OUT STD_LOGIC_VECTOR (31 downto 0);
    result_EN_A : OUT STD_LOGIC;
    result_WEN_A : OUT STD_LOGIC_VECTOR (3 downto 0);
    result_Din_A : OUT STD_LOGIC_VECTOR (31 downto 0);
    result_Dout_A : IN STD_LOGIC_VECTOR (31 downto 0);
    result_Clk_A : OUT STD_LOGIC;
    result_Rst_A : OUT STD_LOGIC );
end;


architecture behav of vectoradd is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "vectoradd,hls_ip_2014_2,{HLS_INPUT_TYPE=c,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7vx485tffg1761-2,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=6.410000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=0,HLS_SYN_LUT=0}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_st1_fsm_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_ST_st2_fsm_1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant ap_ST_st3_fsm_2 : STD_LOGIC_VECTOR (2 downto 0) := "010";
    constant ap_ST_st4_fsm_3 : STD_LOGIC_VECTOR (2 downto 0) := "011";
    constant ap_ST_st5_fsm_4 : STD_LOGIC_VECTOR (2 downto 0) := "100";
    constant ap_ST_st6_fsm_5 : STD_LOGIC_VECTOR (2 downto 0) := "101";
    constant ap_ST_st7_fsm_6 : STD_LOGIC_VECTOR (2 downto 0) := "110";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv4_0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant ap_const_lv4_F : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    constant ap_const_lv32_FFFFFFFF : STD_LOGIC_VECTOR (31 downto 0) := "11111111111111111111111111111111";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";

    signal grp_fu_155_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal reg_160 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_CS_fsm : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal tmp_fu_164_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_2_fu_169_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal op_reg_234 : STD_LOGIC_VECTOR (31 downto 0);
    signal end_reg_240 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_reg_253 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_2_reg_257 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_s_fu_179_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal i_1_reg_134_temp: signed (32-1 downto 0);
    signal tmp_s_reg_264 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_8_fu_174_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_10_fu_185_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_10_reg_279 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_5_fu_196_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal i_reg_144_temp: signed (32-1 downto 0);
    signal tmp_5_reg_286 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_3_fu_191_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_7_fu_202_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_7_reg_301 : STD_LOGIC_VECTOR (0 downto 0);
    signal i_3_fu_215_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_sig_ioackin_resp_TREADY : STD_LOGIC;
    signal i_2_fu_228_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal i_1_reg_134 : STD_LOGIC_VECTOR (31 downto 0);
    signal i_reg_144 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_reg_ioackin_resp_TREADY : STD_LOGIC := '0';
    signal a_Addr_A_orig : STD_LOGIC_VECTOR (31 downto 0);
    signal b_Addr_A_orig : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_9_fu_208_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_6_fu_221_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal result_Addr_A_orig : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_sig_bdd_87 : BOOLEAN;
    signal ap_sig_bdd_101 : BOOLEAN;


begin




    -- the current state (ap_CS_fsm) of the state machine. --
    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n = '0') then
                ap_CS_fsm <= ap_ST_st1_fsm_0;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    -- ap_reg_ioackin_resp_TREADY assign process. --
    ap_reg_ioackin_resp_TREADY_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n = '0') then
                ap_reg_ioackin_resp_TREADY <= ap_const_logic_0;
            else
                if ((((ap_ST_st6_fsm_5 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_10_reg_279)) and not((not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_0 = ap_sig_ioackin_resp_TREADY)))) or ((ap_ST_st7_fsm_6 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_7_reg_301)) and not(((ap_const_logic_0 = ap_sig_ioackin_resp_TREADY) and not((ap_const_lv1_0 = tmp_7_reg_301))))))) then 
                    ap_reg_ioackin_resp_TREADY <= ap_const_logic_0;
                elsif ((((ap_ST_st6_fsm_5 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_1 = resp_TREADY)) or ((ap_ST_st7_fsm_6 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_7_reg_301)) and (ap_const_logic_1 = resp_TREADY)))) then 
                    ap_reg_ioackin_resp_TREADY <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    -- i_1_reg_134 assign process. --
    i_1_reg_134_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0)) and (tmp_fu_164_p2 = ap_const_lv1_0) and not((ap_const_lv1_0 = tmp_2_fu_169_p2)))) then 
                i_1_reg_134 <= cmd_TDATA;
            elsif (((ap_ST_st6_fsm_5 = ap_CS_fsm) and not((not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_0 = ap_sig_ioackin_resp_TREADY))))) then 
                i_1_reg_134 <= i_3_fu_215_p2;
            end if; 
        end if;
    end process;

    -- i_reg_144 assign process. --
    i_reg_144_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0)) and not((tmp_fu_164_p2 = ap_const_lv1_0)))) then 
                i_reg_144 <= cmd_TDATA;
            elsif (((ap_ST_st7_fsm_6 = ap_CS_fsm) and not(((ap_const_logic_0 = ap_sig_ioackin_resp_TREADY) and not((ap_const_lv1_0 = tmp_7_reg_301)))))) then 
                i_reg_144 <= i_2_fu_228_p2;
            end if; 
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not((cmd_TVALID = ap_const_logic_0)) and (ap_ST_st3_fsm_2 = ap_CS_fsm))) then
                end_reg_240 <= cmd_TDATA;
            end if;
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((not((cmd_TVALID = ap_const_logic_0)) and (ap_ST_st2_fsm_1 = ap_CS_fsm))) then
                op_reg_234 <= cmd_TDATA;
            end if;
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0)) and (tmp_fu_164_p2 = ap_const_lv1_0) and not((ap_const_lv1_0 = tmp_2_fu_169_p2))) or ((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0)) and not((tmp_fu_164_p2 = ap_const_lv1_0))))) then
                reg_160 <= grp_fu_155_p2;
            end if;
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_ST_st5_fsm_4 = ap_CS_fsm) and (ap_const_lv1_0 = tmp_reg_253) and not((ap_const_lv1_0 = tmp_2_reg_257)) and not((ap_const_lv1_0 = tmp_8_fu_174_p2)))) then
                tmp_10_reg_279 <= tmp_10_fu_185_p2;
                tmp_s_reg_264 <= tmp_s_fu_179_p1;
            end if;
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0)) and (tmp_fu_164_p2 = ap_const_lv1_0))) then
                tmp_2_reg_257 <= tmp_2_fu_169_p2;
            end if;
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_ST_st5_fsm_4 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_reg_253)) and not((ap_const_lv1_0 = tmp_3_fu_191_p2)))) then
                tmp_5_reg_286 <= tmp_5_fu_196_p1;
                tmp_7_reg_301 <= tmp_7_fu_202_p2;
            end if;
        end if;
    end process;

    -- assign process. --
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0)))) then
                tmp_reg_253 <= tmp_fu_164_p2;
            end if;
        end if;
    end process;

    -- the next state (ap_NS_fsm) of the state machine. --
    ap_NS_fsm_assign_proc : process (cmd_TVALID, ap_CS_fsm, tmp_reg_253, tmp_2_reg_257, tmp_8_fu_174_p2, tmp_10_reg_279, tmp_3_fu_191_p2, tmp_7_reg_301, ap_sig_ioackin_resp_TREADY)
    begin
        case ap_CS_fsm is
            when ap_ST_st1_fsm_0 => 
                ap_NS_fsm <= ap_ST_st2_fsm_1;
            when ap_ST_st2_fsm_1 => 
                if (not((cmd_TVALID = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st3_fsm_2;
                else
                    ap_NS_fsm <= ap_ST_st2_fsm_1;
                end if;
            when ap_ST_st3_fsm_2 => 
                if (not((cmd_TVALID = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st4_fsm_3;
                else
                    ap_NS_fsm <= ap_ST_st3_fsm_2;
                end if;
            when ap_ST_st4_fsm_3 => 
                if (not((cmd_TVALID = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st5_fsm_4;
                else
                    ap_NS_fsm <= ap_ST_st4_fsm_3;
                end if;
            when ap_ST_st5_fsm_4 => 
                if ((((ap_const_lv1_0 = tmp_reg_253) and (ap_const_lv1_0 = tmp_2_reg_257)) or (not((ap_const_lv1_0 = tmp_reg_253)) and (ap_const_lv1_0 = tmp_3_fu_191_p2)) or ((ap_const_lv1_0 = tmp_reg_253) and (ap_const_lv1_0 = tmp_8_fu_174_p2)))) then
                    ap_NS_fsm <= ap_ST_st2_fsm_1;
                elsif ((not((ap_const_lv1_0 = tmp_reg_253)) and not((ap_const_lv1_0 = tmp_3_fu_191_p2)))) then
                    ap_NS_fsm <= ap_ST_st7_fsm_6;
                else
                    ap_NS_fsm <= ap_ST_st6_fsm_5;
                end if;
            when ap_ST_st6_fsm_5 => 
                if (not((not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_0 = ap_sig_ioackin_resp_TREADY)))) then
                    ap_NS_fsm <= ap_ST_st5_fsm_4;
                else
                    ap_NS_fsm <= ap_ST_st6_fsm_5;
                end if;
            when ap_ST_st7_fsm_6 => 
                if (not(((ap_const_logic_0 = ap_sig_ioackin_resp_TREADY) and not((ap_const_lv1_0 = tmp_7_reg_301))))) then
                    ap_NS_fsm <= ap_ST_st5_fsm_4;
                else
                    ap_NS_fsm <= ap_ST_st7_fsm_6;
                end if;
            when others =>  
                ap_NS_fsm <= "XXX";
        end case;
    end process;
    a_Addr_A <= std_logic_vector(shift_left(unsigned(a_Addr_A_orig),to_integer(unsigned('0' & ap_const_lv32_2(31-1 downto 0)))));

    -- a_Addr_A_orig assign process. --
    a_Addr_A_orig_assign_proc : process(ap_CS_fsm, tmp_s_fu_179_p1, tmp_5_fu_196_p1, ap_sig_bdd_87, ap_sig_bdd_101)
    begin
        if ((ap_ST_st5_fsm_4 = ap_CS_fsm)) then
            if (ap_sig_bdd_101) then 
                a_Addr_A_orig <= tmp_5_fu_196_p1(32 - 1 downto 0);
            elsif (ap_sig_bdd_87) then 
                a_Addr_A_orig <= tmp_s_fu_179_p1(32 - 1 downto 0);
            else 
                a_Addr_A_orig <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            end if;
        else 
            a_Addr_A_orig <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;

    a_Clk_A <= ap_clk;
    a_Din_A <= ap_const_lv32_0;

    -- a_EN_A assign process. --
    a_EN_A_assign_proc : process(ap_CS_fsm, tmp_reg_253, tmp_2_reg_257, tmp_8_fu_174_p2, tmp_3_fu_191_p2)
    begin
        if ((((ap_ST_st5_fsm_4 = ap_CS_fsm) and (ap_const_lv1_0 = tmp_reg_253) and not((ap_const_lv1_0 = tmp_2_reg_257)) and not((ap_const_lv1_0 = tmp_8_fu_174_p2))) or ((ap_ST_st5_fsm_4 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_reg_253)) and not((ap_const_lv1_0 = tmp_3_fu_191_p2))))) then 
            a_EN_A <= ap_const_logic_1;
        else 
            a_EN_A <= ap_const_logic_0;
        end if; 
    end process;

    a_Rst_A <= ap_rst_n;
    a_WEN_A <= ap_const_lv4_0;

    -- ap_sig_bdd_101 assign process. --
    ap_sig_bdd_101_assign_proc : process(tmp_reg_253, tmp_3_fu_191_p2)
    begin
                ap_sig_bdd_101 <= (not((ap_const_lv1_0 = tmp_reg_253)) and not((ap_const_lv1_0 = tmp_3_fu_191_p2)));
    end process;


    -- ap_sig_bdd_87 assign process. --
    ap_sig_bdd_87_assign_proc : process(tmp_reg_253, tmp_2_reg_257, tmp_8_fu_174_p2)
    begin
                ap_sig_bdd_87 <= ((ap_const_lv1_0 = tmp_reg_253) and not((ap_const_lv1_0 = tmp_2_reg_257)) and not((ap_const_lv1_0 = tmp_8_fu_174_p2)));
    end process;


    -- ap_sig_ioackin_resp_TREADY assign process. --
    ap_sig_ioackin_resp_TREADY_assign_proc : process(resp_TREADY, ap_reg_ioackin_resp_TREADY)
    begin
        if ((ap_const_logic_0 = ap_reg_ioackin_resp_TREADY)) then 
            ap_sig_ioackin_resp_TREADY <= resp_TREADY;
        else 
            ap_sig_ioackin_resp_TREADY <= ap_const_logic_1;
        end if; 
    end process;

    b_Addr_A <= std_logic_vector(shift_left(unsigned(b_Addr_A_orig),to_integer(unsigned('0' & ap_const_lv32_2(31-1 downto 0)))));

    -- b_Addr_A_orig assign process. --
    b_Addr_A_orig_assign_proc : process(ap_CS_fsm, tmp_s_fu_179_p1, tmp_5_fu_196_p1, ap_sig_bdd_87, ap_sig_bdd_101)
    begin
        if ((ap_ST_st5_fsm_4 = ap_CS_fsm)) then
            if (ap_sig_bdd_101) then 
                b_Addr_A_orig <= tmp_5_fu_196_p1(32 - 1 downto 0);
            elsif (ap_sig_bdd_87) then 
                b_Addr_A_orig <= tmp_s_fu_179_p1(32 - 1 downto 0);
            else 
                b_Addr_A_orig <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
            end if;
        else 
            b_Addr_A_orig <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;

    b_Clk_A <= ap_clk;
    b_Din_A <= ap_const_lv32_0;

    -- b_EN_A assign process. --
    b_EN_A_assign_proc : process(ap_CS_fsm, tmp_reg_253, tmp_2_reg_257, tmp_8_fu_174_p2, tmp_3_fu_191_p2)
    begin
        if ((((ap_ST_st5_fsm_4 = ap_CS_fsm) and (ap_const_lv1_0 = tmp_reg_253) and not((ap_const_lv1_0 = tmp_2_reg_257)) and not((ap_const_lv1_0 = tmp_8_fu_174_p2))) or ((ap_ST_st5_fsm_4 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_reg_253)) and not((ap_const_lv1_0 = tmp_3_fu_191_p2))))) then 
            b_EN_A <= ap_const_logic_1;
        else 
            b_EN_A <= ap_const_logic_0;
        end if; 
    end process;

    b_Rst_A <= ap_rst_n;
    b_WEN_A <= ap_const_lv4_0;

    -- cmd_TREADY assign process. --
    cmd_TREADY_assign_proc : process(cmd_TVALID, ap_CS_fsm)
    begin
        if ((((ap_ST_st4_fsm_3 = ap_CS_fsm) and not((cmd_TVALID = ap_const_logic_0))) or (not((cmd_TVALID = ap_const_logic_0)) and (ap_ST_st2_fsm_1 = ap_CS_fsm)) or (not((cmd_TVALID = ap_const_logic_0)) and (ap_ST_st3_fsm_2 = ap_CS_fsm)))) then 
            cmd_TREADY <= ap_const_logic_1;
        else 
            cmd_TREADY <= ap_const_logic_0;
        end if; 
    end process;

    grp_fu_155_p2 <= std_logic_vector(unsigned(end_reg_240) + unsigned(ap_const_lv32_FFFFFFFF));
    i_2_fu_228_p2 <= std_logic_vector(unsigned(i_reg_144) + unsigned(ap_const_lv32_1));
    i_3_fu_215_p2 <= std_logic_vector(unsigned(i_1_reg_134) + unsigned(ap_const_lv32_1));
    resp_TDATA <= ap_const_lv32_1;

    -- resp_TVALID assign process. --
    resp_TVALID_assign_proc : process(ap_CS_fsm, tmp_10_reg_279, tmp_7_reg_301, ap_reg_ioackin_resp_TREADY)
    begin
        if ((((ap_ST_st6_fsm_5 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_0 = ap_reg_ioackin_resp_TREADY)) or ((ap_ST_st7_fsm_6 = ap_CS_fsm) and not((ap_const_lv1_0 = tmp_7_reg_301)) and (ap_const_logic_0 = ap_reg_ioackin_resp_TREADY)))) then 
            resp_TVALID <= ap_const_logic_1;
        else 
            resp_TVALID <= ap_const_logic_0;
        end if; 
    end process;

    result_Addr_A <= std_logic_vector(shift_left(unsigned(result_Addr_A_orig),to_integer(unsigned('0' & ap_const_lv32_2(31-1 downto 0)))));

    -- result_Addr_A_orig assign process. --
    result_Addr_A_orig_assign_proc : process(ap_CS_fsm, tmp_s_reg_264, tmp_5_reg_286)
    begin
        if ((ap_ST_st7_fsm_6 = ap_CS_fsm)) then 
            result_Addr_A_orig <= tmp_5_reg_286(32 - 1 downto 0);
        elsif ((ap_ST_st6_fsm_5 = ap_CS_fsm)) then 
            result_Addr_A_orig <= tmp_s_reg_264(32 - 1 downto 0);
        else 
            result_Addr_A_orig <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;

    result_Clk_A <= ap_clk;

    -- result_Din_A assign process. --
    result_Din_A_assign_proc : process(ap_CS_fsm, tmp_9_fu_208_p2, tmp_6_fu_221_p2)
    begin
        if ((ap_ST_st7_fsm_6 = ap_CS_fsm)) then 
            result_Din_A <= tmp_6_fu_221_p2;
        elsif ((ap_ST_st6_fsm_5 = ap_CS_fsm)) then 
            result_Din_A <= tmp_9_fu_208_p2;
        else 
            result_Din_A <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end if; 
    end process;


    -- result_EN_A assign process. --
    result_EN_A_assign_proc : process(ap_CS_fsm, tmp_10_reg_279, tmp_7_reg_301, ap_sig_ioackin_resp_TREADY)
    begin
        if ((((ap_ST_st6_fsm_5 = ap_CS_fsm) and not((not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_0 = ap_sig_ioackin_resp_TREADY)))) or ((ap_ST_st7_fsm_6 = ap_CS_fsm) and not(((ap_const_logic_0 = ap_sig_ioackin_resp_TREADY) and not((ap_const_lv1_0 = tmp_7_reg_301))))))) then 
            result_EN_A <= ap_const_logic_1;
        else 
            result_EN_A <= ap_const_logic_0;
        end if; 
    end process;

    result_Rst_A <= ap_rst_n;

    -- result_WEN_A assign process. --
    result_WEN_A_assign_proc : process(ap_CS_fsm, tmp_10_reg_279, tmp_7_reg_301, ap_sig_ioackin_resp_TREADY)
    begin
        if ((((ap_ST_st6_fsm_5 = ap_CS_fsm) and not((not((ap_const_lv1_0 = tmp_10_reg_279)) and (ap_const_logic_0 = ap_sig_ioackin_resp_TREADY)))) or ((ap_ST_st7_fsm_6 = ap_CS_fsm) and not(((ap_const_logic_0 = ap_sig_ioackin_resp_TREADY) and not((ap_const_lv1_0 = tmp_7_reg_301))))))) then 
            result_WEN_A <= ap_const_lv4_F;
        else 
            result_WEN_A <= ap_const_lv4_0;
        end if; 
    end process;

    tmp_10_fu_185_p2 <= "1" when (i_1_reg_134 = reg_160) else "0";
    tmp_2_fu_169_p2 <= "1" when (op_reg_234 = ap_const_lv32_2) else "0";
    tmp_3_fu_191_p2 <= "1" when (signed(i_reg_144) < signed(end_reg_240)) else "0";
    
    i_reg_144_temp <= signed(i_reg_144);
    tmp_5_fu_196_p1 <= std_logic_vector(resize(i_reg_144_temp,64));

    tmp_6_fu_221_p2 <= std_logic_vector(unsigned(b_Dout_A) + unsigned(a_Dout_A));
    tmp_7_fu_202_p2 <= "1" when (i_reg_144 = reg_160) else "0";
    tmp_8_fu_174_p2 <= "1" when (signed(i_1_reg_134) < signed(end_reg_240)) else "0";
    tmp_9_fu_208_p2 <= std_logic_vector(unsigned(a_Dout_A) - unsigned(b_Dout_A));
    tmp_fu_164_p2 <= "1" when (op_reg_234 = ap_const_lv32_1) else "0";
    
    i_1_reg_134_temp <= signed(i_1_reg_134);
    tmp_s_fu_179_p1 <= std_logic_vector(resize(i_1_reg_134_temp,64));

end behav;
