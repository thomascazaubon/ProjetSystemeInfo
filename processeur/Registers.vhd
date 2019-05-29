----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:59:46 05/07/2019 
-- Design Name: 
-- Module Name:    Registers - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers is
	 generic (N: natural := 16);
    Port ( 
			  Ck : in  std_logic;
			  RST : in std_logic;
			  AA : in std_logic_vector(3 downto 0);
			  AB : in std_logic_vector(3 downto 0);
			  AW : in std_logic_vector(3 downto 0);
			  QA : out std_logic_vector(N-1 downto 0);
			  QB : out std_logic_vector(N-1 downto 0);
			  W : in std_logic;
			  DATA : in std_logic_vector(N-1 downto 0)
	);
end Registers;

architecture Behavioral of Registers is
type Tabreg is array (0 to N-1) of std_logic_vector(N-1 downto 0);
Signal reg : Tabreg;
begin
	QA <= reg(to_integer(unsigned(AA))) when W = '0' or AW /= AA else DATA;
	QB <= reg (to_integer(unsigned(AB))) when W = '0' or AW /= AB else DATA;
	process
	begin
		wait until Ck'event and Ck = '1';
		if (RST = '0') then
			reg <= (others => (others => '0'));
		end if;
		if (W = '1') then
			reg (to_integer(unsigned(AW))) <= DATA;
		end if;
	end process;
end Behavioral;

