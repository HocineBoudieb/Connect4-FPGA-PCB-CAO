LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY pilote_curseur IS
	PORT
	(
		oA, oB, ipush, clk, reset	: IN STD_LOGIC;
		oValid, oChange : OUT STD_LOGIC;
		--indice: IN std_logic_vector(2 downto 0);
		indice_sorti : OUT std_logic_vector(2 downto 0)
	);
END ENTITY;

ARCHITECTURE arch of pilote_curseur IS 

	SIGNAL direction : std_logic_vector(1 downto 0);
	TYPE State_type IS (waiting_move,waiting_move11,waiting_move00,mright,mleft,waiting11,m2right,m2left,waiting00);  -- Define the states
	SIGNAL state : State_Type := waiting_move; 
	SIGNAL int_indice: integer:=0;
	SIGNAL cpt : integer := 0;

	BEGIN 
	
	
	direction <= oA&oB;
	oValid <= ipush;
	
	P1 : PROCESS (clk,reset)
	BEGIN 
		if reset='0' then 
			int_indice <=0;
			state <= waiting_move;
		elsif rising_edge(clk) then
			case(state) is
						  when waiting_move => 
								oChange <= '0';
								--if cpt = 300000 then
									if direction = "00" then
										cpt <= 0;
										state <= waiting_move00;
									elsif direction = "11" then
										cpt <= 0;
										state <= waiting_move11;
									end if;
								--else
								--	cpt <= cpt+1;
								--end if;
		              when waiting_move00 => --00
								if direction = "10" then 
										state <= mright;
								elsif direction = "01" then
										state <= mleft;
								end if;
		               when waiting_move11 => --00
								if direction = "01" then 
										state <= mright;
								elsif direction = "10" then
										state <= mleft;
								end if;    
		              when mright => --01
								oChange <= '1';
								if int_indice = 7 THEN
									int_indice <= 0;
								ELSE
									int_indice <= int_indice + 1;
								END IF;
									state <= waiting_move;
		              when mleft => --10
								oChange <= '1';
								if int_indice = 0 THEN
									int_indice <= 7;
								ELSE
									int_indice <= int_indice - 1;
								END IF;
									state <= waiting_move;
						  when others =>
								state <= waiting_move;
			end case;
		END IF;
	END PROCESS;
	indice_sorti <= std_logic_vector(to_unsigned(int_indice,3));
END arch;

-- choisir entre d ou g ou injecter comme réponse colonne+1 ou colonne-1