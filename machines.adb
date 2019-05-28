with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Numerics.Discrete_Random;
with Config;

package body Machines is
   task body Adding_Machine is
      subtype Rand_Range is Integer range 0 .. 100;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      use Rand_Int;
      Gen : Rand_Int.Generator;
      Index : Positive;
      Broken : Boolean := False;
   begin
      accept Run (New_Index : in Positive) do
         Index := New_Index;
      end Run;

      Rand_Int.Reset(Gen);

      loop
         if Broken = False and Random (Gen) < Config.Probability_Of_Crash then
            Broken := True;

            if Config.Is_Chatty_Mode then
               Put_Line (ESC & "[31m" & "adding machine" & Index'Image & ":" & ESC & "[0m BROKEN");
            end if;
         end if;

         select
            accept Execute (New_Task : in out Company_Task) do
               if Broken then
                  New_Task.Result := -1;
                  delay Config.Time_To_Sleep_For_Adding_Machine;

                  if Config.Is_Chatty_Mode then
                     Put_Line (ESC & "[31m" & "adding machine" & Index'Image & ":" & ESC & "[0m STILL BROKEN");
                  end if;
               else
                  New_Task.Result := New_Task.First_Argument + New_Task.Second_Argument;
                  delay Config.Time_To_Sleep_For_Adding_Machine;

                  if Config.Is_Chatty_Mode then
                     Put_Line (ESC & "[31m" & "adding machine" & Index'Image & ":" & ESC & "[0m" &
                                 New_Task.First_Argument'Image & " " &
                                 New_Task.Operation_Symbol'Image &
                                 New_Task.Second_Argument'Image);
                  end if;
               end if;
            end Execute;
         or
            accept Fix do
               Broken := False;

               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[31m" & "adding machine" & Index'Image & ":" & ESC & "[0m FIXED");
               end if;
            end Fix;
         end select;
      end loop;
   end Adding_Machine;

   task body Multiplying_Machine is
      subtype Rand_Range is Integer range 0 .. 100;
      package Rand_Int is new Ada.Numerics.Discrete_Random(Rand_Range);
      use Rand_Int;
      Gen : Rand_Int.Generator;
      Index : Positive;
      Broken : Boolean := False;
   begin
      accept Run (New_Index : in Positive) do
         Index := New_Index;
      end Run;

      Rand_Int.Reset(Gen);

      loop
         if Broken = False and Random (Gen) < Config.Probability_Of_Crash then
            Broken := True;

            if Config.Is_Chatty_Mode then
               Put_Line (ESC & "[31m" & "multiplying machine" & Index'Image & ":" & ESC & "[0m BROKEN");
            end if;
         end if;

         select
            accept Execute (New_Task : in out Company_Task) do
               if Broken then
                  New_Task.Result := -1;
                  delay Config.Time_To_Sleep_For_Multiplying_Machine;

                  if Config.Is_Chatty_Mode then
                     Put_Line (ESC & "[31m" & "multiplying machine" & Index'Image & ":" & ESC & "[0m STILL BROKEN");
                  end if;
               else
                  New_Task.Result := New_Task.First_Argument * New_Task.Second_Argument;
                  delay Config.Time_To_Sleep_For_Multiplying_Machine;

                  if Config.Is_Chatty_Mode then
                     Put_Line (ESC & "[31m" & "multiplying machine" & Index'Image & ":" & ESC & "[0m" &
                                 New_Task.First_Argument'Image & " " &
                                 New_Task.Operation_Symbol'Image &
                                 New_Task.Second_Argument'Image);
                  end if;
               end if;
            end Execute;
         or
            accept Fix do
               Broken := False;

               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[31m" & "multiplying machine" & Index'Image & ":" & ESC & "[0m FIXED");
               end if;
            end Fix;
         end select;
      end loop;
   end Multiplying_Machine;
end Machines;
