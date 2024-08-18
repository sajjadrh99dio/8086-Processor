library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all ;

entity XCHG86 is
	port(
		Source1: in std_logic_vector(7 downto 0);
		Source2: in std_logic_vector(7 downto 0);
		Destiny:  out std_logic_vector(15 downto 0)
	);
	end XCHG86;
	 
architecture behavioral of XCHG86 is
	--signal temp :std_logic_vector(15 downto 0);

	begin
		--temp<= destiny;
		destiny <= source2 & source1;
		--source <= temp;

end behavioral;