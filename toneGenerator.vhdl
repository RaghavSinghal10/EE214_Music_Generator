library ieee;
use ieee.std_logic_1164.all;
library work;
use work.all;

entity toneGenerator is
port (toneOut : out std_logic; --this pin will give your notes output
		clk : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		switch : in std_logic_vector(7 downto 0)
);
end entity toneGenerator;

architecture basic of toneGenerator is
	
begin
	process(clk)
	
	variable count_sa1, count_re, count_ga, count_ma,
	count_pa, count_dha, count_ni, count_sa2: integer range 0 to 1E8 := 1;
	variable sa1, re, ga, ma, pa, dha, ni, sa2: std_logic := '1';
	
	variable max_count_sa1: integer range 0 to 1E8 := 104168;
	variable max_count_re: integer range 0 to 1E8 := 92594;
	variable max_count_ga: integer range 0 to 1E8 := 83334;
	variable max_count_ma: integer range 0 to 1E8 := 78126;
	variable max_count_pa: integer range 0 to 1E8 := 69445;
	variable max_count_dha: integer range 0 to 1E8 := 62501;
	variable max_count_ni: integer range 0 to 1E8 := 111112; --225Hz(lower octave)
	variable max_count_sa2: integer range 0 to 1E8 := 52084;
	
	--switch positions sa,re,ga,ma,pa,dha,ni,null
	
	begin
	
	if (clk = '1' and clk' event) then
	
		if (switch(0) = '1') then
			if (count_sa1 = max_count_sa1) then--240Hz
				count_sa1 := 1;
				sa1 := not sa1;
			else
				count_sa1 := count_sa1 + 1;
			end if;
			toneOut <= sa1;
			LED <= (1 => '1', others => '0');
			
		elsif (switch(1) = '1') then
			if (count_re = max_count_re) then--270Hz
				count_re := 1;
				re := not re;
			else
				count_re := count_re + 1;
			end if;
			toneOut <= re;
			LED <= (2 => '1', others => '0');
			
		elsif (switch(2) = '1') then
			if (count_ga = max_count_ga) then--300Hz
				count_ga := 1;
				ga := not ga;
			else
				count_ga := count_ga + 1;
			end if;
			toneOut <= ga;
			LED <= (3 => '1', others => '0');
			
		elsif (switch(3) = '1') then
			if (count_ma = max_count_ma) then--320Hz
				count_ma := 1;
				ma := not ma;
			else
				count_ma := count_ma + 1;
			end if;
			toneOut <= ma;
			LED <= (4 => '1', others => '0');
		
		elsif (switch(4) = '1') then
			if (count_pa = max_count_pa) then--320Hz
				count_pa := 1;
				pa := not pa;
			else
				count_pa := count_pa + 1;
			end if;
			toneOut <= pa;
			LED <= (4 => '1', others => '0');
		
		elsif (switch(5) = '1') then
			if (count_dha = max_count_dha) then--320Hz
				count_dha := 1;
				dha := not dha;
			else
				count_dha := count_dha + 1;
			end if;
			toneOut <=dha;
			LED <= (4 => '1', others => '0');
			
			
		elsif (switch(6) = '1') then
			if (count_ni = max_count_ni) then--225Hz
				count_ni := 1;
				ni := not ni;
			else
				count_ni := count_ni + 1;
			end if;
			toneOut <= ni;
			LED <= (0 => '1', others => '0');
			
		else
			toneOut <= '0';
			LED <= (others => '0');
		end if;
		
	end if;
	
	end process;

end basic;
