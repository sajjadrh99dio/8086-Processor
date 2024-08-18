library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;
USE IEEE.NUMERIC_STD.ALL;

entity AAD86 is
	port(
		clk: in std_logic;
		AL, AH: in std_logic_vector(7 downto 0);
		OutputZF, OutputSF, OutputPF: out std_logic;
		OutputAL, OutputAH:  out std_logic_vector(7 downto 0)
	);
	end AAD86;
	
architecture behavioral of AAD86 is
Signal number: std_logic_vector(3 downto 0);
Signal S : std_logic_vector(15 downto 0);
Signal Output1, Output2 : std_logic_vector(7 downto 0);
Signal Output16 : std_logic_vector(15 downto 0);
begin
	

	process(clk)
	begin
	
		Output1 <= "00000000";
		Output16 <= (AH * "00001010") + AL;
		Output2 <= Output16(7 downto 0);
		S(15 downto 8) <= Output1;
		S(7 downto 0) <= Output2;
		
		OutputAH <= Output1;
		OutputAL <= Output2;
		OutputZF <= '0';
		OutputSF <= '0';
		OutputPF <= not(S(0) xor S(1) xor S(2) xor S(3) xor S(4) xor S(5) xor S(6) xor S(7) xor S(8)xor S(9)xor S(10)xor S(11)xor S(12)xor S(13)xor S(14)xor S(15));
		
			if(S = 0) then
				OutputZF <= '1';
			end if;
			
			if S(15) = '1' then
				OutputSF <= '1';
			end if;
	end process;
end behavioral;


		