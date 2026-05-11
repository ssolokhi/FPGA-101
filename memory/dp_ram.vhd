library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_RAM is
    generic (
        c_WIDTH: integer := 16;
        c_DEPTH: integer := 256
    );
    port (
        -- write-related
        i_write_clock: in std_logic;
        i_write_address: in std_logic_vector; -- will be sized later on
        i_write_enable: in std_logic;
        i_write_data: in std_logic_vector(c_WIDTH-1 downto 0);
        -- read-related
        i_read_clock: in std_logic;
        i_read_address: in std_logic_vector; -- will be sized later on
        i_read_enable: in std_logic;
        o_read_data: out std_logic_vector(c_WIDTH-1 downto 0);
        o_read_ready: out std_logic
    );
end dual_port_RAM;

architecture dual_port_RAM_RTL of dual_port_RAM is
    -- create custom 2D data type
    type t_RAM is array (0 to c_DEPTH-1) of std_logic_vector(c_WIDTH-1 downto 0);
    signal r_RAM: t_RAM;
begin
    process (i_write_clock)
    begin 
        if rising_edge(i_write_clock) then 
            r_RAM(to_integer(unsigned(i_write_address))) <= i_write_data;
        end if;
    end process;
    process (i_read_clock)
    begin
        if rising_edge(i_read_clock) then
            o_read_data <= r_RAM(to_integer(unsigned(i_read_address)));
            o_read_ready <= i_read_enable;
        end if;
    end process;
end dual_port_RAM_RTL;
