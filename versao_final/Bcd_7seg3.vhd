LIBRARY IEEE;
use ieee.std_logic_1164.all;


-- Testado e fornecido com pinagem para Kit Terasic Altera DE2:
Entity Bcd_7seg3 is
   port (
		entrada3: in std_logic_vector (3 downto 0);
		saida3:	out std_logic_vector (6 downto 0)
	);
end Bcd_7seg3;

architecture with_select_bcd7seg3 of Bcd_7seg3 is
begin
  with entrada3 select
  saida3 <=  
		 "1000000" when "0000", --0
	    "1111001" when "0001", --1
	    "0100100" when "0010", --2
	    "0110000" when "0011", --3
	    "0011001" when "0100", --4
	    "0010010" when "0101", --5
	    "0000010" when "0110", --6
	    "1111000" when "0111", --7
	    "0000000" when "1000", --8
	    "0011000" when "1001", --9
	    "1110111" when "1010", --A
	    "0001000" when "1011", --b
	    "0100111" when "1100", --C
	    "0111101" when "1101", --d
	    "0000110" when "1110", --E
	    "0001110" when "1111", --f
	    "1111111" when others;
	
end with_select_bcd7seg3;
				
				
		