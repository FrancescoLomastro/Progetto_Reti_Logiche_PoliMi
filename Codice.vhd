-------------------------------------------------------
--              PROJECT_RETI_LOGICHE
-------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity project_reti_logiche IS
        PORT (
            i_clk : IN STD_LOGIC;
            i_rst : IN STD_LOGIC;
            i_start : IN STD_LOGIC;
            i_w : IN STD_LOGIC;

            o_z0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_done : OUT STD_LOGIC;

            o_mem_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            i_mem_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_mem_we : OUT STD_LOGIC;
            o_mem_en : OUT STD_LOGIC
        );
end entity;

architecture Behavioral of project_reti_logiche is
component FSM_uscite IS
        PORT (
            i_clk : IN STD_LOGIC;
            i_rst : IN STD_LOGIC;
            i_start : IN STD_LOGIC;
            i_w : IN STD_LOGIC;

            o_z0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_done : OUT STD_LOGIC;

            o_mem_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            i_mem_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_mem_we : OUT STD_LOGIC;
            o_mem_en : OUT STD_LOGIC
        );
end component;
begin
FSM_USC: FSM_uscite port map
(
    i_clk,
    i_rst,
    i_start,
    i_w,
    o_z0,
    o_z1,
    o_z2,
    o_z3,
    o_done,
    o_mem_addr,
    i_mem_data,
    o_mem_we,
    o_mem_en
);


end Behavioral;


-------------------------------------------------------
--              FSM_USCITE
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_uscite IS
        PORT (
            i_clk : IN STD_LOGIC;
            i_rst : IN STD_LOGIC;
            i_start : IN STD_LOGIC;
            i_w : IN STD_LOGIC;

            o_z0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_z3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_done : OUT STD_LOGIC;

            o_mem_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            i_mem_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_mem_we : OUT STD_LOGIC;
            o_mem_en : OUT STD_LOGIC
        );
END  FSM_uscite;

architecture Behavioral of FSM_uscite is
component datapath_uscite is
 Port (
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_start: in std_logic;
        i_w: in std_logic;
        
        WRITE: in std_logic;
        o_done: in std_logic;
        i_mem_data: in std_logic_vector(7 downto 0);
        
        OUTPUT_16: out std_logic_vector(15 downto 0);
        o_z0: out std_logic_vector(7 downto 0);
        o_z1: out std_logic_vector(7 downto 0);
        o_z2: out std_logic_vector(7 downto 0);
        o_z3: out std_logic_vector(7 downto 0)
       );
end component;
signal o_done_internal: std_logic;
signal write: std_logic;
type S is (S0,S1,S2,S3,S4);
signal  state : S;
begin

DATAPATH_USC: datapath_uscite port map
(
    i_clk,
    i_rst,
    i_start,
    i_w,
    write,
    o_done_internal,
    i_mem_data,
    o_mem_addr,
    o_z0,
    o_z1,
    o_z2,
    o_z3
);
o_mem_we<='0';

process(i_clk, i_rst)
begin
    if(i_rst='1') then
        state<=S0;
        o_done_internal<='0';
        o_mem_en<='0';
        write<='0';
    elsif (i_clk'event and i_clk='1') then
         case state is
            when S0 => 
                    o_done_internal<='0';
                    o_mem_en<='0';
                    write<='0';
                    if(i_start='0') then
                        state<=S0;
                    elsif(i_start='1') then
                        state<=S1;
                    end if;
            when S1 => 
                    o_done_internal<='0';
                    o_mem_en<='0';
                    write<='0';
                    if(i_start='0') then
                        state<=S2;
                    elsif(i_start='1') then
                        state<=S1;
                    end if;
            when S2 => 
                    state<=S3;
                    o_mem_en<='1';
                    o_done_internal<='0';
                    write<='1';
            when S3 => 
                    state<=S4;
                    o_mem_en<='1';
                    o_done_internal<='0';
                    write<='1';
            when S4 => 
                     state<=S0;
                     o_mem_en<='0';
                     o_done_internal<='1';
                     write<='0';
         end case;
    end if;
end process;
o_done<=o_done_internal;
end Behavioral;


-------------------------------------------------------
--              DATAPATH_USCITE
-------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity datapath_uscite is
 Port (
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_start: in std_logic;
        i_w: in std_logic;
        
        WRITE: in std_logic;
        o_done: in std_logic;
        i_mem_data: in std_logic_vector(7 downto 0);
                
        OUTPUT_16: out std_logic_vector(15 downto 0);
        o_z0: out std_logic_vector(7 downto 0);
        o_z1: out std_logic_vector(7 downto 0);
        o_z2: out std_logic_vector(7 downto 0);
        o_z3: out std_logic_vector(7 downto 0)
       );
end datapath_uscite;

architecture Behavioral of datapath_uscite is

component FSM_registri is
    Port(
            i_clk: in std_logic;
            i_rst: in std_logic;
            i_start: in std_logic;
            i_w: in std_logic;
            OUTPUT_2: out std_logic_vector(1 downto 0);
            OUTPUT_16: out std_logic_vector(15 downto 0)    
        );
end component;
signal o_z0_mem: std_logic_vector(7 downto 0);
signal o_z1_mem: std_logic_vector(7 downto 0);
signal o_z2_mem: std_logic_vector(7 downto 0);
signal o_z3_mem: std_logic_vector(7 downto 0);
signal ce_0: std_logic;
signal ce_1: std_logic;
signal ce_2: std_logic;
signal ce_3: std_logic;
signal OUTPUT_2: std_logic_vector(1 downto 0);
begin
FSM_REG: FSM_registri port map
(
    i_clk,
    i_rst,
    i_start,
    i_w,
    OUTPUT_2,
    OUTPUT_16
);


ce_0<= WRITE and (not OUTPUT_2(0)) and (not OUTPUT_2(1));
ce_1<= WRITE and  OUTPUT_2(0) and (not OUTPUT_2(1));
ce_2<= WRITE and (not OUTPUT_2(0)) and  OUTPUT_2(1);
ce_3<= WRITE and  OUTPUT_2(0) and  OUTPUT_2(1);

process(i_clk,i_rst)
begin
    if(i_rst='1') then
        o_z0_mem<="00000000";
        o_z1_mem<="00000000";
        o_z2_mem<="00000000";
        o_z3_mem<="00000000";
    elsif(i_clk'event and i_clk='1') then
        if(ce_0 = '1') then
            o_z0_mem<=i_mem_data;
        end if;
        if(ce_1 = '1') then
            o_z1_mem<=i_mem_data;
        end if;
        if(ce_2 = '1') then
            o_z2_mem<=i_mem_data;
        end if;
        if(ce_3 = '1') then
            o_z3_mem<=i_mem_data;
        end if;
    end if;
end process;

 with o_done select
        o_z0 <= "00000000" when '0',
                    o_z0_mem when '1',
                    "XXXXXXXX" when others;
 with o_done select
        o_z1 <= "00000000" when '0',
                    o_z1_mem when '1',
                    "XXXXXXXX" when others;
 with o_done select
        o_z2 <= "00000000" when '0',
                    o_z2_mem when '1',
                    "XXXXXXXX" when others;
 with o_done select
        o_z3 <= "00000000" when '0',
                    o_z3_mem when '1',
                    "XXXXXXXX" when others;
        

end Behavioral;


-------------------------------------------------------
--              FSM_REGISTRI
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_registri is
    Port(
            i_clk: in std_logic;
            i_rst: in std_logic;
            i_start: in std_logic;
            i_w: in std_logic;
            OUTPUT_2: out std_logic_vector(1 downto 0);
            OUTPUT_16: out std_logic_vector(15 downto 0)    
        );
end FSM_registri;

architecture Behavioral of FSM_registri is
component datapath_registri is
     Port(
           i_clk: in std_logic;
           i_rst: in std_logic;
           i_start: in std_logic;
           i_w: in std_logic;
           CLEAR: in std_logic;
           HEADER: in std_logic;
           OUTPUT_2: out std_logic_vector(1 downto 0);
           OUTPUT_16: out std_logic_vector(15 downto 0)    
       );
end component;
signal clear: std_logic;
signal header: std_logic;
type S is (S0,S1,S2,S3,S4,S5);
signal  state : S;
begin


DATAPATH_REG: datapath_registri port map
(
    i_clk,
    i_rst,
    i_start,
    i_w,
    clear,
    header,
    OUTPUT_2,
    OUTPUT_16
);

process(i_clk,i_rst)
begin
    if(i_rst='1') then
        state<=S0;
        header<='1';
        clear<='0';
    elsif ( i_clk'event and i_clk='1') then
        case state is      
            when S0 =>
                        header<='1';
                        clear<='0';
                        if(i_start='1') then
                            state<=S1;
                        else
                            state<=S0;
                        end if;
           when S1 =>
                        header<='0';
                        clear<='0';
                        state<=S2;
           when S2 =>
                        header<='0';
                        clear<='0';
                        if(i_start='0') then
                            state<=S3;
                        else
                            state<=S2;
                        end if;
           when S3 =>
                        header<='0';
                        clear<='0';
                        state<=S4;
           when S4 =>
                        header<='0';
                        clear<='0';
                        state<=S5;
           when S5 =>
                        header<='1';
                        clear<='1';
                        state<=S0;
        end case;
    end if;
end process;

end Behavioral;


-------------------------------------------------------
--              DATAPATH_REGISTRI
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath_registri is
    Port(
            i_clk: in std_logic;
            i_rst: in std_logic;
            i_start: in std_logic;
            i_w: in std_logic;
            CLEAR: in std_logic;
            HEADER: in std_logic;
            OUTPUT_2: out std_logic_vector(1 downto 0);
            OUTPUT_16: out std_logic_vector(15 downto 0)    
        );
end datapath_registri;

architecture Behavioral of datapath_registri is
signal reg_2_ce: std_logic;
signal reg_16_ce: std_logic;
signal rst_reg: std_logic;

component reg_2 is
    Port(
             CLK: in std_logic;
             RST: in std_logic;
             CE: in std_logic;
             D: in std_logic;
             OUTPUT: out std_logic_vector(1 downto 0)
        );
end component;

component reg_16 is
   Port(
            CLK: in std_logic;
            RST: in std_logic;
            CE: in std_logic;
            D: in std_logic;
            OUTPUT: out std_logic_vector(15 downto 0)
        );
end component;
begin
reg_2_ce <= i_start and HEADER;
reg_16_ce <= i_start and not HEADER;
rst_reg <= i_rst or CLEAR;

REG2: reg_2 port map
(
   i_clk,
   rst_reg,
   reg_2_ce,
   i_w,
   OUTPUT_2
);
REG16: reg_16 port map
(
   i_clk,
   rst_reg,
   reg_16_ce,
   i_w,
   OUTPUT_16
);

end Behavioral;


-------------------------------------------------------
--              REG_2
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_2 is
    Port(
            CLK: in std_logic;
            RST: in std_logic;
            CE: in std_logic;
            D: in std_logic;
            OUTPUT: out std_logic_vector(1 downto 0)
        );
end reg_2;

architecture Behavioral of reg_2 is
signal internal_output: std_logic_vector(1 downto 0);
begin

process(CLK,RST)
begin
    if(RST='1') then
        internal_output<="00";
    elsif (CLK'event and CLK='1') then
         if (CE = '1') then
               internal_output<=internal_output(0) & D;
         end if;
    end if;
end process;

OUTPUT<=internal_output;
end Behavioral;


-------------------------------------------------------
--              REG_16
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_16 is
    Port(
            CLK: in std_logic;
            RST: in std_logic;
            CE: in std_logic;
            D: in std_logic;
            OUTPUT: out std_logic_vector(15 downto 0)
        );
end reg_16;

architecture Behavioral of reg_16 is
signal internal_output: std_logic_vector(15 downto 0);
begin

process(CLK,RST)
begin
   if(RST='1') then
        internal_output<="0000000000000000";
    elsif (CLK'event and CLK='1') then
         if (CE='1') then
            internal_output<=internal_output(14 downto 0) & D;
        end if;
    end if;
end process;

OUTPUT<=internal_output;

end Behavioral;
