library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;
USE ieee.std_logic_unsigned.all ;
USE IEEE.NUMERIC_STD.ALL;

entity IDIV86 is
	port(
		clk: in std_logic;
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		Output1, Output2:  out std_logic_vector(15 downto 0)
	);
	end IDIV86;
	
architecture behavioral of IDIV86 is
	signal S, Resto :std_logic_vector(15 downto 0);
	signal A1, B1, A1Byte, B1Byte, S1Byte ,S2Byte, S1Word, S2Word: std_LOGIC_VECTOR(31 downto 0);
	Signal AL, AH: std_logic_vector(7 downto 0);
	Signal ALLow, ALHigh : std_logic_vector(3 downto 0);
	Signal S1,OutputR1, OutputR1Byte: std_logic_vector(15 downto 0);

	begin
		process(clk)
			begin 
				A1(15 downto 0) <= A;
				B1(15 downto 0) <= B;
				if A(15) = '1' then
					A1(31 downto 16)<= "1111111111111111";
				else
					A1(31 downto 16)<= "0000000000000000";
				end if;
				if B(15) = '1' then
					B1(31 downto 16)<= "1111111111111111";
				else 
					B1(31 downto 16)<= "0000000000000000";
					
				end if;
				
				if AByte(7) = '1' then
					A1Byte(7 downto 0) <= AByte;
					A1Byte(31 downto 8)<= "111111111111111111111111";
				else 
					A1Byte(31 downto 8)<= "000000000000000000000000";
					A1Byte(7 downto 0) <= AByte;
				end if;
				
				if BByte(7) = '1' then
					B1Byte(7 downto 0) <= BByte;
					B1Byte(31 downto 8)<= "111111111111111111111111";
				else 
					B1Byte(31 downto 8)<= "000000000000000000000000";
					B1Byte(7 downto 0) <= BByte;
				end if;
		end process;
		
		S1Word <= std_logic_vector(to_signed(to_integer(signed(A1) / signed(B1)),32));
		S2Word <= std_logic_vector(to_signed(to_integer(signed(A1) mod signed(B1)),32));
		AH <= S2Word(7 downto 0);
		AL <= S1Word(7 downto 0);
		OutputR1(7 downto 0) <= AL;
		OutputR1(15 downto 8) <= AH;
		
		S1Byte <= std_logic_vector(to_signed(to_integer(signed(A1Byte) / signed(B1Byte)),32));
		S2Byte <= std_logic_vector(to_signed(to_integer(signed(A1Byte) mod signed(B1Byte)),32));
		ALHigh <= S2Byte(3 downto 0);
		ALLow <= S1Byte(3 downto 0);
		OutputR1Byte(3 downto 0) <= ALLow;
		OutputR1Byte(7 downto 4) <= ALHigh;
		OutputR1Byte(15 downto  8) <= "00000000";
		
		with ByteControl select S1
			<= OutputR1 when '0',
				OutputR1Byte when '1',
		      OutputR1 when others;
				
				
		Output1 <= S1(15 downto 0);
		Output2 <= "0000000000000000";
		
end behavioral;


