--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:26:48 05/10/2019
-- Design Name:   
-- Module Name:   /home/maupu/Bureau/ProjetSystemeInfo/processeur/alu_tb.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UAL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UAL
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         Op : IN  std_logic_vector(7 downto 0);
         S : OUT  std_logic_vector(15 downto 0);
         N : OUT  std_logic;
         O : OUT  std_logic;
         C : OUT  std_logic;
         Z : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal Op : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal S : std_logic_vector(15 downto 0);
   signal N : std_logic;
   signal O : std_logic;
   signal C : std_logic;
   signal Z : std_logic;

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UAL PORT MAP (
          A => A,
          B => B,
          Op => Op,
          S => S,
          N => N,
          O => O,
          C => C,
          Z => Z
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		A <= x"0008";
		B <= x"0002";
		Op <= x"01";

      wait for 100 ns;

		A <= x"0002";
		B <= x"0003";
		Op <= x"02";
		
		wait for 100 ns;
      -- insert stimulus here 

      wait;
   end process;

END;
