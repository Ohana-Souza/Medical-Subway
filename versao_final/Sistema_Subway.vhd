library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sistema_Subway is
  Port (
	 clk_sistema : in STD_LOGIC; -- Sinal de entrada de clock
    TecladoAndar : in STD_LOGIC_VECTOR(3 downto 0); -- 3 bits para representar atÃƒÂ© 7 andares
    TecladoQuarto : in STD_LOGIC_VECTOR(3 downto 0); -- 4 bits para representar atÃƒÂ© 15 quartos por andar
    Porta : in STD_LOGIC; -- Porta do metro
    ENVIAR : in STD_LOGIC; -- Switch para enviar a capsula
    CodigoLiberacao : in STD_LOGIC_VECTOR(2 downto 0); -- 3 bits para cÃƒÂ³digo de liberaÃƒÂ§ÃƒÂ£o
    Reset : in STD_LOGIC := '0'; -- Switch para reset
    Emer_Solucionado : in STD_LOGIC; -- Switch para reset de emergÃƒÂªncia
    Emergencia : in STD_LOGIC; -- Switch para emergÃƒÂªncia
    PortaFechada : out STD_LOGIC; -- LED verde
    PortaAberta : out STD_LOGIC; -- LED vermelho
    Tecnico : out STD_LOGIC; -- LED vermelho indicando que o tÃƒÂ©cnico foi chamado
    CHEGOU : out STD_LOGIC; -- Led verde indicando a chegada da cÃƒÂ¡psula
    Emerg_SigOUT : out STD_LOGIC; -- Led vermelho indicando o acionamento da emergÃƒÂªncia	
	 Saida_Bcd_7seg : out std_logic_vector (6 downto 0);
	 Saida_Bcd_7seg2 : out std_logic_vector (6 downto 0);
    Saida_Bcd_7seg3 : out std_logic_vector (6 downto 0) 	 
  );
  
end entity Sistema_Subway;

architecture Behavioral of Sistema_Subway is
	
	component DivClock is 
	  port (	
		CLK_ClockIN : in std_logic; -- Entrada do clock
      CLK_Reset : in std_logic; -- Entrada de reset
      CLK_ClockOUT : out std_logic -- SaÃƒÂ­da do clock (clock dividido)
		); 
		
	end component;
	
  component Subway_Controladora is
    port (
      clk : in STD_LOGIC;
      DR_TecladoAndar : in STD_LOGIC_VECTOR(3 downto 0);
      DR_TecladoQuarto : in STD_LOGIC_VECTOR(3 downto 0);
      DR_Porta : in STD_LOGIC;
      DR_ENVIAR : in STD_LOGIC;
      DR_CodigoLiberacao : in STD_LOGIC_VECTOR(2 downto 0);
      DR_Reset : in STD_LOGIC;
      DR_Emer_Solucionado : in STD_LOGIC;
      DR_Emergencia : in STD_LOGIC;
		DR_IN_CompA : in std_logic;
		DR_IN_CompQ : in std_logic;
		DR_PortaFechada          : out STD_LOGIC;                -- LED verde
      DR_PortaAberta    			: out STD_LOGIC;                -- LED vermelho
      DR_Tecnico   			   : out STD_LOGIC;                -- LED vermelho indicando que o tÃƒÂ©cnico foi chamado
		DR_CHEGOU						: out STD_LOGIC; 					  -- Led verde indicando a chegada da cÃƒÂ¡psula
      DR_Emerg_SigOUT				: out STD_LOGIC;				  -- Led vermelho indicando o acionamento da emergÃƒÂªn
		display_value      : out STD_LOGIC_VECTOR(3 downto 0);    -- Valor exibido
		display_andar      : out STD_LOGIC_VECTOR(3 downto 0);
		display_quarto     : out STD_LOGIC_VECTOR(3 downto 0);
		Enable_Reg : out std_logic
    );
	 
  end component;

  component Datapath is
    port (
	   Load_Reg : in std_logic;
      DP_Clock : in std_logic;
      DP_Reset : in std_logic;
      DP_A_Atual : in std_logic_vector(3 downto 0);
      DP_Q_Atual : in std_logic_vector(3 downto 0);
      DP_ENVIAR : in std_logic;
		DP_OUT_CompA : out std_logic;
		DP_OUT_CompQ : out std_logic;
		entradaBcd : in std_logic_vector (3 downto 0);
		entradaBcd2 : in std_logic_vector (3 downto 0);
		entradaBcd3 : in std_logic_vector (3 downto 0);
		saidaBcd : out std_logic_vector (6 downto 0);
		saidaBcd2 : out std_logic_vector (6 downto 0);
		saidaBcd3 : out std_logic_vector (6 downto 0)
    );
	 
  end component;

  signal CLK_ClockOUT : std_logic;
  signal OUT_CompA : std_logic;
  signal OUT_CompQ: std_logic;
  signal signal_entradaBcd : std_logic_vector(3 downto 0);
  signal signal_entradaBcd2 : std_logic_vector(3 downto 0);
  signal signal_entradaBcd3 : std_logic_vector(3 downto 0);
  signal Reg_ENABLE : std_logic;  
  
  begin

	 link_DivClock : DivClock port map (
		 CLK_ClockIN => clk_sistema,
       CLK_Reset => Reset,
       CLK_ClockOUT => CLK_ClockOUT
	 );
	 
    link_Subway_Controladora : Subway_Controladora port map (
      clk => CLK_ClockOUT,
      DR_TecladoAndar => TecladoAndar,
      DR_TecladoQuarto => TecladoQuarto,
      DR_Porta => Porta,
      DR_ENVIAR => ENVIAR,
      DR_CodigoLiberacao => CodigoLiberacao,
      DR_Reset => Reset,
      DR_Emer_Solucionado => Emer_Solucionado,
      DR_Emergencia => Emergencia,
		DR_IN_CompA => OUT_CompA,
		DR_IN_CompQ => OUT_CompQ,
		DR_PortaFechada => PortaFechada,    
      DR_PortaAberta => PortaAberta,    		
      DR_Tecnico => Tecnico,  			   
		DR_CHEGOU => CHEGOU,						
      DR_Emerg_SigOUT => Emerg_SigOUT,
	   display_value => signal_entradaBcd,
		display_andar => signal_entradaBcd2,
		display_quarto => signal_entradaBcd3,
		Enable_Reg => Reg_ENABLE
		
    );

    link_Datapath : Datapath port map (
      DP_OUT_CompA => OUT_CompA,
		DP_OUT_CompQ => OUT_CompQ,
		DP_Clock => CLK_ClockOUT,
      DP_Reset => Reset,
   
      DP_A_Atual => TecladoAndar, -- Conectado ao sinal DP_A_Atual
      DP_Q_Atual => TecladoQuarto, -- Conectado ao sinal DP_Q_Atual
      DP_ENVIAR => ENVIAR,
		entradaBcd => signal_entradaBcd,
		entradaBcd2 => signal_entradaBcd2,
		entradaBcd3 => signal_entradaBcd3,
		saidaBcd => Saida_Bcd_7seg,
		saidaBcd2 => Saida_Bcd_7seg2,
		saidaBcd3 => Saida_Bcd_7seg3,
		Load_Reg => Reg_ENABLE
    );
  end architecture Behavioral;
