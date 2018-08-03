library verilog;
use verilog.vl_types.all;
entity ULA_JUAN_THALES is
    port(
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        f               : in     vl_logic_vector(3 downto 0);
        s               : out    vl_logic_vector(13 downto 0);
        saida           : out    vl_logic_vector(3 downto 0);
        v               : out    vl_logic;
        z               : out    vl_logic;
        n               : out    vl_logic
    );
end ULA_JUAN_THALES;
