LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;

ENTITY desloca_1 IS
  PORT(
  a: in std_logic_vector(3 downto 0);
  s: out std_logic_vector(3 downto 0)
  );
END desloca_1;
ARCHITECTURE arq_desloca_1 OF desloca_1 IS
BEGIN 
	s(3) <=  '0';
	s(2) <= a(3);
	s(1) <= a(2);
	s(0) <= a(1);
	
END arq_desloca_1;