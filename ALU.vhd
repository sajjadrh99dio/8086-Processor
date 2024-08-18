library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity ALU is
	port(
		clk: in std_logic;
		control : in std_logic_vector(7 downto 0);
		Operand1, Operand2, Flags: in std_logic_vector(15 downto 0); --Operand1 is the Source and Operand2 is the destination
		SExtra, SFlags: out std_logic_vector(15 downto 0)
		--Flags -    -    -    -    O    -    -    -    S    Z    -    A    -    P    -    C    Flags
		--									 11   10   9    8    7    6         4         2         0
	);
	end ALU;

architecture behavioral of ALU is

component ADC86 IS
port(
		clk, carry, control, controlByte: in std_logic;
		A, B: in std_logic_vector(15 downto 0);
		Abyte, Bbyte: in std_logic_vector(7 downto 0);
		AF, CF, overflow, PF, SF, ZF: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);
	end component;

component	ADD86 is
	port(
		clk, control, controlByte: in std_logic;
		A, B : in std_logic_vector(15 downto 0);
		AByte, BByte: in std_logic_vector(7 downto 0);
		AF, CF, overflow, PF, SF, ZF: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);
	end component;
	
component DEC86 IS
	port(
		clk: in std_logic;
		A :in std_logic_vector(15 downto 0);
		AByte : in std_logic_vector(7 downto 0);
		ByteControl : in std_logic;
		zero, SF, Overflow, Parity, AF: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);
end component;

component DIV86 IS
	port(
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		Output1, Output2:  out std_logic_vector(15 downto 0)
	);
end component;

component IDIV86 IS
	port(
		clk: in std_logic;
		A: in std_logic_vector(15 downto 0);
		B: in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		Output1, Output2:  out std_logic_vector(15 downto 0)
	);
end component;

component INC86 is
	port(
		clk: in std_logic;
		A :in std_logic_vector(15 downto 0);
		AByte : in std_logic_vector(7 downto 0);
		ByteControl : in std_logic;
		zero, SF, Overflow, Parity, AF: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);

end component;

component LAHF86 is
	port(
		SF, ZF, AF, PF, CF: in std_logic;
		--7 6 4 2 0
		AH: in std_logic_vector(7 downto 0);
		Output:  out std_logic_vector(7 downto 0)
	);

end component;

component MUL86 is
	port(
		clk: in std_logic;
		A, B: in std_logic_vector(15 downto 0);
		carryS, Overflow: out std_logic;
		Output1, Output2:  out std_logic_vector(15 downto 0)
	);

end component;

component MULB86 is
	port(
		clk: in std_logic;
		A, B: in std_logic_vector(7 downto 0);
		carryS, Overflow: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);

end component;

component NEG86 is
	port(
		clk: in std_logic;
		A :in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte: in std_logic_vector(7 downto 0);
		zero, SF, Overflow, Parity, auxiliary, CF: out std_logic;
		Output : out std_logic_vector(15 downto 0)
	);
end component;

component NOT86 is 
port(
	A : in std_logic_vector(15 downto 0);
	AByte 		: in std_logic_vector(7 downto 0);
	ByteControl			: in std_logic; 
	S: out std_logic_vector(15 downto 0)
);

end component;


component SAHF86 is
	port(
		SF, ZF, AF, PF, CF: out std_logic;
		--7 6 4 2 0
		AH: in std_logic_vector(7 downto 0)
	);

end component;


component XOR86 is 
port(
	A, B : in std_logic_vector(15 downto 0);
	ByteControl : in std_logic;
	Abyte, BByte: in std_logic_vector(7 downto 0);
	S: out std_logic_vector(15 downto 0)
);

end component;

component AND86 is
   port
   (
      A, B 					: in std_logic_vector(15 downto 0);
		AByte, BByte 		: in std_logic_vector(7 downto 0);
		ByteControl			: in std_logic; 
		C						: out std_logic_vector(15 downto 0);
      Zout, Sout, Pout 	: out std_logic
   );
end component;

component OR86 is
port (
		A, B : in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		S: out std_logic_vector(15 downto 0)

);
end component;

component ROL86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end component;

component ROR86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end component;

component SAR86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end component;



component SHR86 is
   port
   (
      Source, Count	: in std_logic_vector(15 downto 0);
      Destination		: out std_logic_vector(15 downto 0);
		OFOut				: out std_logic
   );
end component;

component TEST86 is
   port
   (
      A, B 					: in std_logic_vector(15 downto 0);
      Zout, Sout, Pout 	: out std_logic
   );
end component;

component AAA86 is
	port(
		AF, clk: in std_logic;
		AL, AH: in std_logic_vector(7 downto 0);
		OutputAF, OutputCF: out std_logic;
		OutputAL, OutputAH:  out std_logic_vector(7 downto 0)
	);
end component;

component DAA86 is
	port(
		AF, CF, clk: in std_logic;
		AL: in std_logic_vector(7 downto 0);
		OutputCF, OutputZF, OutputSF, OutputPF, OutputAF: out std_logic;
		OutputAL:  out std_logic_vector(7 downto 0)
	);
end component;	

component AAS86 is
	port(
		AF, clk: in std_logic;
		AL, AH: in std_logic_vector(7 downto 0);
		OutputAF, OutputCF: out std_logic;
		OutputAL, OutputAH:  out std_logic_vector(7 downto 0)
	);
end component;

component AAM86 is
	port(
		clk: in std_logic;
		AL, AH: in std_logic_vector(7 downto 0);
		OutputZF, OutputSF, OutputPF: out std_logic;
		OutputAL, OutputAH:  out std_logic_vector(7 downto 0)
	);
end component;

component AAD86 is
	port(
		clk: in std_logic;
		AL, AH: in std_logic_vector(7 downto 0);
		OutputZF, OutputSF, OutputPF: out std_logic;
		OutputAL, OutputAH:  out std_logic_vector(7 downto 0)
	);
end component;

component CMP86 is
port(
		clk: in std_logic;
		A , B:in std_logic_vector(15 downto 0);
		ByteControl : in std_logic;
		Abyte, BByte: in std_logic_vector(7 downto 0);
		zero, SF, Overflow, Parity, auxiliary, CF: out std_logic
	);
end component;

component XCHG86 is
	port(
		Source1: in std_logic_vector(7 downto 0);
		Source2: in std_logic_vector(7 downto 0);
		Destiny:  out std_logic_vector(15 downto 0)
	);
end component;


Signal OutputAdd,OutputAdc : std_logic_vector(15 downto 0); --ADD ADC
Signal Fadd, FAdc,FNeg, FCmp: std_logic_vector(5 downto 0); --ADC ADD FLAGS
Signal OutputDec: std_logic_vector(15 downto 0); --DEC
Signal Fdec, FInc, FLahf, FDaa: std_logic_vector(4 downto 0); --DEC FLAgs
Signal SDiv1,SDiv2, SIdiv1, SIdiv2: std_logic_vector(15 downto 0); --DIV IDIV
Signal SInc : std_logic_vector(15 downto 0); --INC
Signal SMul1, SMul2, SMulb: std_logic_vector(15 downto 0); --MUL MULB
Signal FMul, FMulb , FAaa, FAas: std_logic_vector(1 downto 0);
Signal SNeg : std_logic_vector(15 downto 0); --NEG
Signal SNot : std_logic_vector(15 downto 0); --NOT
Signal FSahf, Slahf : std_logic_vector(15 downto 0); -- SAHF
Signal SXCHG1, SXCHG2 : std_logic_vector(15 downto 0); --XCHG
Signal SXOR : std_logic_vector(15 downto 0); --XOR
Signal SAnd, SOr: std_logic_vector(15 downto 0); --AND OR
Signal FAnd , FTest, FAam, FAad: Std_logic_vector(2 downto 0);
Signal SRol , SRor, SSar, SShr: std_logic_vector(15 downto 0); --ROL ROR
Signal FRol, FRor, FSar, FShr: std_logic;-- Flag ROL ROR
Signal SAaa,  SAas, SAam, SAad : std_logic_vector(15 downto 0);
Signal SDaa : std_logic_vector(7 downto 0);
Signal SubOperand1, SubOperand2 : std_logic_vector(7 downto 0);
Signal SOperand1, SOperand2, Output: std_logic_vector(15 downto 0);
Signal Word2 : std_logic;
Signal SJA : std_logic_vector(15 downto 0);
signal xoperand1,xoperand2 : std_logic_vector(15 downto 0); --MULT
signal xchng_result : std_logic_vector(15 downto 0);
Begin
	
SubOperand1 <= Operand1(15 downto 8);
SubOperand2 <= Operand1(7 downto 0);
xoperand1<="00000000"&SubOperand1;
xoperand2<="00000000"&SubOperand2;

add1: ADD86 port map(clk, control(7),control(6), Operand1, Operand2,SubOperand1, SubOperand2, Fadd(0), Fadd(1), Fadd(2), Fadd(3), Fadd(4), Fadd(5), OutputAdd);

adc1: ADC86 port map(clk, Flags(0), control(7),control(6), Operand1, Operand2,SubOperand1, SubOperand2, Fadc(0), Fadc(1), Fadc(2), Fadc(3), Fadc(4), Fadc(5), OutputAdc);

dec1: DEC86 port map(clk, Operand1,SubOperand2, control(6), Fdec(0), Fdec(1), Fdec(2), Fdec(3), Fdec(4), OutputDec);
												--	6 7 11 2 4
div1: DIV86 port map(Operand1, Operand2, control(6), SubOperand1, SubOperand2, SDiv1, SDiv2);

idiv1: IDIV86 port map (clk, Operand1, Operand2, control(6), SubOperand1, SubOperand2, SIdiv1, SIdiv2);

inc1: INC86 port map (clk, Operand1,SubOperand1, control(6), FInc(0), FInc(1), FInc(2), FInc(3), FInc(4), SInc);
													--6 7 11 2 4
lahf1: LAHF86 port map(Flags(0), Flags(1), Flags(2), Flags(3), Flags(4), Operand1(15 downto 8), Slahf(15 downto 8));
								--7 6 4 2 0
mul1: MUL86 port map (clk,xoperand1 , xoperand2, Fmul(0), Fmul(1), SMul1, SMul2);
																	--0 11
mulb1: MULB86 port map (clk, Operand1(15 downto 8), Operand1(7 downto 0), Fmulb(0), Fmulb(1), SMulb);
																	--0 11
neg1: NEG86 port map (clk, Operand1,control(6), SubOperand1, FNeg(0), FNeg(1), FNeg(2), FNeg(3), FNeg(4), FNeg(5), SNeg);								
													--6 7 11 2 4 0
not1: NOT86 port map (Operand1,SubOperand1, control(6), SNot);

sahf1: SAHF86 port map (FSahf(7), FSahf(6), FSahf(4), FSahf(2), FSahf(0), Operand1(15 downto 8));

xor1: XOR86 port map (Operand1, Operand2,control(6), SubOperand1, SubOperand2, SXOR);

and1 : AND86 port map (Operand1, Operand2, SubOperand1, SubOperand2, control(6), SAnd, FAnd(0), FAnd(1), FAnd(2));
																		--6 7 2
or1 : OR86 port map (Operand1, Operand2,control(6), SubOperand1, SubOperand2, SOr);

rol1 : ROL86 port map (Operand1, Operand2, SRol, FRol);

ror1 : ROR86 port map (Operand1, Operand2, SRor, FRor);

sar1 : SAR86 port map (Operand1, Operand2, SSar,FSar);

shr1: SHR86 port map (Operand1, Operand2, SShr, FShr);

test1: TEST86 port map (Operand1, Operand2, FTest(0), FTest(1), FTest(2));
																--6 7 2																
aaa1: AAA86 port map (Flags(4), clk, Operand1(7 downto 0), Operand1(15 downto 8), FAaa(0), FAaa(1), SAaa(7 downto 0), SAaa(15 downto 8));

daa1: DAA86 port map (Flags(4), Flags(0), clk ,Operand1(7 downto 0), FDaa(0), FDaa(1), FDaa(2), FDaa(3), FDaa(4), SDaa(7 downto 0));

aas1: AAS86 port map (Flags(4), clk, Operand1(7 downto 0), Operand1(15 downto 8), FAas(0), FAas(1), SAas(7 downto 0), SAas(15 downto 8));

aam1: AAM86 port map (clk, Operand1(7 downto 0), Operand1(15 downto 8), FAam(0), FAam(1), FAam(2), SAam(7 downto 0), SAam(15 downto 8));

aad1: AAD86 port map (clk, Operand1(7 downto 0), Operand1(15 downto 8), FAad(0), FAad(1), FAad(2), SAad(7 downto 0), SAad(15 downto 8));

cmp1: CMP86 port map (clk, Operand1, Operand2, control(6), SubOperand1, SubOperand2, FCmp(0), FCmp(1), FCmp(2), FCmp(3), FCmp(4), FCmp(5));

xch1: XCHG86 port map(SubOperand2,SubOperand1,xchng_result);

process (clk)
	begin
		--Flags -    -    -    -    O    D    I    T    S    Z    -    A    -    P    -    C    Flags
		--									 11   10   9    8    7    6         4         2         0
		if control = "00000000" then --JMP
			SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			Word2 <= '0';
		elsif control = "00000010" then	 --JA
			if (Flags(0) or Flags(6)) = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
				Word2 <= '0';
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
				Word2 <= '0';
			end if;
			
			elsif control = "00000011" then -- JAE and JNC
				if Flags(0) = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
				Word2 <= '0';
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
				Word2 <= '0';
			end if;
			
			elsif control = "00000100" then -- JB
				if Flags(0) = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
				Word2 <= '0';
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
				Word2 <= '0';
			end if;
			
			elsif control = "00000101" then -- JBE
				if (Flags(0) or Flags(6)) = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
				Word2 <= '0';
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
				Word2 <= '0';
			end if;
			
			elsif control = "00000111" then -- JC
			Word2 <= '0';
				if Flags(0) = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001000" then -- JE
			Word2 <= '0';
				if Flags(6) = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001001" then -- JG
			Word2 <= '0';
				if ((Flags(7) xor Flags(11)) or Flags(6)) = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001010" then -- JGE
			Word2 <= '0';
				if (Flags(7) xor Flags(11)) = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001011" then -- JLE
			Word2 <= '0';
				if ((Flags(7) xor Flags(11)) or Flags(6)) = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001100" then -- JNE
			Word2 <= '0';
				if Flags(6)  = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001101" then -- JNO
			Word2 <= '0';
				if Flags(11)  = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001110" then -- JNPP
			Word2 <= '0';
				if Flags(2)  = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "00001111" then -- JNS
			Word2 <= '0';
				if Flags(7)  = '0' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "10000001" then -- JO
			Word2 <= '0';
				if Flags(11)  = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "10000010" then -- JP
			Word2 <= '0';
				if Flags(1)  = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
			else
				SOperand1 <= Operand1; -- Operand1 when used in a branch is normal PC address
			end if;
			
			elsif control = "10000001" then -- JS
			Word2 <= '0';
				if Flags(7)  = '1' then
				SOperand1 <= Operand2; -- Operand2 when used in a branch is the new PC address
				end if;
				
			elsif control ="11000111" then	--MOVE IMMEDIATE
				SOperand1 <= xoperand2; 
				Word2 <= '0';
				SFlags(15 downto 0) <= (others =>'0');
				
			elsif control ="10010000" then -- MOVE
				SOperand1 <= Operand1; 
				Word2 <= '0';
				SFlags(15 downto 0) <= (others =>'0');
				
			elsif control ="11110000" then -- XCHNG
				SOperand1 <= xchng_result; 
				Word2 <= '0';
				SFlags(15 downto 0) <= (others =>'0');
			
			elsif control = "10110000" or control = "11010000" or control = "00010000" or control = "01010000"then --ADD
				SOperand1 <= OutputAdd;
				SFlags(4) <= FAdd(0);
				SFlags(0) <= FAdd(1);
				SFlags(11) <= FAdd(2);
				SFlags(2) <= FAdd(3);
				SFlags(7) <= FAdd(4);
				SFlags(6) <= FAdd(5);
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			
			elsif control = "10010001" or control = "11010001" or control = "00010001" or control = "01010001" then --ADC
				SOperand1 <= OutputAdc;
				SFlags(4) <= FAdc(0);
				SFlags(0) <= FAdc(1);
				SFlags(11) <= FAdc(2);
				SFlags(2) <= FAdc(3);
				SFlags(7) <= FAdc(4);
				SFlags(6) <= FAdc(5);
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00010010" or control = "01010010"then --DEC
				Word2 <= '0';
				SOperand1 <= OutputDec;
				SFlags(6) <= FDec(0);
				SFlags(7) <= FDec(1);
				SFlags(11) <= FDec(2);
				SFlags(2) <= FDec(3);
				SFlags(4) <= FDec(4);
				SFlags(0) <= '0';
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
			
			elsif control = "00010011" or control = "01010011" then --DIV
				SOperand1 <= SDiv1;
				SOperand2 <= SDiv2;
				Word2 <= '1';		
			
			elsif control = "00010100" or control = "01010100" then --IDIV
				SOperand1 <= SIdiv1;
				SOperand2 <= SIdiv2;
				Word2 <= '1';	
			
			elsif control = "00010101" or control = "01010101"then --INC
				SOperand1 <= SInc;
				SFlags(6) <= FInc(0);
				SFlags(7) <= FInc(1);
				SFlags(11) <= FInc(2);
				SFlags(2) <= FInc(3);
				SFlags(4) <= FInc(4);
				SFlags(0) <= '0';
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00010110" then --LAHF
				SOperand1 <= Slahf;
			
			elsif control = "00010111" then		--MUL
				SOperand1 <= SMul1;
				SOperand2 <= SMul2;
				SFlags(0) <= Fmul(0);
				SFlags(11) <= Fmul(1);
				SFlags(15 downto 12) <= "0000";
				SFlags(10 downto 1) <= "0000000000";
				Word2 <= '1';
				
			elsif control = "00011000" then  --- Mulb
				SOperand1 <= SMulb;
				SFlags(0) <= Fmul(0);
				SFlags(11) <= Fmul(1);
				SFlags(15 downto 12) <= "0000";
				SFlags(10 downto 1) <= "0000000000";
				Word2 <= '0';
			elsif control = "00011001" or control = "01011001" then --Neg
				SOperand1 <= SNeg;
				SFlags(6) <= FNeg(0);
				SFlags(7) <= FNeg(1);
				SFlags(11) <= FNeg(2);
				SFlags(2) <= FNeg(3);
				SFlags(4) <= FNeg(4);
				SFlags(0) <= FNeg(5);
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00011010" or control = "01011010" then --Not
				SOperand1 <= SNot;

			elsif control = "00011011" then   -- Sahf
				SFlags(15 downto 8) <= Flags(15 downto 8);
				SFlags(5) <= Flags(5);
				SFlags(3) <= Flags(3);
				SFlags(1) <= Flags(1);
				SFlags(7) <= FSahf(7);
				SFlags(6) <= FSahf(6);
				SFlags(4) <= FSahf(4);
				SFlags(2) <= FSahf(2);
				SFlags(0) <= FSahf(0);
				Word2 <= '0';
			elsif control = "00011100" or control = "01011100" then --Xor
				SOperand1 <= SXOR;
			
			elsif control = "00011101" or control = "01011101" then --And
				SOperand1 <= SAnd;
				SFlags(6) <= FAnd(0);
				SFlags(7) <= FAnd(1);
				SFlags(2) <= FAnd(2);
				SFlags(4) <= '0';
				SFlags(0) <= '0';
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00011110" or control = "01011110" then -- Or
				SOperand1 <= SOr;
				Word2 <= '0';
			elsif control = "00011111" then --Rol
				SOperand1 <= SRol;
				SFlags(11) <= FRol;
				SFlags(10 downto 0) <= "00000000000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00100000" then --Ror
				SOperand1 <= SRor;
				SFlags(11) <= FRor;
				SFlags(10 downto 0) <= "00000000000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00100001" then --Sar
				SOperand1 <= SSar;
				SFlags(11) <= FSar;
				SFlags(10 downto 0) <= "00000000000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			
			elsif control = "00100011" then  -- Shr
				SOperand1 <= SShr;
				SFlags(11) <= FShr;
				SFlags(10 downto 0) <= "00000000000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00100100" then --Test
				SFlags(6) <= FTest(0);
				SFlags(7) <= FTest(1);
				SFlags(2) <= FTest(2);
				SFlags(4) <= '0';
				SFlags(0) <= '0';
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00000001" then --aaa
				SOperand1 <= SAaa;
				SFlags(4) <= FAaa(0);
				SFlags(0) <= FAaa(1);
				SFlags(3 downto 1) <= "000";
				SFlags(15 downto 5) <= "00000000000";
				Word2 <= '0';
			
			elsif control = "00100111" then  --Daa
				SOperand1(7 downto 0) <= SDaa;
				SOperand1(15 downto 8) <= "00000000";
				SFlags(0) <=  FDaa(0);
				SFlags(6) <=  FDaa(1);
				SFlags(7) <=  FDaa(2);
				SFlags(2) <=  FDaa(3);
				SFlags(4) <=  FDaa(4);
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(15 downto 8) <= "00000000";
				Word2 <= '0';
			elsif control = "00101000" then --Aas
				SOperand1 <= SAas;
				SFlags(4) <= FAas(0);
				SFlags(0) <= FAas(1);
				SFlags(3 downto 1) <= "000";
				SFlags(15 downto 5) <= "00000000000";
				Word2 <= '0';
				
			elsif control = "00101001" then
				SOperand1 <= SAam;
				SFlags(6) <= FAam(0);
				SFlags(7) <= FAam(1);
				SFlags(2) <= FAam(2);
				SFlags(4) <= '0';
				SFlags(0) <= '0';
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
			elsif control = "00101010" then
				SOperand1 <= SAad;
				SFlags(6) <= FAad(0);
				SFlags(7) <= FAad(1);
				SFlags(2) <= FAad(2);
				SFlags(4) <= '0';
				SFlags(0) <= '0';
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
				Word2 <= '0';
				
			elsif control = "00101011" then --Cmp
				Word2 <= '0';
				SFlags(6) <= FCmp(0);
				SFlags(7) <= FCmp(1);
				SFlags(11) <= FCmp(2);
				SFlags(2) <= FCmp(3);
				SFlags(4) <= FCmp(4);
				SFlags(0) <= FCmp(5);
				SFlags(1) <= '0';
				SFlags(3) <= '0';
				SFlags(5) <= '0';
				SFlags(10 downto 8) <= "000";
				SFlags(15 downto 12) <= "0000";
			
			elsif control = "00101100" then --CLC
				SFlags(0) <= '0';
				SFlags(15 downto 1) <= Flags (15 downto 1);
			
			elsif control = "00101101" then --CMC
				SFlags(0) <= not Flags(0);
				SFlags(15 downto 1) <= Flags(15 downto 1);
				
			elsif control = "00101110" then --STC
				SFlags(0) <= '1';
				SFlags(15 downto 1) <= Flags(15 downto 1);



		end if;
--		SExtra <= SOperand1; --Output
		if Word2 = '1' then 
			--Output <= SOperand2;
			SExtra <= SOperand2;
		else
			SExtra <= SOperand1;
		end if;	
end process;
--SExtra <= Output;

end behavioral;