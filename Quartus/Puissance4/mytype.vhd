LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package mytype IS

	Type tBRG is array(natural range<>) OF std_logic_vector(23 downto 0);
	Type tMatrice is array (0 to 7, 0 to 7) OF std_logic_vector(1 downto 0);

end package;