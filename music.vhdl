LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity music is
port (toneOut : out std_logic;
	clk_50, resetn : in std_logic;
	LED : out std_logic_vector(7 downto 0));
end entity music;

architecture fsm of music is
-- Fill all the states
------------------Code here---------------------------
-- Declare state types here
	type state_type is (sa, re, ga, ma, pa, dha, ni, silent);
	
-- Declare all necessary signals here
	signal y_present : state_type := silent;
	signal switch : std_logic_vector(7 downto 0);
	signal count: integer := 0;
	signal clk_music: std_logic;
	
-- Take the toneGenerator component
	component toneGenerator is
	port (toneOut : out std_logic; --this pin will give your notes output
			clk : in std_logic;
			LED : out std_logic_vector(7 downto 0);
			switch : in std_logic_vector(7 downto 0));
	end component toneGenerator;
	
begin

	process(clk_50, clk_music, resetn)	-- Fill sensitivity list
	variable y_next_var : state_type;
	variable n_count : integer := 0;
	variable timecounter : integer range 0 to 1E8 := 0;
	variable clk_c : std_logic := '1';
	
	begin
	
		y_next_var := y_present;
		n_count := count;
		
		--switch positions sa,re,ga,ma,pa,dha,ni,null
		--led positions sa,re,ga,ma,pa,dha,ni

		case y_present is
				
			WHEN sa => --sa state
				if (count = 29) then
					y_next_var := sa;
				elsif (count = 30) then
					y_next_var := silent;
				elsif (count = 24) then
					y_next_var := ni;
				end if;
				switch <= (0 => '1', others => '0');
				
			WHEN re =>	--re state
				if ((count = 23) or (count = 28)) then
					y_next_var := sa;
				elsif (count = 27) then
					y_next_var := re;
				elsif (count = 16) then
					y_next_var := ga;	
				end if;
				switch <= (1 => '1', others => '0');
				
			WHEN ga =>	--ga state
				if ((count = 15) or (count = 22)) then
					y_next_var := re;
				elsif ((count = 17) or (count = 18) or (count = 19)) then
					y_next_var := ga;
				elsif ((count = 8) or (count = 20)) then
					y_next_var := ma;
				end if;
				switch <= (2 => '1', others => '0');
				
			WHEN ma =>	--ma state
				if ((count = 7) or (count = 14) or (count = 21)) then
					y_next_var := ga;
				elsif ((count = 9) or (count = 10) or (count = 11)) then
					y_next_var := ma;
				elsif (count = 12) then
					y_next_var := pa;
				end if;
				switch <= (3 => '1', others => '0');
			
			WHEN pa =>	--pa state
				if ((count = 6) or (count = 13)) then
					y_next_var := ma;
				elsif ((count = 1) or (count = 2) or (count = 3)) then
					y_next_var := pa;
				elsif (count = 4) then
					y_next_var := dha;
				end if;
				switch <= (4 => '1', others => '0');
				
			WHEN dha =>	--pa state
				if (count = 5) then
					y_next_var := pa;
				end if;
				switch <= (5 => '1', others => '0');
				
			WHEN ni =>	--ni state
				if(count = 26) then
					y_next_var := re;
				elsif (count = 25) then
					y_next_var := ni;
				end if;
				switch <= (6 => '1', others => '0');
				
			WHEN silent => --silent state
				if (count = 31) then
					y_next_var := silent;
				elsif ((count = 32) or (count = 0)) then
					y_next_var := pa;
				end if;
				switch <= (7 => '1', others => '0');
			
			WHEN others =>
				y_next_var := Silent;
				switch <= (7 => '1', others => '0');	
				
		END CASE ;
	
--		generate 4Hz clock (0.25s time period) from 50MHz clock (clock_music)
		if (clk_50 = '1' and clk_50' event) then
				if timecounter = 6250000 then -- The cycles in which clk is 1 or 0
					timecounter := 1;			-- When it reaches max count i.e. 25x10^6 (half a second) it will be 0 again 
					clk_c := not clk_c;		-- this variable will toggle
				else
					timecounter := timecounter + 1;	-- Counter will be incremented till it reaches max count
			end if;
		end if;
		clk_music <= clk_c;
			
--		state transition	
		if (clk_music = '1' and clk_music' event) then
			if (resetn = '1') then
				y_present <= Silent;
				count <= 0;

			else 
				y_present <= y_next_var;
				if (count = 32) then
					count <= 0;
				else
					count <= count + 1;			
				end if;
			end if;	
		end if;
	end process;
	
	-- instantiate the component of toneGenerator 
	tone_gen: toneGenerator port map (toneOut, clk_50, LED, switch);
end fsm;