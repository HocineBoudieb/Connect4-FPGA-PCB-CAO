LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.mytype.ALL;

ENTITY pilote_matrice IS
	PORT (
				iStart, clk  : in std_logic;
				Mat : in tMatrice;
				oBIT : out std_logic
	);
END ENTITY;

ARCHITECTURE arch OF pilote_matrice IS
	
	TYPE TState IS (waiting_start, start, s0h, s1h, sl, spix, read_matrice);
	SIGNAL state: TState:= waiting_start;
	SIGNAL cpt: integer:=0;
	SIGNAL i: integer:=0;
	SIGNAL j: integer:=0;
	SIGNAL a: integer:=0;
	SIGNAL pixel : std_logic_vector(23 downto 0);
	SIGNAL cellule : std_logic_vector(1 downto 0);
--	SIGNAL inter_GRB: std_logic_vector(23 downto 0);
	constant rose  : std_logic_vector(23 downto 0) := "000000101010101000100000";
	constant bleu  : std_logic_vector(23 downto 0) := "101010100000000011100000";
	constant nul   : std_logic_vector(23 downto 0) := "000000000000000000000000";
	constant blanc : std_logic_vector(23 downto 0) := "001001000010010000100100";

BEGIN

	p1: PROCESS (clk)

			BEGIN
				IF rising_edge(clk) THEN
					CASE state IS
						WHEN waiting_start =>
							i <= 0;
							cpt <= 0;
							j <= 0;
							a <= 0;
						IF (iStart='0') THEN
								state <= read_matrice;	
								cellule <= Mat(0, 0);
							ELSE 
							state <= waiting_start;
						END IF;			
							oBit<='0';
						WHEN read_matrice =>
							IF (cellule = "00") THEN
								pixel <= nul;
							ELSIF (cellule = "01") THEN
								pixel <= bleu;
							ELSIF (cellule = "10") THEN
								pixel <= rose;
							ELSE 
								pixel <= blanc;
							END IF;
							state <= start;
						WHEN start =>
							cpt <=0;
							IF (pixel(a)='1') THEN
								state <= s1h;
							ELSE
								state <= s0h;
							END IF;
							oBit<='0';
						WHEN s1h =>
							oBit<='1';
							IF cpt=40 THEN
								state<= sl;
							ELSE
								cpt <= cpt+1;
							END IF;
						WHEN s0h =>
							oBit<='1';
							IF cpt=20 THEN		
								state<=sl;
							ELSE
								cpt <= cpt+1;
							END IF;
						WHEN sl=>
							oBiT<='0';
							IF cpt=63 THEN
								state<=spix;
							ELSE
								cpt <= cpt+1;
							END IF;
						WHEN spix =>
							IF a=23 THEN 
								IF j=7 THEN
									IF i=7 THEN
										--IF iStart='1'  THEN 
											state <= waiting_start;                                                                                                                                                              
										--END IF;
									ELSE 
										j <= 0;
										cellule <= Mat(i+1, 0);
										i <= i+1;
										a <= 0;
										state <= read_matrice;
									END IF;
								ELSE 
									cellule <= Mat(i, j+1);
									j <= j+1;
									a <= 0;
									state <= read_matrice;
								END IF;
							ELSE 
								a<=a+1;
								state <= start;
							END IF;
							oBiT<='0';
						WHEN OTHERS =>
							state <= waiting_start;
							oBiT <= '0';
					END CASE;
				END IF;
			END PROCESS;

END ARCHITECTURE;