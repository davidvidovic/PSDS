----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2022 07:51:23 PM
-- Design Name: 
-- Module Name: kvadratni_koren_tb - Behavioral
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
use IEEE.STD_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kvadratni_koren_tb is
    Generic ( WIDTH : integer := 32);
    --  Port ( );
end kvadratni_koren_tb;

architecture Behavioral of kvadratni_koren_tb is
    signal s_x, s_res_out : STD_LOGIC_VECTOR (WIDTH-1 downto 0);
    signal s_clk, s_reset, s_ready, s_start : STD_LOGIC;
    
begin
    top: entity work.kvadratni_koren_top
    Generic map(    WIDTH   =>  WIDTH)
    Port map(       x       =>  s_x,
                    res_out =>  s_res_out,
                    clk     =>  s_clk,
                    reset   =>  s_reset,
                    ready   =>  s_ready,
                    start   =>  s_start
    );
    
    clk_gen: process
    begin
        s_clk <= '0';
        wait for 50ns;
        s_clk <= '1';
        wait for 50ns;
    end process;
    
    
    stim_gen: process
    begin
        s_reset <= '0';
        s_start <= '1';
        s_x <= conv_std_logic_vector(16, WIDTH);
        wait for 1000ms;
        s_x <= conv_std_logic_vector(25, WIDTH);
    wait;
    end process;

end Behavioral;
