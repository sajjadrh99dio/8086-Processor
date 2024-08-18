library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity ROR86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end entity ROR86;
  
architecture Behavioral of ROR86 is
signal tmp	 : std_logic_vector(15 downto 0);
signal tmpCount : std_logic_vector(15 downto 0);
signal tmpOF : std_logic;
begin
	tmpCount <= "000000000000"&Count(3 downto 0);
	with tmpCount select  
	tmp 			<=	Source													when "0000000000000000",
						Source(0)				&Source(15 downto 1) 	when "0000000000000001",
						Source(1 downto 0)	&Source(15 downto 2) 	when "0000000000000010",
						Source(2 downto 0)	&Source(15 downto 3) 	when "0000000000000011",
						Source(3 downto 0)	&Source(15 downto 4)	 	when "0000000000000100",
						Source(4 downto 0)	&Source(15 downto 5) 	when "0000000000000101",
						Source(5 downto 0)	&Source(15 downto 6) 	when "0000000000000110",
						Source(6 downto 0)	&Source(15 downto 7) 	when "0000000000000111",
						Source(7 downto 0)	&Source(15 downto 8) 	when "0000000000001000",
						Source(8 downto 0)	&Source(15 downto 9) 	when "0000000000001001",
						Source(9 downto 0)	&Source(15 downto 10) 	when "0000000000001010",
						Source(10 downto 0)	&Source(15 downto 11) 	when "0000000000001011",
						Source(11 downto 0)	&Source(15 downto 12)	when "0000000000001100",
						Source(12 downto 0)	&Source(15 downto 13)	when "0000000000001101",
						Source(13 downto 0)	&Source(15 downto 14) 	when "0000000000001110",
						Source(14 downto 0)	&Source(15)			 		when "0000000000001111",
						Source													when others;
	process(tmp)
	begin 
		IF tmp(15) = SOURCE(15) THEN
			tmpOF <= '0';
		ELSE
			tmpOF <= tmpOF;
		END IF;
		OFOut <= tmpOF;
		Destination <= tmp;
	end process;
end Behavioral;