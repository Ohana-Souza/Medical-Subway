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
        DR_Emerg_SigOUT				: out STD_LOGIC; 					  -- Led vermelho indicando o acionamento da emergência
		 
		  lcd_rs             : out STD_LOGIC;                      -- LCD Register Select
		  lcd_rw             : out STD_LOGIC;                      -- LCD Read/Write
		  lcd_e              : out STD_LOGIC;                      -- LCD Enable
		  lcd_data           : out STD_LOGIC_VECTOR(7 downto 0)    -- LCD Data Bus
    );
end entity Subway_Controladora;

architecture Behavioral of Subway_Controladora is

    type state_type is (IDLE, WAITING, SENDING, ARRIVED, EMERGENCY);
    signal state : state_type := IDLE;
    signal lcd_message : string(1 to 16) := "                "; -- Mensagem de 16 caracteres para o LCD
    constant LIBERATION_CODE  : std_logic_vector(2 downto 0) := "011"; -- Substitua por código real
    

begin

 
    -- Processo de controle principal
    process (clk, DR_Reset)
    begin
        if (DR_Reset = '1') or (DR_Emer_Solucionado = '1') then
            state <= IDLE;
            DR_PortaFechada <= '0';
            DR_PortaAberta <= '0';
            DR_Tecnico <= '0';
            DR_CHEGOU <= '0';
            DR_Emerg_SigOUT <= '0';
            lcd_message <= "BEM VINDO!      ";
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if (DR_TecladoAndar /= "000") and (DR_TecladoQuarto /= "0000") then
                        state <= WAITING;
                        DR_PortaFechada <= '1';
                        DR_PortaAberta <= '0';
                        lcd_message <= "DADOS INSERIDOS ";
                    elsif DR_ENVIAR = '1' and DR_Porta = '0' then
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '1';
                        lcd_message <= "PORTA ABERTA    ";
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
                        lcd_message <= "ENVIANDO        ";
                    end if;

                when SENDING =>
                    if DR_Reset = '1' then
                        state <= IDLE;
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '0';
                        DR_Tecnico <= '0';
                        lcd_message <= "INICIO          ";
                    elsif DR_CapsuleArrived = '1' then
                        state <= ARRIVED;
                        DR_PortaFechada <= '1';
                        DR_PortaAberta <= '0';
                        DR_CHEGOU <= '1';
                        lcd_message <= "CHEGOU          ";
                    end if;

                when ARRIVED =>
                    if DR_CodigoLiberacao = LIBERATION_CODE then
                        state <= IDLE;
                        DR_PortaFechada <= '0';
                        DR_PortaAberta <= '0';
                        DR_Tecnico <= '0';
                        DR_CHEGOU <= '0';
                        lcd_message <= "LIBERADO        ";
                    end if;

                when EMERGENCY =>
                    DR_Emerg_SigOUT <= '1';
                    DR_Tecnico <= '1';
                    lcd_message <= "EMERGENCIA      ";
                    if DR_Emer_Solucionado = '1' then
                        state <= IDLE;
                        DR_Emerg_SigOUT <= '0';
                        DR_Tecnico <= '0';
                        lcd_message <= "  SOLUCIONADO   ";
                    end if;

                when others =>
                    state <= IDLE;

            end case;
        end if;
    end process;

    -- Processo para atualizar o LCD
    process (clk)
    variable counter : natural := 0;
    begin
        if rising_edge(clk) then
            -- Lógica para enviar a mensagem lcd_message ao display LCD
            lcd_rs <= '0';
            lcd_rw <= '0';
            lcd_e <= '1';
            lcd_data <= "00001100"; -- Comando para ligar o display sem cursor

            for i in 1 to 16 loop
                lcd_rs <= '1';
                lcd_rw <= '0';
                lcd_e <= '1';
                lcd_data <= std_logic_vector(to_unsigned(character'pos(lcd_message(i)), 8));

                -- Adicione um pequeno atraso (por exemplo, 10 ciclos de clock)
                if counter < 10 then
                    counter := counter + 1;
                else
                    counter := 0; -- Reinicia o contador
                    lcd_e <= '0'; -- Desativa o sinal de enable após o envio dos dados
                end if;
            end loop;
        end if;
    end process;

end Behavioral;
