library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity ADD86 is
	port(
		clk, control, controlByte: in std_logic;
		A, B : in std_logic_vector(15 downto 0);
		AByte, BByte: in std_logic_vector(7 downto 0);
		AF, CF, overflow, PF, SF, ZF: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);
	end ADD86;
	
architecture behavioral of ADD86 is

	signal S :std_logic_vector(15 downto 0);
	signal X1, X2 , Y, SByte :std_logic_vector(7 downto 0);
	signal half1, half2, half3: std_logic_vector(4 downto 0);
	signal temp, temp2 :std_logic;

	begin
		process(clk)
		begin
		
		if controlByte = '1' then
			
			if (control = '1') then
				S <= A - B;
			else 
				S <= A + B;
			end if;
			ZF <= '0';
			SF <= '0';
			Overflow <= '0';
			AF <= '0';
			CF <='0';

			
			Output <= S;
			PF <= not(S(0) xor S(1) xor S(2) xor S(3) xor S(4) xor S(5) xor S(6) xor S(7) xor S(8)xor S(9)xor S(10)xor S(11)xor S(12)xor S(13)xor S(14)xor S(15));
			if(S = 0) then
				ZF <= '1';
			end if;
			temp <=(A(15)and B(15)) and (not(S(15)));
			if(temp = '1') then
				Overflow <= '1';
				else
					if S(15) = '1' then
						SF <= '1';
					end if;
			end if;
			half1(4) <= '0';
				half2(4) <= '0';
				half1(3 downto 0) <= A(3 downto 0);
				half2(3 downto 0) <= B(3 downto 0);
				half3 <= half1 + half2;
				if (half3(4) = '1') then
					AF <='1';
				end if;
			temp2 <=(A(15)and B(15)) and (not(S(15)));
			if (temp2 = '1') then
				CF <= '1';
			end if;
			
			else 
			
			if control = '1' then
					SByte <= AByte - BByte;
				else
					SByte <= AByte + BByte;
				end if;

				ZF <= '0';
				SF <= '0';
				Overflow <= '0';
				AF <= '0';
				CF <='0';

				Output(7 downto 0) <= SByte;
				if(SByte(7) = '1') then
					Output(15 downto 8) <= "11111111";
				else
					Output(15 downto 8) <= "00000000";
				end if;
				PF <= not(SByte(0) xor SByte(1) xor SByte(2) xor SByte(3) xor SByte(4) xor SByte(5) xor SByte(6) xor SByte(7));
				if(S = 0) then
					ZF <= '1';
				end if;
				temp <=(A(7)and B(7)) and (not(S(7)));
				if(temp = '1') then
					Overflow <= '1';
					else
						if S(7) = '1' then
							SF <= '1';
						end if;
				end if;
				--X1 <= A(7 downto 0);
				--X2 <= B(7 downto 0);
				--Y <= X1 + X2 ;
				half1(4) <= '0';
				half2(4) <= '0';
				half1(3 downto 0) <= AByte(3 downto 0);
				half2(3 downto 0) <= BByte(3 downto 0);
				half3 <= half1 + half2; 
				if (half3(4) = '1') then
					AF <='1';
				end if;
				temp2 <=(AByte(7)and BByte(7)) and (not(SByte(7)));
				if (temp2 = '1') then
					CF <= '1';
				end if;
			end if;
		end process;
end behavioral;