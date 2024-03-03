library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic	(
	ADDR_WIDTH : integer := 8; -- ROM's address width (words, not bytes)
	COL_WIDTH  : integer := 8;  -- Column width (8bit -> byte)
	NB_COL     : integer := 4  -- Number of columns in memory
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

architecture arch of controller_rom2 is

-- type word_t is std_logic_vector(31 downto 0);
type ram_type is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);

signal ram : ram_type :=
(

     0 => x"d4ff4a71",
     1 => x"78ffc348",
     2 => x"c048d0ff",
     3 => x"d4ff78e1",
     4 => x"7278c148",
     5 => x"7131c449",
     6 => x"48d0ff78",
     7 => x"2678e0c0",
     8 => x"5b5e0e4f",
     9 => x"f40e5d5c",
    10 => x"48a6c486",
    11 => x"ec4b78c0",
    12 => x"e0c27ebf",
    13 => x"e84dbfe5",
    14 => x"cec24cbf",
    15 => x"e349bfc2",
    16 => x"eecb87cd",
    17 => x"87c2cd49",
    18 => x"a6cc4970",
    19 => x"e749c759",
    20 => x"987087c0",
    21 => x"6e87c805",
    22 => x"0299c149",
    23 => x"c187c5c1",
    24 => x"7ebfec4b",
    25 => x"bfc2cec2",
    26 => x"87e3e249",
    27 => x"cc4966c8",
    28 => x"987087e4",
    29 => x"c287da02",
    30 => x"49bffacd",
    31 => x"cdc2b9c1",
    32 => x"fd7159fe",
    33 => x"eecb87f9",
    34 => x"87fecb49",
    35 => x"a6cc4970",
    36 => x"e549c759",
    37 => x"987087fc",
    38 => x"87c3ff05",
    39 => x"99c1496e",
    40 => x"87fbfe05",
    41 => x"d0029b73",
    42 => x"fc49ff87",
    43 => x"dac187c9",
    44 => x"87dee549",
    45 => x"c148a6c4",
    46 => x"c2cec278",
    47 => x"e9c005bf",
    48 => x"49fdc387",
    49 => x"c387cbe5",
    50 => x"c5e549fa",
    51 => x"c3497487",
    52 => x"1e7199ff",
    53 => x"d8fc49c0",
    54 => x"c8497487",
    55 => x"1e7129b7",
    56 => x"ccfc49c1",
    57 => x"c886c887",
    58 => x"497487fa",
    59 => x"c899ffc3",
    60 => x"b4712cb7",
    61 => x"dd029c74",
    62 => x"fecdc287",
    63 => x"d5ca49bf",
    64 => x"05987087",
    65 => x"4cc087c4",
    66 => x"e0c287d2",
    67 => x"87fac949",
    68 => x"58c2cec2",
    69 => x"cdc287c6",
    70 => x"78c048fe",
    71 => x"99c24974",
    72 => x"c387cd05",
    73 => x"e9e349eb",
    74 => x"c2497087",
    75 => x"87d00299",
    76 => x"7ea5d8c1",
    77 => x"c702bf6e",
    78 => x"4bbf6e87",
    79 => x"0f7349fb",
    80 => x"99c14974",
    81 => x"c387cd05",
    82 => x"c5e349f4",
    83 => x"c2497087",
    84 => x"87d10299",
    85 => x"7ea5d8c1",
    86 => x"c002bf6e",
    87 => x"bf6e87c7",
    88 => x"7349fa4b",
    89 => x"c849740f",
    90 => x"87ce0599",
    91 => x"e249f5c3",
    92 => x"497087e0",
    93 => x"c00299c2",
    94 => x"e0c287e6",
    95 => x"c002bfe9",
    96 => x"c14887ca",
    97 => x"ede0c288",
    98 => x"87cfc058",
    99 => x"4aa5d8c1",
   100 => x"c6c0026a",
   101 => x"ff4b6a87",
   102 => x"c40f7349",
   103 => x"78c148a6",
   104 => x"99c44974",
   105 => x"87cec005",
   106 => x"e149f2c3",
   107 => x"497087e4",
   108 => x"c00299c2",
   109 => x"e0c287ee",
   110 => x"487ebfe9",
   111 => x"03a8b7c7",
   112 => x"6e87cbc0",
   113 => x"c280c148",
   114 => x"c058ede0",
   115 => x"d8c187d1",
   116 => x"bf6e7ea5",
   117 => x"87c7c002",
   118 => x"fe4bbf6e",
   119 => x"c40f7349",
   120 => x"78c148a6",
   121 => x"e049fdc3",
   122 => x"497087e8",
   123 => x"c00299c2",
   124 => x"e0c287e7",
   125 => x"c002bfe9",
   126 => x"e0c287c9",
   127 => x"78c048e9",
   128 => x"c187d1c0",
   129 => x"6e7ea5d8",
   130 => x"c7c002bf",
   131 => x"4bbf6e87",
   132 => x"0f7349fd",
   133 => x"c148a6c4",
   134 => x"49fac378",
   135 => x"87f2dfff",
   136 => x"99c24970",
   137 => x"87ebc002",
   138 => x"bfe9e0c2",
   139 => x"a8b7c748",
   140 => x"87c9c003",
   141 => x"48e9e0c2",
   142 => x"d1c078c7",
   143 => x"a5d8c187",
   144 => x"02bf6e7e",
   145 => x"6e87c7c0",
   146 => x"49fc4bbf",
   147 => x"a6c40f73",
   148 => x"c078c148",
   149 => x"e4e0c24b",
   150 => x"cb50c048",
   151 => x"e9c449ee",
   152 => x"cc497087",
   153 => x"e0c259a6",
   154 => x"05bf97e4",
   155 => x"7487dec1",
   156 => x"99f0c349",
   157 => x"87cdc005",
   158 => x"ff49dac1",
   159 => x"7087d3de",
   160 => x"c8c10298",
   161 => x"e84bc187",
   162 => x"c3494cbf",
   163 => x"b7c899ff",
   164 => x"c2b4712c",
   165 => x"49bfc2ce",
   166 => x"87f3d9ff",
   167 => x"c34966c8",
   168 => x"987087f4",
   169 => x"87c6c002",
   170 => x"48e4e0c2",
   171 => x"e0c250c1",
   172 => x"05bf97e4",
   173 => x"7487d6c0",
   174 => x"99f0c349",
   175 => x"87c5ff05",
   176 => x"ff49dac1",
   177 => x"7087cbdd",
   178 => x"f8fe0598",
   179 => x"029b7387",
   180 => x"c887dec0",
   181 => x"e0c248a6",
   182 => x"c878bfe9",
   183 => x"91cb4966",
   184 => x"6e7ea175",
   185 => x"c8c002bf",
   186 => x"4bbf6e87",
   187 => x"734966c8",
   188 => x"0266c40f",
   189 => x"c287c8c0",
   190 => x"49bfe9e0",
   191 => x"c287d3f1",
   192 => x"02bfc6ce",
   193 => x"4987ddc0",
   194 => x"7087cbc2",
   195 => x"d3c00298",
   196 => x"e9e0c287",
   197 => x"f9f049bf",
   198 => x"f249c087",
   199 => x"cec287d9",
   200 => x"78c048c6",
   201 => x"f3f18ef4",
   202 => x"5b5e0e87",
   203 => x"1e0e5d5c",
   204 => x"e0c24c71",
   205 => x"c149bfe5",
   206 => x"c14da1cd",
   207 => x"7e6981d1",
   208 => x"cf029c74",
   209 => x"4ba5c487",
   210 => x"e0c27b74",
   211 => x"f149bfe5",
   212 => x"7b6e87d2",
   213 => x"c4059c74",
   214 => x"c24bc087",
   215 => x"734bc187",
   216 => x"87d3f149",
   217 => x"c70266d4",
   218 => x"87de4987",
   219 => x"87c24a70",
   220 => x"cec24ac0",
   221 => x"f0265aca",
   222 => x"000087e2",
   223 => x"00000000",
   224 => x"00000000",
   225 => x"00000000",
   226 => x"711e0000",
   227 => x"bfc8ff4a",
   228 => x"48a17249",
   229 => x"ff1e4f26",
   230 => x"fe89bfc8",
   231 => x"c0c0c0c0",
   232 => x"c401a9c0",
   233 => x"c24ac087",
   234 => x"724ac187",
   235 => x"724f2648",
  others => ( x"00000000")
);

-- Xilinx Vivado attributes
attribute ram_style: string;
attribute ram_style of ram: signal is "block";

signal q_local : std_logic_vector((NB_COL * COL_WIDTH)-1 downto 0);

signal wea : std_logic_vector(NB_COL - 1 downto 0);

begin

	output:
	for i in 0 to NB_COL - 1 generate
		q((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= q_local((i+1) * COL_WIDTH - 1 downto i * COL_WIDTH);
	end generate;
    
    -- Generate write enable signals
    -- The Block ram generator doesn't like it when the compare is done in the if statement it self.
    wea <= bytesel when we = '1' else (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            q_local <= ram(to_integer(unsigned(addr)));
            for i in 0 to NB_COL - 1 loop
                if (wea(NB_COL-i-1) = '1') then
                    ram(to_integer(unsigned(addr)))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= d((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
                end if;
            end loop;
        end if;
    end process;

end arch;
