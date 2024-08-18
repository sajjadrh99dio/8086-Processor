library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Datapath is
  port (
	clock 										: in std_logic;
	reset 										: in std_logic;
	Force_en										: in std_logic;
   ForceAX, ForceBX, ForceCX,
	ForceDX, ForceSP, ForceBP,
	ForceDI, ForceSI							: in  std_logic_vector(15 downto 0);
	ForceCS, ForceDS, ForceSS,
	ForceES, ForceIP, ForceI1,
	ForceI2, ForceI3							: in  std_logic_vector(15 downto 0);
	OutputAX, OutputBX, OutputCX,
	OutputDX, OutputSP, OutputBP,
	OutputDI, OutputSI						: out std_logic_vector(15 downto 0);
	OutputCS, OutputDS, OutputSS,
	OutputES, OutputIP, OutputI1,
	OutputI2, OutputI3						: out std_logic_vector(15 downto 0);
	FlagsOut										: out std_logic_vector(15 downto 0)
    );
end Datapath;
 
architecture description of Datapath is






















































end description;