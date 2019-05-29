----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:59 05/07/2019 
-- Design Name: 
-- Module Name:    Processor - Behavioral 
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

entity Processor is
	 generic (N: natural := 16);
    Port ( 
			  Ck : in std_logic;
			  Rst : in std_logic;
			  EN : in std_logic;
			  Wo : out std_logic;
			  Do : out std_logic_vector(N-1 downto 0);
           Awo : out std_logic_vector(N-1 downto 0)
	);
end Processor;

architecture Behavioral of Processor is

	Component Pipeline Port ( 
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
	end Component;
	
	Component UAL port(
		A: in std_logic_vector (N-1 downto 0);
		B: in std_logic_vector (N-1 downto 0);
		Op: in std_logic_vector (N/2-1 downto 0);
		S: out std_logic_vector (N-1 downto 0);
		N, O, C, Z: out std_logic
	);
	end Component;
	
	Component Registers port(
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
	end Component;
	
	Component Decode  port ( 
			 ins_di : in  std_logic_vector(N*2-1 downto 0);
			 A : out std_logic_vector((N)-1 downto 0);
			 B : out std_logic_vector((N)-1 downto 0);
			 C : out std_logic_vector((N)-1 downto 0);
			 OP : out std_logic_vector((N/2)-1  downto 0)
	);
	end Component;
	
	Component MI port (
		ins_a : in std_logic_vector (N-1 downto 0);
		ins_di : out std_logic_vector (N*2-1 downto 0)
	);
	end Component;
	
	Component MD port (
		Ck : in std_logic;
		addr : in std_logic_vector (N-1 downto 0); 
		data_in : in std_logic_vector (N-1 downto 0);
		W : in std_logic;
		data_out : out std_logic_vector (N-1 downto 0);
		RST : in std_logic
	);
	end Component;
	
	type stageRecord is record
			op : std_logic_vector(N/2-1 downto 0);
			a, b, c : std_logic_vector(N-1 downto 0);
	end record stageRecord;
	
	signal mibr_out, br_out,brual_out, ualmd_out, mdbr_out, decode_out : stageRecord;
	signal IP : std_logic_vector(N-1 downto 0) := (others => '0');
	signal ins_di : std_logic_vector(N*2-1 downto 0);
	signal Wbr : std_logic;
	signal Wmd : std_logic;
	signal mux_out_BR : std_logic_vector(N-1 downto 0);
	signal QA_out : std_logic_vector(N-1 downto 0);
	signal QB_out : std_logic_vector(N-1 downto 0);
	signal mux_out_ALU : std_logic_vector(N-1 downto 0);
	signal mux_data_BR: std_logic_vector(N-1 downto 0);
	signal mux_addr_MD : std_logic_vector(N-1 downto 0);
	signal ALUo : std_logic_vector(N-1 downto 0);
	signal MD_out : std_logic_vector(N-1 downto 0);

begin
	--MUX bit write du banc de registre, 1 quand COP == AFC, sinon 0
	Wbr <= '1' when mdbr_out.op = x"06" or mdbr_out.op = x"01" or mdbr_out.op = x"02" or mdbr_out.op = x"03" or mdbr_out.op = x"04" else '0';
	--MUX bit write de la mémoire de données, 1 quand COP == STORE, 0 sinon
	Wmd <= '1' when ualmd_out.op = x"08" else '0';
	--MUX pour la valeur de B en in au niveau du Pipeline BR->UAL, on prend la sortie Qa de BR quand COP == "LOAD"
	mux_out_BR <= QA_out when mibr_out.op = x"01" or mibr_out.op = x"02" or mibr_out.op = x"03" or mibr_out.op = x"08" else mibr_out.b;
	--MUX pour la valeur de B en in au niveau du Pipeline UAL->MD, on prend la sortie de l'ALU quand on s'en sert, 
	--sinon B en sortie du Pipeline BR->UAL
   mux_out_ALU <=  ALUo when brual_out.op = x"01" or brual_out.op = x"02" or brual_out.op = x"03" or  brual_out.op = x"04" else brual_out.b;
	--MUX pour DATA en entrée de BR, prend la sortie de la MD quand COP == LOAD, sinon B en sortie du Pipeline MD->BR
	mux_data_BR <= MD_out when mdbr_out.op = x"07" else mdbr_out.b;
	--MUX pour addr en entrée de MD, prend A en sortie du Pipeline ALU->MD quand quand COP == STORE, sinon B.
	mux_addr_MD <= ualmd_out.a when ualmd_out.op = x"08" else ualmd_out.b;
	--Mémoire d'instructions
	MEMINS: MI port map(IP,ins_di);
	--Bloc Decode
	DEC: Decode port map(ins_di, decode_out.a,decode_out.b,decode_out.c,decode_out.op);
	--Pipeline de la mémoire d'instructions aux registres
	MIBR: Pipeline	port map(Ck,decode_out.op,decode_out.a,decode_out.b,decode_out.c,mibr_out.op,mibr_out.a,mibr_out.b,mibr_out.c);
	--Registres
	BR: Registers port map(Ck,RST,mibr_out.b(3 downto 0),mibr_out.c(3 downto 0),mdbr_out.a(3 downto 0),QA_out,QB_out,Wbr,mux_data_BR);
	--Pipeline des registres à l'ALU
	BRUAL: Pipeline port map(Ck,mibr_out.op,mibr_out.a,mux_out_BR,QB_out,brual_out.op,brual_out.a,brual_out.b,brual_out.c);
	--ALU
	ALU: UAL port map(brual_out.b,brual_out.c,brual_out.op,ALUo);
	--Pipeline de la mémoire d'instructions aux registres
	UALMD: Pipeline port map(Ck,brual_out.op,brual_out.a, mux_out_ALU,x"0000",ualmd_out.op,ualmd_out.a,ualmd_out.b,open);
	--Mémoire des données
	DM: MD port map (Ck, mux_addr_MD, ualmd_out.b, Wmd, MD_out, RST);
	--Pipeline de la mémoire d'instructions aux registres
	MDBR: Pipeline port map(Ck, ualmd_out.op, ualmd_out.a, ualmd_out.b, x"0000", mdbr_out.op, mdbr_out.a, mdbr_out.b, open);

	process
	begin
		wait until Ck'event and Ck = '1';
		if EN = '1' then
			IP <= IP + x"01";
		end if;
	end process;

   Wo <= Wbr;
   Do <= mdbr_out.b;
   Awo <= mdbr_out.a;

end Behavioral;

