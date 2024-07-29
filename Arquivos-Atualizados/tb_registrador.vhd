library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity tb_Registrador is
end tb_Registrador;
architecture teste of tb_Registrador is
component Registrador is
   generic (
      W : integer := 4 -- largura do registrador (número de bits)
   );
   port (
    --  clk : in std_logic; -- clock
      REG_Reset : in std_logic; -- reset
      REG_Enable : in std_logic; -- enable
      REG_DataIN : in std_logic_vector(W - 1 downto 0); -- dado de entrada
      REG_DataOUT : out std_logic_vector(W - 1 downto 0) -- dado de saída
   );
end component;
signal fio_Cl: std_logic :='0'; 
signal fio_Re, fio_e: std_logic;
signal fio_in, fio_ou: std_logic_vector(3 downto 0);
begin
instancia_Registrador: Registrador 
generic map(W=>4)
port map(
--		clk => fio_cl,
      REG_Reset => fio_re,
      REG_Enable => fio_e,
      REG_DataIN => fio_in,
      REG_DataOUT => fio_ou
);
-- Dados de entrada de 4 bits sÃ£o expressos em "hexadecimal" usando "x":
fio_Cl<= not fio_Cl after 5ns;
fio_Re<='1','0' after 2ns;
fio_e<='0','1' after 15ns;
fio_in<=x"5", x"3" after 20ns;
end teste;
