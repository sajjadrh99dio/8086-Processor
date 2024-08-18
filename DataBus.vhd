
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DataBus IS PORT(
	 InControl 							: in std_LOGIC_VECTOR(2 downto 0);
    TemporalReg1, TemporalReg2 	: in std_LOGIC_VECTOR(15 downto 0);
	 GeneralReg							: in std_LOGIC_VECTOR(15 downto 0);
	 ALU, Flags							: in std_LOGIC_VECTOR(15 downto 0);
	 IMMDIATE_DATA						: in std_LOGIC_VECTOR(7 downto 0);
	 SGeneral							: out std_LOGIC_VECTOR(15 downto 0);
	 STemp1, STemp2					: out std_LOGIC_VECTOR(15 downto 0);
	 SBRegisters						: out std_LOGIC_VECTOR(15 downto 0)
);
END DataBus;

ARCHITECTURE behavioral OF DataBus IS

Signal inp: std_LOGIC_VECTOR(15 downto 0);

begin

	with InControl select
		inp	<=	TemporalReg1 	when "000",
						TemporalReg2 	when "001",
						ALU 				when "010",
						Flags 			when "011",
						("00000000" & IMMDIATE_DATA)	when "100",
						GeneralReg 		when others;
	SGeneral		<=	inp;
	SBRegisters <= inp;
					  
	with InControl select
		STemp1	<=	"00000000"&inp(7 downto 0)	when "101",
						inp 									when others;
	with InControl select
		STemp2	<=	"00000000"&inp(15 downto 8)	when "101",
						inp 									when others;
					  
end behavioral;



