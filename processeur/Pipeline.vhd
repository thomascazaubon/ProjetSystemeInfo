----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:18:20 05/07/2019 
-- Design Name: 
-- Module Name:    Pipeline - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pipeline is
	 generic (N: natural := 16);
    Port ( 
			  Ck : in std_logic;
			  OPi : in  std_logic_vector(N/2-1 downto 0);
           Ai : in  std_logic_vector(N-1 downto 0);
           Bi : in  std_logic_vector(N-1 downto 0);
           Ci : in  std_logic_vector(N-1 downto 0);
           OPo : out  std_logic_vector(N/2-1 downto 0);
           Ao : out  std_logic_vector(N-1 downto 0);
           Bo : out  std_logic_vector(N-1 downto 0);
           Co : out  std_logic_vector(N-1 downto 0)
	);
end Pipeline;

architecture Behavioral of Pipeline is

begin
	process
	begin
		wait until Ck'event and Ck = '1';
		OPo <= OPi;
		Ao <= Ai;
		Bo <= Bi;
		Co <= Ci;
	end process;
end Behavioral;

