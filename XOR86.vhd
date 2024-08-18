library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity XOR86 is 
port(
	A, B : in std_logic_vector(15 downto 0);
	ByteControl : in std_logic;
	Abyte, BByte: in std_logic_vector(7 downto 0);
	S: out std_logic_vector(15 downto 0)
);
end XOR86;
 
architecture behavioral of XOR86 is
Signal SByte : std_logic_vector(15 downto 0);

begin

	SByte(7 downto 0) <= AByte xor BByte;
	SByte(15 downto 8) <= "00000000";
	with ByteControl select S 
		<= A xor B when '0',
		  SByte when '1',
			(others =>'X')    when others;
	end behavioral;