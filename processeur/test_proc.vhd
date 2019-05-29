--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:00:42 05/29/2019
-- Design Name:   
-- Module Name:   /home/maupu/Bureau/ProjetSystemeInfo/processeur/test_proc.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Processor
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
 
ENTITY test_proc IS
END test_proc;
 
ARCHITECTURE behavior OF test_proc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Processor
    PORT(
         Ck : IN  std_logic;
         Rst : IN  std_logic;
			En : IN std_logic;
         Wo : OUT  std_logic;
         Do : OUT  std_logic_vector(15 downto 0);
         Awo : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Ck : std_logic := '0';
   signal Rst : std_logic := '0';
	signal En : std_logic := '0';

 	--Outputs
   signal Wo : std_logic;
   signal Do : std_logic_vector(15 downto 0);
   signal Awo : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant Ck_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Processor PORT MAP (
          Ck => Ck,
          Rst => Rst,
			 En => En,
          Wo => Wo,
          Do => Do,
          Awo => Awo
        );

   -- Clock process definitions
   Ck_process :process
   begin
		Ck <= '0';
		wait for Ck_period/2;
		Ck <= '1';
		wait for Ck_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RST <= '0';
      wait for 10 ns;	
		
		RST <= '1';
		En <= '1';
      wait for 200 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
