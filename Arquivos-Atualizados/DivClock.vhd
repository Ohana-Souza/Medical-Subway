library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DivClock is
    generic (Divisao : integer := 50000);
    port (
        CLK_ClockIN : in std_logic; -- Entrada do clock
        CLK_Reset : in std_logic; -- Entrada de reset
        CLK_ClockOUT : out std_logic -- Saída do clock (clock dividido)
    );
end DivClock;

architecture Behavioral of DivClock is
    signal counter : integer := 0;
    signal clk_div : std_logic := '0';
    constant DIVISOR : integer := Divisao; -- Altere este valor para dividir por um número diferente
begin
    process (CLK_ClockIN, CLK_Reset)
    begin
        if CLK_Reset = '1' then
            counter <= 0;
            clk_div <= '0';
        elsif rising_edge(CLK_ClockIN) then
            if counter = (DIVISOR / 2) - 1 then
                clk_div <= not clk_div;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    CLK_ClockOUT <= clk_div;

end Behavioral;