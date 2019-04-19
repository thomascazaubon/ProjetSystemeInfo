----------------------------------------------------------------------------------
-- Company: Maupu & co
-- Engineer: 
-- 
-- Create Date:    13:43:50 04/19/2019 
-- Design Name: 
-- Module Name:    UAL - Behavioral 
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

entity UAL is
	generic (N: natural := 16);
	port(
		A: in std_logic_vector (N-1 downto 0);
		B: in std_logic_vector (N-1 downto 0);
		Op: in std_logic_vector (N/2-1 downto 0);
		S: out std_logic_vector (N-1 downto 0);
		N, O, C, Z: out std_logic
	);
end UAL;

architecture Behavioral of UAL is
	signal Stmp: std_logic_vector (N downto 0);
	signal StmpMul: std_logic_vector (N*2 downto 0);
begin

	Stmp <= ('0' & A) + ('0' & B) when Op = x"01" else
			  ('0' & A) - ('0' & B) when Op = x"03" else
			  ('0' & A) / ('0' & B) when Op = x"04" else
		(others => '0');
	StmpMul <= A * B when Op = x"02" else
		(others => '0');
		
	C <= Stmp(N);	
	-- Le flag d'overflow passe à 1 quand on fait une addition 
	-- avec A et B de même signe et Stmp de signe différent 
	O <= '1' when (A(N) = B(N) and A(N) /= Stmp(N) and Op = x"01")
			 or (StmpMul(N*2 - 1 downto N) > 0  and Op = x"02");
		
end Behavioral;

