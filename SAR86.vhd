library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SAR86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end entity SAR86;
  
architecture Behavioral of SAR86 is
signal tmp, tmp1, tmp2 : std_logic_vector(15 downto 0);
signal tmpOF : std_logic;
begin
	with Count select  
	tmp1 			<=	Source													when "0000000000000000",
						'1'						&Source(15 downto 1) 	when "0000000000000001",
						"11"						&Source(15 downto 2) 	when "0000000000000010",
						"111"						&Source(15 downto 3) 	when "0000000000000011",
						"1111"					&Source(15 downto 4)	 	when "0000000000000100",
						"11111"					&Source(15 downto 5) 	when "0000000000000101",
						"111111"					&Source(15 downto 6) 	when "0000000000000110",
						"1111111"				&Source(15 downto 7) 	when "0000000000000111",
						"11111111"				&Source(15 downto 8) 	when "0000000000001000",
						"111111111"				&Source(15 downto 9) 	when "0000000000001001",
						"1111111111"			&Source(15 downto 10) 	when "0000000000001010",
						"11111111111"			&Source(15 downto 11) 	when "0000000000001011",
						"111111111111"			&Source(15 downto 12)	when "0000000000001100",
						"1111111111111"		&Source(15 downto 13)	when "0000000000001101",
						"11111111111111"		&Source(15 downto 14) 	when "0000000000001110",
						"111111111111111"		&Source(15)			 		when "0000000000001111",
						"1111111111111111" 									when others;
	with Count select  
	tmp2 			<=	Source													when "0000000000000000",
						'0'						&Source(15 downto 1) 	when "0000000000000001",
						"00"						&Source(15 downto 2) 	when "0000000000000010",
						"000"						&Source(15 downto 3) 	when "0000000000000011",
						"0000"					&Source(15 downto 4)	 	when "0000000000000100",
						"00000"					&Source(15 downto 5) 	when "0000000000000101",
						"000000"					&Source(15 downto 6) 	when "0000000000000110",
						"0000000"				&Source(15 downto 7) 	when "0000000000000111",
						"00000000"				&Source(15 downto 8) 	when "0000000000001000",
						"000000000"				&Source(15 downto 9) 	when "0000000000001001",
						"0000000000"			&Source(15 downto 10) 	when "0000000000001010",
						"00000000000"			&Source(15 downto 11) 	when "0000000000001011",
						"000000000000"			&Source(15 downto 12)	when "0000000000001100",
						"0000000000000"		&Source(15 downto 13)	when "0000000000001101",
						"00000000000000"		&Source(15 downto 14) 	when "0000000000001110",
						"000000000000000"		&Source(15)			 		when "0000000000001111",
						"0000000000000000" 									when others;
	process(tmp)
	begin 
		IF SOURCE(15) = '1' THEN
			tmp <= tmp1;
		ELSE
			tmp <= tmp2;
		END IF;
		IF tmp(15) = SOURCE(15) THEN
			tmpOF <= '0';
		ELSE
			tmpOF <= tmpOF;
		END IF;
		OFOut <= tmpOF;
		Destination <= tmp;
	end process;
end Behavioral;