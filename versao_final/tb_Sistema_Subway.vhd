library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Sistema_Subway is
end entity tb_Sistema_Subway;

architecture testbench of tb_Sistema_Subway is
  -- Declarações dos sinais utilizados no testbench
  signal clk_sistema : std_logic := '0';
  signal TecladoAndar : std_logic_vector(2 downto 0) := "000";
  signal TecladoQuarto : std_logic_vector(3 downto 0) := "0000";
  signal Porta : std_logic := '0';
  signal ENVIAR : std_logic := '0';
  signal CodigoLiberacao : std_logic_vector(2 downto 0) := "000";
  signal Reset : std_logic := '0';
  signal Emer_Solucionado : std_logic := '0';
  signal Emergencia : std_logic := '0';
  signal PortaFechada : std_logic;
  signal PortaAberta : std_logic;
  signal Tecnico : std_logic;
  signal CHEGOU : std_logic;
  signal Emerg_SigOUT : std_logic;
  signal Saida_Bcd : std_logic_vector(3 downto 0);

  -- Periodo do Clock
  constant clk_period : time := 10 ns;

  -- Componente Subway_Controladora para instância
  component Subway_Controladora is
    Port (
      clk                : in STD_LOGIC;
      DR_TecladoAndar    : in STD_LOGIC_VECTOR(2 downto 0);
      DR_TecladoQuarto   : in STD_LOGIC_VECTOR(3 downto 0);
      DR_Porta           : in STD_LOGIC;
      DR_ENVIAR          : in STD_LOGIC;
      DR_CodigoLiberacao : in STD_LOGIC_VECTOR(2 downto 0);
      DR_Reset           : in STD_LOGIC := '0';
      DR_Emer_Solucionado: in STD_LOGIC;
      DR_Emergencia      : in STD_LOGIC;
      DR_IN_CompA        : in std_logic;
      DR_IN_CompQ        : in std_logic;
      DR_PortaFechada    : out STD_LOGIC;
      DR_PortaAberta     : out STD_LOGIC;
      DR_Tecnico         : out STD_LOGIC;
      DR_CHEGOU          : out STD_LOGIC;
      DR_Emerg_SigOUT    : out STD_LOGIC;
      Enable_Reg         : out std_logic;
      display_value      : out std_logic_vector(3 downto 0)
    );
  end component;

begin

  -- Instanciação do componente Subway_Controladora
  uut: Subway_Controladora
    port map (
      clk                => clk_sistema,
      DR_TecladoAndar    => TecladoAndar,
      DR_TecladoQuarto   => TecladoQuarto,
      DR_Porta           => Porta,
      DR_ENVIAR          => ENVIAR,
      DR_CodigoLiberacao => CodigoLiberacao,
      DR_Reset           => Reset,
      DR_Emer_Solucionado=> Emer_Solucionado,
      DR_Emergencia      => Emergencia,
      DR_IN_CompA        => '0',  -- Ajuste de acordo com a especificação
      DR_IN_CompQ        => '0',  -- Ajuste de acordo com a especificação
      DR_PortaFechada    => PortaFechada,
      DR_PortaAberta     => PortaAberta,
      DR_Tecnico         => Tecnico,
      DR_CHEGOU          => CHEGOU,
      DR_Emerg_SigOUT    => Emerg_SigOUT,
      Enable_Reg         => open,
      display_value      => Saida_Bcd
    );

  -- Processo para gerar o clock
  Clock_Process: process
  begin
    while true loop
      clk_sistema <= '0';
      wait for clk_period / 2;
      clk_sistema <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- Processo de Estímulos para o testbench
  Stimulus_Process: process
  begin
  
    TecladoAndar <= "000"; TecladoQuarto <= "0000"; Porta <= '1'; ENVIAR <= '0'; CodigoLiberacao <= "011"; Reset <='0';Emergencia <= '0'; Emer_Solucionado <= '0'; 
    wait for 100 ns;
    TecladoAndar <= "001"; TecladoQuarto <= "0000"; Porta <= '1'; ENVIAR <= '0'; CodigoLiberacao <= "011"; Reset <= '0';Emergencia <= '0'; Emer_Solucionado <= '0';
	 wait for 100ns;
    TecladoAndar <= "001"; TecladoQuarto <= "1010"; Porta <= '1'; ENVIAR <= '1'; CodigoLiberacao <= "011"; Reset <= '0';Emergencia <= '0';Emer_Solucionado <= '0';
	 wait for 100 ns;
	 TecladoAndar <= "101"; TecladoQuarto <= "1110"; Porta <= '0'; ENVIAR <= '1'; CodigoLiberacao <= "111"; Reset <= '0';Emergencia <= '0'; Emer_Solucionado <= '0';
	 wait for 20 ns;
	 TecladoAndar <= "001"; TecladoQuarto <= "1010"; Porta <= '1'; ENVIAR <= '0'; CodigoLiberacao <= "100"; Reset <= '1';Emergencia <= '1'; Emer_Solucionado <= '0';
	 wait for 20 ns;	 
	 TecladoAndar <= "001"; TecladoQuarto <= "0000"; Porta <= '0'; ENVIAR <= '0'; CodigoLiberacao <= "100"; Reset <= '0';Emergencia <= '0'; Emer_Solucionado <= '1';
	 wait for 20 ns;
	 TecladoAndar <= "001"; TecladoQuarto <= "1010"; Porta <= '1'; ENVIAR <= '1'; CodigoLiberacao <= "011"; Reset <= '0'; Emergencia <= '1'; Emer_Solucionado <= '0';
	 wait for 20 ns;
	 TecladoAndar <= "001"; TecladoQuarto <= "1010"; Porta <= '1'; ENVIAR <= '0'; CodigoLiberacao <= "100"; Reset <= '1';Emergencia <= '0';  Emer_Solucionado <= '0';
    wait for 20 ns;

    wait;
  end process;

end architecture testbench;
