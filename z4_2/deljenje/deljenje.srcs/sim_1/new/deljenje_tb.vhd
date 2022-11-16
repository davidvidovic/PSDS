----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2022 07:44:06 PM
-- Design Name: 
-- Module Name: deljenje_tb - Behavioral
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

entity deljenje_tb is
  Generic ( WIDTH : integer := 8);
--  Port ( );
end deljenje_tb;

architecture Behavioral of deljenje_tb is
  signal s_a_in, s_b_in, s_r_out : STD_LOGIC_vector(WIDTH-1 downto 0);
  signal s_clk, s_reset, s_ready, s_start : STD_LOGIC;
  
begin
  top: entity work.deljenje_top
    Generic map ( WIDTH   =>  WIDTH)
    Port map    ( a_in    =>  s_a_in,
                  b_in    =>  s_b_in,
                  r_out   =>  s_r_out,
                  clk     =>  s_clk,
                  reset   =>  s_reset,
                  ready   =>  s_ready,
                  start   =>  s_start);
  
  process
  begin
    s_clk <= '0';
    wait for 50ms;
    s_clk <= '1';
    wait for 50ms;
  end process;
  
  
  
  process
  begin
    s_reset <= '1';
    s_start <= '0';
    s_a_in <= conv_std_logic_vector(20, WIDTH);
    s_b_in <= conv_std_logic_vector(4, WIDTH);
    
    wait for 75ms;
    
    s_reset <= '0';
    
    wait for 225ms;
    
    s_start <= '1';
  wait;
  end process;
end Behavioral;
