library verilog;
use verilog.vl_types.all;
entity altera_up_edge_detection_pixel_info_shift_register is
    generic(
        SIZE            : integer := 3628
    );
    port(
        clken           : in     vl_logic;
        clock           : in     vl_logic;
        shiftin         : in     vl_logic_vector(1 downto 0);
        shiftout        : out    vl_logic_vector(1 downto 0);
        taps            : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end altera_up_edge_detection_pixel_info_shift_register;
