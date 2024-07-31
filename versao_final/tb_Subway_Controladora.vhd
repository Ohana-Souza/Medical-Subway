library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Subway_Controladora is
	type state_type is (IDLE, WAITING, SENDING, ARRIVED, EMERGENCY);
end tb_Subway_Controladora;

architecture tb of tb_Subway_Controladora is
  
  -- DeclaraÃ§Ã£o dos sinais que irÃ£o interagir com a UUT (Unit Under Test)
  signal clk                : std_logic := '0';
  signal DR_TecladoAndar    : std_logic_vector(3 downto 0) := "000";
  signal DR_TecladoQuarto   : std_logic_vector(3 downto 0) := "0000";
  signal DR_Porta           : std_logic := '0';
  signal DR_ENVIAR          : std_logic := '0';
  signal DR_CodigoLiberacao : std_logic_vector(2 downto 0) := "000";
  signal DR_Reset           : std_logic := '0';
  signal DR_Emer_Solucionado: std_logic := '0';
  signal DR_Emergencia      : std_logic := '0';
  signal DR_IN_CompA        : std_logic := '0';
  signal DR_IN_CompQ       : std_logic := '0';

  signal DR_PortaFechada    : std_logic;
  signal DR_PortaAberta     : std_logic;
  signal DR_Tecnico         : std_logic;
  signal DR_CHEGOU          : std_logic;
  signal DR_Emerg_SigOUT    : std_logic;
  signal state : state_type := IDLE;


  -- Periodo do Clock
  constant clk_period : time := 10 ns;

  -- InstanciaÃ§Ã£o da UUT
  component Subway_Controladora is
	
    Port (
        clk                : in STD_LOGIC;                       -- Sinal de entrada de clock
        DR_TecladoAndar    : in STD_LOGIC_VECTOR(3 downto 0);    -- 3 bits para representar atÃ© 7 andares
        DR_TecladoQuarto   : in STD_LOGIC_VECTOR(3 downto 0);    -- 4 bits para representar atÃ© 15 quartos por andar
        DR_Porta           : in STD_LOGIC;                       -- Porta do metrÃ´
        DR_ENVIAR          : in STD_LOGIC;                       -- Switch para enviar a cÃ¡psula
        DR_CodigoLiberacao : in STD_LOGIC_VECTOR(2 downto 0);    -- 3 bits para cÃ³digo de liberaÃ§Ã£o
        DR_Reset           : in STD_LOGIC := '0';                -- Switch para reset
        DR_Emer_Solucionado: in STD_LOGIC;                       -- Switch para reset de emergÃªncia
        DR_Emergencia      : in STD_LOGIC;                       -- Switch para emergÃªncia
        DR_IN_CompA        : in std_logic;
        DR_IN_CompQ       : in std_logic;
        DR_PortaFechada    : out STD_LOGIC;                      -- LED verde
        DR_PortaAberta     : out STD_LOGIC;                      -- LED vermelho
        DR_Tecnico         : out STD_LOGIC;                      -- LED vermelho indicando que o tÃ©cnico foi chamado
        DR_CHEGOU          : out STD_LOGIC;                      -- LED verde indicando a chegada da cÃ¡psula
        DR_Emerg_SigOUT    : out STD_LOGIC;                      -- LED vermelho indicando o acionamento da emergÃªncia
        Enable_Reg         : out std_logic;
        display_value      : out std_logic_vector(3 downto 0)
        --estado : out state_type
		  
    );
  end component;


begin

  -- InstanciaÃ§Ã£o do componente Subway_Controladora
  uut: Subway_Controladora
    port map (
      clk                => clk,
      DR_TecladoAndar    => DR_TecladoAndar,
      DR_TecladoQuarto   => DR_TecladoQuarto,
      DR_Porta           => DR_Porta,
      DR_ENVIAR          => DR_ENVIAR,
      DR_CodigoLiberacao => DR_CodigoLiberacao,
      DR_Reset           => DR_Reset,
      DR_Emer_Solucionado=> DR_Emer_Solucionado,
      DR_Emergencia      => DR_Emergencia,
      DR_IN_CompA        => DR_IN_CompA,
      DR_IN_CompQ       => DR_IN_CompQ,
      DR_PortaFechada    => DR_PortaFechada,
      DR_PortaAberta     => DR_PortaAberta,
      DR_Tecnico         => DR_Tecnico,
      DR_CHEGOU          => DR_CHEGOU,
      DR_Emerg_SigOUT    => DR_Emerg_SigOUT,
      Enable_Reg         => open,
      display_value      => open

   
    );

  -- GeraÃ§Ã£o do Clock
  Clock_Process: process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- Processo de EstÃ­mulos para o testbench
  Stimulus_Process: process
  begin
    -- Aplicar Reset ativado por 20 ns
    DR_Emer_Solucionado <= '0';
    DR_Reset <= '1';
    wait for 20 ns;
    DR_Reset <= '0';
    wait for 20 ns;

    -- Teste com TecladoAndar e TecladoQuarto diferentes de zero
    DR_TecladoAndar <= "010";
    DR_TecladoQuarto <= "0101";
    wait for 20 ns;

    -- Teste com ENVIAÃ‡ÃƒO de cÃ¡psula ativada, porta fechada
    DR_ENVIAR <= '1';
    DR_Porta <= '0';
    wait for 20 ns;

    -- Teste com ENVIAÃ‡ÃƒO de cÃ¡psula desativada, porta aberta
    DR_ENVIAR <= '0';
    DR_Porta <= '1';
    wait for 20 ns;

    -- Teste com ENVIAÃ‡ÃƒO de cÃ¡psula ativada, porta aberta
    DR_ENVIAR <= '1';
    DR_Porta <= '1';
    wait for 20 ns;

    -- Teste com EmergÃªncia ativada, TecladoAndar e TecladoQuarto alterados
    DR_Emergencia <= '1';
    DR_TecladoAndar <= "110";
    DR_TecladoQuarto <= "1101";
    wait for 20 ns;

    -- Teste com CodigoLiberacao correto, TecladoAndar e TecladoQuarto alterados
    DR_CodigoLiberacao <= "011";
    DR_TecladoAndar <= "110";
    DR_TecladoQuarto <= "1101";
    wait for 20 ns;

    -- Finalizar simulaÃ§Ã£o
    wait;
  end process;

end architecture tb;
