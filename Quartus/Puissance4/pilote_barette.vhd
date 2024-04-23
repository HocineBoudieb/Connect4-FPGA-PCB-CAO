LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pilote_barette IS
	PORT ( 
				clk_bar, iStart_bar : in std_logic;
				GRB_bar : in std_logic_vector(191 downto 0);
				oBIT_bar : out std_logic_vector(7 downto 0)
	);
END ENTITY;

ARCHITECTURE archi OF pilote_barette IS

	component pilote_pixel is
		port (
			iStart, clk : in std_logic;
			GRB : in std_logic_vector(23 downto 0);
			oBIT : out std_logic 
		);
	end component;
	
	BEGIN
		U1:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(23 downto 0),
			oBIT => oBIT_bar(0)
		);
		
		U2:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(47 downto 24),
			oBIT => oBIT_bar(1)
		);
		
		U3:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(71 downto 48),
			oBIT => oBIT_bar(2)
		);
		
		U4:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(95 downto 72),
			oBIT => oBIT_bar(3)
		);
		
		U5:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(119 downto 96),
			oBIT => oBIT_bar(4)
		);
		
		U6:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(143 downto 120),
			oBIT => oBIT_bar(5)
		);
		
		U7:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(167 downto 144),
			oBIT => oBIT_bar(6)
		);
		
		U8:pilote_pixel
		PORT MAP(
			iStart => iStart_bar,
			clk => clk_bar,
			GRB => GRB_bar(191 downto 168),
			oBIT => oBIT_bar(7)
		);

END archi;