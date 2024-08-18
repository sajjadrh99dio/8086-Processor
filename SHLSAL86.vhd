library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SHLSAL86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end entity SHLSAL86;
  
architecture Behavioral of SHLSAL86 is
signal tmp : std_logic_vector(15 downto 0);
signal tmpOF : std_logic;
begin 
   with Count select  
      tmp 			<= Source												when "0000000000000000",  
							Source(14 downto 0)	&'0' 						when "0000000000000001",
							Source(13 downto 0)	&"00" 					when "0000000000000010",
							Source(12 downto 0)	&"000" 					when "0000000000000011",
							Source(11 downto 0)	&"0000" 					when "0000000000000100",  
							Source(10 downto 0)	&"00000" 				when "0000000000000101",
							Source(9 downto 0)	&"000000" 				when "0000000000000110",
							Source(8 downto 0)	&"0000000" 				when "0000000000000111",
							Source(7 downto 0)	&"00000000" 			when "0000000000001000",  
							Source(6 downto 0)	&"000000000" 			when "0000000000001001",
							Source(5 downto 0)	&"0000000000" 			when "0000000000001010",
							Source(4 downto 0)	&"00000000000" 		when "0000000000001011",
							Source(3 downto 0)	&"000000000000" 		when "0000000000001100",  
							Source(2 downto 0)	&"0000000000000" 		when "0000000000001101",
							Source(1 downto 0)	&"00000000000000" 	when "0000000000001110",
							Source(0)				&"000000000000000" 	when "0000000000001111",		
							"0000000000000000" 								when others;
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