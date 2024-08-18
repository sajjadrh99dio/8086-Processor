library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all ;

entity AAS86 is
	port(
		AF, clk: in std_logic;
		AL, AH: in std_logic_vector(7 downto 0);
		OutputAF, OutputCF: out std_logic;
		OutputAL, OutputAH:  out std_logic_vector(7 downto 0)
	);
	end AAS86;
	
architecture behavioral of AAS86 is
Signal number: std_logic_vector(3 downto 0);
begin
	number <= AL(3 downto 0);
	process(clk)
	begin
		if ((number > 9) or (AF = '1')) then
			OutputAL <= AL - 6 ;
			OutputAH <= AH - 1;
			OutputAF <= '1';
			OutputCF <= '1';
			
		else 
			OutputAF <= '0';
			OutputCF <= '0';
			OutputAL(3 downto 0) <= AL(3 downto 0);
			OutputAH <= AH;
			
		end if;
		OutputAL(7 downto 4) <= "0000";
	end process;
end behavioral;