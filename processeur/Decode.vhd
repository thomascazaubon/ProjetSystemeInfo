----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:54:24 05/13/2019 
-- Design Name: 
-- Module Name:    Decode - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;+
--use UNISIM.VComponents.all;

entity Decode is
	generic (N: natural := 32);
   Port ( 
			 ins_di : in  std_logic_vector(N-1 downto 0);
			 A : out std_logic_vector((N/2)-1 downto 0);
			 B : out std_logic_vector((N/2)-1 downto 0);
			 C : out std_logic_vector((N/2)-1 downto 0);
			 OP : out std_logic_vector((N/4)-1  downto 0)
	);
end Decode;

architecture Behavioral of Decode is
	signal OPStmp: std_logic_vector ((N/4)-1 downto 0);
begin
	
	process(ins_di, OPStmp)
	begin 
		
		OPStmp <= ins_di(N-1 downto (N/4)*3);
		Op <= OPStmp;
		
		if (OPStmp = x"06" or OPStmp = x"07") then
			A <= x"00" & ins_di(((N/4)*3)-1 downto (N/4)*2);
			B <= x"00" & ins_di(((N/4)*2)-1 downto (N/4)*1);
			
		elsif (OPStmp = x"08") then
			A <= x"00" & ins_di(((N/4)*3)-1 downto (N/4)*2);
			B <= x"00" & ins_di(((N/4)*2)-1 downto (N/4)*1);
			
		elsif (OPStmp = x"0E") then
			A <= ins_di(((N/4)*3)-1 downto (N/4)*1);
		
		elsif (OPStmp = x"0F") then
			A <= ins_di(((N/4)*3)-1 downto (N/4)*1);
			B <= x"00" & ins_di(((N/4)*1)-1 downto 0);
		else
			A <= x"00" & ins_di(((N/4)*3)-1 downto (N/4)*2);
			B <= x"00" & ins_di(((N/4)*2)-1 downto (N/4)*1);
			C <= x"00" & ins_di(((N/4)*1)-1 downto 0);
		end if;
		
	end process;

end Behavioral;

