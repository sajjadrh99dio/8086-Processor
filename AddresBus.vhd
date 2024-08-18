LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY AddressBus IS PORT(
    SegmentBase, Offset : IN STD_LOGIC_VECTOR(15 downto 0);
	 IP						: IN STD_LOGIC_VECTOR(15 downto 0);
	 Address 				: OUT STD_LOGIC_VECTOR(19 downto 0);
	 IPpp						: OUT STD_LOGIC_VECTOR(15 downto 0);
	 JUMP_ADDR     		: in std_logic_vector (7 downto 0);
	 JUMP_INST_TO_IP 		: in std_logic
);
END AddressBus;

ARCHITECTURE behavioral OF AddressBus IS
begin
				--Address <= (SegmentBase&"0000") + ("0000"&Offset);
				
				
				with JUMP_INST_TO_IP select
						Address <= (SegmentBase&"0000") + ("000000000000"&JUMP_ADDR)  when '1',
										(SegmentBase&"0000") + ("0000"&Offset)				when others;
				
				
				
				with JUMP_INST_TO_IP select
						IPpp <= ("00000000"&JUMP_ADDR ) when '1',
								  (IP + "0000000000000001") 				       when others;
				
end behavioral;