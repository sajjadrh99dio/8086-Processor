library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity InstructionQueue is
  port (
    reset 	: in std_logic;
    clk     : in std_logic;
    w   			:in  std_logic;
    inp 	: in  std_logic_vector(7 downto 0);
    full   	: out std_logic;
    r   : in  std_logic;
    Output : out std_logic_vector(7 downto 0);
    empyt   : out std_logic;
	 address_value : in std_logic_vector (7 downto 0);
	 JUMP_SIGNAL   : in std_logic;
	 JUMP_ADDR     : in std_logic_vector (7 downto 0);
	 JUMP_INST_TO_IP : out std_logic
    );
end InstructionQueue;
 
architecture description of InstructionQueue is
 
	type type_queue is array (0 to 5) of std_logic_vector(7 downto 0);
	signal vector_queue 		: type_queue := (others => (others => '0'));
	signal queue_IPholder 		: type_queue := (others => (others => '0'));
	signal Output_partial 	: std_logic_vector(7 downto 0);
	signal index_read   	: integer range 0 to 5 := 0;
	signal index_write   	: integer range 0 to 5 := 0;
	signal w_full  			: std_logic :='0';
	signal w_empyt 			: std_logic :='1';
	signal clear_queue 		: std_logic :='0';
	signal JUMP_INST_TO_IP_signal       : std_logic  := '0';
   
begin
 
  QUEUE_EXECUTION : process (clk, reset,JUMP_SIGNAL) is
	VARIABLE counter 		: integer range -1 to 6 := 0;
  begin
	if(reset = '0') then
        counter := 0;
        index_read   <= 0;
        index_write   <= 0;
		  clear_queue<= '0';
		  w_full <= '0';
		  w_empyt <= '1';
		  JUMP_INST_TO_IP_signal<= '0';
		  vector_queue<= (others => (others => '0'));
		  queue_IPholder<= (others => (others => '0'));
		  
-- JUMP ADD BEGIN		  
	elsif(JUMP_SIGNAL ='1') then
		if 	(queue_IPholder(0) = JUMP_ADDR ) then 
					index_read <= 0;
		elsif (queue_IPholder(1) = JUMP_ADDR) then 
					index_read <= 1;
		elsif (queue_IPholder(2) = JUMP_ADDR) then 
					index_read <= 2;
		elsif (queue_IPholder(3) = JUMP_ADDR) then 
					index_read <= 3;					
		elsif (queue_IPholder(4) = JUMP_ADDR) then 
					index_read <= 4;
		elsif (queue_IPholder(5) = JUMP_ADDR) then 
					index_read <= 5;
		else
					JUMP_INST_TO_IP_signal <='1';
					clear_queue<= '1';
					w_full<='0';	-- to stop increamenting PC
		end if;
-- JUMP ADD END

		
	elsif (clk = '1' AND clk'EVENT) then
		if (clear_queue= '1') then
		  clear_queue<= '0';
		  counter := 0;
        index_read   <= 0;
        index_write   <= 0;
		  w_full <= '0';
		  w_empyt <= '1';
		  JUMP_INST_TO_IP_signal<='0';
		  vector_queue<= (others => (others => '0'));
		  queue_IPholder<= (others => (others => '0'));
		  else
			JUMP_INST_TO_IP_signal<='0';
			--write control
			if w = '1' AND w_full = '0' then
				vector_queue(index_write) <= inp;
				queue_IPholder(index_write) <= address_value;
				if index_write = 5 then
					index_write <= 0;
				else
					index_write <= index_write + 1;
				end if;
			end if;
			--read control
			if (r = '1' and w_empyt = '0') then
				Output_partial <= vector_queue(index_read);
				if index_read = 5 then
					index_read <= 0;
				else
					index_read <= index_read + 1;
				end if;
			end if;
			--read and write control
			if w = '1' and r = '1' and w_empyt = '1' then
				index_write <= 0;
				index_read <= 0;
				vector_queue(0) <= inp;
				queue_IPholder(0) <= address_value;
				Output_partial <= inp;
			end if;
			--quantity control
			if (w = '1' and r = '0' and w_full = '0') then
				if(counter = -1) then
					counter := 1;
				else
					counter := counter + 1;
				end if;
			elsif (w = '0' and r = '1' and w_empyt = '0') then
				counter := counter - 1;
			end if;
			--control signals
			if counter = 6 then
				w_full <= '1';
			else
				w_full <= '0';
			end if;
			
			if counter = 0 then
				w_empyt <= '1';
			else
				w_empyt <= '0';
			end if;
    end if;
	end if;
	Output 	<= Output_partial;
	full  <= w_full;
	empyt 	<= w_empyt;
  end process QUEUE_EXECUTION;
  
  
--  JUMP_INST_CHECK : process (JUMP_SIGNAL,queue_IPholder,JUMP_ADDR) is
--	begin
--	if(JUMP_SIGNAL ='1') then
--		if 	(queue_IPholder(0) = JUMP_ADDR ) then 
--					index_read <= 0;
--		elsif (queue_IPholder(1) = JUMP_ADDR) then 
--					index_read <= 1;
--		elsif (queue_IPholder(2) = JUMP_ADDR) then 
--					index_read <= 2;
--		elsif (queue_IPholder(3) = JUMP_ADDR) then 
--					index_read <= 3;					
--		elsif (queue_IPholder(4) = JUMP_ADDR) then 
--					index_read <= 4;
--		elsif (queue_IPholder(5) = JUMP_ADDR) then 
--					index_read <= 5;
--		else
--					JUMP_INST_TO_IP_signal <='1';
--		end if;
--	  end if;
--  end process	JUMP_INST_CHECK;	
--  
--  
  JUMP_INST_TO_IP <= JUMP_INST_TO_IP_signal;
  
end description;