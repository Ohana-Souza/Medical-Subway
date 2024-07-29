library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity Registrador is
   generic (
      W : integer := 4 -- largura do registrador (número de bits)
   );
   port (
      clk		 : in std_logic; -- clock
      REG_Reset : in std_logic; -- reset
      REG_Enable : in std_logic; -- enable
      REG_DataIN : in std_logic_vector(W - 1 downto 0); -- dado de entrada
      REG_DataOUT : out std_logic_vector(W - 1 downto 0) -- dado de saída
   );
end Registrador;

architecture Behavioral of Registrador is
begin
    process(clk,REG_Reset)
    begin
        if REG_Reset = '1' then
            REG_DataOUT <= STD_LOGIC_VECTOR(to_unsigned(0,W));
        elsif rising_edge(clk) then
			  if REG_Enable = '1' then
					REG_DataOUT <= REG_DataIN;       
			  end if;
			end if;
    end process;
end Behavioral;