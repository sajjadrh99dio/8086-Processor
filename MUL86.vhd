library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity MUL86 is
	port(
		clk: in std_logic;
		A, B: in std_logic_vector(15 downto 0);
		carryS, Overflow: out std_logic;
		Output1, Output2:  out std_logic_vector(15 downto 0)
	);
	end MUL86;
	 
architecture behavioral of MUL86 is
	signal S :std_logic_vector(31 downto 0);
	signal X1, X2 , Y :std_logic_vector(7 downto 0);

	begin
		process(clk)
		begin
			S <= A * B;
			Overflow <= '1';
			CarryS <='1';
			if(S(31 downto 16)= 0) then
				overflow <= '0';
				CarryS <= '0';
			end if;
		end process;
		Output1 <= S(31 downto 16);
		Output2 <= S(15 downto 0);
end behavioral;