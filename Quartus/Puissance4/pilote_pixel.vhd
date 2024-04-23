LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pilote_pixel IS
	PORT (
				iStart, clk : in std_logic;
				GRB : in std_logic_vector(23 downto 0);
				oBIT : out std_logic
	);
END ENTITY;

ARCHITECTURE arch OF pilote_pixel IS
	
	TYPE TState IS (waiting_start, start, s0h, s1h, sl);
	SIGNAL state: TState:= waiting_start;
	SIGNAL cpt: integer:=0;
	SIGNAL i: integer:=0;
--	SIGNAL inter_GRB: std_logic_vector(23 downto 0);

BEGIN

	p1: PROCESS (clk)

		BEGIN
			IF rising_edge(clk) THEN
				CASE state IS
					WHEN waiting_start =>
						i <= 0;
						cpt <= 0;
						IF (iStart='0') THEN
							state <= start;
						ELSE 
							state <= waiting_start;
						END IF;
						oBit<='0';
					WHEN start =>
						IF i=24 THEN 
							state <= waiting_start;
						ELSE
							--inter_GRB <= GRB;
							IF GRB(i)='1' THEN
								state <= s1h;
							ELSE
								state <= s0h;
							END IF;
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
							i<=i+1;
							cpt <= 0;
							state<=start;
						ELSE
							cpt <= cpt+1;
						END IF;
					WHEN OTHERS =>
						IF iStart='1'  THEN 
							state <= waiting_start;
						END IF;
						oBiT <= '0';
				END CASE;
			END IF;
		END PROCESS;

END ARCHITECTURE;
						
						
					
						
			