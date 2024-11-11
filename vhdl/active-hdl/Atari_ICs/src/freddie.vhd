															   LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY freddie IS
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
END ENTITY;

ARCHITECTURE behaviour OF freddie IS

	SIGNAL neg_clk : STD_ULOGIC;
	SIGNAL fcount : STD_ULOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL mpy : STD_ULOGIC;
	SIGNAL l_rw : STD_ULOGIC;

BEGIN

	freddie_counter : PROCESS (clk_in, rst)
	BEGIN
		IF rst = '0' THEN
			fcount <= "000";
		ELSIF clk_in'event AND clk_in = '1' THEN

			fcount(0) <= (NOT fcount(2) AND NOT fcount(1) AND NOT phi2)
			OR (fcount(2) AND fcount(1) AND phi2);

			fcount(1) <= (NOT fcount(2) AND fcount(0) AND NOT phi2)
			OR (NOT fcount(2) AND fcount(1) AND NOT fcount(0) AND NOT phi2)
			OR (fcount(2) AND fcount(1) AND NOT fcount(0) AND phi2);

			fcount(2) <= (NOT fcount(2) AND fcount(1) AND NOT fcount(0) AND NOT phi2)
			OR (fcount(2) AND fcount(1) AND NOT fcount(0) AND phi2)
			OR (fcount(2) AND fcount(0) AND phi2);

		END IF;
	END PROCESS freddie_counter;

	ras_rw : PROCESS (neg_clk, rst)
	BEGIN
		IF rst = '0' THEN
			ras <= '1';
			l_rw <= '1';
		ELSIF neg_clk'event AND neg_clk = '1' THEN
			IF fcount = "000" OR fcount = "001" OR fcount = "011" THEN
				ras <= '1';
			ELSE
				ras <= '0';
			END IF;

			IF fcount = "010" THEN
				l_rw <= rw;
			END IF;

		END IF;
	END PROCESS ras_rw;

	neg_clk <= NOT clk_in;
	clk_out <= neg_clk;
	osc <= '1' WHEN fcount(2 DOWNTO 1) = "00" OR fcount(2 DOWNTO 1) = "11" ELSE '0';
	mpy <= '0' WHEN fcount = "001" OR fcount = "011" OR fcount = "010" ELSE '1';
	ba(0) <= a(0) WHEN mpy = '0' ELSE a(8);
	ba(1) <= a(1) WHEN mpy = '0' ELSE a(9);
	ba(2) <= a(2) WHEN mpy = '0' ELSE a(10);
	ba(3) <= a(3) WHEN mpy = '0' ELSE a(11);
	ba(4) <= a(4) WHEN mpy = '0' ELSE a(12);
	ba(5) <= a(5) WHEN mpy = '0' ELSE a(13);
	ba(6) <= a(6) WHEN mpy = '0' ELSE a(14);
	ba(7) <= a(7) WHEN mpy = '0' ELSE a(15);
	w <= rw WHEN fcount = "001" OR fcount = "011" OR (fcount = "010" AND neg_clk = '0') ELSE l_rw;
	cas <= '1' WHEN extsel = '0' OR casinh = '0'
		OR fcount = "011" OR fcount = "010" OR fcount = "110"
		OR (l_rw = '1' AND fcount = "001")
		OR (l_rw = '0' AND fcount = "111")
		OR (l_rw = '0' AND fcount = "001" AND neg_clk = '1')
		OR (l_rw = '0' AND fcount = "101" AND neg_clk = '0')
		ELSE '0';

END ARCHITECTURE;