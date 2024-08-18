library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity SAHF86 is
	port(
		SF, ZF, AF, PF, CF: out std_logic;
		--7 6 4 2 0
		AH: in std_logic_vector(7 downto 0)
	);
	end SAHF86;
	 
architecture behavioral of SAHF86 is

	begin
		CF<= AH(0);
		PF<= AH(2) ; 
		AF<= AH(4);	 
		ZF <= AH(6);
		SF<= AH(7)  ;

end behavioral;