--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:43:33 05/13/2019
-- Design Name:   
-- Module Name:   /home/maupu/Bureau/ProjetSystemeInfo/processeur/test_reg.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Registers
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
 
ENTITY test_reg IS
END test_reg;
 
ARCHITECTURE behavior OF test_reg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Registers
    PORT(
         Ck : IN  std_logic;
         RST : IN  std_logic;
         AA : IN  std_logic_vector(3 downto 0);
         AB : IN  std_logic_vector(3 downto 0);
         AW : IN  std_logic_vector(3 downto 0);
         QA : OUT  std_logic_vector(15 downto 0);
         QB : OUT  std_logic_vector(15 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Ck : std_logic := '0';
   signal RST : std_logic := '0';
   signal AA : std_logic_vector(3 downto 0) := (others => '0');
   signal AB : std_logic_vector(3 downto 0) := (others => '0');
   signal AW : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal QA : std_logic_vector(15 downto 0);
   signal QB : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant Ck_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Registers PORT MAP (
          Ck => Ck,
          RST => RST,
          AA => AA,
          AB => AB,
          AW => AW,
          QA => QA,
          QB => QB,
          W => W,
          DATA => DATA
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
      wait for 100 ns;	
			AW <= x"1";
			W <= '1';
			DATA <= x"0022";
			--AA <= x"1";
		wait for 200 ns;	
		
			AA <= x"1";
		wait for 200 ns;	
		
      wait;
   end process;

END;
