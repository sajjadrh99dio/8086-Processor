library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity NOT86 is 
port(
	A : in std_logic_vector(15 downto 0);
	AByte 		: in std_logic_vector(7 downto 0);
	ByteControl			: in std_logic; 
	S: out std_logic_vector(15 downto 0)
);
end NOT86;

architecture behavioral of NOT86 is
	signal word: std_logic_vector(15 downto 0); 
	begin	
		word(7 downto 0) <= not AByte;
		word(15 downto 8) <= "00000000";
		with ByteControl select
		S<= not A when '0',
			word when '1',
		  (others =>'X') when others;
			
	end behavioral; 