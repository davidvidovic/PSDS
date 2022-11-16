----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2022 07:18:12 PM
-- Design Name: 
-- Module Name: deljenje_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity deljenje_top is
    Generic ( WIDTH : integer := 8);
    Port ( a_in : in STD_LOGIC_vector(WIDTH-1 downto 0);
           b_in : in STD_LOGIC_vector(WIDTH-1 downto 0);
           r_out : out STD_LOGIC_vector(WIDTH-1 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC);
end deljenje_top;

architecture Behavioral of deljenje_top is
  type state_type is (idle, dodela1, dodela2, calc);
  signal state_reg, state_next : state_type := idle;
  signal q_reg, q_next : STD_LOGIC_vector(WIDTH-1 downto 0);
  signal r_reg, r_next : STD_LOGIC_vector(WIDTH-1 downto 0);
  signal op1_reg, op1_next : STD_LOGIC_vector(WIDTH-1 downto 0);
  signal op2_reg, op2_next : STD_LOGIC_vector(WIDTH-1 downto 0);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state_reg <= idle;
        q_reg <= (others => '0');
        r_reg <= (others => '0');
        op1_reg <= (others => '0');
        op2_reg <= (others => '0');
      else
        state_reg <= state_next;
        q_reg <= q_next;
        r_reg <= r_next;
        op1_reg <= op1_next;
        op2_reg <= op2_next;
      end if;
    end if;
  end process;
  
  process(start, state_next, state_reg, op1_reg, op2_reg, q_reg, r_reg)
  begin
    q_next <= q_reg;
    r_next <= r_reg;
    op1_next <= op1_reg;
    op2_next <= op2_reg;
    ready <= '0';
    
    case state_reg is
      when idle =>
        ready <= '1';
        
        if start = '1' then
          q_next <= conv_std_logic_vector(0, WIDTH);
          r_next <= conv_std_logic_vector(0, WIDTH);
          
          if a_in > b_in then
            state_next <= dodela1;
            else
            state_next <= dodela2;
          end if;
          else
            state_next <= idle;
          end if;
        
        
        when dodela1 =>
          op1_next <= a_in;
          op2_next <= b_in;
          state_next <= calc;
        
        when dodela2 =>
          op1_next <= b_in;
          op2_next <= a_in;
          state_next <= calc;  
          
        when calc =>
          if op1_reg >= op2_reg then
            op1_next <= conv_std_logic_vector(unsigned(op1_reg)-unsigned(op2_reg), WIDTH);
            q_next <= conv_std_logic_vector(unsigned(q_reg)+1, WIDTH);
          else
            r_next <= op1_reg;
          end if;
     end case;
  end process;

  r_out <= r_reg;
  
end Behavioral;
