-------------------------------- 8086 Processor Top module ---------------------------------------
--------------------------------- Prepared by Sajjad Roohi ---------------------------------------
------------------------------------- SN : 810101175 ---------------------------------------------
---------------------- Computer assignment 1 of VHDL course by Dr.Navabi -------------------------
---------------------------------- University of Tehran ------------------------------------------
--------------------------------------- April 2024 -----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Processor_8086 is
  port (
	clock 										: in std_logic;
	reset 										: in std_logic;
	Force_en										: in std_logic;
   ForceAX, ForceBX, ForceCX,
	ForceDX, ForceSP, ForceBP,
	ForceDI, ForceSI							: in  std_logic_vector(15 downto 0);
	ForceCS, ForceDS, ForceSS,
	ForceES, ForceIP, ForceI1,
	ForceI2, ForceI3							: in  std_logic_vector(15 downto 0);
	OutputAX, OutputBX, OutputCX,
	OutputDX, OutputSP, OutputBP,
	OutputDI, OutputSI						: out std_logic_vector(15 downto 0);
	OutputCS, OutputDS, OutputSS,
	OutputES, OutputIP, OutputI1,
	OutputI2, OutputI3						: out std_logic_vector(15 downto 0);
	FlagsOut										: out std_logic_vector(15 downto 0)
    );
end Processor_8086;
 
architecture description of Processor_8086 is

------------------------------------------------ Signal Declatation --------------------------------------------------------------

signal	CurrentIP																								:	std_logic_vector(15 downto 0);
--GPR input and output signals
signal	DBtoGPR																								:	std_logic_vector(15 downto 0);
signal	GPRtoDB1, GPRtoDB2																				:	std_logic_vector(7 downto 0);
signal   concatination_signal																				:	std_logic_vector(15 downto 0);
--BReg signals
signal	DBtoBReg, MEMtoBReg																					:	std_logic_vector(15 downto 0);
signal	control_InBReg1, control_InBReg2, control_OutBReg1, control_OutBReg2, control_OutBReg3	:	std_logic_vector(2 downto 0) := (others=>'0');
signal 	control_wBReg1, control_wBReg2																		: 	std_logic :='0' ;
signal	BRegtoDB, BRegtoAB, BRegtoMEM																		: 	std_logic_vector(15 downto 0);
signal	control_IPpp																						:	std_logic;
--AB signals
signal 	ABtoMEM																								:	std_logic_vector(19 downto 0);
signal 	IPpp																									:	std_logic_vector(15 downto 0);
--MEM signals
signal	MEMtoIQ																								:	std_logic_vector(7 downto 0);
--IQ signals
signal	control_rQueue																						:	std_logic;
signal	control_wQueue																						:	std_logic;
signal	control_QueueFull																					:	std_logic;
signal	control_QueueEmpty																				:	std_logic;
signal	IQtoCTRL																								:	std_logic_vector(7 downto 0);
--GPR input and output Control signals
signal	control_InGPR1, control_InGPR2, control_OutGPR1, control_OutGPR2						:	std_logic_vector(3 downto 0);
--GPR write signal
signal	control_wGPR1, control_wGPR2																		:	std_logic;
--RT input and output signals
signal	DBtoRT1, DBtoRT2, RTtoDB1, RTtoDB2, RTtoALU1, RTtoALU2							:	std_logic_vector(15 downto 0);
--RT write signal
signal	control_wRT1, control_wRT2																		:	std_logic;
--FR write signal
signal	control_wFR																							:	std_logic;
--FR input and output signals
signal	FRout, FRin																							:	std_logic_vector(15 downto 0);
--ALU operation control
signal	control_OpALU																						:	std_logic_vector(7 downto 0);
--ALU Output
signal	ALUtoDB																								: std_logic_vector(15 downto 0);
--input control in DB
signal	control_InDB																						:	std_logic_vector(2 downto 0);
--DB input and outputs
signal StoreData1,StoreData2																				:	std_logic_vector(7 downto 0);
signal read_write_control																					:  std_logic;
signal Instruction_regged 																			  		 :   std_logic_vector(7 downto 0);
signal JUMP_ADDR      																						: std_logic_vector(7 downto 0);
signal JUMP_SIGNAL    																						: std_logic;
signal JUMP_INST_TO_IP                                                                 : std_logic;

--------------------------------------------- Controller Component declaration --------------------------------------------------------
component Controller 	IS PORT(
			 reset 														: in  std_logic;
			 clk     													: in  std_logic;
			 QueueEmpty													: in  std_logic;
			 inpInstruction 											: in  std_logic_vector(7 downto 0);
			 Instruction_regged 										: out std_logic_vector(7 downto 0);
			 inpGPR1, inpGPR2, OutputGPR1, OutputGPR2			: out std_logic_vector(3 downto 0);
			 QueueRead													: out std_logic;
			 WriteGPR1, WriteGPR2 									: out std_logic;
			 OutputDataBUS												: out std_logic_vector(2 downto 0);
			 WriteRT1, WriteRT2 										: out std_logic;
			 WFlag														: out std_logic;
			 OPALU														: out std_logic_vector(7 downto 0);
			 OutputBR1									         	: out std_logic_vector(2 downto 0);
			 read_write_control 										: out std_logic;
			 FLAG_REG 													: in  std_logic_vector(15 downto 0);
			 JUMP_SIGNAL												: out std_logic;
			 JUMP_ADDR													: out std_logic_vector (7 downto 0)
			 );
end component;

--------------------------------------------- Datapath Component declarations ---------------------------------------------

 																				   
component GPR  	IS PORT(
    inp1, inp2   																				: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	 wsel1, wsel2, rsel1, rsel2 																		: IN 	STD_LOGIC_VECTOR(3 downto 0);
    w1, w2, clk, clr  																					: IN 	STD_LOGIC;
    Output1, Output2   																					: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 wDEBUG																									: IN 	STD_LOGIC;
	 ForceAX, ForceBX, ForceCX, ForceDX, ForceSP, ForceBP, ForceDI, ForceSI	: IN 	STD_LOGIC_VECTOR(15 downto 0);
	 OutputAX, OutputBX, OutputCX, OutputDX, OutputSP, OutputBP, OutputDI, OutputSI	: OUT STD_LOGIC_VECTOR(15 downto 0)
);
end component;

component BIURegisters  		IS PORT(
   inp1, inp2 																	: IN std_LOGIC_VECTOR(15 downto 0);
    wsel1, wsel2, controlOutput1,
	 controlOutput2, controlOutput3										: IN STD_LOGIC_VECTOR(2 downto 0);
    clr, w1, w2																: IN STD_LOGIC;
    clk 																			: IN STD_LOGIC;
    S1, S2 , S3																: OUT std_LOGIC_VECTOR(15 downto 0);
	 WritForce 																	: IN STD_LOGIC;
	 ForceCS, ForceDS, ForceSS, ForceES,
	 ForceIP, ForceInternal1,
	 ForceInternal2, ForceInternal3 										: IN STD_LOGIC_VECTOR(15 downto 0);
	 outCS, outDS, outSS, outES, outIP,
	 outInternal1, outInternal2, outInternal3 						: OUT STD_LOGIC_VECTOR(15 downto 0);
	 IPppw																		: IN STD_LOGIC;
	 IPpp																			: IN STD_LOGIC_VECTOR(15 downto 0)
	 );
end component;

component RegisterTemp 			IS PORT(
		 inp1, inp2 									: IN std_LOGIC_VECTOR(15 downto 0);
		 clr, w1, w2									: IN STD_LOGIC;
		 clk 												: IN STD_LOGIC;
		 Output1, Output2 , Output3, Output4	: OUT std_LOGIC_VECTOR(15 downto 0)
);
end component;

component DataBus 				IS PORT(
		InControl 								: IN std_LOGIC_VECTOR(2 downto 0);
		TemporalReg1, TemporalReg2 		: IN std_LOGIC_VECTOR(15 downto 0);
		GeneralReg								: IN std_LOGIC_VECTOR(15 downto 0);
		ALU, Flags								: IN std_LOGIC_VECTOR(15 downto 0);
		IMMDIATE_DATA							: in std_LOGIC_VECTOR(7 downto 0);
		SGeneral									: OUT std_LOGIC_VECTOR(15 downto 0);
		STemp1, STemp2							: OUT std_LOGIC_VECTOR(15 downto 0)
);
end component;

component ALU 						IS PORT(
		 clk										: IN std_logic;
		 control 								: IN std_logic_vector(7 downto 0);
		 Operand1, Operand2, Flags			: IN std_logic_vector(15 downto 0);
		 SExtra, SFlags						: OUT std_logic_vector(15 downto 0)
	);
end component;

component Register16 		IS PORT(
			d										: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			w  									: IN STD_LOGIC;
			clr									: IN STD_LOGIC;
			clk									: IN STD_LOGIC;
			q  									: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	 );
end component;
component InstructionQueue		IS PORT(
			reset 								: IN STD_LOGIC;
			clk     								: IN STD_LOGIC;
			w   									: IN STD_LOGIC;
			inp 									: IN STD_LOGIC_VECTOR(7 downto 0);
			full   								: OUT STD_LOGIC;
			r  									: IN STD_LOGIC;
			Output 								: OUT STD_LOGIC_VECTOR(7 downto 0);
			empyt   								: OUT STD_LOGIC;
			address_value 						: in std_logic_vector (7 downto 0);
			JUMP_SIGNAL                   : in std_logic;
			JUMP_ADDR                     : in std_logic_vector(7 downto 0);
			JUMP_INST_TO_IP		 			: out std_logic
			);
end component;

component AddressBus				IS PORT(
			SegmentBase, Offset 									: IN STD_LOGIC_VECTOR(15 downto 0);
			IP															: IN STD_LOGIC_VECTOR(15 downto 0);
			Address 													: OUT STD_LOGIC_VECTOR(19 downto 0);
			IPpp														: OUT STD_LOGIC_VECTOR(15 downto 0);
			JUMP_ADDR     											: in std_logic_vector (7 downto 0);
			JUMP_INST_TO_IP 										: in std_logic
			);
end component;
component MemoryController 		IS PORT(
		    read_write_control : in std_logic;
		    inpData1,inpData2									: IN std_LOGIC_VECTOR(7 downto 0);
		    inpAddress												: IN std_LOGIC_VECTOR(19 downto 0);
			 clk, reset												: IN STD_LOGIC;
			 QueueFull 												: IN std_LOGIC;
			 WriteQueue 											: OUT std_LOGIC;
			 IncrementPC 											: OUT std_Logic;
			 controlBIURegister1, controlBIURegister2 	: OUT std_logic_vector(2 downto 0);
			 OutputQueue											: OUT std_LOGIC_VECTOR(7 downto 0);
			 OutputRegs												: OUT std_LOGIC_VECTOR(15 downto 0);
			 ForceSI,ForceDX								   	: IN std_LOGIC_VECTOR(15 downto 0)
		);
end component;


begin
-------------------------------------------- Controller Portmap ------------------------------------------------
--Processor controller
	CTRL:	Controller		port map(
												reset,
												clock,
												control_QueueEmpty,
												IQtoCTRL,Instruction_regged,
												control_InGPR1, control_InGPR2, Control_OutGPR1, control_OutGPR2,
												control_rQueue,
												control_wGPR1, control_wGPR2,
												control_InDB,
												control_wRT1, control_wRT2,
												control_wFR,
												control_OpALU,
												control_OutBReg1,
												read_write_control,
												FRout,
											   JUMP_SIGNAL,	
												JUMP_ADDR					
												);



-------------------------------------------- Datapath components' Portmap ---------------------------------------------


	--Registers used for memory access
	BReg:	BIURegisters 			port map(
												DBtoBReg, MEMtoBReg,
												control_InBReg1, control_InBReg2,
												control_OutBReg1, control_OutBReg2, control_OutBReg3,
												reset, control_wBReg1, control_wBReg2,
												clock,
												BRegtoDB, BRegtoAB, BRegtoMEM,
												Force_en,
												ForceCS, ForceDS, ForceSS, ForceES,
												ForceIP, ForceI1, ForceI2, ForceI3,
												OutputCS, OutputDS, OutputSS,
												OutputES, CurrentIP, OutputI1, OutputI2, OutputI3,
												control_IPpp,
												IPpp);
	--Generates the address for memory
	AB:	AddressBus				port map(
												BRegtoAB, BRegtoMEM,
												CurrentIP,
												ABtoMEM,
												IPpp,
												JUMP_ADDR,
												JUMP_INST_TO_IP												
												);
	--Memory
	MEM:	MemoryController			port map(
											   read_write_control,
												StoreData1,StoreData2,
												ABtoMEM,
												clock, reset,
												control_QueueFull,
												control_wQueue,
												control_IPpp,
												Control_OutBReg2, Control_OutBReg3,
												MEMtoIQ,
												MEMtoBReg,
												ForceSI,
												ForceDX
												);
	--Instruction Queue
	IQ:	InstructionQueue		port map(
												reset,
												clock,
												control_wQueue,
												MEMtoIQ,
												control_QueueFull,
												control_rQueue,
												IQtoCTRL,
												control_QueueEmpty,
												ABtoMEM (7 downto 0),
												JUMP_SIGNAL,
												JUMP_ADDR,
												JUMP_INST_TO_IP
												);

				 
	--General purpose registers
	GPR1 :	GPR 		port map(
												DBtoGPR(15 downto 8), DBtoGPR(7 downto 0),
												control_InGPR1, control_InGPR2, control_OutGPR1, control_OutGPR2,
												control_wGPR1, control_wGPR2, clock, reset,
												GPRtoDB1, GPRtoDB2,
												Force_en,
												ForceAX, ForceBX, ForceCX, ForceDX, ForceSP, ForceBP, ForceDI, ForceSI,
												OutputAX, OutputBX, OutputCX, OutputDX, OutputSP, OutputBP, OutputDI, OutputSI
												);

	--ALU operand registers
	RT:	RegisterTemp 			port map(
												DBtoRT1, DBtoRT2,
												reset, control_wRT1, control_wRT2,
												clock, 
												RTtoDB1, RTtoDB2, RTtoALU1, RTtoALU2);
																						
	--ALU bus
	

	DB:	DataBus 					port map(
												InControl  => control_InDB,
												TemporalReg1  => RTtoDB1,
												TemporalReg2  => RTtoDB2,
												GeneralReg => concatination_signal,
												ALU => ALUtoDB,
												Flags => FRout,
												IMMDIATE_DATA => Instruction_regged,
												SGeneral => DBtoGPR,
												STemp1 => DBtoRT1,
												STemp2 => DBtoRT2);		
								
	--ALU.											
	ALU1:	ALU 						port map(
												clock,
												control_OpALU,
												RTtoALU1, RTtoALU2, FRout,
												ALUtoDB, FRin
												);
	
	--Flag Registrar
	FR:	Register16			port map(
												FRin,
												control_wFR,
												reset,
												clock,
												FRout);
	StoreData1<=ALUtoDB(7 downto 0);
	StoreData2<=ALUtoDB(15 downto 8);	
	FlagsOut <= FRout;
	OutputIP <= CurrentIP;
	concatination_signal <= GPRtoDB2 & GPRtoDB1;
end description;