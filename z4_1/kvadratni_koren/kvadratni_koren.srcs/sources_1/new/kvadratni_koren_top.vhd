----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2022 11:50:39 PM
-- Design Name: 
-- Module Name: kvadratni_koren_top - Behavioral
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
--use IEEE.STD_logic_arith.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kvadratni_koren_top is
    Generic ( WIDTH : integer := 32);
    Port ( x : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           res_out : out STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : out STD_LOGIC);
end kvadratni_koren_top;

architecture Behavioral of kvadratni_koren_top is
    type state_type is (idle, s1, s2, shift, calc, s3);
    signal state_next, state_reg : state_type := idle;
    signal op_next, op_reg : STD_LOGIC_VECTOR (WIDTH-1 downto 0);
    signal res_next, res_reg : STD_LOGIC_VECTOR (WIDTH-1 downto 0);
    signal one_next, one_reg : STD_LOGIC_VECTOR (WIDTH-1 downto 0);
    signal comp1, comp2, comp3 : STD_LOGIC;
    
    signal temp : STD_LOGIC_VECTOR (32 downto 0);
    
begin
    -- sekvencijalna logika
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= idle;
                op_reg <= (others => '0');
                res_reg <= (others => '0');
                one_reg <= (others => '0');
            else
                state_reg <= state_next;
                op_reg <= op_next;
                res_reg <= res_next;
                one_reg <= one_next;
            end if;
        end if;
    end process;
    
    -- CONTROL PATH
    process(start, state_next, state_reg, op_next, op_reg, one_next, one_reg, res_next, res_reg)
    begin
        op_next <= (others => '0');
        res_next <= (others => '0');
        one_next <= (others => '0');
        ready <= '0';
        
        case state_reg is
            when idle =>
                ready <= '1';
                
                if start = '1' then
                    op_next <= x;
                    res_next <= "00000000000000000000000000000000";
                    one_next <= "01000000000000000000000000000000";
                    --one_next <= one_next(1 downto 0) & "000000000000000000000000000000";
                    state_next <= s1;
                else
                    state_next <= idle;
                end if;
                
            when s1 =>
                if one_reg <= op_reg then
                    state_next <= s2;
                else
                    state_next <= shift;
                end if;
             
            when s2 =>
                if one_next = "00000000000000000000000000000000" then
                    state_next <= idle;
                else
                    if op_reg < std_logic_vector(unsigned(res_reg)+unsigned(one_reg)) then
                        state_next <= calc;
                    else
                        state_next <= s3;
                    end if;
               end if;
           
            when shift =>
                one_next <= "00" & one_reg(WIDTH-1 downto 2);
                state_next <= s1;
            
            when calc =>
                op_next <= std_logic_vector(unsigned(op_reg)-(unsigned(res_reg)+unsigned(one_reg)));
                temp <= std_logic_vector(unsigned(res_reg)+unsigned(one_reg(WIDTH-2 downto 0) & "0"));
                temp <= "0" & temp(WIDTH downto 1);
                res_next <= temp(WIDTH downto 1);
                one_next <= "00" & one_reg(WIDTH-1 downto 2);
                state_next <= s2;
            
            when s3 =>
                res_next <= "0" & res_reg(WIDTH-1 downto 1);
                one_next <= "00" & one_reg(WIDTH-1 downto 2);
                state_next <= s2;
                
            end case;
    end process;
    
    
    -- izlaz
    res_out <= res_reg;
    
    

end Behavioral;
