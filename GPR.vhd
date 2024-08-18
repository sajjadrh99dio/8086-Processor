LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY GPR IS PORT(
    inp2, inp1   																				: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	 wsel1, wsel2, rsel1, rsel2 																		: IN 	STD_LOGIC_VECTOR(3 downto 0);
    w1, w2, clk, clr  																					: IN 	STD_LOGIC;
    Output1, Output2   																					: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 wDEBUG																									: IN 	STD_LOGIC;
	 ForceAX, ForceBX, ForceCX, ForceDX, ForceSP, ForceBP, ForceDI, ForceSI	: IN 	STD_LOGIC_VECTOR(15 downto 0);
	 OutputAX, OutputBX, OutputCX, OutputDX, OutputSP, OutputBP, OutputDI, OutputSI	: OUT STD_LOGIC_VECTOR(15 downto 0)
);
END GPR;

ARCHITECTURE description OF GPR IS
SIGNAL inpAH, inpAL, inpBH, inpBL, inpCH, inpCL, inpDH, inpDL 	: std_logic_vector(7 downto 0);
SIGNAL inpSP, inpBP, inpDI, inpSI																: std_logic_vector(15 downto 0);
SIGNAL outAH, outAL, outBH, outBL, outCH, outCL, outDH, outDL 						: std_logic_vector(7 downto 0);
SIGNAL outSP, outBP, outDI, outSI																			: std_logic_vector(15 downto 0);
SIGNAL wAH, wAL, wBH, wBL, wCH, wCL, wDH, wDL, wSP, wBP, wDI, wSI											: std_logic;
SIGNAL selAH, selAL, selBH, selBL, selCH, selCL, selDH, selDL, selSP, selBP, selDI, selSI			: std_logic_vector(2 downto 0);
COMPONENT Register16
	PORT(
	d  	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
   w  	: IN STD_LOGIC;
   clr 	: IN STD_LOGIC;
   clk 	: IN STD_LOGIC;
   q   	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;
COMPONENT Register8 
	PORT(
    d   	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    w  	: IN STD_LOGIC;
    clr 	: IN STD_LOGIC;
    clk 	: IN STD_LOGIC;
    q   	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN


-------- SELECTING SOURCE REGISTER USING OUTPUTRG FROM CONTROLLER
	with rsel1 select 
		Output1 <= 	
					outAL when "1000",
					--outAL when "1000",
					outBL when "1001",
					--outBL when "1001",
					outCL when "1010",
					--outCL when "1010",
					outDL when "1011",
					--outDL when "1011",
					outAH when "0000",
					outBH when "0001",
					outCH when "0010",
					outDH when "0011",
					outSP(7 downto 0) when "1100",
					outBP(7 downto 0) when "1101",
					outSI(7 downto 0) when "1110",
					outDI(7 downto 0) when "1111",
               "XXXXXXXX" when others;
												
	with rsel2 select 
		Output2 <= 	
					outAL when "1000",
					--outAH when "0001",
					outBL when "1001",
					--outBH when "0011",
					outCL when "1010",
					--outCH when "0101",
					outDL when "1011",
					--outDH when "0111",
					outAH when "0000",
					outBH when "0001",
					outCH when "0010",
					outDH when "0011",
					outSP(15 downto 8) when "1100",
					outBP(15 downto 8) when "1101",
					outSI(15 downto 8) when "1110",
					outDI(15 downto 8) when "1111",
               "XXXXXXXX" when others;
	





-------- SELECTING DESTINATION REGISTER USING OUTPUTRG FROM CONTROLLER



	--AL = 0001
	wAL	<= wDEBUG or ((	w1 AND NOT(wsel1(3)) AND NOT(wsel1(2)) AND NOT(wsel1(1)) AND (wsel1(0))) OR (w2 AND NOT(wsel2(3)) AND NOT(wsel2(2)) AND NOT(wsel2(1)) AND (wsel2(0))));
	selAL(0)	<=		w1 AND NOT(wsel1(3)) AND NOT(wsel1(2)) AND NOT(wsel1(1)) AND (wsel1(0));
   selAL(1)	<=	(w2 AND NOT(wsel2(3)) AND NOT(wsel2(2)) AND NOT(wsel2(1)) AND (wsel2(0)));
	selAL(2) <= wDEBUG;
	with selAL select 
		inpAL <= 	
							outAL when "000",
							inp2 when "001",
							inp1 when "010",
							ForceAX(7 downto 0) when others;
    AL: Register8 port map(inpAL, wAL, clr, clk, outAL);
	 


	--AH = 0010
	wAH	<= wDEBUG or ((	w1 AND NOT(wsel1(3)) AND NOT(wsel1(2)) AND (wsel1(1)) AND NOT wsel1(0)) 	OR (w2 AND NOT(wsel2(3)) AND NOT(wsel2(2)) AND (wsel2(1)) AND NOT wsel2(0)));
	selAH(0)	<=	 (	w1 AND NOT(wsel1(3)) AND NOT(wsel1(2)) AND (wsel1(1)) AND NOT wsel1(0)) ;
	selAH(1)	<=	(w2 AND NOT(wsel2(3)) AND NOT(wsel2(2)) AND (wsel2(1)) AND NOT wsel2(0));
	selAH(2) <= wDEBUG;
	with selAH select 
		inpAH <= 	
							outAH when "000",
							inp2 when "001",
							inp1 when "010",
							ForceAX(15 downto 8) when others;
    AH: Register8 port map(inpAH, wAH, clr, clk, outAH);
	 

	 --BL = 0011
	 wBL	<= wDEBUG or (( w1 AND NOT(wsel1(3)) AND NOT(wsel1(2)) AND wsel1(1) AND wsel1(0)) 	OR (w2 AND NOT(wsel2(3)) AND NOT(wsel2(2)) AND wsel2(1) AND wsel2(0)));
	selBL(0)	<=	  (w1 AND NOT(wsel1(3)) AND NOT(wsel1(2)) AND wsel1(1) AND wsel1(0)); 	
	selBL(1)	<=   (w2 AND NOT(wsel2(3)) AND NOT(wsel2(2)) AND wsel2(1) AND wsel2(0));
	selBL(2) <= wDEBUG;
	with selBL select 
		inpBL <= 	
							outBL when "000",
							inp2 when "001",
							inp1 when "010",
							ForceBX(7 downto 0) when others;
    BL: Register8 port map(inpBL, wBL, clr, clk, outBL);
	 
	 --BH = 0100
	 wBH	<= wDEBUG or (( w1 AND NOT(wsel1(3)) AND (wsel1(2)) AND NOT wsel1(1) AND NOT(wsel1(0))) 	OR (w2 AND NOT (wsel2(3)) AND (wsel2(2)) AND NOT wsel2(1) AND NOT (wsel2(0))));
	selBH(0)	<=	 	w1 AND NOT(wsel1(3)) AND (wsel1(2)) AND NOT wsel1(1) AND NOT(wsel1(0)); 
	selBH(1)	<=	w2 AND NOT(wsel2(3)) AND (wsel2(2)) AND NOT wsel2(1) AND NOT(wsel2(0));
	selBH(2)	<=	wDEBUG;
	with selBH select 
		inpBH <= 	
							outBH when "000",
							inp2 when "001",
							inp1 when "010",
							ForceBX(15 downto 8) when others;
    BH: Register8 port map(inpBH, wBH, clr, clk, outBH);
	 
	 
	 
	 --CL = 0101
	 wCL	<= wDEBUG or ((	w1 AND NOT (wsel1(3)) AND wsel1(2) AND NOT(wsel1(1)) AND (wsel1(0))) 	OR (w2 AND NOT (wsel2(3)) AND wsel2(2) AND NOT(wsel2(1)) AND (wsel2(0))));
	selCL(0)	<=		w1 AND (NOT wsel1(3)) AND wsel1(2) AND NOT(wsel1(1)) AND (wsel1(0));
	selCL(1)	<=	w2 AND (NOT wsel2(3)) AND wsel2(2) AND NOT(wsel2(1)) AND (wsel2(0));
	selCL(2) <= wDEBUG;
	with selCL select 
		inpCL <= 	
							outCL when "000",
							inp2 when "001",
							inp1 when "010",
							ForceCX(7 downto 0) when others;
    CL: Register8 port map(inpCL, wCL, clr, clk, outCL);
	 
	 
	 
	 --CH = 0110
	 wCH	<= wDEBUG or ((	w1 AND NOT(wsel1(3)) AND wsel1(2) AND (wsel1(1)) AND NOT wsel1(0)) 	OR (w2 AND NOT(wsel2(3)) AND wsel2(2) AND (wsel2(1)) AND NOT wsel2(0)));
	selCH(0)	<=	(	w1 AND NOT(wsel1(3)) AND wsel1(2) AND (wsel1(1)) AND NOT wsel1(0));
	selCH(1) <= (w2 AND NOT(wsel2(3)) AND wsel2(2) AND (wsel2(1)) AND NOT wsel2(0));
	selCH(2) <= wDEBUG;
	with selCH select 
		inpCH <= 	
							outCH when "000",
							inp2 when "001",
							inp1 when "010",
							ForceCX(15 downto 8) when others;
    CH: Register8 port map(inpCH, wCH, clr, clk, outCH);
	 
	 --DL = 0111
	 wDL	<= wDEBUG or ((	w1 AND NOT(wsel1(3)) AND wsel1(2) AND wsel1(1) AND (wsel1(0))) 	OR (w2 AND NOT(wsel2(3)) AND wsel2(2) AND wsel2(1) AND (wsel2(0))));
	selDL(0)	<=	(	w1 AND NOT(wsel1(3)) AND wsel1(2) AND wsel1(1) AND (wsel1(0)));
	selDL(1)	<=	(w2 AND NOT(wsel2(3)) AND wsel2(2) AND wsel2(1) AND (wsel2(0)));
	selDL(2) <= wDEBUG;
	with selDL select 
		inpDL <= 		outDL when "000",
							inp2 when "001",
							inp1 when "010",
							ForceDX(7 downto 0) when others;
    DL: Register8 port map(inpDL, wDL, clr, clk, outDL);
	 
	 --DH = 1000
	 wDH	<= wDEBUG or ((	w1 AND (wsel1(3)) AND NOT wsel1(2) AND NOT wsel1(1) AND NOT wsel1(0)) 	OR (w2 AND (wsel2(3)) AND NOT wsel2(2) AND NOT wsel2(1) AND NOT wsel2(0)));
	selDH(0)	<=	(	w1 AND (wsel1(3)) AND NOT wsel1(2) AND NOT wsel1(1) AND NOT wsel1(0));
	selDH(1)	<= (w2 AND (wsel2(3)) AND NOT wsel2(2) AND NOT wsel2(1) AND NOT wsel2(0));
	selDH(2) <= wDEBUG; 
	with selDH select 
		inpDH <= 	
							outDH when "000",
							inp2 when "001",
							inp1 when "010",
							ForceDX(15 downto 8) when others;
    DH: Register8 port map(inpDH, wDH, clr, clk, outDH);
	 

	 
	 
	 
	 
	 
	 --SP = 1100
	wSP <= wDEBUG or ((w1 AND wsel1(3) AND wsel1(2) AND NOT(wsel1(1)) AND NOT(wsel1(0)))AND (w2 AND wsel2(3) AND wsel2(2) AND NOT(wsel2(1)) AND NOT(wsel2(0))));
	with wDEBUG select 
		inpSP <= 	inp2&inp1 when '0',
							ForceSP 			when others;
   SP: Register16 port map(inpSP, wSP, clr, clk, outSP);
	 
	--BP = 1101
	wBP			<= wDEBUG or ((w1 AND wsel1(3) AND wsel1(2) AND NOT(wsel1(1)) AND wsel1(0)) 		AND (w2 AND wsel2(3) AND wsel2(2) AND NOT(wsel2(1)) AND wsel2(0)));
	with wDEBUG select 
		inpBP <= 	inp2&inp1 when '0',
							ForceBP 			when others;
   BP: Register16 port map(inpBP, wBP, clr, clk, outBP);
	 
	 --SI = 1110
	wSI			<= wDEBUG or (((w1 AND wsel1(3) AND wsel1(2) AND wsel1(1) AND NOT(wsel1(0))) 		AND (w2 AND wsel2(3) AND wsel2(2) AND wsel2(1) AND NOT(wsel2(0)))));
	with wDEBUG select 
		inpSI <= 	inp2&inp1 when '0',
							ForceSI 			when others;
   SI: Register16 port map(inpSI, wSI, clr, clk, outSI);
	 
	 --DI = 1111
	wDI			<= wDEBUG or ((w1 AND wsel1(3) AND wsel1(2) AND wsel1(1) AND wsel1(0)) 			AND (w2 AND wsel2(3) AND wsel2(2) AND wsel2(1) AND wsel2(0)));
	with wDEBUG select 
		inpDI <= 	inp2&inp1 when '0',
							ForceDI 			when others;
   DI: Register16 port map(inpDI, wDI, clr, clk, outDI);
	 

	OutputAX <= outAH&outAL;
	OutputBX <= outBH&outBL;
	OutputCX <= outCH&outCL;
	OutputDX <= outDH&outDL;
	OutputSP <= outSP;
	OutputBP <= outBP;
	OutputSI <= outSI;
	OutputDI <= outDI;
	 
END description;