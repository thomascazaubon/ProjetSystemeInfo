----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:48:28 05/29/2019 
-- Design Name: 
-- Module Name:    MD - Behavioral 
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

entity MD is
	generic(N : natural := 16 ; TAILLE : natural := 8);
	Port (
		Ck : in std_logic;
		addr : in std_logic_vector (N-1 downto 0); 
		data_in : in std_logic_vector (N-1 downto 0);
		W : in std_logic;
		data_out : out std_logic_vector (N-1 downto 0);
		RST : in std_logic
	);
end MD;

architecture Behavioral of MD is
	type Tabmem is array (0 to 2**TAILLE-1) of std_logic_vector(N-1 downto 0);
	Signal mem : Tabmem;
begin
	data_out <= mem (to_integer(unsigned(addr)));
	process
	begin
		wait until Ck'event and Ck = '1';
		if (RST = '0') then
			mem <= (others => (others => '0'));
		end if;
		if (W = '1') then
			mem (to_integer(unsigned(addr))) <= data_in;
		end if;
	end process;
end Behavioral;

