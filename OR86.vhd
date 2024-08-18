library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity OR86 is
port (
		A, B : in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		S: out std_logic_vector(15 downto 0)

);
end OR86;
	
architecture behavioral of OR86 is
Signal SByte : std_logic_vector(15 downto 0);

begin

	SByte(7 downto 0) <= AByte or BByte;
	SByte(15 downto 8) <= "00000000";
	with ByteControl select S 
		<= A or B when '0',
		  SByte when '1',
		  (others =>'X') when others;
end behavioral; 