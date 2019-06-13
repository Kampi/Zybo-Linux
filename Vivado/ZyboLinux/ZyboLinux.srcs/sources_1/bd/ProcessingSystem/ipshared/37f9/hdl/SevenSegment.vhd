----------------------------------------------------------------------------------
-- Company:             www.kampis-elektroecke.de
-- Engineer:            Daniel Kampert
-- 
-- Create Date:         14.01.2019 19:10:26
-- Design Name: 
-- Module Name:         SevenSegment - SevenSegment_Arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:         Multiplexing seven segment driver
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision             0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegment is
    Port ( Clock    : in STD_LOGIC;
           ResetN   : in STD_LOGIC;
           Data     : in STD_LOGIC_VECTOR(7 downto 0);
           Anode    : out STD_LOGIC_VECTOR(6 downto 0);
           Segment  : out STD_LOGIC
           );
end SevenSegment;

architecture SevenSegment_Arch of SevenSegment is

    signal Segment_Int      : STD_LOGIC := '0';
    signal RefreshCounter   : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
    signal Data_Int         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Anode_Int        : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');

begin

    Segment <= Segment_Int;
    Anode <= Anode_Int;
    Segment_Int <= RefreshCounter(10);

    process(Clock, ResetN)
    begin
        if(rising_edge(Clock)) then
            if(ResetN = '0') then
                RefreshCounter <= (others => '0');
            else
                RefreshCounter <= STD_LOGIC_VECTOR(UNSIGNED(RefreshCounter) + 1);
            end if;
        end if;        
    end process;
    
    process(Clock, ResetN, Segment_Int, Data)
    begin
        if(rising_edge(Clock)) then
            if(ResetN = '0') then
                Data_Int <= (others => '1');
            else
                case Segment_Int is
                    when '0' => Data_Int <= Data(3 downto 0);
                    when '1' => Data_Int <= Data(7 downto 4);
                end case;
            end if;
        end if;
    end process;
    
    process(Data_Int)
    begin
        case Data_Int is
            when "0000" => Anode_Int <= "0111111";   
            when "0001" => Anode_Int <= "0000110";
            when "0010" => Anode_Int <= "1011011"; 
            when "0011" => Anode_Int <= "1001111";
            when "0100" => Anode_Int <= "1100110"; 
            when "0101" => Anode_Int <= "1101101"; 
            when "0110" => Anode_Int <= "1111101"; 
            when "0111" => Anode_Int <= "0000111";
            when "1000" => Anode_Int <= "1111111";
            when "1001" => Anode_Int <= "1101111";
            when others => Anode_Int <= "0000000";
        end case;
    end process;

end SevenSegment_Arch;