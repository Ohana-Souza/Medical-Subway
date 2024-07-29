library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Subway_Controladora is
end tb_Subway_Controladora;

architecture Behavioral of tb_Subway_Controladora is

    component Subway_Controladora
        Port (
            clk                : in STD_LOGIC;
            DR_TecladoAndar    : in STD_LOGIC_VECTOR(2 downto 0);
            DR_TecladoQuarto   : in STD_LOGIC_VECTOR(3 downto 0);
            DR_Porta           : in STD_LOGIC;
            DR_ENVIAR          : in STD_LOGIC;
            DR_CodigoLiberacao : in STD_LOGIC_VECTOR(2 downto 0);
            DR_Reset           : in STD_LOGIC;
            DR_Emer_Solucionado: in STD_LOGIC;
            DR_CapsuleArrived  : in STD_LOGIC;
            DR_Emergencia      : in STD_LOGIC;
            
            DR_PortaFechada    : out STD_LOGIC;
            DR_PortaAberta     : out STD_LOGIC;
            DR_Tecnico         : out STD_LOGIC;
            DR_CHEGOU          : out STD_LOGIC;
            DR_Emerg_SigOUT    : out STD_LOGIC;
            
            lcd_rs             : out STD_LOGIC;
            lcd_rw             : out STD_LOGIC;
            lcd_e              : out STD_LOGIC;
            lcd_data           : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal clk                : STD_LOGIC := '0';
    signal DR_TecladoAndar    : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal DR_TecladoQuarto   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal DR_Porta           : STD_LOGIC := '0';
    signal DR_ENVIAR          : STD_LOGIC := '0';
    signal DR_CodigoLiberacao : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal DR_Reset           : STD_LOGIC := '0';
    signal DR_Emer_Solucionado: STD_LOGIC := '0';
    signal DR_CapsuleArrived  : STD_LOGIC := '0';
    signal DR_Emergencia      : STD_LOGIC := '0';
    
    signal DR_PortaFechada    : STD_LOGIC;
    signal DR_PortaAberta     : STD_LOGIC;
    signal DR_Tecnico         : STD_LOGIC;
    signal DR_CHEGOU          : STD_LOGIC;
    signal DR_Emerg_SigOUT    : STD_LOGIC;
    
    signal lcd_rs             : STD_LOGIC;
    signal lcd_rw             : STD_LOGIC;
    signal lcd_e              : STD_LOGIC;
    signal lcd_data           : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 5 ns;  -- Reduzido para 5 ns para aumentar a frequência de clock

    -- Declaração da variável state para realizar as verificações
    type state_type is (IDLE, WAITING, SENDING, ARRIVED, EMERGENCY);
    signal state : state_type := IDLE;

begin
    -- Processo de clock para gerar o sinal de clock
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Instância do componente Subway_Controladora
    uut: Subway_Controladora
        Port map (
            clk                => clk,
            DR_TecladoAndar    => DR_TecladoAndar,
            DR_TecladoQuarto   => DR_TecladoQuarto,
            DR_Porta           => DR_Porta,
            DR_ENVIAR          => DR_ENVIAR,
            DR_CodigoLiberacao => DR_CodigoLiberacao,
            DR_Reset           => DR_Reset,
            DR_Emer_Solucionado=> DR_Emer_Solucionado,
            DR_CapsuleArrived  => DR_CapsuleArrived,
            DR_Emergencia      => DR_Emergencia,
            
            DR_PortaFechada    => DR_PortaFechada,
            DR_PortaAberta     => DR_PortaAberta,
            DR_Tecnico         => DR_Tecnico,
            DR_CHEGOU          => DR_CHEGOU,
            DR_Emerg_SigOUT    => DR_Emerg_SigOUT,
            
            lcd_rs             => lcd_rs,
            lcd_rw             => lcd_rw,
            lcd_e              => lcd_e,
            lcd_data           => lcd_data
        );

    -- Processo de estímulo para testar a controladora
    stim_proc: process
    begin
        -- Teste inicial
        DR_TecladoAndar <= "000";
        DR_TecladoQuarto <= "0000";
        DR_Porta <= '0';
        DR_ENVIAR <= '0';
        DR_CodigoLiberacao <= "000";
        DR_Reset <= '0';
        DR_Emer_Solucionado <= '0';
        DR_CapsuleArrived <= '0';
        DR_Emergencia <= '0';
        wait for 10 us;  -- Reduzido o tempo de espera para 10 ns

        -- Teste: transição para o estado WAITING
        DR_TecladoAndar <= "001";
        DR_TecladoQuarto <= "0001";
        wait for 10 us;
        assert (DR_PortaFechada = '1' and DR_PortaAberta = '0') report "Falha ao entrar no estado WAITING a partir de IDLE" severity error;

        -- Teste: transição para o estado SENDING
        DR_Porta <= '1';
        DR_ENVIAR <= '1';
        wait for 10 us;
        assert (DR_PortaFechada = '1' and DR_PortaAberta = '0') report "Falha ao entrar no estado SENDING a partir de WAITING" severity error;

        -- Teste: transição para o estado ARRIVED
        DR_CapsuleArrived <= '1';
        wait for 10 us;
        assert (DR_CHEGOU = '1') report "Falha ao entrar no estado ARRIVED a partir de SENDING" severity error;

        -- Teste: retorno ao estado IDLE
        DR_CodigoLiberacao <= "011";
        wait for 10 us;
        assert (DR_PortaFechada = '0' and DR_PortaAberta = '0') report "Falha ao retornar ao estado IDLE a partir de ARRIVED" severity error;

        -- Teste: entrada no estado EMERGENCY
        DR_Emergencia <= '1';
        wait for 10 us;
        assert (DR_Emerg_SigOUT = '1' and DR_Tecnico = '1') report "Falha ao entrar no estado EMERGENCY" severity error;

        -- Teste: resolução do estado EMERGENCY
        DR_Emer_Solucionado <= '1';
        wait for 10 us;
        assert (DR_Emerg_SigOUT = '0' and DR_Tecnico = '0') report "Falha ao resolver o estado EMERGENCY" severity error;

        -- Teste: reset do sistema
        DR_Reset <= '1';
        wait for 10 us;
        assert (state = IDLE) report "Falha ao resetar o sistema" severity error;

        wait;
    end process;

end Behavioral;
