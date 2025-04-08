LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; -- Adicionado para operações numéricas

ENTITY count_intensity IS
    PORT (
        clk     : IN  STD_LOGIC;
        blink   : OUT STD_LOGIC;
		  reset: in std_logic;
		  button_up:  in std_logic;
        button_down: in std_logic;
		  digit0:     out std_logic_vector(3 downto 0);  -- BCD unidades
        digit1:     out std_logic_vector(3 downto 0);	 -- BCD dezenas
		  seg0		 : OUT std_logic_vector(6 downto 0);
		  seg1		 : OUT std_logic_vector(6 downto 0)
    );
END count_intensity;

ARCHITECTURE counter OF count_intensity IS
    -- Constante para divisão do clock (ajuste conforme o clock da sua placa)
    constant DIVISOR : INTEGER := 25000000; -- Para 50MHz, 25M ciclos = 0.5s
	 signal count0, count1: INTEGER RANGE 0 TO 10 := 0;
	 signal button_up_prev, button_down_prev: std_logic := '0';
BEGIN
    PROCESS(clk)
        VARIABLE blink_counter: INTEGER RANGE 0 TO DIVISOR := 0;
        VARIABLE blink_state: STD_LOGIC := '0';
		  variable bcd0: std_logic_vector(3 downto 0);
		  variable bcd1: std_logic_vector(3 downto 0);
    BEGIN
		 if reset = '0' then
            count0 <= 0;
            count1 <= 0;
            button_up_prev <= '0';
            button_down_prev <= '0';
        elsif rising_edge(clk) THEN
            -- Controle do Blink (1Hz)
            blink_counter := blink_counter + 1;
            IF blink_counter = DIVISOR THEN
                blink_counter := 0;
                blink_state := NOT blink_state; -- Inverte o estado
					-- Contador principal (0-9)
					button_up_prev <= button_up;
					button_down_prev <= button_down;
					
					-- Lógica de incremento (botão up)
					if button_up = '1' then
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
					
					-- Lógica de decremento (botão down)
					elsif button_down = '1' then
						 if count0 = 0 then
							  count0 <= 9;
							  if count1 = 0 then
									count1 <= 9;
							  else
									count1 <= count1 - 1;
							  end if;
						 else
							  count0 <= count0 - 1;
						 end if;
					end if;
				END IF;
				blink <= blink_state;
				 bcd0 := std_logic_vector(to_unsigned(count0, 4));
				 bcd1 := std_logic_vector(to_unsigned(count1, 4));	
        END IF;
		  case bcd0 is
				when "0000" => seg0 <= "1000000"; -- 0
            when "0001" => seg0 <= "1111001"; -- 1
            when "0010" => seg0 <= "0100100"; -- 2
            when "0011" => seg0 <= "0110000"; -- 3
            when "0100" => seg0 <= "0011001"; -- 4
            when "0101" => seg0 <= "0010010"; -- 5
            when "0110" => seg0 <= "0000010"; -- 6
            when "0111" => seg0 <= "1111000"; -- 7
            when "1000" => seg0 <= "0000000"; -- 8
            when "1001" => seg0 <= "0010000"; -- 9
            when others => seg0 <= "1111111"; -- Apagado
		end case;
		case bcd1 is
				when "0000" => seg1 <= "1000000"; -- 0
            when "0001" => seg1 <= "1111001"; -- 1
            when "0010" => seg1 <= "0100100"; -- 2
            when "0011" => seg1 <= "0110000"; -- 3
            when "0100" => seg1 <= "0011001"; -- 4
            when "0101" => seg1 <= "0010010"; -- 5
            when "0110" => seg1 <= "0000010"; -- 6
            when "0111" => seg1 <= "1111000"; -- 7
            when "1000" => seg1 <= "0000000"; -- 8
            when "1001" => seg1 <= "0010000"; -- 9
            when others => seg1 <= "1111111"; -- Apagado
		end case;
		digit0 <= bcd0;
		digit1 <= bcd1;
    END PROCESS;
END counter;