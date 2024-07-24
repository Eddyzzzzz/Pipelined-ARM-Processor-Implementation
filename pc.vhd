library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is -- 32-bit rising-edge triggered register with write-enable and synchronous reset
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     write_enable : in  STD_LOGIC; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     PCWrite      : in std_logic; -- pc write enable for stalls
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
);
end PC;

architecture behavioral  of pc is
signal rollingCounter   : std_logic_vector(63 downto 0);

begin
    
    -- sensitivity list (clk, reset, enable, AddressIn) the data going into the
    -- reg also changes so we add it to the list
    -- add the rolling counter as well set its value to addressout to stall
    process(clk, write_enable, rst, AddressIn, rollingCounter) 
    
    begin
        
        if rst = '1' then
            rollingCounter <= (others => '0');
        elsif rising_edge(clk) and PCWrite = '1' then 
            if write_enable = '1' then 
                rollingCounter <= AddressIn;
            else 
                rollingCounter <= std_logic_vector( (unsigned(rollingCounter) + 1) mod (x"ffffffffffffffff") );
            end if;
        end if;

    end process;
    AddressOut <= rollingCounter;
end behavioral;
