library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 
entity vgacore is 
    Port (	clk : 			in std_logic;   --系统时钟50MHZ
				--rst_n : 		in std_logic;
           
				--addr_data : 	out std_logic_vector (14 downto 0); -- 重复显示图像所用地址位数
		      addr_data:		out std_logic_vector (12 downto 0); -- 固定区域显示图像所用位数（200x150）
				vga_hs : 		out std_logic;    --行同步
				vga_vs : 		out std_logic);   --场同步
end entity vgacore; 

architecture Behavioral of vgacore is 
		
		--VGA_640_480_60fps_25MHz
		--Horizontal Parameter	( Pixel )
		constant	H_DISP 	:  integer := 640;
		constant	H_FRONT	:  integer := 16; 
		constant	H_SYNC 	:  integer := 96;  
		constant	H_BACK 	:  integer := 48;   
		constant	H_TOTAL	:  integer := 800; 
		--Virtical Parameter	( Line ) 
		constant	V_DISP 	:  integer := 480;  					
		constant	V_FRONT	:  integer := 10;  
		constant	V_SYNC 	:  integer := 2;   
		constant	V_BACK 	:  integer := 33;   
		constant	V_TOTAL	:  integer := 525; 
		
		signal clk_vga : 						std_logic;  						--25MHz时钟
		signal Horizontal_Counter : 		integer range 0 to 999 := 0; 	--行计数
		signal Vertical_Counter	 : 		integer range 0 to 999 := 0;	--场计数
		signal vga_xpos :						integer range 0 to 999 := 0; 	--像素x坐标
		signal vga_ypos :						integer range 0 to 999 := 0; 	--像素y坐标
		signal addr: 							integer range 0 to 99999 := 0;
begin 

-----------------------分频-------------------------
process (clk) 
begin 
	if clk' event and clk= '1' then 
	  if (clk_vga = '0')then 
	    clk_vga <= '1' after 2 ns; 
	  else 
	    clk_vga <= '0' after 2 ns; 
		end if; 
	end if; 
end process;

-----------------行同步信号发生器----------------------
process (clk_vga)
begin
	if clk_vga' event and clk_vga = '1' then
		if Horizontal_Counter < H_TOTAL - 1 then
			Horizontal_Counter <= Horizontal_Counter + 1;
		else
			Horizontal_Counter <= 0;
		end if;
	end if;
end process;

process (clk_vga)
begin
	if clk_vga' event and clk_vga = '1' then
		if (Horizontal_Counter >= H_DISP + H_FRONT - 1)
		and (Horizontal_Counter < H_DISP + H_FRONT + H_SYNC - 1) then
			vga_hs <= '0';
		else
			vga_hs <= '1';
		end if;
	end if;
end process;

-----------------场同步信号发生器---------------------
process (clk_vga)
begin
	if clk_vga' event and clk_vga = '1' then
		if Horizontal_Counter = H_DISP - 1 then
			if Vertical_Counter < V_TOTAL -1 then
				Vertical_Counter <= Vertical_Counter + 1;
			else
				Vertical_Counter <= 0;
			end if;
		else
			Vertical_Counter <= Vertical_Counter;
		end if;
	end if;
end process;

process (clk_vga)
begin
	if clk_vga' event and clk_vga = '1' then
		if (Vertical_Counter >= V_DISP + V_FRONT - 1)
		and (Vertical_Counter < V_DISP + V_FRONT + V_SYNC - 1) then
			vga_vs <= '0';
		else
			vga_vs <= '1';
		end if;
	end if;
end process;

-------------------vga_xpos对像素所处行计数-----------------
process (Horizontal_Counter)
begin
	if vga_xpos <= H_DISP then
		vga_xpos <= Horizontal_Counter;
	else
		vga_xpos <= 0;
	end if;
end process;

-------------------vga_ypos对像素所处列计数-----------------
process (Vertical_Counter)
begin
	if vga_ypos <= V_DISP then
		vga_ypos <= Vertical_Counter;
	else
		vga_ypos <= 0;
	end if;
end process;

--vga_xpos <= (Horizontal_Counter < H_DISP) ? Horizontal_Counter(9 downto 0) + 1 : 0;
--vga_ypos <= (Vertical_Counter < V_DISP) ? Vertical_Counter(9 downto 0) + 1 : 0;

-------------------在屏幕中重复显示图像的地址映射-------------------
process (clk_vga)
begin
	if((vga_ypos >= 1 and vga_ypos <= V_DISP) and (vga_xpos >= 1 and vga_xpos <= H_DISP)) then
		if vga_xpos = 1 then
			addr <= (vga_ypos - 1) rem 60*80;
			--addr <= (vga_ypos - 1)%60*80;
		elsif vga_xpos = 2 then
			addr <= (vga_ypos - 1) rem 60*80 + 1;
		elsif (vga_xpos > 2) and (vga_xpos < H_DISP) then
			addr <= (vga_ypos - 1) rem 60*80 + (vga_xpos - 1) rem 80;
		elsif vga_ypos = H_DISP then
			addr <= (vga_ypos - 1) rem 60*80 + 79;
		else addr <= 0;
		end if;
	end if;
end process;

--------------------在屏幕的固定位置显示图像的地址映射-------------
--process (clk_vga)
--begin
--	if clk_vga' event and clk_vga = '0' then
--		if ((vga_ypos >= 161 and vga_ypos <= 315) and (vga_xpos >= 221 and vga_xpos <= 420)) then
--			addr <= (vga_ypos - 161) * 200 + (vga_xpos - 221);
--		else
--			addr <= 0;
--		end if;
--	end if;
--end process;

--addr_data <= conv_std_logic_vector(addr, 15);
addr_data <= conv_std_logic_vector(addr, 13);

end architecture Behavioral;
