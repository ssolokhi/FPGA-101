library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIFO is
    generic (
        c_WIDTH: integer := 16;
        c_DEPTH: integer := 256;
        c_ALMOST_FULL_LEVEL: integer := 2;
        c_ALMOST_EMPTY_LEVEL: integer := 2
    );
    port (
        -- write-related
        i_write_clock: in std_logic;
        i_write_enable: in std_logic;
        i_write_data: in std_logic_vector(c_WIDTH-1 downto 0);
        -- read-related
        i_read_clock: in std_logic;
        i_read_enable: in std_logic;
        o_read_data: out std_logic_vector(c_WIDTH-1 downto 0);
        o_read_ready: out std_logic;
        o_is_full: out std_logic;
        o_is_almost_full: out std_logic;
        o_is_empty: out std_logic;
        o_is_almost_empty: out std_logic
    );
end FIFO;

architecture FIFO_RTL of FIFO is
    -- create custom 2D data type
    type t_FIFO is array (0 to c_DEPTH-1) of std_logic_vector(c_WIDTH-1 downto 0);
    signal r_FIFO: t_FIFO;
    signal r_write_address: natural range 0 to c_DEPTH - 1;
    signal r_read_address: natural range 0 to c_DEPTH - 1;
    signal r_element_count: natural;
begin
    process (i_write_clock)
    begin 
        if rising_edge(i_write_clock) then 
            if (i_write_enable) then
                if (r_write_address = c_DEPTH - 1) then
                    r_write_address <= 0; -- to prevent overflow
                else
                    r_FIFO(r_write_address) <= i_write_data;
                    r_write_address <= r_write_address + 1;
                end if;
            end if;
            if (i_write_enable = '1' and i_read_enable = '0') then
                if r_element_count /= c_DEPTH then
                    r_element_count <= r_element_count + 1;
                end if;
            end if;
        end if;
    end process;
    process (i_read_clock)
    begin 
        if rising_edge(i_read_clock) then 
            if (i_read_enable) then
                if (r_read_address = c_DEPTH - 1) then
                    r_read_address <= 0; -- to prevent overflow
                else
                    r_read_address <= r_read_address + 1;
                end if;
            end if;
            if (i_read_enable = '1' and i_write_enable = '0') then
                if r_element_count /= 0 then
                    r_element_count <= r_element_count + 1;
                end if;
            end if;
        end if;
    end process;
    o_read_data <= r_FIFO(r_read_address);
    o_is_full <= '1' when ((r_element_count = c_DEPTH) or (r_element_count = c_DEPTH - 1 and i_write_enable = '1' and i_read_enable = '0')) else '0'; 
    o_is_almost_full <= '1' when (r_element_count > c_DEPTH - c_ALMOST_FULL_LEVEL) else '0';
    o_is_empty <= '1' when (r_element_count = 0) else '0'; 
    o_is_almost_empty <= '1' when (r_element_count < c_ALMOST_EMPTY_LEVEL) else '0';
end FIFO_RTL;
