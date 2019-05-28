with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Numerics.Discrete_Random;
with Boards; use Boards;
with Machines; use Machines;
with Service_Center; use Service_Center;
with Config;

package body Positions is
   task body Chief_Type is
      subtype Rand_Range is Integer range Config.Min_Value_Of_Argument .. Config.Max_Value_Of_Argument;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      use Rand_Int;
      Gen : Rand_Int.Generator;
      New_Task : Company_Task;
      Temp : Integer;
   begin
      Rand_Int.Reset(Gen);

      loop
         New_Task.First_Argument := Random(Gen);
         New_Task.Second_Argument := Random(Gen);
         Temp := abs (New_Task.First_Argument + New_Task.Second_Argument) mod 2;

         case Temp is
            when 0 => New_Task.Operation_Symbol := '+';
            when others => New_Task.Operation_Symbol := '*';
         end case;

         if Config.Is_Chatty_Mode then
            Put_Line (ESC & "[33m" & "chief:" & ESC & "[0m" &
                        New_Task.First_Argument'Image & " " &
                        New_Task.Operation_Symbol'Image &
                        New_Task.Second_Argument'Image);
         end if;

         Tasks.Add_Task (New_Task);
         delay Config.Time_To_Sleep_For_Chief;
      end loop;
   end Chief_Type;

   task body Worker_Type is
      subtype Rand_Range_Add is Positive range 1 .. Config.Number_Of_Adding_Machines;
      subtype Rand_Range_Mul is Positive range 1 .. Config.Number_Of_Multiplying_Machines;
      package Rand_Add is new Ada.Numerics.Discrete_Random(Rand_Range_Add);
      package Rand_Mul is new Ada.Numerics.Discrete_Random(Rand_Range_Mul);
      Gen_Add : Rand_Add.Generator;
      Gen_Mul : Rand_Mul.Generator;

      function Get_Next_Machine_Add return Positive is
         use Rand_Add;
      begin
         return Random (Gen_Add);
      end Get_Next_Machine_Add;

      function Get_Next_Machine_Mul return Positive is
         use Rand_Mul;
      begin
         return Random (Gen_Mul);
      end Get_Next_Machine_Mul;

      Next_Task : Company_Task;
      New_Product : Company_Product;
      Index : Positive;
      Impatient : Boolean := True;
      Machine_Index : Positive;
      Report : Crash_Report;
   begin
      accept Run (New_Index : in Positive; New_Impatient : in Boolean) do
         Index := New_Index;
         Impatient := New_Impatient;
      end Run;

      Rand_Add.Reset(Gen_Add);
      Rand_Mul.Reset(Gen_Mul);

      loop
         Tasks.Get_Task (Next_Task);

         case Next_Task.Operation_Symbol is
            when '+' =>
               L2 : loop
                  Machine_Index := Get_Next_Machine_Add;

                  if Impatient then
                     L1 : loop
                        select
                           Adding_Machines (Machine_Index).Execute (Next_Task);
                           exit L1;
                        or
                           delay Config.Time_To_Wait_For_Impatient_Worker;
                           Machine_Index := Get_Next_Machine_Add;

                           if Config.Is_Chatty_Mode then
                              Put_Line (ESC & "[32m" & "worker" & Index'Image & ":" & ESC & "[0m" &
                                          " dropping adding machine" & Machine_Index'Image);
                           end if;
                        end select;
                     end loop L1;
                  else
                     Adding_Machines (Machine_Index).Execute (Next_Task);
                  end if;

                  if Next_Task.Result = -1 then
                     if Config.Is_Chatty_Mode then
                        Put_Line (ESC & "[32m" & "worker" & Index'Image & ":" & ESC & "[0m" &
                                    " broken adding machine" & Machine_Index'Image);
                     end if;

                     Report.Machine_Type := '+';
                     Report.Machine_Index := Machine_Index;
                     Service_Center_Task.Add_Report (Report);
                  else
                     exit L2;
                  end if;
               end loop L2;

               Workers_Info.Increment_Executed (Index);
            when '*' =>
               L4 : loop
                  Machine_Index := Get_Next_Machine_Mul;

                  if Impatient then
                     L3 : loop
                        select
                           Multiplying_Machines (Machine_Index).Execute (Next_Task);
                           exit L3;
                        or
                           delay Config.Time_To_Wait_For_Impatient_Worker;
                           Machine_Index := Get_Next_Machine_Mul;

                           if Config.Is_Chatty_Mode then
                              Put_Line (ESC & "[32m" & "worker" & Index'Image & ":" & ESC & "[0m" &
                                          " dropping multiplying machine" & Machine_Index'Image);
                           end if;
                        end select;
                     end loop L3;
                  else
                     Multiplying_Machines (Machine_Index).Execute (Next_Task);
                  end if;

                  if Next_Task.Result = -1 then
                     if Config.Is_Chatty_Mode then
                        Put_Line (ESC & "[32m" & "worker" & Index'Image & ":" & ESC & "[0m" &
                                    " broken multiplying machine" & Machine_Index'Image);
                     end if;

                     Report.Machine_Type := '*';
                     Report.Machine_Index := Machine_Index;
                     Service_Center_Task.Add_Report (Report);
                  else
                     exit L4;
                  end if;
               end loop L4;

               Workers_Info.Increment_Executed (Index);
            when others =>
               Next_Task.Result := 0;
         end case;

         if Config.Is_Chatty_Mode then
            Put_Line (ESC & "[32m" & "worker" & Index'Image & ":" & ESC & "[0m" &
                        Next_Task.First_Argument'Image & " " &
                        Next_Task.Operation_Symbol'Image &
                        Next_Task.Second_Argument'Image &
                        " =" & Next_Task.Result'Image);
         end if;

         New_Product.Value := Next_Task.Result;
         Products.Add_Product (New_Product);
         delay Config.Time_To_Sleep_For_Worker;
      end loop;
   end Worker_Type;

   task body Customer_Type is
      Next_Product : Company_Product;
      Index : Positive;
   begin
      accept Run (New_Index : in Positive) do
         Index := New_Index;
      end Run;

      loop
         Products.Get_Product (Next_Product);

         if Config.Is_Chatty_Mode then
            Put_Line (ESC & "[36m" & "customer" & Index'Image & ":" & ESC & "[0m" &
                        Next_Product.Value'Image);
         end if;

         delay Config.Time_To_Sleep_For_Customer;
      end loop;
   end Customer_Type;

   protected body Worker_Info_Board is
      procedure Add_Info (Index : in Integer; Impatient : Boolean) is
      begin
         Board (Index).Impatient := Impatient;
         Board (Index).Executed_Tasks := 0;
      end Add_Info;

      procedure Increment_Executed (Index : in Integer) is
      begin
         Board (Index).Executed_Tasks := Board (Index).Executed_Tasks + 1;
      end Increment_Executed;

      procedure Print_Workers is
      begin
         for I in Board'Range loop
            Put_Line ("worker" & I'Image &
                        ", impatient = " & Board (I).Impatient'Image &
                        ", executed =" & Board (I).Executed_Tasks'Image);
         end loop;

         Put_Line ("================");
      end Print_Workers;
   end Worker_Info_Board;
end Positions;
