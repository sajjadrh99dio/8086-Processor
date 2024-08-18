



------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;

ENTITY TB IS
END ENTITY TB;

ARCHITECTURE test OF TB IS

	SIGNAL clock : STD_LOGIC := '0';
	SIGNAL reset : STD_LOGIC;
	SIGNAL wDEBUG: STD_LOGIC;
	SIGNAL inpAX, inpBX, inpCX, inpDX, inpSP, inpBP, inpDI, inpSI	: std_logic_vector(15 downto 0);
	SIGNAL inpCS, inpDS, inpSS, inpES, inpIP, inpI1, inpI2, inpI3	:  std_logic_vector(15 downto 0);
	SIGNAL OutputAX, OutputBX, OutputCX, OutputDX, OutputSP, OutputBP, OutputDI, OutputSI						:  std_logic_vector(15 downto 0);
	SIGNAL OutputCS, OutputDS, OutputSS, OutputES, OutputIP, OutputI1, OutputI2, OutputI3						:  std_logic_vector(15 downto 0);
	SIGNAL SFROut																											:  std_logic_vector(15 downto 0);

	--TYPE data_mem IS ARRAY (0 TO 65536) OF STD_LOGIC_VECTOR(7 DOWNTO 0);

	--alias dataBusrep : BIT_VECTOR (7 DOWNTO 0) is .TB.intel_TOP_Circuit.intel_UNIT.dataBus (7 DOWNTO 0) ;
       -- SIGNAL addrBusrep : .TB.PUNEH_TOP_Circuit.intel_UNIT.addrBus : STD_LOGIC_VECTOR (15 DOWNTO 0) ;
	--alias mem : signal is <<.TB.intel_TOP_Circuit.MEMORY_UNIT.dataMEM : data_mem >> ;

BEGIN	
	clock <= NOT clock AFTER 1 NS WHEN NOW <= 2000 NS ELSE '0';
	reset <= '0', '1' AFTER 2 NS;
	--wDEBUG <= '1','0' AFTER 9 NS;
	--inpAX <= "0000000000000010" AFTER 2 NS;
	--inpBX <= "0000000000000101" AFTER 2 NS;
	inpDX <= "0000000000010000" AFTER 2 NS;
	inpSI <= "0000000000000000" AFTER 2 NS;
	inpCS <= "0000000000000000" AFTER 2 NS;
	inpIP <= "0000000000000000" AFTER 2 NS;
	
	intel_UNIT :  ENTITY WORK.Processor_8086 
                                PORT MAP(clock, reset, wDEBUG,
                                 inpAX, inpBX, inpCX, inpDX, inpSP, inpBP, inpDI, inpSI,
                                 inpCS, inpDS, inpSS, inpES, inpIP, inpI1, inpI2, inpI3,
											OutputAX, OutputBX, OutputCX, OutputDX, OutputSP, OutputBP, OutputDI, OutputSI,
											OutputCS, OutputDS, OutputSS, OutputES, OutputIP, OutputI1, OutputI2, OutputI3,
											SFROut);
		
END ARCHITECTURE test;


