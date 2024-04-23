LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE work.mytype.ALL;

ENTITY detect_win IS
	PORT (
				clk, rst: in std_logic;
				iMat : in tMatrice;
				oMat : out tMatrice
	);
END ENTITY;

ARCHITECTURE ar OF detect_win IS

	TYPE GState IS (init,game, increase_line,increase_column,increase_diag_up ,diag_up, diag_down, down, droite, win);
	SIGNAL state: GState:= init ;
	SIGNAL i: integer;
	SIGNAL j: integer;
	SIGNAL cpt: integer:=0;
	SIGNAL k : integer;
	SIGNAL puissance4: integer := 0;
	SIGNAL player: std_logic_vector(1 downto 0);
	SIGNAL Matrice_1: tMatrice:=(("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","01","00","00","00","00","01","00"),
											 ("00","01","00","00","00","00","01","00"),
											 ("00","01","00","00","00","00","01","00"),
											 ("00","01","00","01","01","00","01","00"),
											 ("00","01","00","01","01","00","01","00"),
											 ("00","00","01","00","00","01","00","00"));
											 
	SIGNAL Matrice_2: tMatrice:=(("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","10","00","00","00","00","10","00"),
											 ("00","10","00","00","00","00","10","00"),
											 ("00","10","00","00","00","00","10","00"),
											 ("00","10","00","10","10","00","10","00"),
											 ("00","10","00","10","10","00","10","00"),
											 ("00","00","10","00","00","10","00","00"));
	SIGNAL Matrice_RST: tMatrice;
--	signal win_player : std_logic_vector(1 downto 0) := "00";
BEGIN
--oMat <= Matrice_1 WHEN win_player = "01" ELSE
--		  Matrice_2 WHEN win_player = "10" ELSE
--		  iMat;
	Matrice_RST<=Matrice_1 WHEN player = "01" ELSE
					Matrice_2;
	oMat<=iMat WHEN puissance4 < 4 ELSE
	Matrice_RST;
	
	p1: PROCESS (clk)
			BEGIN
				IF rst = '0' THEN 
					state <= init;
				ELSIF rising_edge(clk) THEN
					IF puissance4 = 4 THEN 
						state <= win;
					END IF;
					CASE state IS
						WHEN init =>
							i <= 0;
							j <= 0;
							puissance4<=0;
							state <= increase_line;
						WHEN increase_line =>
							player<= "01";
							i<=i+1;
							IF i>7 THEN
								puissance4<=0;
								state <= increase_column;
								i<=1;
							ELSE
								state<=droite;
							END IF;
						WHEN increase_column =>
							j<=j+1;
							IF j>7 THEN
								puissance4<=0;
								j<=0;
								state <= increase_diag_up;
							ELSE
								state<=down;
							END IF;
						WHEN increase_diag_up =>
							j<=j+1;
							k <= j;
							IF j>5 THEN ----c'est FINIIIIIIIIIIIIIIII 15.23
								puissance4<=0;
								j<=0;
								state <= increase_line;
							ELSE
								state<=diag_up;
							END IF;
						WHEN diag_up =>
							IF i>7-j THEN
								i<=1;
								k<=j+1;
								state <= increase_diag_up;
							ELSE
								i<=i+1;
								k<=k+1;
								IF iMat(i,k) = player THEN
									puissance4 <= puissance4+1;
								ELSIF iMat(i,k) ="00" THEN
									puissance4<=0;
								ELSE
									puissance4<=1;
									player <= iMat(i,k);
								END IF;
							END IF;
						WHEN down =>
							IF i>7 THEN
								i<=1;
								state <= increase_column;
							ELSE
								i<=i+1;
								IF iMat(i,j) = player THEN
									puissance4 <= puissance4+1;
								ELSIF iMat(i,j) ="00" THEN
									puissance4<=0;
								ELSE
									puissance4<=1;
									player <= iMat(i,j);
								END IF;
							END IF;
						WHEN droite =>
							IF j>7 THEN
								j<=0;
								state <= increase_line;
							ELSE
								j<=j+1;
								IF iMat(i,j) = player THEN
									puissance4 <= puissance4+1;
								ELSIF iMat(i,j) ="00" THEN
									puissance4<=0;
								ELSE
									puissance4<=1;
									player <= iMat(i,j);
								END IF;
							END IF;
						WHEN win => 
							puissance4<=4;
						WHEN others=>
							state <= init;
						END case;	
			END IF;
		END PROCESS;
--p2 : PROCESS (clk)
--	
--	BEGIN
--	IF rst = '0' THEN 
--			state <= init;
--	ELSIF rising_edge(clk) THEN
--			CASE state IS
--				WHEN init =>
--					cpt <= 0;
--					win_player <= "00";
--					state <= game;
--				WHEN game =>
--					FOR row IN 0 TO 7 LOOP
--						FOR col IN 0 TO 3 LOOP
--							IF (iMat(row, col) = iMat(row, col + 1) AND
--									iMat(row, col + 1) = iMat(row, col + 2) AND
--									iMat(row, col + 2) = iMat(row, col + 3)) THEN
--								win_player <= iMat(row, col);
--							END IF;
--						END LOOP;
--					END LOOP;
--
--					FOR col IN 0 TO 7 LOOP
--						FOR row IN 0 TO 3 LOOP
--							IF (iMat(row, col) = iMat(row + 1, col) AND
--									iMat(row + 1, col) = iMat(row + 2, col) AND
--									iMat(row + 2, col) = iMat(row + 3, col)) THEN
--								win_player <= iMat(row, col);
--							END IF;
--						END LOOP;
--					END LOOP;
--
--					FOR row IN 0 TO 3 LOOP
--						FOR col IN 0 TO 3 LOOP
--							IF (iMat(row, col) = iMat(row + 1, col + 1) AND
--									iMat(row + 1, col + 1) = iMat(row + 2, col + 2) AND
--									iMat(row + 2, col + 2) = iMat(row + 3, col + 3)) THEN
--								win_player <= iMat(row, col);
--							END IF;
--						END LOOP;
--					END LOOP;
--
--					FOR row IN 0 TO 3 LOOP
--						FOR col IN 3 TO 7 LOOP
--							IF (iMat(row, col) = iMat(row + 1, col - 1) AND
--									iMat(row + 1, col - 1) = iMat(row + 2, col - 2) AND
--									iMat(row + 2, col - 2) = iMat(row + 3, col - 3)) THEN
--								win_player <= iMat(row, col);
--							END IF;
--						END LOOP;
--					END LOOP;
--					IF (win_player = "01") THEN
--						state <= win;
--						-- Player 1 has won
--						-- Output to some signal or register to indicate player 1 has won
--					ELSIF (win_player = "10") THEN
--						state <= win;
--						-- Player 2 has won
--						-- Output to some signal or register to indicate player 2 has won
--					END IF;
--			
--				WHEN win =>
--					state <= win;
----					IF cpt=12500 THEN
----								state<=init;
----							ELSE
----								cpt <= cpt+1;
----							END IF;
--				WHEN others=>
--					state <= init;
--			END case;
--		END IF;
--	END PROCESS;
END ar;