library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sistema_Subway is
    Port (
        clk                : in STD_LOGIC;                       -- Sinal de entrada de clock
        DR_TecladoAndar    : in STD_LOGIC_VECTOR(2 downto 0);    -- 3 bits para representar até 7 andares
        DR_TecladoQuarto   : in STD_LOGIC_VECTOR(3 downto 0);    -- 4 bits para representar até 15 quartos por andar
        DR_Porta           : in STD_LOGIC;                       -- Porta do metrô
        DR_ENVIAR          : in STD_LOGIC;                       -- Switch para enviar a cápsula
        DR_CodigoLiberacao : in STD_LOGIC_VECTOR(2 downto 0);    -- 3 bits para código de liberação
        DR_Reset           : in STD_LOGIC := '0';                -- Switch para reset
        DR_Emer_Solucionado: in STD_LOGIC;                       -- Switch para reset de emergência
        DR_CapsuleArrived  : in STD_LOGIC;                       -- Indica que a cápsula chegou
        DR_Emergencia      : in STD_LOGIC;                       -- Switch para emergência

        DR_PortaFechada    : out STD_LOGIC;                      -- LED verde
        DR_PortaAberta     : out STD_LOGIC;                      -- LED vermelho
        DR_Tecnico         : out STD_LOGIC;                      -- LED vermelho indicando que o técnico foi chamado
        DR_CHEGOU          : out STD_LOGIC;                      -- LED verde indicando a chegada da cápsula
        DR_Emerg_SigOUT    : out STD_LOGIC;                      -- LED vermelho indicando o acionamento da emergência
        lcd_rs             : out STD_LOGIC;                      -- LCD Register Select
        lcd_rw             : out STD_LOGIC;                      -- LCD Read/Write
        lcd_e              : out STD_LOGIC;                      -- LCD Enable
        lcd_data           : out STD_LOGIC_VECTOR(7 downto 0)    -- LCD Data Bus
    );
end entity Sistema_Subway;

architecture Behavioral of Sistema_Subway is

    type state_type is (IDLE, WAITING, SENDING, ARRIVED, EMERGENCY);
    signal state : state_type := IDLE;
    signal lcd_message : string(1 to 16) := "                "; -- Mensagem de 16 caracteres para o LCD
    constant LIBERATION_CODE : std_logic_vector(2 downto 0) := "011"; -- Substitua por código real

    -- Declarar sinais internos se necessário
    signal temp_chegou : STD_LOGIC;

begin

    -- Instância do datapath
    INST_Datapath : entity work.Datapath
        port map (
            DP_Clock => clk,
            DP_Reset => DR_Reset,
            DP_TecladoAndar => DR_TecladoAndar,
            DP_TecladoQuarto => DR_TecladoQuarto,
            DP_ENVIAR => DR_ENVIAR,
            DP_A_Atual => "000",  -- Valor atual do andar
            DP_Q_Atual => "0000", -- Valor atual do quarto
            DP_Temp_Start => '0',  -- Iniciar temporizador
            DP_Temp_Reset => '0', -- Resetar temporizador
            DR_Temp_OUT => open,  -- Saída do temporizador
            DR_CHEGOU => temp_chegou  -- Usar sinal interno
        );

    -- Instância da controladora
    INST_Subway_Controladora : entity work.Subway_Controladora
        port map (
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

    -- Lógica de controle principal da controladora
    process (clk, DR_Reset)
    begin
        if (DR_Reset = '1') then
            state <= IDLE;
            -- Lógica de reset
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    -- Lógica do estado IDLE
                when WAITING =>
                    -- Lógica do estado WAITING
                when SENDING =>
                    -- Lógica do estado SENDING
                when ARRIVED =>
                    -- Lógica do estado ARRIVED
                when EMERGENCY =>
                    -- Lógica do estado EMERGENCY
                when others =>
                    -- Lógica para estados desconhecidos
            end case;
        end if;
    end process;

    -- Processo para atualizar o LCD
    process (clk)
    begin
        if rising_edge(clk) then
            -- Lógica para atualizar o LCD aqui...
        end if;
    end process;

end architecture Behavioral;
