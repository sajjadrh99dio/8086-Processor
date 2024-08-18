LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Register8 IS PORT(
    d   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    w  : IN STD_LOGIC;
    clr : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    q   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END Register8;

ARCHITECTURE description OF Register8 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '0' then
            q <= "00000000";
        elsif rising_edge(clk) then
            if w = '1' then
                q <= d;
            end if;
        end if;
    end process;
END description;