library verilog;
use verilog.vl_types.all;
entity ULA_JUAN_THALES_vlg_check_tst is
    port(
        n               : in     vl_logic;
        s               : in     vl_logic_vector(13 downto 0);
        saida           : in     vl_logic_vector(3 downto 0);
        v               : in     vl_logic;
        z               : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end ULA_JUAN_THALES_vlg_check_tst;
