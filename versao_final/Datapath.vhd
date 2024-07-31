library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Datapath is
    port (
		  Load_Reg : in std_logic;
        DP_Clock : in std_logic;
        DP_Reset : in std_logic;
        DP_TecladoAndar : in std_logic_vector(3 downto 0);
        DP_TecladoQuarto : in std_logic_vector(3 downto 0);
		  DP_A_Atual : in std_logic_vector(3 downto 0);
		  DP_Q_Atual : in std_logic_vector(3 downto 0);
        DP_ENVIAR : in std_logic;
		  DP_OUT_CompA : out std_logic;
		  DP_OUT_CompQ : out std_logic;
        DP_CHEGOU : out std_logic;
		  entradaBcd : in std_logic_vector (3 downto 0);
		  entradaBcd2 : in std_logic_vector (3 downto 0);
		  entradaBcd3 : in std_logic_vector (3 downto 0);
		  saidaBcd : out std_logic_vector (6 downto 0);
		  saidaBcd2 : out std_logic_vector (6 downto 0);
		  saidaBcd3 : out std_logic_vector (6 downto 0)  
    );
end entity;

architecture arch of Datapath is

    signal SIG_A_Destino : std_logic_vector(3 downto 0);
    signal SIG_Q_Destino : std_logic_vector(3 downto 0);
	 signal SIG_Clock_Div : std_logic;
    signal SIG_A_Igual : std_logic;
	 signal SIG_Q_Igual : std_logic;
    signal SIG_CodigoLiberacao : std_logic_vector(2 downto 0);

		
	 component Bcd_7seg is 
		  port (
			entrada: in std_logic_vector (3 downto 0);
			saida:	out std_logic_vector (6 downto 0)
		);
		end component;
		
	 component Bcd_7seg2 is 
		  port (
			entrada2: in std_logic_vector (3 downto 0);
			saida2:	out std_logic_vector (6 downto 0)
		);
		end component;
		
	 component Bcd_7seg3 is 
		  port (
			entrada3: in std_logic_vector (3 downto 0);
			saida3:	out std_logic_vector (6 downto 0)
		);
		end component;
		
    component Registrador is
        generic (
            W : integer := 4 -- largura do registrador (nÃƒÆ’Ã‚Âºmero de bits)
        );
        port (
            clk : in std_logic; -- clock
            REG_Reset : in std_logic; -- reset
            REG_Enable : in std_logic; -- enable
            REG_DataIN : in std_logic_vector(W - 1 downto 0); -- dado de entrada
            REG_DataOUT : out std_logic_vector(W - 1 downto 0) -- dado de saÃƒÆ’Ã‚Â­da
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

    -- Registradores para armazenar os valores de andar e quarto
    INST_Reg_Q_Destino : Registrador
    generic map(W => 4)
    port map(
        clk => SIG_Clock_Div,
        REG_Reset => DP_Reset,
        REG_Enable => Load_Reg,
        REG_DataIN => DP_Q_Atual,
        REG_DataOUT => SIG_Q_Destino
    );
	 
	 INST_verif_Q_destino : Comparador
    generic map(DATA_WIDTH => 4)
    port map(
      a => SIG_Q_Destino,
		b => DP_Q_Atual,
		result => DP_OUT_CompQ
    );

    INST_Reg_A_Destino : Registrador
    generic map(W => 4)
    port map(
        clk => SIG_Clock_Div,
        REG_Reset => DP_Reset,
        REG_Enable => Load_Reg,
        REG_DataIN => DP_A_Atual,
        REG_DataOUT => SIG_A_Destino
    );
	 
	 INST_verif_A_destino : Comparador
    generic map(DATA_WIDTH => 4)
    port map(
      a	=> SIG_A_Destino,
		b	=> DP_A_Atual,
		result => DP_OUT_CompA
      );
	 
	INST_Bcd_7seg : Bcd_7seg
	port map (
		entrada => entradaBcd,
		saida => saidaBcd
		);
		
	INST_Bcd_7seg2 : Bcd_7seg2
	port map (
		entrada2 => entradaBcd2,
		saida2 => saidaBcd2
		);
	INST_Bcd_7seg3 : Bcd_7seg3
	port map (
		entrada3 => entradaBcd3,
		saida3 => saidaBcd3
		);
		
end architecture;