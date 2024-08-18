library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity INC86 is
	port(
		clk: in std_logic;
		A :in std_logic_vector(15 downto 0);
		AByte : in std_logic_vector(7 downto 0);
		ByteControl : in std_logic;
		zero, SF, Overflow, Parity, AF: out std_logic;
		Output:  out std_logic_vector(15 downto 0)
	);
	end INC86;
	
architecture behavioral of INC86 is
	signal S :std_logic_vector(15 downto 0);
	signal Y :std_logic_vector(7 downto 0);
	signal half1, half2: std_logic_vector(4 downto 0);

	begin
		process(clk)
		begin
		if ByteControl = '1' then
			S <= A + 1;
			Overflow <= '0';
			zero <= '0';
			SF <= '0';
			AF <= '0';
			--0 1 2 4 7 8 11 13 14 16 19 21 22 25 26 28 31 32 35 37 38 41 42 44 47 49 50 52 55 56 59 61 62 64 67 69 70 73 74 76 79 81 82 84 87 88 91 93 94 97 98 100 103 104
			Parity <= not(S(0) xor S(1) xor S(2) xor S(3) xor S(4) xor S(5) xor S(6) xor S(7) xor S(8)xor S(9)xor S(10)xor S(11)xor S(12)xor S(13)xor S(14)xor S(15));
			if(S = 0) then
				zero <= '1';
			end if;
			if(A = "011111111111111")then
				Overflow <= '1';
				else
					if S(15) = '1' then
						SF <= '1';
					end if;
			end if;
				half1(4) <= '0';
				half1(3 downto 0) <= A(3 downto 0);
				half2 <= half1 + 1;
				if (half2(4) = '1') then
					AF <='1';
				end if;
			else
			
			S(7 downto 0) <= AByte + 1;
			S(15 downto 8) <= "00000000";
			Overflow <= '0';
			zero <= '0';
			SF <= '0';
			AF <= '0';
			--0 1 2 4 7 8 11 13 14 16 19 21 22 25 26 28 31 32 35 37 38 41 42 44 47 49 50 52 55 56 59 61 62 64 67 69 70 73 74 76 79 81 82 84 87 88 91 93 94 97 98 100 103 104
			Parity <= not(S(0) xor S(1) xor S(2) xor S(3) xor S(4) xor S(5) xor S(6) xor S(7) xor S(8)xor S(9)xor S(10)xor S(11)xor S(12)xor S(13)xor S(14)xor S(15));
			if(S = 0) then
				zero <= '1';
			end if;
			if(AByte = "01111111")then
				Overflow <= '1';
				else
					if S(7) = '1' then
						SF <= '1';
					end if;
			end if;
				half1(4) <= '0';
				half1(3 downto 0) <= AByte(3 downto 0);
				half2 <= half1 + 1;
				if (half2(4) = '1') then
					AF <='1';
				end if;
			end if;
		end process;
		Output <= S;
end behavioral;