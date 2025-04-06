library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_intensity is 
    port(
        clk:    in std_logic;
        reset:  in std_logic;
        digit0: out std_logic_vector(3 downto 0);  -- BCD unidades
        digit1: out std_logic_vector(3 downto 0)   -- BCD dezenas
    );
end count_intensity;

architecture behavioral of count_intensity is
    signal count0, count1: integer range 0 to 9 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count0 <= 0;
            count1 <= 0;
        elsif rising_edge(clk) then
            if count0 = 9 then
                count0 <= 0;
                if count1 = 9 then
                    count1 <= 0;
                else
                    count1 <= count1 + 1;
                end if;
            else
                count0 <= count0 + 1;
            end if;
        end if;
    end process;

    -- Conversão para BCD (4 bits)
    digit0 <= std_logic_vector(to_unsigned(count0, 4));
    digit1 <= std_logic_vector(to_unsigned(count1, 4));
	
	
	 
end behavioral;