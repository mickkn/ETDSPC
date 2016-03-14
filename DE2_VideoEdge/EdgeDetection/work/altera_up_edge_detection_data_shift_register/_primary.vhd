library verilog;
use verilog.vl_types.all;
entity altera_up_edge_detection_data_shift_register is
    generic(
        DW              : integer := 10;
        SIZE            : integer := 720
    );
    port(
        clken           : in     vl_logic;
        clock           : in     vl_logic;
        shiftin         : in     vl_logic_vector;
        shiftout        : out    vl_logic_vector;
        taps            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end altera_up_edge_detection_data_shift_register;
