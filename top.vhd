library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
  Port(
  anode: out std_logic_vector(3 downto 0);
  cathode: out std_logic_vector(6 downto 0);
  clk: in std_logic;
  reset: in std_logic
  );
end top;

architecture Behavioral of top is

signal inner_clk: std_logic_vector(1 downto 0);
signal change_clk: std_logic;

signal letter1: std_logic_vector(6 downto 0) := "0011000";
signal letter2: std_logic_vector(6 downto 0) := "0011000";
signal letter3: std_logic_vector(6 downto 0) := "0011000";
signal letter4: std_logic_vector(6 downto 0) := "0011000";

type mem is array(0 to 11) of std_logic_vector(6 downto 0);
signal reg: mem := (
    0 => "1111001",
    1 => "1111111",
    2 => "1110001",
    3 => "0000001",
    4 => "1000101",
    5 => "0110000",
    6 => "1111111",
    7 => "1000100",
    8 => "0000001",
    9 => "1000001",
    10 => "1111111",
    11 => "1111111"
); 

begin
    process(clk)
        variable aux: std_logic_vector(15 downto 0) := x"0000";
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    aux := x"0000";
                else
                    aux := aux + 1;
                end if;
            end if;
            inner_clk <= aux(15 downto 14);
    end process;
    
    process(clk)
        variable aux: std_logic_vector(23 downto 0) := "000000000000000000000000";
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    aux := "000000000000000000000000";
                else
                    aux := aux + 1;
                end if;
            end if;
            change_clk <= aux(23);
    end process;
    
    with inner_clk select anode <=
        "0111" when "00",
        "1011" when "01",
        "1101" when "10",
        "1110" when others;
    
    process(change_clk)
        variable aux: integer := 0;
        begin
            if rising_edge(change_clk) then
                if aux < 9 then
                    letter4 <= reg(aux);
                    letter3 <= reg(aux + 1);
                    letter2 <= reg(aux + 2);
                    letter1 <= reg(aux + 3);
                elsif aux = 9 then
                    letter4 <= reg(9);
                    letter3 <= reg(10);
                    letter2 <= reg(11);
                    letter1 <= reg(0);
                elsif aux = 10 then
                    letter4 <= reg(10);
                    letter3 <= reg(11);
                    letter2 <= reg(0);
                    letter1 <= reg(1);
                elsif aux = 11 then
                    letter4 <= reg(11);
                    letter3 <= reg(0);
                    letter2 <= reg(1);
                    letter1 <= reg(2);
                end if;
                aux := aux + 1;
                if aux = 10 then
                    aux := 0;
                end if;
            end if;
    end process;
    
    with inner_clk select cathode <=
        letter4 when "00",
        letter3 when "01",
        letter2 when "10",
        letter1 when others;
    

end Behavioral;
