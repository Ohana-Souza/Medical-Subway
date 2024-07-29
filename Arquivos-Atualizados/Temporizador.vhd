library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Temporizador is
    generic (
        frequencia : integer := 25_000_000; -- Frequência do clock em Hz (1 MHz, por exemplo)
        tempo : integer := 30 -- Tempo de temporização em segundos (30 segundos)
    );
    port (
        TEMP_Clock  : in  std_logic; -- Clock de entrada
        TEMP_Start  : in  std_logic; -- Sinal para iniciar o temporizador
        TEMP_Reset  : in  std_logic; -- Sinal para resetar o temporizador
        TEMP_SigOUT : out std_logic  -- Sinal de saída que indica se o tempo foi atingido
    );
end Temporizador;

architecture arch of Temporizador is
    constant MAX_COUNT : integer := frequencia * tempo; -- Contador máximo baseado na frequência do clock e tempo desejado
    signal Contador    : integer range 0 to MAX_COUNT := 0; -- Sinal para o contador
begin

    -- Processo responsável pelo temporizador
    process(TEMP_Clock, TEMP_Reset)
    begin
        if TEMP_Reset = '1' then
            -- Reseta o contador quando TEMP_Reset é alto
            Contador <= 0;
            TEMP_SigOUT <= '0';
        elsif rising_edge(TEMP_Clock) then
            -- Aumenta o contador se TEMP_Start está alto e o clock está na borda de subida
            if TEMP_Start = '1' then
                if Contador = MAX_COUNT then
                    -- Define TEMP_SigOUT como alto quando o contador atinge MAX_COUNT
                    TEMP_SigOUT <= '1';
                else
                    -- Incrementa o contador
                    Contador <= Contador + 1;
                end if;
            else
                -- Reseta o contador se TEMP_Start está baixo
                Contador <= 0;
            end if;
        end if;
    end process;

end arch;