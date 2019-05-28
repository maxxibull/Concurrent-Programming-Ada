with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Numerics.Discrete_Random;
with Positions; use Positions;
with Boards; use Boards;
with Machines; use Machines;
with Service_Center; use Service_Center;
with Config;

package body Company is
   task body Commands_Type is
      Temp : Character;
   begin
      loop
         delay 1.0;
         Put_Line ("What do you want to check?");
         Put_Line (ESC & "[33m" & "[1]" & ESC & "[0m" & " Tasks Board");
         Put_Line (ESC & "[33m" & "[2]" & ESC & "[0m" & " Store Board");
         Put_Line (ESC & "[33m" & "[3]" & ESC & "[0m" & " Workers");
         Put_Line ("================");
         Put ("Your choice: " & ESC & "[33m");
         Get (Temp);
         Put_Line (ESC & "[0m" & "================");

         case Temp is
            when '1' => Tasks.Print_Tasks;
            when '2' => Products.Print_Products;
            when '3' => Workers_Info.Print_Workers;
            when others => Put ("");
         end case;
      end loop;
   end Commands_Type;

   procedure Run_Company is
      subtype Rand_Range is Integer range 0 .. 1;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      use Rand_Int;
      Gen : Rand_Int.Generator;
   begin
      Rand_Int.Reset(Gen);

      for I in Adding_Machines'Range loop
         Adding_Machines (I).Run (I);
      end loop;

      for I in Multiplying_Machines'Range loop
         Multiplying_Machines (I).Run (I);
      end loop;

      for I in Service_Center_Workers'Range loop
         Service_Center_Workers (I).Run (I);
      end loop;

      for I in Workers'Range loop
         if Random (Gen) = 0 then
            Workers (I).Run (I, False);
            Workers_Info.Add_Info (I, False);
         else
            Workers (I).Run (I, True);
            Workers_Info.Add_Info (I, True);
         end if;
      end loop;

      for I in Customers'Range loop
         Customers (I).Run (I);
      end loop;

      if Config.Is_Chatty_Mode = False then
         Commands := new Commands_Type;
      end if;
   end Run_Company;
end Company;
