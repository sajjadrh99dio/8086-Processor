
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BIURegisters IS PORT(
    inp1, inp2 														: IN std_LOGIC_VECTOR(15 downto 0);
    wsel1, wsel2, controlOutput1,
	 controlOutput2, controlOutput3								: IN STD_LOGIC_VECTOR(2 downto 0);
    clr, w1, w2												   	: IN STD_LOGIC;
    clk 																	: IN STD_LOGIC;
    S1, S2 , S3														: OUT std_LOGIC_VECTOR(15 downto 0);
	 WritForce 															: IN STD_LOGIC;
	 ForceCS, ForceDS, ForceSS, ForceES,
	 ForceIP, ForceInternal1, ForceInternal2,
	 ForceInternal3 													: IN STD_LOGIC_VECTOR(15 downto 0);
	 outCS, outDS, outSS, outES, outIP,
	 outInternal1, outInternal2, outInternal3 				: OUT STD_LOGIC_VECTOR(15 downto 0);
	 IPppw																: IN STD_LOGIC;
	 IPpp																	: IN STD_LOGIC_VECTOR(15 downto 0)
);
END BIURegisters;

ARCHITECTURE behavioaral OF BIURegisters IS
	signal CS, DS, SS, ES, IP, Internal1, Internal2, Internal3 : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal inpCS, inpDS, inpSS, inpES, inpIP, inpInternal1, inpInternal2, inpInternal3: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal WCS, WDS, WSS, WES, WIP, WInternal1, WInternal2, WInternal3: std_LOGIC;
	signal WcsOrWAll, WdsOrWAll, WssOrWAll, WesOrWAll, WipOrWAll, Winternal1OrWAll, Winternal2OrWAll, Winternal3OrWAll: std_LOGIC;
	signal selCS, selDS , selSS , selES, selInternal1 , selInternal2 , selInternal3 : std_LOGIC_vector(1 downto 0);
	signal selIP	: std_logic_vector(2 downto 0);
	
component Register16 IS PORT(
    d   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    w  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    q   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
end component;

begin
	selCS(0) <= ((w1 AND (not wsel1(2)) and NOT(wsel1(1)) AND NOT(wsel1(0)))) OR (w2 AND (not wsel2(2)) and NOT(wsel2(1)) AND NOT(wsel2(0)));
	selCS(1) <= WritForce;
   with selCS select 
        inpCS <=   ForceCS when "00",
                       inp1 when "01",
							  inp2 when others;
							  
	WCS <= (w1 and (not wsel1(2)) and (not Wsel1(1)) and (not Wsel1(0))) or (w2 and (not wsel2(2)) and (not Wsel2(1)) and (not Wsel2(0)));
	WcsOrWAll <= WCS or  WritForce;
	RegCS : register16 port map (inpCS, WcsOrWAll, clr, clk, CS);
	--000
	
	selDS(0) <= ((w1 AND (not wsel1(2)) and NOT(wsel1(1)) AND wsel1(0))) OR (w2 AND (not wsel2(2)) and NOT(wsel2(1)) AND wsel2(0));
	selDS(1) <= WritForce;
   with selDS select 
        inpDS <=   ForceDS when "00",
                       inp1 when "01",
							  inp2 when others;
							  
	WDS <= (w1 and (not wsel1(2)) and (not wsel1(1)) and wsel1(0)) or (w2 and (not wsel2(2)) and (not wsel2(1)) and wsel2(0));
	WdsOrWAll <= WDS or  WritForce;
	RegDS : register16 port map (inpDS, WdsOrWAll, clr, clk, DS);
	
	--001
	selSS(0) <= ((w1 AND (not wsel1(2)) and (wsel1(1)) AND NOT(wsel1(0)))) OR (w2 AND (not wsel2(2)) and (wsel2(1)) AND NOT(wsel2(0)));
	selSS(1) <= WritForce;
   with selSS select 
        inpSS <=   ForceSS when "00",
                       inp1 when "01",
							  inp2 when others;
							  
	WSS <= (w1 and (not wsel1(2)) and Wsel1(1) and(not Wsel1(0))) or (w2 and (not wsel2(2)) and Wsel2(1) and(not Wsel2(0)));
	WssOrWAll <= WSS or  WritForce;
	RegSS : register16 port map (inpSS, WssOrWAll, clr, clk, SS);
	--010
	
	selES(0) <= ((w1 AND (not wsel1(2)) and (wsel1(1)) AND (wsel1(0)))) OR (w2 AND (not wsel2(2)) and (wsel2(1)) AND (wsel2(0)));
	selES(1) <= WritForce;
   with selES select 
        inpES <=   ForceES when "00",
                       inp1 when "01",
							  inp2 when others;
							  
	WES<= (w1 and (not wsel1(2)) and Wsel1(1) and Wsel1(0))or (w2 and (not wsel2(2)) and Wsel2(1) and Wsel2(0));
	WesOrWAll <= WES or  WritForce;
	RegES : register16 port map (inpES, WesOrWAll, clr, clk, ES);
	
	--011
	selIP(0) <= ((w1 AND ( wsel1(2)) and not (wsel1(1)) AND NOT(wsel1(0)))) OR (w2 AND ( wsel2(2)) and not(wsel2(1)) AND NOT(wsel2(0)));
	selIP(1) <= WritForce;
	selIP(2) <= IPppw;
   with selIP select 
        inpIP <=   IPpp when "000",
                       inp1 when "001",
							  inp2 when "010",
							  ForceIP when "011",
							  IPpp when others;
							  
	WIP<=  (w1 and wsel1(2) and (not Wsel1(1)) and (not Wsel1(0))) or(w2 and wsel2(2) and (not Wsel2(1)) and (not Wsel2(0)));
	WipOrWAll <= WIP or  WritForce or IPppw;
	RegIP : register16 port map (inpIP, WipOrWAll, clr, clk, IP);
	--100
	
	selInternal1(0) <= ((w1 AND ( wsel1(2)) and not (wsel1(1)) AND (wsel1(0)))) OR (w2 AND ( wsel2(2)) and not(wsel2(1)) AND (wsel2(0)));
	selInternal1(1) <= WritForce;
   with selInternal1 select 
        inpInternal1 <=   ForceInternal1 when "00",
										inp1 when "01",
										inp2 when others;
										
	WInternal1<=  (w1 and wsel1(2) and (not Wsel1(1)) and Wsel1(0)) or (w2 and wsel2(2) and (not Wsel2(1)) and Wsel2(0));
	WInternal1OrWAll <= WInternal1 or  WritForce;
	RegInternal1 : register16 port map (inpInternal1, WInternal1orWAll, clr, clk, Internal1);
	--101
	
	selInternal2(0) <= ((w1 AND wsel1(2) and wsel1(1) AND not (wsel1(0)))) OR (w2 AND wsel2(2) and wsel2(1) AND not(wsel2(0)));
	selInternal2(1) <= WritForce;
   with selInternal2 select 
        inpInternal2 <=   ForceInternal2 when "00",
										inp1 when "01",
										inp2 when others;
	WInternal2<=  (w1 and wsel1(2) and Wsel1(1) and (not Wsel1(0))) or (w2 and wsel2(2) and Wsel2(1) and (not Wsel2(0)));
	WInternal2OrWAll <= WInternal2 or  WritForce;
	RegInternal2 : register16 port map (inpInternal2, WInternal2OrWAll, clr, clk, Internal2);
	-- 110
	
	selInternal3(0) <= ((w1 AND ( wsel1(2)) and (wsel1(1)) AND (wsel1(0)))) OR (w2 AND ( wsel2(2)) and (wsel2(1)) AND (wsel2(0)));
	selInternal3(1) <= WritForce;
   with selInternal3 select 
        inpInternal3 <=   ForceInternal3 when "00",
										inp1 when "01",
										inp2 when others;
										
	WInternal3<=  (w1 and wsel1(2) and Wsel1(1) and Wsel1(0))or(w2 and wsel2(2) and Wsel2(1) and Wsel2(0));
	WInternal3OrWAll <= WInternal3 or  WritForce;
	RegInternal3 : register16 port map (inpInternal3, WInternal3orWAll, clr, clk, Internal3);
	--111
	
	with controlOutput1 select
		S1 <= CS when "000",
				DS when "001",
				SS when "010",
				ES when "011",
				IP when "100",
				Internal1 when "101",
				Internal2 when "110",
				Internal3 when "111",
				Internal3 when others;
		
	with controlOutput2 select
		S2 <= CS when "000",
				DS when "001",
				SS when "010",
				ES when "011",
				IP when "100",
				Internal1 when "101",
				Internal2 when "110",
				Internal3 when "111",
				IP when others;
			
	with controlOutput3 select
		S3 <= CS when "000",
				DS when "001",
				SS when "010",
				ES when "011",
				IP when "100",
				Internal1 when "101",
				Internal2 when "110",
				Internal3 when "111",
				Internal3 when others;
	
	outCS <= CS;
	outDS <= DS;
	outSS <= SS;
	outES <= ES;
	outIP <= IP;
	outInternal1 <= Internal1;
	outInternal2 <= Internal2;
	outInternal3 <= Internal3;
	

end behavioaral;