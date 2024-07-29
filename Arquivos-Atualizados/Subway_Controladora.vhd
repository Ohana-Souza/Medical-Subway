library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Subway_Controladora is
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

        DR_PortaFechada          : out STD_LOGIC;                -- LED verde
        DR_PortaAberta    			: out STD_LOGIC;                -- LED vermelho
        DR_Tecnico   			   : out STD_LOGIC;                -- LED vermelho indicando que o técnico foi chamado
		  DR_CHEGOU						: out STD_LOGIC; 					  -- Led verde indicando a chegada da cápsula
        DR_Emerg_SigOUT				: out STD_LOGIC					  -- Led vermelho indicando o acionamento da emergência
		 
		
    );
end entity Subway_Controladora;

architecture Behavioral of Subway_Controladora is

    type state_type is (IDLE, WAITING, SENDING, ARRIVED, EMERGENCY);
    signal state : state_type := IDLE;
  
    constant LIBERATION_CODE  : std_logic_vector(2 downto 0) := "011"; -- Substitua por código real
    

begin

 
    -- Processo de controle principal
    process (clk, DR_Reset, DR_Emer_Solucionado)
    begin
        if (DR_Reset = '1') or (DR_Emer_Solucionado = '1') then
            state <= IDLE;
            DR_PortaFechada <= '0';
            DR_PortaAberta <= '0';
            DR_Tecnico <= '0';
            DR_CHEGOU <= '0';
            DR_Emerg_SigOUT <= '0';
          
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if (DR_TecladoAndar /= "000") and (DR_TecladoQuarto /= "0000") then
                        state <= WAITING;
                        DR_PortaFechada <= '1';
                        DR_PortaAberta <= '0';
                        
                    elsif DR_ENVIAR = '1' and DR_Porta = '0' then
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '1';
                       
                    end if;

                when WAITING =>
                    if DR_Reset = '1' then
                        state <= IDLE;
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '0';
                        DR_Tecnico <= '0';
                    elsif (DR_Porta = '1') and (DR_ENVIAR = '1') then
                        state <= SENDING;
                        DR_PortaFechada <= '1';
                        DR_PortaAberta <= '0';
                        
                    end if;

                when SENDING =>
                    if DR_Reset = '1' then
                        state <= IDLE;
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '0';
                        DR_Tecnico <= '0';
                       
                    elsif DR_CapsuleArrived = '1' then
                        state <= ARRIVED;
                        DR_PortaFechada <= '1';
                        DR_PortaAberta <= '0';
                        DR_CHEGOU <= '1';
                       
                    end if;

                when ARRIVED =>
                    if DR_CodigoLiberacao = LIBERATION_CODE then
                        state <= IDLE;
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '0';
                        DR_Tecnico <= '0';
                        DR_CHEGOU <= '0';
                       
                    end if;

                when EMERGENCY =>
                    DR_Emerg_SigOUT <= '1';
                    DR_Tecnico <= '1';
                 
                    if DR_Emer_Solucionado = '1' then
                        state <= IDLE;
                        DR_Emerg_SigOUT <= '0';
                        DR_Tecnico <= '0';
                      
                    end if;

                when others =>
                    state <= IDLE;

            end case;
        end if;
    end process;

end Behavioral;
