library ieee;--�����⺯��
library LPM;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;
use LPM.lpm_components.all;
--------------------------------------------------------
entity  adc0804test is
port(--q:in std_logic_vector(23 downto 0);	-----
     --clk:in std_logic;						----FPGA---50MHz
     clk_10 :in std_logic;
     clk_2k :in std_logic;
     ad_data:in std_logic_vector(7 downto 0);---adc-----AD7~AD0:PIN11~PIN18:DB7~DB0;
     qdata:out std_logic_vector(7 downto 0);---FPGA---LED SMG0,SMG1~SMG7: DP,abcdefg;
     rd,wr,adcs:out std_logic;		----------adc-----rd:pin2,read; wr:pin3; adcs:pin1,CS;
     led:out std_logic_vector(7 downto 0));---FPGA--- LED SEG1,SEG2,...SEG6;
end entity ;
------------------------------------------------
architecture miao of adc0804test is

signal m: integer range 0 to 9999;

--signal n1:integer range 0 to 3;
signal n1: std_logic_vector(1 downto 0);

signal n2:integer range 0 to 3;
signal n3:integer range 0 to 99;
--signal clk_2k,clk_10,
signal en:std_logic;

signal data:std_logic_vector(3 downto 0);
signal data1:integer range 0 to 9;

signal addr:std_logic_vector(7 downto 0);

signal vo: integer range 0 to 5000;
--variable dn: integer range 0 to 5000;
--------------------------------------------------------
begin

--clock_2k:process(clk)  -- 10_000��Ƶ�õ� 5/2 KHz
--begin
--if clk'event and clk='1' then 
--   if m=9999 then  m<=0;
--      clk_2k<=not clk_2k;
--    else 
--      m<=m+1;
--    end if;
--end if;
--end process clock_2k;
---------------------------------n3--------------------------------
--clock_10:process(clk_2k)  -- 100��Ƶ�õ�50/2/2Hz=12.5 HZ
--begin
--if clk_2k'event and clk_2k='1' then 
--   if n3=99 then
--      n3<=0;
--      clk_10<=not clk_10;--
--    else 
--      n3<=n3+1;
--    end if;
--end if;
--end process clock_10;
----------------------------------n2-------------------------------
adcs<='0';	---cs'=0,

process(clk_10)

begin
if clk_10'event and clk_10='1' then
   if n2=0 then	--clear 
      wr<='0';
      en<='1';
      n2<=n2+1;
   elsif n2=1 then	-- start
      wr<='1';
      en<='1';
      n2<=n2+1;
   elsif n2=2 then	--hold
      wr<='1';
      en<='0';
      n2<=n2+1;
  else
      wr<='1';
      en<='1';
      n2<=0;  
  end if;
end if;
end process ;

rd<=en;

----------addr<=ad_data---------------------------------
read_addata:process(en)--��ȡAD��������Ϣ
begin
 if en'event and en='1' then 
      addr<=ad_data;
end if;
		end process read_addata;
-----------------------n1---------------------

--en_led:process(clk_2k)
--begin
--if clk_2k'event and clk_2k='1' then
--    if n1=3 then
--       n1<=0;
--    else
--       n1<=n1+1;
--    end if;
--end if;
--end process en_led;
-----------------------LED display------------------------------

--data_choise:process(n1)
--begin
--  if n1=0 then
--  led<="100000";
--  data<=addr(7 downto 4);
--  --qdata(7)<='0';
--else
--  led<="010000";
--  data<=addr(3 downto 0);
--  --qdata(7)<='0';
--end if;
--end process data_choise;
data_choise:process(clk_2k)
variable dn: integer range 0 to 5000;
		begin
		dn:= conv_integer(addr);
--		vo<=(addr*5000)/256;
		vo<=(dn*5000)/256;
		n1<="00";
	case n1 is
	when "00"=>led<="10000000";
			data1<=(vo)/1000;
			n1<="01";
	when "01"=>led<="01000000";
			data1<=((vo)/100) rem 10;
			n1<="10";
	when "10"=>led<="00100000";
			data1<=((vo)/10) rem 10;
	when "11"=>led<="00010000";
			data1<=(vo) rem 10;
			n1<="00";
	end case;
	data <= conv_std_logic_vector(data1,4);
	 --grey_output <= conv_std_logic_vector( grey_cnt��8)
end process data_choise;		
-------------------------------------
display:process(data)
begin
	
case data is
when "0000"=>qdata(7 downto 0)<="00000011";--a-h
when "0001"=>qdata(7 downto 0)<="10011111";
when "0010"=>qdata(7 downto 0)<="00100101";
when "0011"=>qdata(7 downto 0)<="00001101";
when "0100"=>qdata(7 downto 0)<="10011001";
when "0101"=>qdata(7 downto 0)<="01001001";
when "0110"=>qdata(7 downto 0)<="01000001";
when "0111"=>qdata(7 downto 0)<="00011111";
when "1000"=>qdata(7 downto 0)<="00000001";
when "1001"=>qdata(7 downto 0)<="00001001";
when "1010"=>qdata(7 downto 0)<="00010001";
when "1011"=>qdata(7 downto 0)<="11000001";
when "1100"=>qdata(7 downto 0)<="01100011";
when "1101"=>qdata(7 downto 0)<="10000101";
when "1110"=>qdata(7 downto 0)<="01100001";
when "1111"=>qdata(7 downto 0)<="01110001";
when others=>qdata(7 downto 0)<="00000011";
end case;
end process display;

end miao;
