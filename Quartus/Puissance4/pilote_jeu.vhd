LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE work.mytype.ALL;

ENTITY pilote_jeu IS
	PORT (
				iValid1, iValid2, clk, rst, iChange1,iChange2 : in std_logic;
				indice1,indice2 : in std_logic_vector(2 downto 0);
				oMat : out tMatrice;
				oplayer: out std_logic_vector(1 downto 0);
				oValid : out std_logic
	);
END ENTITY;

ARCHITECTURE ar OF pilote_jeu IS

	TYPE TState IS (init, waiting_change, disp_cursor, playing, release, waiting, verif_victoire);
	SIGNAL indice : std_logic_vector(2 downto 0) := indice1;
	SIGNAL state : TState := init;
	SIGNAL nshot: integer:=0;
	SIGNAL iChange,iValid : std_logic;
	SIGNAL int_indice: integer;
	SIGNAL player : integer;
	type tab is array (0 to 7) of integer;
	SIGNAL column : tab;
	SIGNAL cpt: integer;
	SIGNAL Matrice : tMatrice;
	CONSTANT Matrice_RST: tMatrice:=(("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"),
											 ("00","00","00","00","00","00","00","00"));
--	  SIGNAL Matrice : tMatrice :=(("01","10","00","00","00","00","00","00"),
--											 ("00","01","10","00","00","00","00","00"),
--											 ("00","00","01","10","00","00","00","00"),
--											 ("00","00","00","01","10","00","00","00"),
--											 ("00","00","00","00","01","10","00","00"),
--											 ("00","00","00","00","00","01","10","00"),
--											 ("00","00","00","00","00","00","01","10"),
--											 ("00","00","00","00","00","00","00","01"));
BEGIN
	int_indice <= to_integer(unsigned(indice));
	oMat <= Matrice ;
	player <= (nshot mod 2)+ 1;
	oplayer <= std_logic_vector(to_unsigned(player,2));
	iChange <= iChange1 WHEN  player = 1 ELSE iChange2;
	iValid <= iValid1 WHEN  player = 1 ELSE iValid2;
	indice <= indice1 WHEN player = 1 ELSE indice2;
	p1: PROCESS (clk,rst)
			BEGIN
				IF rst = '0' THEN 
					state <= init;
					cpt <= 0;
				ELSIF rising_edge(clk) THEN
					CASE state IS
						WHEN init =>
							cpt<=0;
							column(0)<= 7;
							column(1)<= 7;
							column(2)<= 7;
							column(3)<= 7;
							column(4)<= 7;
							column(5)<= 7;
							column(6)<= 7;
							column(7)<= 7;
							nshot <= 1;
							Matrice <= Matrice_RST;
							oValid <='1';
							state <= disp_cursor;
						WHEN waiting_change =>
							IF iChange = '1' THEN
								Matrice(0, 0) <= "00";
								Matrice(0, 1) <= "00";
								Matrice(0, 2) <= "00";
								Matrice(0, 3) <= "00";
								Matrice(0, 4) <= "00";
								Matrice(0, 5) <= "00";
								Matrice(0, 6) <= "00";
								Matrice(0, 7) <= "00";
								state <= disp_cursor;
							END IF;
							IF cpt > 600 THEN
								IF iValid = '0' THEN
									state <= release;
								END IF;
							ELSE
								cpt<= cpt+1;
							END IF;
							oValid <='1';
						WHEN disp_cursor =>
							Matrice(0, int_indice) <= std_logic_vector(to_unsigned(player,2));
							if (iChange='0') then
								state <= waiting_change;
							end if;
							oValid <='0';
						WHEN playing =>
							IF column(int_indice)>0 THEN
								Matrice(column(int_indice),int_indice)<= std_logic_vector(to_unsigned(player,2));
								column(int_indice)<=column(int_indice)-1;
								nshot <= nshot+1;
							END IF;
							oValid <='1';
							state <= waiting;
						WHEN release =>
							cpt<=0;
							IF iValid = '1' THEN
								state <= playing;
							END IF;
							oValid <='1';
						WHEN waiting =>                                        
							Matrice(0,int_indice)<=std_logic_vector(to_unsigned(player,2));		
							IF (iValid='1') THEN
								state <= waiting_change;
							END IF;
							oValid <='0';
						WHEN OTHERS =>
							state <= init;
							oValid <='1';
					END CASE;
				END IF;
	END PROCESS;
END ar;