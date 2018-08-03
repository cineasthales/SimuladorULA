LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;

ENTITY desloca_2 IS
  PORT(
  a: in std_logic_vector(3 downto 0);
  s: out std_logic_vector(3 downto 0)
  );
END desloca_2;
ARCHITECTURE arq_desloca_2 OF desloca_2 IS
BEGIN 
	s(3) <= a(1);
	s(2) <= a(0);
	s(1) <=  '0';
	s(0) <=  '0';	
END arq_desloca_2;