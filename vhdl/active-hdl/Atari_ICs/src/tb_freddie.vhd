LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY freddie_tb IS
END ENTITY;

ARCHITECTURE testbench OF freddie_tb IS

	COMPONENT freddie IS
		PORT (
			clk_in : IN STD_ULOGIC;
			clk_out : OUT STD_ULOGIC;
			rst : IN STD_ULOGIC;
			extsel : IN STD_ULOGIC;
			casinh : IN STD_ULOGIC;
			phi2 : IN STD_ULOGIC;
			rw : IN STD_ULOGIC;
			a : IN STD_ULOGIC_VECTOR(15 DOWNTO 0);
			osc : OUT STD_ULOGIC;
			ras : OUT STD_ULOGIC;
			cas : OUT STD_ULOGIC;
			w : OUT STD_ULOGIC;
			ba : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL s_clk_in : STD_ULOGIC;
	SIGNAL s_clk_out : STD_ULOGIC;
	SIGNAL s_rst : STD_ULOGIC;
	SIGNAL s_extsel : STD_ULOGIC;
	SIGNAL s_casinh : STD_ULOGIC;
	SIGNAL s_phi2 : STD_ULOGIC;
	SIGNAL s_rw : STD_ULOGIC;
	SIGNAL s_a : STD_ULOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL s_osc : STD_ULOGIC;
	SIGNAL s_ras : STD_ULOGIC;
	SIGNAL s_cas : STD_ULOGIC;
	SIGNAL s_w : STD_ULOGIC;
	SIGNAL s_ba : STD_ULOGIC_VECTOR(7 DOWNTO 0);

	-- PAL
	CONSTANT period : TIME := 35242 ps;

	-- NTSC
	-- CONSTANT period : TIME := 34910 ps;

BEGIN

	connect : freddie PORT MAP(s_clk_in, s_clk_out, s_rst, s_extsel, s_casinh, s_phi2, s_rw, s_a, s_osc, s_ras, s_cas, s_w, s_ba);

	clock_14MHz : PROCESS
	BEGIN
		s_clk_in <= '1';
		WAIT FOR period;
		s_clk_in <= '0';
		WAIT FOR period;
	END PROCESS clock_14MHz;

	clock_o2 : PROCESS
	BEGIN
		s_phi2 <= '0';
		WAIT FOR period * 7;
		s_phi2 <= '1';
		WAIT FOR period * 8;
		s_phi2 <= '0';
		WAIT FOR period;
	END PROCESS clock_o2;

	main : PROCESS
	BEGIN

		s_rst <= '0';
		s_rw <= '0';
		s_extsel <= '0';
		s_casinh <= '0';
		s_a <= "0000000011111111";
		WAIT FOR period * 11;

		s_rst <= '1';
		WAIT FOR period * 5;

		s_extsel <= '1';
		s_casinh <= '1';
		WAIT FOR period * 16;

		s_rw <= '1';
		WAIT FOR period * 16;

		s_rw <= '0';
		WAIT FOR period * 32;

	END PROCESS main;

END;
