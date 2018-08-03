LIBRARY	IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ULA_JUAN_THALES IS
  PORT(
  a: in std_logic_vector(3 downto 0); -- entrada A
  b: in std_logic_vector(3 downto 0); -- entrada B
  f: in std_logic_vector(3 downto 0); -- seletor de operação
  s: out std_logic_vector(13 downto 0); -- saída
  saida: out std_logic_vector(3 downto 0); -- saída nos leds
  v: out std_logic; -- flag overflow
  z: out std_logic; -- flag zero
  n: out std_logic -- flag negativo
  );
END ULA_JUAN_THALES;

--------------------------------------

ARCHITECTURE arq_ULA_JUAN_THALES OF ULA_JUAN_THALES IS

SIGNAL fio_of: std_logic_vector(15 downto 0);
SIGNAL fio_coder: std_logic_vector(15 downto 0);
SIGNAL fio_somasub: std_logic_vector(3 downto 0);
SIGNAL fio_somaA: std_logic_vector(3 downto 0);
SIGNAL fio_somaB: std_logic_vector(3 downto 0);
SIGNAL fio_nB: std_logic_vector(3 downto 0);
SIGNAL fio_des2: std_logic_vector(3 downto 0);
SIGNAL fio_des1: std_logic_vector(3 downto 0);
SIGNAL fio_soma2a: std_logic_vector(3 downto 0);
SIGNAL fio_soma2b: std_logic_vector(3 downto 0);
SIGNAL fio_or1: std_logic_vector(1 downto 0);
SIGNAL fio_or2: std_logic;
SIGNAL fio_saida: std_logic_vector(3 downto 0);
SIGNAL fio_resto: std_logic;
SIGNAL fio_saida_ov: std_logic;

--------------------------------------

COMPONENT coder
  PORT(
  a: in std_logic_vector(3 downto 0);
  s: out std_logic_vector(15 downto 0)
  );
END COMPONENT;

COMPONENT somador_subtrator_4bits
  PORT(
  a, b: in std_logic_vector(3 downto 0);
  control: in std_logic;
  s: out std_logic_vector(3 downto 0);
  overflow: out std_logic
  );
END COMPONENT;

COMPONENT mux_16x1
  PORT(
  a: in std_logic_vector(15 downto 0);
  control: in std_logic_vector(3 downto 0);
  s: out std_logic
  );
END COMPONENT;

COMPONENT desloca_1
  PORT(
  a: in std_logic_vector(3 downto 0);
  s: out std_logic_vector(3 downto 0)
  );
END COMPONENT;

COMPONENT desloca_2
  PORT(
  a: in std_logic_vector(3 downto 0);
  s: out std_logic_vector(3 downto 0)
  );
END COMPONENT;

COMPONENT seg7_2
  PORT(
  entrada: in std_logic_vector(3 downto 0);
  s: out std_logic_vector(13 downto 0)
  );
END COMPONENT;

--------------------------------------

BEGIN

	codificador: coder
		port map (a => f, s => fio_coder);
	a_mais_menos_b: somador_subtrator_4bits
		port map (a => a, b => b, control => fio_coder(15), s => fio_somasub, overflow => fio_of(0));
	a_mais_a: somador_subtrator_4bits
		port map (a => a, b => a, control => fio_coder(4), s => fio_somaA, overflow => fio_or1(0));
	b_mais_b: somador_subtrator_4bits
		port map (a => b, b => b, control => fio_coder(4), s => fio_somaB, overflow => fio_of(2));
	nega_b: somador_subtrator_4bits
		port map (a => "0000", b => b, control => fio_coder(14), s => fio_nB, overflow => fio_resto);
	desloca1: desloca_1
		port map (a => b, s => fio_des1);
	desloca2: desloca_2
		port map (a => a, s => fio_des2);
	ax2_mais_b: somador_subtrator_4bits
		port map (a => fio_somaA, b => b, control => fio_coder(4), s => fio_soma2a, overflow => fio_or1(1));
	bx2_somasub_b: somador_subtrator_4bits
		port map (a => a, b => fio_somaB, control => fio_coder(13), s => fio_soma2b, overflow => fio_or2);
---------------------------------------------------------------------------------------------------------------
	fio_of(1) <= fio_or1(0) or fio_or1(1);
	fio_of(3) <= fio_of(2) or fio_or2;
	fio_of(5) <= fio_of(2) or fio_or2;
	fio_of(11) <= fio_of(0);
	
	over_flow: mux_16x1
		port map (a => fio_of, control(3) => fio_coder(3), control(2) => fio_coder(2), control(1) => fio_coder(1), 
						control(0) => fio_coder(0), s => fio_saida_ov); 
	mux3: mux_16x1
		port map (a(15) => '0', a(14) => '0', a(13) => b(3), a(12) => a(3), a(11) => fio_somasub(3), 
		a(10) => (a(3) XOR b(3)), a(9) => (a(3) AND b(3)), a(8) => fio_des1(3), a(7) => fio_des2(3),
		a(6) => fio_nB(3), a(5) => fio_soma2b(3), a(4) => (a(3) OR b(3)), a(3) => fio_soma2b(3),
		a(2) => fio_somaB(3), a(1) => fio_soma2a(3), a(0) => fio_somasub(3),
		control(3) => fio_coder(3), control(2) => fio_coder(2), control(1) => fio_coder(1), 
		control(0) => fio_coder(0), s => fio_saida(3));
	
	mux2: mux_16x1
		port map (a(15) => '0', a(14) => '0', a(13) => b(2), a(12) => a(2), a(11) => fio_somasub(2), 
		a(10) => (a(2) XOR b(2)), a(9) => (a(2) AND b(2)), a(8) => fio_des1(2), a(7) => fio_des2(2),
		a(6) => fio_nB(2), a(5) => fio_soma2b(2), a(4) => (a(2) OR b(2)), a(3) => fio_soma2b(2),
		a(2) => fio_somaB(2), a(1) => fio_soma2a(2), a(0) => fio_somasub(2),
		control(3) => fio_coder(3), control(2) => fio_coder(2), control(1) => fio_coder(1), 
		control(0) => fio_coder(0), s => fio_saida(2));
		
	mux1: mux_16x1
		port map (a(15) => '0', a(14) => '0', a(13) => b(1), a(12) => a(1), a(11) => fio_somasub(1), 
		a(10) => (a(1) XOR b(1)), a(9) => (a(1) AND b(1)), a(8) => fio_des1(1), a(7) => fio_des2(1),
		a(6) => fio_nB(1), a(5) => fio_soma2b(1), a(4) => (a(1) OR b(1)), a(3) => fio_soma2b(1),
		a(2) => fio_somaB(1), a(1) => fio_soma2a(1), a(0) => fio_somasub(1),
		control(3) => fio_coder(3), control(2) => fio_coder(2), control(1) => fio_coder(1), 
		control(0) => fio_coder(0), s => fio_saida(1));
		
	mux0: mux_16x1
		port map (a(15) => '0', a(14) => '0', a(13) => b(0), a(12) => a(0), a(11) => fio_somasub(0), 
		a(10) => (a(0) XOR b(0)), a(9) => (a(0) AND b(0)), a(8) => fio_des1(0), a(7) => fio_des2(0),
		a(6) => fio_nB(0), a(5) => fio_soma2b(0), a(4) => (a(0) OR b(0)), a(3) => fio_soma2b(0),
		a(2) => fio_somaB(0), a(1) => fio_soma2a(0), a(0) => fio_somasub(0),
		control(3) => fio_coder(3), control(2) => fio_coder(2), control(1) => fio_coder(1), 
		control(0) => fio_coder(0), s => fio_saida(0));
		
	n <= fio_saida(3); 
	z <= NOT(fio_saida(3) OR fio_saida(2) OR fio_saida(1) OR fio_saida(0)); 
	v <= fio_saida_ov; 
	saida <= fio_saida;
	
	dois7segmentos: seg7_2
		port map(entrada => fio_saida, s => s);

END arq_ULA_JUAN_THALES;