library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity CLC86 is
	port(
		CF: inout std_logic

	);
	end CLC86;
	
architecture comportamento of CLC86 is
begin
	CF <= '0'; 

end comportamento;