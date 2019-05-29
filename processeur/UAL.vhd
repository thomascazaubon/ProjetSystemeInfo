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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAL is
	generic (MAX: natural := 16);
	port(
		A: in std_logic_vector (MAX-1 downto 0);
		B: in std_logic_vector (MAX-1 downto 0);
		Op: in std_logic_vector (MAX/2-1 downto 0);
		S: out std_logic_vector (MAX-1 downto 0);
		N, O, C, Z: out std_logic
	);
end UAL;

architecture Behavioral of UAL is
	signal Stmp: std_logic_vector (MAX downto 0);
	signal StmpMul: std_logic_vector (MAX*2-1 downto 0);
begin
	
	StmpMul <= A * B when Op = x"02" else
		(others => '0');
		
	Stmp <= ('0' & A) + ('0' & B) when Op = x"01" else
			  ('0' & A) - ('0' & B) when Op = x"03" else
			  StmpMul(MAX downto 0) when Op = x"02" else
			  --('0' & A) / ('0' & B) when Op = x"04" else
		(others => '0');
		
	S <= Stmp(MAX-1 downto 0);	
		
	C <= Stmp(MAX);	
	N <= Stmp(MAX-1) when Op /= x"02" else
			StmpMul(MAX-1) when Op = x"02";
	Z <= '1' when (Stmp = 0 and Op /= x"02") or
			(StmpMul = 0 and Op = x"02") else '0';
	-- Le flag d'overflow passe à 1 quand on fait une addition 
	-- avec A et B de même signe et Stmp de signe différent 
	O <= '1' when (A(MAX-1) = B(MAX-1) and A(MAX-1) /= Stmp(MAX-1) and Op = x"01")
			 or (StmpMul(MAX*2 - 1 downto MAX) > 0  and Op = x"02") else '0';
		
end Behavioral;

