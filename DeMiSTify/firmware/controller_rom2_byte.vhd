
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic
	(
		ADDR_WIDTH : integer := 15 -- Specify your actual ROM size to save LEs and unnecessary block RAM usage.
	);
port (
	clk : in std_logic;
	reset_n : in std_logic := '1';
	addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	q : out std_logic_vector(31 downto 0);
	-- Allow writes - defaults supplied to simplify projects that don't need to write.
	d : in std_logic_vector(31 downto 0) := X"00000000";
	we : in std_logic := '0';
	bytesel : in std_logic_vector(3 downto 0) := "1111"
);
end entity;

architecture rtl of controller_rom2 is

	signal addr1 : integer range 0 to 2**ADDR_WIDTH-1;

	--  build up 2D array to hold the memory
	type word_t is array (0 to 3) of std_logic_vector(7 downto 0);
	type ram_t is array (0 to 2 ** ADDR_WIDTH - 1) of word_t;

	signal ram : ram_t:=
	(

     0 => (x"d4",x"ff",x"4a",x"71"),
     1 => (x"78",x"ff",x"c3",x"48"),
     2 => (x"c0",x"48",x"d0",x"ff"),
     3 => (x"d4",x"ff",x"78",x"e1"),
     4 => (x"72",x"78",x"c1",x"48"),
     5 => (x"71",x"31",x"c4",x"49"),
     6 => (x"48",x"d0",x"ff",x"78"),
     7 => (x"26",x"78",x"e0",x"c0"),
     8 => (x"5b",x"5e",x"0e",x"4f"),
     9 => (x"f4",x"0e",x"5d",x"5c"),
    10 => (x"48",x"a6",x"c4",x"86"),
    11 => (x"ec",x"4b",x"78",x"c0"),
    12 => (x"e0",x"c2",x"7e",x"bf"),
    13 => (x"e8",x"4d",x"bf",x"e5"),
    14 => (x"ce",x"c2",x"4c",x"bf"),
    15 => (x"e3",x"49",x"bf",x"c2"),
    16 => (x"ee",x"cb",x"87",x"cd"),
    17 => (x"87",x"c2",x"cd",x"49"),
    18 => (x"a6",x"cc",x"49",x"70"),
    19 => (x"e7",x"49",x"c7",x"59"),
    20 => (x"98",x"70",x"87",x"c0"),
    21 => (x"6e",x"87",x"c8",x"05"),
    22 => (x"02",x"99",x"c1",x"49"),
    23 => (x"c1",x"87",x"c5",x"c1"),
    24 => (x"7e",x"bf",x"ec",x"4b"),
    25 => (x"bf",x"c2",x"ce",x"c2"),
    26 => (x"87",x"e3",x"e2",x"49"),
    27 => (x"cc",x"49",x"66",x"c8"),
    28 => (x"98",x"70",x"87",x"e4"),
    29 => (x"c2",x"87",x"da",x"02"),
    30 => (x"49",x"bf",x"fa",x"cd"),
    31 => (x"cd",x"c2",x"b9",x"c1"),
    32 => (x"fd",x"71",x"59",x"fe"),
    33 => (x"ee",x"cb",x"87",x"f9"),
    34 => (x"87",x"fe",x"cb",x"49"),
    35 => (x"a6",x"cc",x"49",x"70"),
    36 => (x"e5",x"49",x"c7",x"59"),
    37 => (x"98",x"70",x"87",x"fc"),
    38 => (x"87",x"c3",x"ff",x"05"),
    39 => (x"99",x"c1",x"49",x"6e"),
    40 => (x"87",x"fb",x"fe",x"05"),
    41 => (x"d0",x"02",x"9b",x"73"),
    42 => (x"fc",x"49",x"ff",x"87"),
    43 => (x"da",x"c1",x"87",x"c9"),
    44 => (x"87",x"de",x"e5",x"49"),
    45 => (x"c1",x"48",x"a6",x"c4"),
    46 => (x"c2",x"ce",x"c2",x"78"),
    47 => (x"e9",x"c0",x"05",x"bf"),
    48 => (x"49",x"fd",x"c3",x"87"),
    49 => (x"c3",x"87",x"cb",x"e5"),
    50 => (x"c5",x"e5",x"49",x"fa"),
    51 => (x"c3",x"49",x"74",x"87"),
    52 => (x"1e",x"71",x"99",x"ff"),
    53 => (x"d8",x"fc",x"49",x"c0"),
    54 => (x"c8",x"49",x"74",x"87"),
    55 => (x"1e",x"71",x"29",x"b7"),
    56 => (x"cc",x"fc",x"49",x"c1"),
    57 => (x"c8",x"86",x"c8",x"87"),
    58 => (x"49",x"74",x"87",x"fa"),
    59 => (x"c8",x"99",x"ff",x"c3"),
    60 => (x"b4",x"71",x"2c",x"b7"),
    61 => (x"dd",x"02",x"9c",x"74"),
    62 => (x"fe",x"cd",x"c2",x"87"),
    63 => (x"d5",x"ca",x"49",x"bf"),
    64 => (x"05",x"98",x"70",x"87"),
    65 => (x"4c",x"c0",x"87",x"c4"),
    66 => (x"e0",x"c2",x"87",x"d2"),
    67 => (x"87",x"fa",x"c9",x"49"),
    68 => (x"58",x"c2",x"ce",x"c2"),
    69 => (x"cd",x"c2",x"87",x"c6"),
    70 => (x"78",x"c0",x"48",x"fe"),
    71 => (x"99",x"c2",x"49",x"74"),
    72 => (x"c3",x"87",x"cd",x"05"),
    73 => (x"e9",x"e3",x"49",x"eb"),
    74 => (x"c2",x"49",x"70",x"87"),
    75 => (x"87",x"d0",x"02",x"99"),
    76 => (x"7e",x"a5",x"d8",x"c1"),
    77 => (x"c7",x"02",x"bf",x"6e"),
    78 => (x"4b",x"bf",x"6e",x"87"),
    79 => (x"0f",x"73",x"49",x"fb"),
    80 => (x"99",x"c1",x"49",x"74"),
    81 => (x"c3",x"87",x"cd",x"05"),
    82 => (x"c5",x"e3",x"49",x"f4"),
    83 => (x"c2",x"49",x"70",x"87"),
    84 => (x"87",x"d1",x"02",x"99"),
    85 => (x"7e",x"a5",x"d8",x"c1"),
    86 => (x"c0",x"02",x"bf",x"6e"),
    87 => (x"bf",x"6e",x"87",x"c7"),
    88 => (x"73",x"49",x"fa",x"4b"),
    89 => (x"c8",x"49",x"74",x"0f"),
    90 => (x"87",x"ce",x"05",x"99"),
    91 => (x"e2",x"49",x"f5",x"c3"),
    92 => (x"49",x"70",x"87",x"e0"),
    93 => (x"c0",x"02",x"99",x"c2"),
    94 => (x"e0",x"c2",x"87",x"e6"),
    95 => (x"c0",x"02",x"bf",x"e9"),
    96 => (x"c1",x"48",x"87",x"ca"),
    97 => (x"ed",x"e0",x"c2",x"88"),
    98 => (x"87",x"cf",x"c0",x"58"),
    99 => (x"4a",x"a5",x"d8",x"c1"),
   100 => (x"c6",x"c0",x"02",x"6a"),
   101 => (x"ff",x"4b",x"6a",x"87"),
   102 => (x"c4",x"0f",x"73",x"49"),
   103 => (x"78",x"c1",x"48",x"a6"),
   104 => (x"99",x"c4",x"49",x"74"),
   105 => (x"87",x"ce",x"c0",x"05"),
   106 => (x"e1",x"49",x"f2",x"c3"),
   107 => (x"49",x"70",x"87",x"e4"),
   108 => (x"c0",x"02",x"99",x"c2"),
   109 => (x"e0",x"c2",x"87",x"ee"),
   110 => (x"48",x"7e",x"bf",x"e9"),
   111 => (x"03",x"a8",x"b7",x"c7"),
   112 => (x"6e",x"87",x"cb",x"c0"),
   113 => (x"c2",x"80",x"c1",x"48"),
   114 => (x"c0",x"58",x"ed",x"e0"),
   115 => (x"d8",x"c1",x"87",x"d1"),
   116 => (x"bf",x"6e",x"7e",x"a5"),
   117 => (x"87",x"c7",x"c0",x"02"),
   118 => (x"fe",x"4b",x"bf",x"6e"),
   119 => (x"c4",x"0f",x"73",x"49"),
   120 => (x"78",x"c1",x"48",x"a6"),
   121 => (x"e0",x"49",x"fd",x"c3"),
   122 => (x"49",x"70",x"87",x"e8"),
   123 => (x"c0",x"02",x"99",x"c2"),
   124 => (x"e0",x"c2",x"87",x"e7"),
   125 => (x"c0",x"02",x"bf",x"e9"),
   126 => (x"e0",x"c2",x"87",x"c9"),
   127 => (x"78",x"c0",x"48",x"e9"),
   128 => (x"c1",x"87",x"d1",x"c0"),
   129 => (x"6e",x"7e",x"a5",x"d8"),
   130 => (x"c7",x"c0",x"02",x"bf"),
   131 => (x"4b",x"bf",x"6e",x"87"),
   132 => (x"0f",x"73",x"49",x"fd"),
   133 => (x"c1",x"48",x"a6",x"c4"),
   134 => (x"49",x"fa",x"c3",x"78"),
   135 => (x"87",x"f2",x"df",x"ff"),
   136 => (x"99",x"c2",x"49",x"70"),
   137 => (x"87",x"eb",x"c0",x"02"),
   138 => (x"bf",x"e9",x"e0",x"c2"),
   139 => (x"a8",x"b7",x"c7",x"48"),
   140 => (x"87",x"c9",x"c0",x"03"),
   141 => (x"48",x"e9",x"e0",x"c2"),
   142 => (x"d1",x"c0",x"78",x"c7"),
   143 => (x"a5",x"d8",x"c1",x"87"),
   144 => (x"02",x"bf",x"6e",x"7e"),
   145 => (x"6e",x"87",x"c7",x"c0"),
   146 => (x"49",x"fc",x"4b",x"bf"),
   147 => (x"a6",x"c4",x"0f",x"73"),
   148 => (x"c0",x"78",x"c1",x"48"),
   149 => (x"e4",x"e0",x"c2",x"4b"),
   150 => (x"cb",x"50",x"c0",x"48"),
   151 => (x"e9",x"c4",x"49",x"ee"),
   152 => (x"cc",x"49",x"70",x"87"),
   153 => (x"e0",x"c2",x"59",x"a6"),
   154 => (x"05",x"bf",x"97",x"e4"),
   155 => (x"74",x"87",x"de",x"c1"),
   156 => (x"99",x"f0",x"c3",x"49"),
   157 => (x"87",x"cd",x"c0",x"05"),
   158 => (x"ff",x"49",x"da",x"c1"),
   159 => (x"70",x"87",x"d3",x"de"),
   160 => (x"c8",x"c1",x"02",x"98"),
   161 => (x"e8",x"4b",x"c1",x"87"),
   162 => (x"c3",x"49",x"4c",x"bf"),
   163 => (x"b7",x"c8",x"99",x"ff"),
   164 => (x"c2",x"b4",x"71",x"2c"),
   165 => (x"49",x"bf",x"c2",x"ce"),
   166 => (x"87",x"f3",x"d9",x"ff"),
   167 => (x"c3",x"49",x"66",x"c8"),
   168 => (x"98",x"70",x"87",x"f4"),
   169 => (x"87",x"c6",x"c0",x"02"),
   170 => (x"48",x"e4",x"e0",x"c2"),
   171 => (x"e0",x"c2",x"50",x"c1"),
   172 => (x"05",x"bf",x"97",x"e4"),
   173 => (x"74",x"87",x"d6",x"c0"),
   174 => (x"99",x"f0",x"c3",x"49"),
   175 => (x"87",x"c5",x"ff",x"05"),
   176 => (x"ff",x"49",x"da",x"c1"),
   177 => (x"70",x"87",x"cb",x"dd"),
   178 => (x"f8",x"fe",x"05",x"98"),
   179 => (x"02",x"9b",x"73",x"87"),
   180 => (x"c8",x"87",x"de",x"c0"),
   181 => (x"e0",x"c2",x"48",x"a6"),
   182 => (x"c8",x"78",x"bf",x"e9"),
   183 => (x"91",x"cb",x"49",x"66"),
   184 => (x"6e",x"7e",x"a1",x"75"),
   185 => (x"c8",x"c0",x"02",x"bf"),
   186 => (x"4b",x"bf",x"6e",x"87"),
   187 => (x"73",x"49",x"66",x"c8"),
   188 => (x"02",x"66",x"c4",x"0f"),
   189 => (x"c2",x"87",x"c8",x"c0"),
   190 => (x"49",x"bf",x"e9",x"e0"),
   191 => (x"c2",x"87",x"d3",x"f1"),
   192 => (x"02",x"bf",x"c6",x"ce"),
   193 => (x"49",x"87",x"dd",x"c0"),
   194 => (x"70",x"87",x"cb",x"c2"),
   195 => (x"d3",x"c0",x"02",x"98"),
   196 => (x"e9",x"e0",x"c2",x"87"),
   197 => (x"f9",x"f0",x"49",x"bf"),
   198 => (x"f2",x"49",x"c0",x"87"),
   199 => (x"ce",x"c2",x"87",x"d9"),
   200 => (x"78",x"c0",x"48",x"c6"),
   201 => (x"f3",x"f1",x"8e",x"f4"),
   202 => (x"5b",x"5e",x"0e",x"87"),
   203 => (x"1e",x"0e",x"5d",x"5c"),
   204 => (x"e0",x"c2",x"4c",x"71"),
   205 => (x"c1",x"49",x"bf",x"e5"),
   206 => (x"c1",x"4d",x"a1",x"cd"),
   207 => (x"7e",x"69",x"81",x"d1"),
   208 => (x"cf",x"02",x"9c",x"74"),
   209 => (x"4b",x"a5",x"c4",x"87"),
   210 => (x"e0",x"c2",x"7b",x"74"),
   211 => (x"f1",x"49",x"bf",x"e5"),
   212 => (x"7b",x"6e",x"87",x"d2"),
   213 => (x"c4",x"05",x"9c",x"74"),
   214 => (x"c2",x"4b",x"c0",x"87"),
   215 => (x"73",x"4b",x"c1",x"87"),
   216 => (x"87",x"d3",x"f1",x"49"),
   217 => (x"c7",x"02",x"66",x"d4"),
   218 => (x"87",x"de",x"49",x"87"),
   219 => (x"87",x"c2",x"4a",x"70"),
   220 => (x"ce",x"c2",x"4a",x"c0"),
   221 => (x"f0",x"26",x"5a",x"ca"),
   222 => (x"00",x"00",x"87",x"e2"),
   223 => (x"00",x"00",x"00",x"00"),
   224 => (x"00",x"00",x"00",x"00"),
   225 => (x"00",x"00",x"00",x"00"),
   226 => (x"71",x"1e",x"00",x"00"),
   227 => (x"bf",x"c8",x"ff",x"4a"),
   228 => (x"48",x"a1",x"72",x"49"),
   229 => (x"ff",x"1e",x"4f",x"26"),
   230 => (x"fe",x"89",x"bf",x"c8"),
   231 => (x"c0",x"c0",x"c0",x"c0"),
   232 => (x"c4",x"01",x"a9",x"c0"),
   233 => (x"c2",x"4a",x"c0",x"87"),
   234 => (x"72",x"4a",x"c1",x"87"),
   235 => (x"72",x"4f",x"26",x"48"),
		others => (others => x"00")
	);
	signal q1_local : word_t;

	-- Altera Quartus attributes
	attribute ramstyle: string;
	attribute ramstyle of ram: signal is "no_rw_check";

begin  -- rtl

	addr1 <= to_integer(unsigned(addr(ADDR_WIDTH-1 downto 0)));

	-- Reorganize the read data from the RAM to match the output
	q(7 downto 0) <= q1_local(3);
	q(15 downto 8) <= q1_local(2);
	q(23 downto 16) <= q1_local(1);
	q(31 downto 24) <= q1_local(0);

	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(we = '1') then
				-- edit this code if using other than four bytes per word
				if (bytesel(3) = '1') then
					ram(addr1)(3) <= d(7 downto 0);
				end if;
				if (bytesel(2) = '1') then
					ram(addr1)(2) <= d(15 downto 8);
				end if;
				if (bytesel(1) = '1') then
					ram(addr1)(1) <= d(23 downto 16);
				end if;
				if (bytesel(0) = '1') then
					ram(addr1)(0) <= d(31 downto 24);
				end if;
			end if;
			q1_local <= ram(addr1);
		end if;
	end process;
  
end rtl;

