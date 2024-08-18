LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.Numeric_Std.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

ENTITY MemoryController IS PORT(
	 read_write_control : in std_logic;
	 inpData1: in std_LOGIC_VECTOR(7 downto 0);
	 inpData2: in std_LOGIC_VECTOR(7 downto 0);
	 inpAddress: in std_LOGIC_VECTOR(19 downto 0);
    clk, reset: IN STD_LOGIC;
	 QueueFull : in std_LOGIC;
	 WriteQueue : out std_LOGIC;
	 IncrementPC : out std_Logic;
	 controlBIURegister1, controlBIURegister2 : out std_logic_vector(2 downto 0);
	 OutputQueue: out std_LOGIC_VECTOR(7 downto 0);
	 OutputRegs: out std_LOGIC_VECTOR(15 downto 0);
	 ForceSI,ForceDX	 : IN std_LOGIC_VECTOR(15 downto 0)

	 
);
END MemoryController;


ARCHITECTURE behavioral OF MemoryController IS

signal addr : std_logic_vector(7 downto 0);
signal Smemory, data :std_logic_vector(7 downto 0);
signal w: std_LOGIC;


   TYPE ram_type IS ARRAY (0 TO 300) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL ram : ram_type;
	SIGNAL read_write_control_registered : std_logic := '0';
	SIGNAL dataStoreCounter : std_logic_vector(19 downto 0):= (others=>'0');


begin



	process (clk) IS
	variable data_segment : std_logic_vector (19 downto 0);
	begin
		if(clk'EVENT and clk='1') then
			read_write_control_registered<=read_write_control;
			if(read_write_control_registered = '1' and read_write_control ='0' ) then
				data_segment := (ForceDX&"0000") + ("0000"&ForceSI);
				ram(to_integer(unsigned(data_segment+dataStoreCounter))) <=inpData1;
				ram(to_integer(unsigned(data_segment+dataStoreCounter+1))) <=inpData2;
				dataStoreCounter<=dataStoreCounter+"00000000000000000010";
			else
			
			
--------------------------INST FOR MOVEI			
--				ram(0) <=  "11000111";
--				ram(1) <=  "11011011";
--				ram(2) <=  "00010000";
--				ram(3) <=  "11111111"; -- dummy for test
--				ram(4) <=  "11111110";
--				ram(5) <=  "11111100";
--				ram(6) <=  "00000000";
--				ram(7) <=  "00000000";
--				ram(8) <=  "00000000";
--				ram(9) <=  "00000000";
--				ram(10) <= "00000000";
--				ram(11) <= "00000000";
--				ram(12) <= "00000000";
--				ram(13) <= "00000000";	
--				ram(14) <= "00000000";					
------------------------INST FOR MULT
--				ram(0) <=  "00001011";
--				ram(1) <=  "00000001";
--				ram(2) <=  "00010000";
--				ram(3) <=  "11111111"; -- dummy for test
--				ram(4) <=  "00010000";
--				ram(5) <=  "00010000";
--				ram(6) <=  "00000000";
--				ram(7) <=  "00000000";
--				ram(8) <=  "00000000";
--				ram(9) <=  "00000000";
--				ram(10) <= "00000000";
--				ram(11) <= "00000000";
--				ram(12) <= "00000000";
--				ram(13) <= "00000000";	
--				ram(14) <= "00000000";
--------------------INST FOR MOVE
--				ram(0) <=  "10010000";
--				ram(2) <=  "11111111"; -- dummy for test
--				ram(3) <=  "11111110";
--				ram(4) <=  "11111100";
--				ram(5) <=  "11111000";
--				ram(6) <=  "00000000";
--				ram(7) <=  "00000000";
--				ram(8) <=  "00000000";
--				ram(9) <=  "00000000";
--				ram(10) <= "00000000";
--				ram(11) <= "00000000";
--				ram(12) <= "00000000";
--				ram(13) <= "00000000";	
--				ram(14) <= "00000000";
--------------------INST FOR ADD
--				ram(0) <=  "00000010";
--				ram(1) <=  "00000001";
--				ram(2) <=  "00010000";
--				ram(3) <=  "00000010";
--				ram(4) <=  "00000001";
--				ram(5) <=  "00010000";
--				ram(6) <=  "00000010";
--				ram(7) <=  "00000001";
--				ram(8) <=  "00010000";
--				ram(6) <=  "00000010";
--				ram(7) <=  "00000001";
--				ram(8) <=  "00010000";
--				ram(9) <=  "11111111";
--				ram(10)<=  "11111110";
--				ram(11)<=  "11111100";
--------------------INST FOR MOVE AND MULT
--				ram(0) <=  "11000111"; -- MOVE IMMD AX
--				ram(1) <=  "00000010";
--				ram(2) <=  "00010000";
--				ram(3) <=  "11000111"; -- MOVE IMMD BX
--				ram(4) <=  "00000101";
--				ram(5) <=  "00110010";				
--				ram(6) <=  "00001011"; -- MULT
--				ram(7) <=  "00000001";
--				ram(8) <=  "00010000";
--				ram(9) <=  "11000111"; -- MOVE IMMD CX
--				ram(10) <=  "00111100";
--				ram(11) <=  "01010100";
--				ram(12) <=  "11111110"; -- IDLE 
--				ram(13) <=  "11111100";
--				ram(14) <=  "11111000"; -- dummy 

--------------------INST FOR MOVE AND DEC
--				ram(0) <=  "11000111"; -- MOVE IMMD AX
--				ram(1) <=  "00000010";
--				ram(2) <=  "00010000";
--				
--				ram(3) <=  "11000111"; -- MOVE IMMD CX
--				ram(4) <=  "00000001";
--				ram(5) <=  "01010100";
--				
--				ram(6) <=  "01001000"; -- DEC CX
--				ram(7) <=  "01000010";
--				
--				ram(8) <=  "11000111"; -- MOVE IMMD BX
--				ram(9) <=  "00000010";
--				ram(10) <=  "00110010";
--				
--				ram(11) <=  "11111110"; -- IDLE 
--				ram(12) <=  "11111100";
--				ram(13) <=  "11111000"; -- dummy 
--				ram(14) <=  "11111000"; -- dummy
 
--------------------INST FOR MOVE, DEC and JUMPZ

--				ram(0) <=  "11000111"; -- MOVE IMMD AX
--				ram(1) <=  "00000010";
--				ram(2) <=  "00010000";
--				
--				ram(3) <=  "11000111"; -- MOVE IMMD CX
--				ram(4) <=  "00000001";
--				ram(5) <=  "01010100";
--				
--				ram(6) <=  "01001000"; -- DEC CX
--				ram(7) <=  "01000010";
--				
--				ram(8) <=  "01110100"; -- JZ
--				ram(9) <=  "00000011";	
--				
--				ram(10) <=  "11111110"; -- IDLE 
--				ram(11) <=  "11111100";
--				ram(12) <=  "11111000"; -- dummy 
--				ram(13) <=  "11111000"; -- dummy 

-------------------- FINAL INSTRUCTION

				ram(0) <=  "11000111"; -- MOVE IMMD AX
				ram(1) <=  "00000010";
				ram(2) <=  "00010000";

				ram(3) <=  "11000111"; -- MOVE IMMD BX
				ram(4) <=  "00000010";
				ram(5) <=  "00110010";

				ram(6) <=  "11000111"; -- MOVE IMMD CX
				ram(7) <=  "00001010";
				ram(8) <=  "01010100";

				ram(9) <=  "00001011"; -- MULT
				ram(10) <=  "00000001";
				ram(11) <=  "00010000";
				
				ram(12) <=  "01001000"; -- DEC CX
				ram(13) <=  "01000010";
				

				ram(14) <=  "01110100"; -- JZ
				ram(15) <=  "00001001";
	
				ram(16) <=  "11111110"; -- IDLE 



			end if;
		end if;
	end process;
		
	addr<=inpAddress(7 downto 0);			
	OutputQueue <= ram(to_integer(unsigned(addr)));
	IncrementPC <= not QueueFull;
	WriteQueue <= not QueueFull;
	controlBIURegister1 <= "000";
	controlBIURegister2 <= "100";

end behavioral;
