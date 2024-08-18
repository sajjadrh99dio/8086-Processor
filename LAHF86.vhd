library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity LAHF86 is
	port(
		SF, ZF, AF, PF, CF: in std_logic;
		--7 6 4 2 0
		AH: in std_logic_vector(7 downto 0);
		Output:  out std_logic_vector(7 downto 0)
	);
	end LAHF86;
	
architecture behavioral of LAHF86 is
	signal S :std_logic_vector(31 downto 0);
	signal X1, X2 , Y :std_logic_vector(7 downto 0);

	begin
		Output(0) <= CF;
		Output(1) <= AH(1);
		Output(2) <= PF;
		Output(3) <= AH(3);
		Output(4) <= AF;
		Output(5) <= AH(5);
		Output(6) <= ZF;
		Output(7) <= SF;

end behavioral;