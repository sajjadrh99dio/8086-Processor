library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all ;

entity DAA86 is
	port(
		AF, CF, clk: in std_logic;
		AL: in std_logic_vector(7 downto 0);
		OutputCF, OutputZF, OutputSF, OutputPF, OutputAF: out std_logic;
		OutputAL:  out std_logic_vector(7 downto 0)
	);
	end DAA86;
	
architecture behavioral of DAA86 is
Signal numero: std_logic_vector(3 downto 0);
Signal OutputTemp: std_logic_vector(7 downto 0);
Signal S1Temp, ALow, S2Temp, AHigh: std_logic_vector(4 downto 0);
begin
	numero <= AL(3 downto 0);
	process(clk)
	begin
		if ((numero > 9) or (AF = '1')) then
			ALow(3 downto 0) <= AL(3 downto 0);
			ALow(4) <= '0';
			S1Temp <= ALow + 6 ;
			OutputAL(3 downto 0) <= S1Temp(3 downto 0);
			OutputAF <= '1';
			OutputCF <= '1';
			
		else 
			OutputAF <= '0';
			OutputCF <= '0';
			OutputAL(3 downto 0) <= AL(3 downto 0);
			OutputTemp(3 downto 0)<= AL(3 downto 0);
			S1temp(4) <= '0';

		end if;
		
		if (AL > 159) or (CF = '1') then
			AHigh(3 downto 0) <= AL(7 downto 4);
			AHigh(4) <= '0';
			S2Temp <= AHigh + 6;
			--OutputAL <= AL + 140;
			--OutputTemp <= AL + 140;
			OutputAL(7 downto 4) <= S2Temp(3 downto 0);
			OutputCF <= '1';
		else
			OutputAF <= '0';
			OutputCF <= '0';
			OutputAL(7 downto 4) <= AL(7 downto 4) + S1temp(4);
			OutputTemp(7 downto 4)<= AL(7 downto 4)+ S1temp(4);
			
		end if;
		   OutputZF <= '0';
			OutputSF <= '0';
			OutputPF <= not(AL(0) xor AL(1) xor AL(2) xor AL(3) xor AL(4) xor AL(5) xor AL(6) xor AL(7));
			if(OutputTemp = 0) then
				OutputZF <= '1';
			end if;
			
			if OutputTemp(7) = '1' then
				OutputSF <= '1';
			end if;

		
	end process;
end behavioral;


