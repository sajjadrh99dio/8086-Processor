library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
 
entity Controller is
PORT(
			 reset 													: in std_logic;
			 clk     												: in std_logic;
			 QueueEmpty												: in std_logic;
			 inpInstruction 										: in  std_logic_vector(7 downto 0);
			 Instruction_regged 									: out  std_logic_vector(7 downto 0);
			 inpGPR1, inpGPR2, OutputGPR1, OutputGPR2		: out std_logic_vector(3 downto 0);
			 QueueRead												: out std_logic;
			 WriteGPR1, WriteGPR2 								: out std_logic;
			 OutputDataBUS											: out std_logic_vector(2 downto 0);
			 WriteRT1, WriteRT2 									: out std_logic;
			 WFlag													: out std_logic;
			 OPALU													: out std_logic_vector(7 downto 0);
			 OutputBR1									         : out std_logic_vector(2 downto 0);
			 read_write_control 									: out std_logic;
			 FLAG_REG 												: in std_logic_vector(15 downto 0);
			 JUMP_SIGNAL											: out std_logic;
			 JUMP_ADDR												: out std_logic_vector (7 downto 0)
			 );
end Controller;
 
architecture description of Controller is
	TYPE State_type1 IS (fetch, Arith1, Arith2, exe, response, final, IDLE);
	TYPE State_type2 IS (arithmetic, move_r,move_i,INC_DEC,JNZ,JZ,JMP,Status);
	SIGNAL state : State_Type1;
	SIGNAL sub_state : State_Type2;
	signal destination1,destination2 : std_logic_vector(3 downto 0);
	signal RealInstruction : std_logic_vector(7 downto 0);
	signal memory_wb : std_logic;
-- sub add control
-- 8 bit instructions


begin
 
	State_CONTROL : process (clk, reset) is
	variable CurrentInstruction, instruction : std_logic_vector(7 downto 0);
	variable sourceDestination : std_logic_vector(3 downto 0);
		begin
		if (reset = '0') then
			OutputDataBUS <= "111";
			state <= fetch;
			sub_state<= arithmetic;
			QueueRead <= '0';
			memory_wb <= '0';
			read_write_control <= '0';
			OPALU <= "00000000";
			QueueRead <= '0';
			WriteGPR1 <= '0'; 
			WriteGPR2 <= '0';
			WriteRT1 <= '0';
			WriteRT2 <= '0';
			JUMP_SIGNAL<='0';
			inpGPR1<= "0001";
			inpGPR2<= "0010";
			OutputGPR1 <= "1000";
			OutputGPR2 <= "1001";
			read_write_control <= '0';
		elsif clk'event and clk = '1' then
			case state is
				when fetch =>
					--QueueRead <= '0';
					if(QueueEmpty = '1') then
						state <= fetch;
						sub_state<= arithmetic;
					else
						memory_wb <= '0';
						read_write_control <= '0';
						QueueRead <= '1';
						JUMP_SIGNAL<='0';
						memory_wb <='0';
						instruction := inpInstruction;
						if (instruction = "00000010" ) then --ADD register register 16
							--OutputGPR1 <= "1000";
							CurrentInstruction := inpInstruction;
							RealInstruction <= "00010000";
							memory_wb <= '1';
							WriteRT1 <= '1'; --write register signal for reg temp 1 
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
							
						elsif(instruction = "00100011") then -- AND register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "00011101";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
							
						elsif(instruction = "00000100") then -- OR register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "00011110";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
							
						elsif(instruction = "00000101") then -- SUB register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "10110000";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
						
						elsif(instruction = "00000110") then -- XOR register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "00011100";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
							
						elsif(instruction = "00000111") then -- ADC register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "00010001";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
							
						elsif(instruction = "00001000") then -- NOT register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "00011010";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '0'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
							
						elsif(instruction = "10010001") then -- SUBC register register 16
							CurrentInstruction := inpInstruction;
							RealInstruction <= "10010001";
							memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;

						elsif(instruction = "10000001") then -- DIV
								CurrentInstruction := inpInstruction;
								RealInstruction <= "00010011";
								memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
							end if;
							
						elsif(instruction = "10010000") then -- move_r
								CurrentInstruction := inpInstruction;
								RealInstruction <= "10010000";
								memory_wb <= '0';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '0'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= move_r;
							end if;
						elsif(instruction = "11111111") then -- NOP
							--QueueRead <= '0';
							state <= fetch;
							sub_state<= arithmetic;
						
						elsif(instruction = "00001011") then -- MULT
								CurrentInstruction := inpInstruction;
								RealInstruction <= "00010111";
								memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '1'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;
						
						elsif(instruction = "01001000") then -- DEC
								CurrentInstruction := inpInstruction;
								RealInstruction <= "00010010";
								memory_wb <= '0';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '0'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= INC_DEC;
						end if;
						
						
						elsif(instruction = "10000010") then -- DIVI
							 	CurrentInstruction := inpInstruction;
								 RealInstruction <= "00010100";
								 memory_wb <= '1';
							if(QueueEmpty = '1') then
								state <= fetch;
								sub_state<= arithmetic;
							else
								QueueRead <= '0'; --signal to stop reading instructions from the queue
								state <= Arith1;
								sub_state<= arithmetic;
							end if;

						elsif(instruction = "01000000") then -- INC
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00010101";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= INC_DEC;
								end if;


						elsif(instruction = "10000100") then -- LAHF
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00010110";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;
								

						elsif(instruction = "10000110") then -- Mulb
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00011000";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;
								
						elsif(instruction = "10000111") then -- Neg
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00011001";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;									

								
						elsif(instruction = "10001000") then -- Not
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00011010";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;		
								
						elsif(instruction = "10001001") then -- Sahf
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00011011";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;	

								
						elsif(instruction = "10001010") then -- ROl
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00011111";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;							
														
								
						elsif(instruction = "10001011") then -- Ror
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00100000";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;							
														
								
						elsif(instruction = "10001100") then -- Sar
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00100001";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;							
														
								
						elsif(instruction = "10001101") then -- Shr
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00100011";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;							
														
								
						elsif(instruction = "10001110") then -- Test
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00100100";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;							
														
								
						elsif(instruction = "10001111") then -- Daa
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00100111";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;							
														
								
						elsif(instruction = "10010001") then -- CMP
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00101011";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;
								
							elsif(instruction = "11000111") then -- move_i
									CurrentInstruction := inpInstruction;
									RealInstruction <= "11000111";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= move_i;
								end if;
								
								elsif(instruction = "01110100") then -- JNZ
									CurrentInstruction := inpInstruction;
									RealInstruction <= "01110100";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= JNZ;
								end if;
	
							elsif(instruction = "01110101") then -- JZ
									CurrentInstruction := inpInstruction;
									RealInstruction <= "01110101";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= JZ;
								end if;
								
							elsif(instruction = "01110110") then -- JMP
									CurrentInstruction := inpInstruction;
									RealInstruction <= "01110110";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= JMP;
								end if;			
							elsif(instruction = "00101100") then -- CLC
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00101100";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= Status;
								end if;
								
							elsif(instruction = "00101101") then -- CMC
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00101101";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= Status;
								end if;
								
							elsif(instruction = "00101110") then -- STC
									CurrentInstruction := inpInstruction;
									RealInstruction <= "00101110";
									memory_wb <= '0';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '0'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= Status;
								end if;
								
							elsif(instruction = "11110000") then -- XCHNG
									CurrentInstruction := inpInstruction;
									RealInstruction <= "11110000";
									memory_wb <= '1';
								if(QueueEmpty = '1') then
									state <= fetch;
									sub_state<= arithmetic;
								else
									QueueRead <= '1'; --signal to stop reading instructions from the queue
									state <= Arith1;
									sub_state<= arithmetic;
								end if;								

														
							
						elsif(instruction = "11111110") then --IDLE
							QueueRead <= '0';
							state <= IDLE;
						end if;
					end if;
					
				when Arith1 =>
					case sub_state is
						when arithmetic =>
							read_write_control <= '0';
								QueueRead <= '0';
								JUMP_SIGNAL<='0';
									if inpInstruction(3 downto 0) = "0000" then
										OutputGPR1 <= "1000"; -- SEL AL 
									elsif inpInstruction(3 downto 0) = "0001" then
										OutputGPR1 <= "1001"; --	SEL BL
									elsif inpInstruction(3 downto 0) = "0010" then
										OutputGPR1 <= "1010"; -- SEL CL
									elsif inpInstruction(3 downto 0) = "0011" then
										OutputGPR1 <= "1011"; -- SEL DL
									elsif inpInstruction(3 downto 0) = "0100" then
										OutputGPR1 <= "0000"; -- SEL AH
									elsif inpInstruction(3 downto 0) = "0101" then
										OutputGPR1 <= "0001";	-- SEL BH
									elsif inpInstruction(3 downto 0) = "0110" then
										OutputGPR1 <= "0010"; -- SEL CH
									elsif inpInstruction(3 downto 0) = "0111" then
										OutputGPR1 <= "0011"; -- SEL DH
									elsif inpInstruction(3 downto 0) = "1000" then
										OutputGPR1 <= "1100"; -- SEL SP
									elsif inpInstruction(3 downto 0) = "1001" then
										OutputGPR1 <= "1101"; -- SEL BP
									elsif inpInstruction(3 downto 0) = "1010" then
										OutputGPR1 <= "1110";	-- SEL SI
									elsif inpInstruction(3 downto 0) = "1011" then
										OutputGPR1 <= "1111"; -- SEL DI
									end if;
					
								if inpInstruction(7 downto 4) = "0000" then
										OutputGPR2 <= "1000"; -- SEL AL 
									elsif inpInstruction(3 downto 0) = "0001" then
										OutputGPR2 <= "1001"; --	SEL BL
									elsif inpInstruction(3 downto 0) = "0010" then
										OutputGPR2 <= "1010"; -- SEL CL
									elsif inpInstruction(3 downto 0) = "0011" then
										OutputGPR2 <= "1011"; -- SEL DL
									elsif inpInstruction(3 downto 0) = "0100" then
										OutputGPR2 <= "0000"; -- SEL AH
									elsif inpInstruction(3 downto 0) = "0101" then
										OutputGPR2 <= "0001";	-- SEL BH
									elsif inpInstruction(3 downto 0) = "0110" then
										OutputGPR2 <= "0010"; -- SEL CH
									elsif inpInstruction(3 downto 0) = "0111" then
										OutputGPR2 <= "0011"; -- SEL DH
									elsif inpInstruction(3 downto 0) = "1000" then
										OutputGPR2 <= "1100"; -- SEL SP
									elsif inpInstruction(3 downto 0) = "1001" then
										OutputGPR2 <= "1101"; -- SEL BP
									elsif inpInstruction(3 downto 0) = "1010" then
										OutputGPR2 <= "1110";	-- SEL SI
									elsif inpInstruction(3 downto 0) = "1011" then
										OutputGPR2 <= "1111"; -- SEL DI
									end if;
								
									OutputDataBUS <= "111";
						
									--destination1 <= inpInstruction(3 downto 0);
									--destination2 <= inpInstruction(7 downto 4);
									WriteRT1 <= '1'; --write register signal for reg temp  1 
									state <= Arith2;
									sub_state <= arithmetic;
									
							when move_r =>
											
									read_write_control <= '0';
									QueueRead <= '0';
									if inpInstruction(3 downto 0) = "0000" then 	   -- MOVE TO AX
										OutputGPR1 <= "1000"; --AL 
										OutputGPR2 <= "0000"; --AH 
									elsif inpInstruction(3 downto 0) = "0001" then  -- MOVE TO BX
										OutputGPR1 <= "1001"; -- BL
										OutputGPR2 <= "0001"; --	BH
									elsif inpInstruction(3 downto 0) = "0010" then	-- MOVE TO CX
										OutputGPR1 <= "1010";	-- CL
										OutputGPR2 <= "0010";	-- CH
									elsif inpInstruction(3 downto 0) = "0011" then	-- MOVE TO DX
										OutputGPR1 <= "1011";	-- DL
										OutputGPR2 <= "0011";	-- DH
									elsif inpInstruction(3 downto 0) = "0100" then
										OutputGPR1 <= "1100";
										OutputGPR2 <= "0100";
									elsif inpInstruction(3 downto 0) = "0101" then
										OutputGPR1 <= "1101";
										OutputGPR2 <= "0101";
									elsif inpInstruction(3 downto 0) = "0110" then
										OutputGPR1 <= "1110";
										OutputGPR2 <= "0110";
									elsif inpInstruction(3 downto 0) = "0111" then
										OutputGPR1 <= "1111";
										OutputGPR2 <= "0111";
									end if;
										
								
									OutputDataBUS <= "111";
									destination1 <= inpInstruction(7 downto 4);
									destination2 <= inpInstruction(7 downto 4) + "0001";
									WriteRT1 <= '1'; --write register signal for reg temp  1 
									state <= Arith2;
									sub_state <= move_r;
						
						
							when move_i =>
								Instruction_regged<=inpInstruction;				
								read_write_control <= '0';
								QueueRead <= '0';
								OutputDataBUS <= "100";
								WriteRT1 <= '1'; --write register signal for reg temp  1 
								state <= Arith2;
								sub_state <= move_i;
								
							when Status =>			
								read_write_control <= '0';
								QueueRead <= '0';
								OutputDataBUS <= "111";
								WriteRT1 <= '1'; 
								state <= Arith2;
								sub_state <= Status;
								
								
							
							when INC_DEC =>
									read_write_control <= '0';
									QueueRead <= '0';
									if inpInstruction(3 downto 0) = "0000" then 	   -- SELECT AX
										OutputGPR1 <= "1000"; --AL 
										OutputGPR2 <= "0000"; --AH 
									elsif inpInstruction(3 downto 0) = "0001" then  -- SELECT BX
										OutputGPR1 <= "1001"; -- BL
										OutputGPR2 <= "0001"; --	BH
									elsif inpInstruction(3 downto 0) = "0010" then	-- SELECT CX
										OutputGPR1 <= "1010";	-- CL
										OutputGPR2 <= "0010";	-- CH
									elsif inpInstruction(3 downto 0) = "0011" then	-- SELECT DX
										OutputGPR1 <= "1011";	-- DL
										OutputGPR2 <= "0011";	-- DH
									elsif inpInstruction(3 downto 0) = "0100" then
										OutputGPR1 <= "1100";
										OutputGPR2 <= "0100";
									elsif inpInstruction(3 downto 0) = "0101" then
										OutputGPR1 <= "1101";
										OutputGPR2 <= "0101";
									elsif inpInstruction(3 downto 0) = "0110" then
										OutputGPR1 <= "1110";
										OutputGPR2 <= "0110";
									elsif inpInstruction(3 downto 0) = "0111" then
										OutputGPR1 <= "1111";
										OutputGPR2 <= "0111";
									end if;
									
									OutputDataBUS <= "111";
									destination1 <= inpInstruction(7 downto 4);
									destination2 <= inpInstruction(7 downto 4) + "0001";
									WriteRT1 <= '1'; --write register signal for reg temp  1 
									state <= Arith2;
									sub_state <= INC_DEC;
									
									
							when JNZ =>
									read_write_control <= '0';
									QueueRead <= '0';
									if(FLAG_REG(6) = '0') then -- ZERO FLAG
										JUMP_SIGNAL<='1';
										JUMP_ADDR<=inpInstruction(7 downto 0);
										state <= Arith2;
										sub_state <= JNZ;
										QueueRead <= '0';
										OutputDataBUS <= "111";
								   end if;
										
							when JZ =>
									read_write_control <= '0';
									QueueRead <= '0';
									if(FLAG_REG(6) = '1') then -- ZERO FLAG
										JUMP_SIGNAL<='1';
										JUMP_ADDR<=inpInstruction(7 downto 0);
										state <= Arith2;
										sub_state <= JZ;
										QueueRead <= '0';
										OutputDataBUS <= "111";
								   end if;
									
							when JMP =>
									read_write_control <= '0';
									QueueRead <= '0';
									JUMP_SIGNAL<='1';
									JUMP_ADDR<=inpInstruction(7 downto 0);
									state <= Arith2;
									sub_state <= JMP;
									QueueRead <= '0';
									OutputDataBUS <= "111";
								   										
									
									
						end case;				
				

							
							
				when Arith2 =>
					   read_write_control <= '0';
						QueueRead <= '0';
						JUMP_SIGNAL<='0';
						if (sub_state = arithmetic) then
									destination1 <= inpInstruction(3 downto 0);
									destination2 <= inpInstruction(7 downto 4);
						elsif (sub_state = move_i) then
									destination1 <= inpInstruction(3 downto 0);
									destination2 <= inpInstruction(7 downto 4);
						end if;
--					if inpInstruction(3 downto 0) = "0000" then
--						OutputGPR1 <= "1000"; --outAH when "0001
--						elsif inpInstruction(3 downto 0) = "0001" then
--						OutputGPR1 <= "1001"; --	 when "1001"
--						elsif inpInstruction(3 downto 0) = "0010" then
--						OutputGPR1 <= "1010";
--						elsif inpInstruction(3 downto 0) = "0011" then
--						OutputGPR1 <= "1011";
--						elsif inpInstruction(3 downto 0) = "0100" then
--						OutputGPR1 <= "1100";
--						elsif inpInstruction(3 downto 0) = "0101" then
--						OutputGPR1 <= "1101";
--						elsif inpInstruction(3 downto 0) = "0110" then
--						OutputGPR1 <= "1110";
--						elsif inpInstruction(3 downto 0) = "0111" then
--						OutputGPR1 <= "1111";
--					end if;
--					
--					if inpInstruction(7 downto 4) = "0000" then
--						OutputGPR2<= "1000";--AX
--						elsif inpInstruction(7 downto 4) = "0001" then
--						OutputGPR2<= "1001";--BX
--						elsif inpInstruction(7 downto 4) = "0010" then
--						OutputGPR2<= "1010";--CX
--						elsif inpInstruction(7 downto 4) = "0011" then
--						OutputGPR2<= "1011";--DX
--						elsif inpInstruction(7 downto 4) = "0100" then
--						OutputGPR2<= "1100";
--						elsif inpInstruction(7 downto 4) = "0101" then
--						OutputGPR2<= "1101";
--						elsif inpInstruction(7 downto 4) = "0110" then
--						OutputGPR2<= "1110";
--						elsif inpInstruction(7 downto 4) = "0111" then
--						OutputGPR2<= "1111";
--					end if;
											
						OutputDataBUS <= "111";
						WriteRT1 <= '0';
						WriteRT2 <= '1'; --write register signal for reg temp  2
						state <= exe;
						
			when exe => --Final part of the instruction 
					read_write_control <= '0';
					QueueRead <= '0';
					OPALU <= RealInstruction;-- passes the instruction to ALU
					WFlag <= '1'; --enable writing to flag register
					--WriteRT2 <= '0';
					state <= response;
					
			when response =>
					read_write_control <= '0';
					if( sub_state = arithmetic or sub_state = move_i or sub_state = move_r or sub_state=INC_DEC) then
						WriteGPR1 <= '1';
						WriteGPR2 <= '1';
					end if;
					QueueRead <= '0';
					if destination1 = "0000" then
							inpGPR1<= "0001";		--SeL AL
							elsif destination1 = "0001" then
							inpGPR1<= "0010";		--SeL AH
							elsif destination1 = "0010" then
							inpGPR1<= "0011";		--SeL BL
							elsif destination1 = "0011" then
							inpGPR1<= "0100";		--SeL BH
							elsif destination1 = "0100" then
							inpGPR1<= "0101";		--SEL CL
							elsif destination1 = "0101" then
							inpGPR1<= "0110";		--SEL CH
							elsif destination1 = "0110" then
							inpGPR1<= "0111";		--SEL DL
							elsif destination1 = "0111" then
							inpGPR1<= "1000";		--SEL DH
						end if;
						
						if destination2 = "0000" then
							inpGPR2<= "0001";	--SeL AL
							elsif destination2 = "0001" then
							inpGPR2<= "0010";	--SeL AH
							elsif destination2 = "0010" then
							inpGPR2<= "0011";	--SeL BL
							elsif destination2 = "0011" then
							inpGPR2<= "0100";	--SeL BH
							elsif destination2 = "0100" then
							inpGPR2<= "0101";	--SeL CL
							elsif destination2 = "0101" then
							inpGPR2<= "0110";	--SeL CH
							elsif destination2 = "0110" then
							inpGPR2<= "0111";	--SeL DL
							elsif destination2 = "0111" then
							inpGPR2<= "1000";	--SeL DH
						end if;
				
				
					OutputDataBUS <= "010";
					state <= final;
					
				when final =>
					QueueRead <= '0';
					WriteGPR1 <= '0'; 
					WriteGPR2 <= '0';
					WriteRT1 <= '0';
					WriteRT2 <= '0';
					state <= fetch;
					if	(memory_wb = '1') then
						read_write_control <= '1';
					end if;
					
				when IDLE => 
					QueueRead <= '0';
					WriteGPR1 <= '0'; 
					WriteGPR2 <= '0';
					WriteRT1 <= '0';
					WriteRT2 <= '0';

			end case;
		end if;
	end process State_CONTROL;
end description;