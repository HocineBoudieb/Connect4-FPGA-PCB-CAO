LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.mytype.ALL;

ENTITY Puissance4 IS
	PORT (
		CLOCK_50	: in  std_logic;
		KEY : in std_logic_vector(1 downto 0);
		GPIO_0_D : inout std_logic_vector(13 downto 0);
		LED : out std_LOGIC_VECTOR(7 downto 0)
	);
END ENTITY;

ARCHITECTURE arc OF Puissance4 IS
SIGNAL GPIO_11 : std_logic_vector(13 downto 0);
SIGNAL GPIO_111 : std_logic_vector(13 downto 0);
SIGNAL rest: std_logic := '1';

--	constant BRG : tBRG (0 to 7):=(
--											"000000000000000000000000",
--											"100000000000000011100010",
--											"000000000000000000001100",
--											"101010100000000011100000",
--											"000000101010101000100000",
--											"000100100100001110100000",
--											"011011010101011011010101",
--											"000000011100000011100000"
--											);

--constant Matrice : tMatrice :=(("11","11","00","00","00","00","00","00"),
--											 ("11","11","00","00","00","00","00","00"),
--											 ("11","11","00","00","11","00","00","00"),
--											 ("11","11","00","11","00","00","11","00"),
--											 ("11","11","00","11","00","00","00","00"),
--											 ("11","11","00","11","00","00","11","00"),
--											 ("11","11","00","00","11","11","00","00"),
--											 ("11","11","00","00","00","00","00","00"));

--constant Matrice : tMatrice :=(("00","00","01","00","00","10","00","00"),
--										 ("00","00","01","00","00","10","00","00"),
--											 ("00","00","01","00","00","10","00","00"),
--											 ("00","00","01","00","00","10","00","00"),
--											 ("00","00","01","00","00","10","00","00"),
--											 ("00","00","01","00","00","10","00","00"),
--											 ("00","00","01","00","00","10","00","00"),
--											 ("00","00","01","00","00","10","00","00"));

--constant Matrice : tMatrice :=(("11","00","01","00","00","10","00","00"),
--										 ("11","00","01","00","00","10","00","00"),
--											 ("11","00","01","00","00","10","00","00"),
--											 ("11","00","01","00","00","10","00","00"),
--											 ("11","00","01","00","00","10","00","00"),
--											 ("11","00","01","00","00","10","00","00"),
--											 ("11","00","01","00","00","10","00","00"),
--											 ("11","00","01","00","00","10","00","00"));

	signal Matrice : tMatrice;
	Signal inter_matrice : tMatrice;
	signal change1 : std_logic;
	signal change2 : std_logic;
	constant rose : std_logic_vector(23 downto 0) := "000000101010101000100000";
	constant bleu : std_logic_vector(23 downto 0) := "101010100000000011100000";
--	component pilote_barette is
--		port (
--			clk_bar, iStart_bar : in std_logic;
--			GRB_bar : in std_logic_vector(191 downto 0);
--			oBIT_bar : out std_logic_vector(7 downto 0)
--		);
--		end component;

--	component pilote_pixel is
--		PORT (
--				iStart, clk : in std_logic;
--				GRB : in std_logic_vector(23 downto 0);
--				oBIT : out std_logic
--		);
--	end component;

--	component pilote_barre is
--		PORT (
--					iStart, clk : in std_logic;
--					GRB : in tBRG;
--					oBIT : out std_logic
--		);
--	end component;
	
	component pilote_matrice is
		PORT (
					iStart, clk : in std_logic;
					Mat : in tMatrice;
					oBIT : out std_logic
		);
	end component;
	component pilote_curseur IS
	PORT
	(
		oA, oB, ipush, clk, reset	: IN STD_LOGIC;
		oValid, oChange : OUT STD_LOGIC;
		--indice: IN std_logic_vector(2 downto 0);
		indice_sorti : OUT std_logic_vector(2 downto 0)
	);
	END component;
	component pilote_jeu IS
	PORT (
				iValid1, iValid2, clk, rst, iChange1,iChange2 : in std_logic;
				indice1,indice2 : in std_logic_vector(2 downto 0);
				oMat : out tMatrice;
				oplayer: out std_logic_vector(1 downto 0);
				oValid : out std_logic
	);
	END component;
	COMPONENT diviseur IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		cout		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END COMPONENT;
	COMPONENT detect_win IS
	PORT (
				clk, rst: in std_logic;
				iMat : in tMatrice;
				oMat : out tMatrice
	);
	END COMPONENT;
	
	SIGNAL inter_Valid1,inter_Valid2 : std_LOGIC := '1';
	SIGNAL indice_inter1: std_logic_vector(2 downto 0):= "000";
	SIGNAL indice_inter2: std_logic_vector(2 downto 0):= "000";
	SIGNAL q : std_logic_vector(15 downto 0);
	Signal Valid : std_logic;
	signal player: std_logic_vector(1 downto 0);
	
BEGIN

rest <= inter_Valid1 OR inter_Valid2;
synchro:PROCESS(CLOCK_50)
	BEGIN 
	IF rising_edge(CLOCK_50) THEN
		GPIO_11(0) <= GPIO_0_D(0);
		GPIO_11(1) <= GPIO_0_D(1);
		GPIO_11 (2)<= GPIO_0_D(2);
		GPIO_11 (3)<= GPIO_0_D(3);
		GPIO_11 (4)<= GPIO_0_D(4);
		GPIO_11(5) <= GPIO_0_D(5);
		GPIO_11(6) <= GPIO_0_D(6);
		GPIO_11 (7)<= GPIO_0_D(7);
		GPIO_11(8) <= GPIO_0_D(8);
		GPIO_11(9) <= GPIO_0_D(9);
		GPIO_11(10) <= GPIO_0_D(10);
		GPIO_11(11) <= GPIO_0_D(11);
		GPIO_11(13) <= GPIO_0_D(13);
	END IF;
END PROCESS;

synchro2:PROCESS(CLOCK_50)
	BEGIN 
	IF rising_edge(CLOCK_50) THEN
		GPIO_111(0) <= GPIO_11(0);
		GPIO_111(1) <= GPIO_11(1);
		GPIO_111(2)<= GPIO_11(2);
		GPIO_111(3)<= GPIO_11(3);
		GPIO_111(4)<= GPIO_11(4);
		GPIO_111(5) <= GPIO_11(5);
		GPIO_111(6) <= GPIO_11(6);
		GPIO_111(7)<= GPIO_11(7);
		GPIO_111(8) <= GPIO_11(8);
		GPIO_111(9) <= GPIO_11(9);
		GPIO_111(10) <= GPIO_11(10);
		GPIO_111(11) <= GPIO_11(11);
		GPIO_111(13) <= GPIO_11(13);
	END IF;
END PROCESS;

--inter_data <= "111000000000000000000000";
--GPIO_1(6)<='0';
--GPIO_1(10)<='0';
--
--	U1:pilote_pixel
--		PORT MAP(
--			clk => CLOCK_50,
--			iStart => KEY(0),
--			GRB => inter_data,
--			oBit => GPIO_1(8)
--		);

--	U2:pilote_barre
--		PORT MAP(
--			clk => CLOCK_50,
--			iStart => KEY(0),
--			GRB => BRG,
--			oBIT => GPIO_1(8)
--		);
	div: diviseur port map 
		(
		clock => CLOCK_50,
		q => q
		);
	U1:pilote_curseur
		PORT MAP
		(
		reset => rest,
		oB => GPIO_111(0),
		ipush => GPIO_111(10),
		oA => GPIO_111(1),
		clk => q(15),
		--indice => indice_inter,
		indice_sorti => indice_inter1,
		oValid => inter_Valid1,
		oChange => change1
		);
		
	U9:pilote_curseur
		PORT MAP
		(
		reset => rest,
		oB => GPIO_111(5),
		ipush => GPIO_111(2),
		oA => GPIO_111(6),
		clk => q(15),
		--indice => indice_inter,
		indice_sorti => indice_inter2,
		oValid => inter_Valid2,
		oChange => change2
		);
		
	U2: pilote_jeu
		PORT MAP
		(
		iValid1 => inter_Valid1,
		iValid2 => inter_Valid2,
		iChange1 => change1,
		iChange2 => change2,
		clk => q(15),
		rst => rest,
		indice1 => indice_inter1,
		indice2 => indice_inter2,
		oMat  => Matrice,
		oplayer => player,
		oValid => Valid
		);
	U3: detect_win
		PORT MAP 
		(
				clk => q(15),
				rst => rest,
				iMat => Matrice,
				oMat => inter_matrice
		);
	U4:pilote_matrice
		PORT MAP(
			clk => CLOCK_50,
			iStart => Valid,                      
			--iStart => KEY(2),
			oBiT => GPIO_0_D(3),
			Mat => inter_matrice
		);
	U5:pilote_matrice
		PORT MAP(
			clk => CLOCK_50,
			iStart => Valid,                      
			--iStart => KEY(2),
			oBIT => GPIO_0_D(4),
			Mat => inter_matrice
		);
	LED(2 downto 0) <= indice_inter1;
	LED(7 downto 6) <= player;
	GPIO_0_D(9) <= '1';
	GPIO_0_D(13) <= '1' WHEN player = "10" ELSE '0';
	GPIO_0_D(11) <= '1' WHEN player = "01" ELSE '0';
	--GPIO_11(5) <= change;
	--GPIO_0(4)<='0';
END arc;


