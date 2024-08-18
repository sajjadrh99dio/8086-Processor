LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Register16 IS PORT(
    d   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    w  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    q   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END Register16;

ARCHITECTURE behavioral OF Register16 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '0' then
            q <= "0000000000000000";
        elsif rising_edge(clk) then
            if w = '1' then
                q <= d;
            end if;
        end if;
    end process;
END behavioral;