library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all ;

entity DAS86 is
	port(
		AF, CF, clk: in std_logic;
		AL: in std_logic_vector(7 downto 0);
		SaidaCF, SaidaZF, SaidaSF, SaidaPF, SaidaAF: out std_logic;
		SaidaAL:  out std_logic_vector(7 downto 0)
	);
	end DAS86;
	
architecture comportamento of DAS86 is
Signal numero: std_logic_vector(3 downto 0);
Signal SaidaTemp: std_logic_vector(7 downto 0);
Signal S1Temp, ALow, S2Temp, AHigh: std_logic_vector(4 downto 0);
begin
	numero <= AL(3 downto 0);
	process(clk)
	begin
		if ((numero > 9) or (AF = '1')) then
			ALow(3 downto 0) <= AL(3 downto 0);
			ALow(4) <= '0';
			S1Temp <= ALow - 6 ;
			SaidaAL(3 downto 0) <= S1Temp(3 downto 0);
			SaidaAF <= '1';
			SaidaCF <= '1';
			
		else 
			SaidaAF <= '0';
			SaidaCF <= '0';
			SaidaAL(3 downto 0) <= AL(3 downto 0);
			SaidaTemp(3 downto 0)<= AL(3 downto 0);
			S1temp(4) <= '0';

		end if;
		
		if (AL > 159) or (CF = '1') then
			AHigh(3 downto 0) <= AL(7 downto 4);
			AHigh(4) <= '0';
			S2Temp <= AHigh - 6;
			--SaidaAL <= AL + 140;
			--SaidaTemp <= AL + 140;
			SaidaAL(7 downto 4) <= S2Temp(3 downto 0);
			SaidaCF <= '1';
		else
			SaidaAF <= '0';
			SaidaCF <= '0';
			SaidaAL(7 downto 4) <= AL(7 downto 4) + S1temp(4);
			SaidaTemp(7 downto 4)<= AL(7 downto 4)+ S1temp(4);
			
		end if;
		   SaidaZF <= '0';
			SaidaSF <= '0';
			SaidaPF <= not(AL(0) xor AL(1) xor AL(2) xor AL(3) xor AL(4) xor AL(5) xor AL(6) xor AL(7));
			if(SaidaTemp = 0) then
				SaidaZF <= '1';
			end if;
			
			if SaidaTemp(7) = '1' then
				SaidaSF <= '1';
			end if;

		
	end process;
end comportamento;


