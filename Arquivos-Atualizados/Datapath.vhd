library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Datapath is
    port (
        DP_Clock : in std_logic;
        DP_Reset : in std_logic;
        DP_TecladoAndar : in std_logic_vector(2 downto 0);
        DP_TecladoQuarto : in std_logic_vector(3 downto 0);
		  DP_A_Atual : in std_logic_vector(2 downto 0);
		  DP_Q_Atual : in std_logic_vector(3 downto 0);
        DP_ENVIAR : in std_logic;
        DP_Temp_Start : in std_logic;
        DP_Temp_Reset : in std_logic;
		  DR_Temp_OUT : out std_logic;
        DR_CHEGOU : out std_logic
    );
end entity;

architecture arch of Datapath is

    signal SIG_A_Destino : std_logic_vector(2 downto 0);
    signal SIG_Q_Destino : std_logic_vector(3 downto 0);
	 signal SIG_Clock_Div : std_logic;
    signal SIG_A_Igual : std_logic;
	 signal SIG_Q_Igual : std_logic;
    signal SIG_Tempo: std_logic;
    signal SIG_Peso : std_logic_vector(8 downto 0);
    signal SIG_CodigoLiberacao : std_logic_vector(2 downto 0);
    signal SIG_Temporizador : std_logic;
		
	 component DivClock is
    generic (Divisao : integer := 50000);
    port (
        CLK_ClockIN : in std_logic; -- Entrada do clock
        CLK_Reset : in std_logic; -- Entrada de reset
        CLK_ClockOUT : out std_logic -- Saída do clock (clock dividido)
    );	
	 end component;	
	 
    component Temporizador is
        generic (
            frequencia : integer := 1000;
            tempo : integer := 30 -- Valor da temporização em segundos
        );
        port (
            TEMP_Clock : in std_logic;
            TEMP_Start : in std_logic;
            TEMP_Reset : in std_logic;
            TEMP_SigOUT : out std_logic
        );
    end component;
		

    component Registrador is
        generic (
            W : integer := 4 -- largura do registrador (número de bits)
        );
        port (
            clk : in std_logic; -- clock
            REG_Reset : in std_logic; -- reset
            REG_Enable : in std_logic; -- enable
            REG_DataIN : in std_logic_vector(W - 1 downto 0); -- dado de entrada
            REG_DataOUT : out std_logic_vector(W - 1 downto 0) -- dado de saída
        );
    end component;
	 
	 component Comparador is

		generic
		(
			DATA_WIDTH : natural := 4
		);

		port 
		(
			a	   : in std_logic_vector	((DATA_WIDTH-1) downto 0);
			b	   : in std_logic_vector	((DATA_WIDTH-1) downto 0);
			result : out std_logic
		);

	end component;

begin

	INST_DivisorClock : DivClock
    generic map(
        Divisao=>50000)
    port map(
        CLK_ClockIN => DP_Clock,
        CLK_Reset => DP_Reset,
        CLK_ClockOUT => SIG_Clock_Div
    );
	
    -- Temporizador para monitorar o tempo de entrega
    INST_Temporizador : Temporizador
    generic map(
        frequencia => 1000,
        tempo => 30)
    port map(
        TEMP_Clock => SIG_Clock_Div,
        TEMP_Start => DP_Temp_Start,
        TEMP_Reset => DP_Temp_Reset,
        TEMP_SigOUT => DR_Temp_OUT
    );

    -- Registradores para armazenar os valores de andar e quarto
    INST_Reg_A_Destino : Registrador
    generic map(W => 3)
    port map(
        clk => SIG_Clock_Div,
        REG_Reset => DP_Reset,
        REG_Enable => DP_ENVIAR,
        REG_DataIN => DP_TecladoAndar,
        REG_DataOUT => SIG_A_Destino
    );

    INST_Reg_Q_Destino : Registrador
    generic map(W => 4)
    port map(
        clk => SIG_Clock_Div,
        REG_Reset => DP_Reset,
        REG_Enable => DP_ENVIAR,
        REG_DataIN => DP_TecladoQuarto,
        REG_DataOUT => SIG_Q_Destino
    );
	 
	 INST_verif_A_destino : Comparador
    generic map(DATA_WIDTH => 3)
    port map(
      a	=> SIG_A_Destino,
		b	=> DP_A_Atual,
		result => SIG_A_Igual
    );
	 
	 INST_verif_Q_destino : Comparador
    generic map(DATA_WIDTH => 4)
    port map(
      a => SIG_Q_Destino,
		b => DP_Q_Atual,
		result => SIG_Q_Igual
    );
	 
	 INST_verif_destino : Comparador
    generic map(DATA_WIDTH => 1)
    port map(
      a(0) => SIG_Q_Igual,
		b(0) => SIG_A_Igual,
		result => DR_CHEGOU
    );

end architecture;