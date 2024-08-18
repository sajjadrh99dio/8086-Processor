library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity MULB86 is
	port(
		clk: in std_logic;
		A, B: in std_logic_vector(7 downto 0);
		carryS, Overflow: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);
	end MULB86;
	 
architecture behavioral of MULB86 is
	signal S :std_logic_vector(15 downto 0);
	--signal X1, X2 , Y :std_logic_vector(7 downto 0);

	begin
		process(clk)
		begin
			S <= A * B;
			Overflow <= '1';
			CarryS <='1';
			if(S(15 downto 8)= 0) then
				overflow <= '0';
				CarryS <= '0';
			end if;
		end process;

		Output <= S(15 downto 0);
end behavioral;