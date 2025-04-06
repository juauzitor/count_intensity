library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count_intensity is 
    port(
        clk:    in std_logic;
        reset:  in std_logic;
        digit0: out std_logic_vector(3 downto 0);  -- BCD unidades
        digit1: out std_logic_vector(3 downto 0);  -- BCD dezenas
		  seg0: out std_logic_vector(6 downto 0);
		  seg1: out std_logic_vector(6 downto 0)
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

	 process(count0, count1)
	 begin
		case count0 is
				when 0 => seg0 <= "0000001"; -- 0
            when 1 => seg0 <= "1001111"; -- 1
            when 2 => seg0 <= "0010010"; -- 2
            when 3 => seg0 <= "0000110"; -- 3
            when 4 => seg0 <= "1001100"; -- 4
            when 5 => seg0 <= "0100100"; -- 5
            when 6 => seg0 <= "0100000"; -- 6
            when 7 => seg0 <= "0001111"; -- 7
            when 8 => seg0 <= "0000000"; -- 8
            when 9 => seg0 <= "0000100"; -- 9
            when others => seg0 <= "1111111"; -- Apagado
		end case;
		case count0 is
				when 0 => seg1 <= "0000001"; -- 0
            when 1 => seg1 <= "1001111"; -- 1
            when 2 => seg1 <= "0010010"; -- 2
            when 3 => seg1 <= "0000110"; -- 3
            when 4 => seg1 <= "1001100"; -- 4
            when 5 => seg1 <= "0100100"; -- 5
            when 6 => seg1 <= "0100000"; -- 6
            when 7 => seg1 <= "0001111"; -- 7
            when 8 => seg1 <= "0000000"; -- 8
            when 9 => seg1 <= "0000100"; -- 9
            when others => seg1 <= "1111111"; -- Apagado
		end case;
	 end process;
    -- Conversão para BCD (4 bits)
    digit0 <= std_logic_vector(to_unsigned(count0, 4));
    digit1 <= std_logic_vector(to_unsigned(count1, 4));
	
	
	 
end behavioral;