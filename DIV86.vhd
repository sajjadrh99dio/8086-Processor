library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;
USE ieee.std_logic_unsigned.all ;
USE IEEE.NUMERIC_STD.ALL;

entity DIV86 is
	port(
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		Output1, Output2:  out std_logic_vector(15 downto 0)
	);
	end DIV86;
	
architecture behavioral of DIV86 is
	signal S, Resto :std_logic_vector(15 downto 0);
	signal A1, B1, A1Byte, B1Byte, S1Byte ,S2Byte, S1Word, S2Word: std_LOGIC_VECTOR(31 downto 0);
	Signal AL, AH: std_logic_vector(7 downto 0);
	Signal ALLow, ALHigh : std_logic_vector(3 downto 0);
	Signal S1,OutputR1, OutputR1Byte: std_logic_vector(15 downto 0);

	begin
	
		A1(15 downto 0) <= A;
		B1(15 downto 0) <= B;
		A1(31 downto 16)<= "0000000000000000";
		B1(31 downto 16)<= "0000000000000000";
		
		A1Byte(7 downto 0) <= AByte;
		B1Byte(7 downto 0) <= BByte;
		A1Byte(31 downto 8)<= "000000000000000000000000";
		B1Byte(31 downto 8)<= "000000000000000000000000";
		
		S1Word <= std_logic_vector(to_signed(to_integer(signed(A1) / signed(B1)),32));
		S2Word <= std_logic_vector(to_signed(to_integer(signed(A1) mod signed(B1)),32));
		AH <= S2Word(7 downto 0);
		AL <= S1Word(7 downto 0);
		OutputR1(7 downto 0) <= AL;
		OutputR1(15 downto 8) <= AH;
		
		S1Byte <= std_logic_vector(to_signed(to_integer(signed(A1Byte) / signed(B1Byte)),32));
		S2Byte <= std_logic_vector(to_signed(to_integer(signed(A1Byte) mod signed(B1Byte)),32));
		ALHigh <= S2Byte(7 downto 4);
		ALLow <= S1Byte(3 downto 0);
		OutputR1Byte(3 downto 0) <= ALLow;
		OutputR1Byte(7 downto 4) <= ALHigh;
		OutputR1Byte(15 downto  8) <= "00000000";
		
		with ByteControl select S1
			<= OutputR1 when '1',
				OutputR1Byte when '0',
		      OutputR1 when others;
				
				
		Output1 <= S1(15 downto 0);
		Output2 <= "0000000000000000";
		
end behavioral;
