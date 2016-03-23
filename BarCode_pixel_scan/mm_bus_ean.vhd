library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mm_bus_counter is
  
  port (
    -- Avalon Interface
    csi_clockreset_clk     : in  std_logic;                     -- Avalon Clk
    csi_clockreset_reset_n : in  std_logic;                     -- Avalon Reset
    avs_s1_write           : in  std_logic;                     -- Avalon wr
    avs_s1_read            : in  std_logic;                     -- Avalon rd
    avs_s1_chipselect      : in  std_logic;                     -- Avalon cs
    avs_s1_address         : in  std_logic_vector(7 downto 0);  -- Avalon address
    avs_s1_writedata       : in  std_logic_vector(3 downto 0);  -- Avalon wr data
    avs_s1_readdata        : out std_logic_vector(3 downto 0);  -- Avalon rd data
    ins_irq0_irq           : out std_logic;                     -- Avalon irq

  -- External Inputs
  input_irq     : in std_logic;
  input_counter : in std_logic);

end mm_bus_counter;

architecture behaviour of mm_bus_counter is

-- Signal Declarations
	signal counter 			: std_logic_vector(15 downto 0):=(others=>'0');
	signal counter_reset	: std_logic := 0;
	signal data_register 	: std_logic_vector(15 downto 0);
	
begin
	-- Watching MM-bus
	seq : process(csi_clockreset_clk) -- Sensitivity list
		begin
			if rising_edge(csi_clockreset_clk) then
			
				-- If a write is happening, put data into register
				if avs_s1_write = '1' then
					if avs_s1_chipselect = '1' then
						data_register <= avs_s1_writedata;
					end if;
				end if;
				
				-- If a read is happening
				if avs_s1_read = '1' then
					if avs_s1_chipselect = '1' then
						if avs_s1_address = X"00" then
							avs_s1_writedata <= counter;
						else if avs_s1_address = X"01" then
							counter_reset <= '1'; --Reset Counter
						end if;
					end if;
				end if;
			end if;
	end process seq;

	-- Counter process, count up for every input_counter
	counter <= X"0000";	-- Initial value
	count : process(input_counter)
		begin
			if rising_edge(input_counter) then
				if counter_reset = '0' then
					counter <= std_logic_vector(unsigned(counter) + 1);
				else
					counter <= X"0000";
					counter_reset <= '0';
				end if;
			end if;
	end process count;
	
	--invert input_irq to ins_irq0_irq
	ins_irq0_irq <= not input_irq;
  
end behaviour;
