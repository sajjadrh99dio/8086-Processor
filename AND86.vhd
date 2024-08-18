library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AND86 is
   port
   (
      A, B 					: in std_logic_vector(15 downto 0);
		AByte, BByte 		: in std_logic_vector(7 downto 0);
		ByteControl			: in std_logic; 
		C						: out std_logic_vector(15 downto 0);
      Zout, Sout, Pout 	: out std_logic
   );
end entity AND86;
  
architecture Behavioral of AND86 is
   signal tmp , word: std_logic_vector(15 downto 0); 
begin 
	word(7 downto 0) <= AByte and BByte;
	word(15 downto 8) <= "00000000";
	with ByteControl select
		tmp <= A AND B when '0',
				 word when '1',
				 word when others;
	Pout <= NOT(tmp(15) XOR tmp(14) XOR tmp(13) XOR tmp(12) XOR tmp(11) XOR tmp(10) XOR tmp(9) XOR tmp(8) XOR tmp(7) XOR tmp(6) XOR tmp(5) XOR tmp(4) XOR tmp(3) XOR tmp(2) XOR tmp(1) XOR tmp(0));
	Zout <= NOT(tmp(15) OR tmp(14) OR tmp(13) OR tmp(12) OR tmp(11) OR tmp(10) OR tmp(9) OR tmp(8) OR tmp(7) OR tmp(6) OR tmp(5) OR tmp(4) OR tmp(3) OR tmp(2) OR tmp(1) OR tmp(0));
	Sout <= tmp(15);
	C <= tmp;
end Behavioral;