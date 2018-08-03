LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_2x1 IS
  PORT(
  a: in std_logic_vector(1 downto 0);
  c: in std_logic;
  s: out std_logic
  );
END mux_2x1;
ARCHITECTURE arq_mux_2x1 OF mux_2x1 IS
BEGIN 
	s <= (((NOT c) AND a(0)) OR (c AND a(1)));
END arq_mux_2x1;