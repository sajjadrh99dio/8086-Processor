
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RegisterTemp IS PORT(
    inp1, inp2 : in std_LOGIC_VECTOR(15 downto 0);
	 clr, w1, w2: IN STD_LOGIC;
    clk : IN STD_LOGIC;
    Output1, Output2 , Output3, Output4: out std_LOGIC_VECTOR(15 downto 0)
);
END RegisterTemp;

ARCHITECTURE behavioral OF RegisterTemp IS
signal R1,R2: STD_LOGIC_VECTOR(15 DOWNTO 0);
	
component Register16 IS PORT(
    d   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    w  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    q   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
end component;

begin

	RegR1 : Register16 port map (inp1, w1, clr, clk, R1);

	RegR2 : Register16 port map (inp2, w2, clr, clk, R2);
	
	Output1 <= R1;

	Output2 <= R2;
			
	Output3 <= R1;
				
	Output4 <= R2;



end behavioral;



