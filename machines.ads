with Config;

package Machines is
   type Company_Task is record
      First_Argument : Integer;
      Second_Argument : Integer;
      Operation_Symbol : Character;
      Result : Integer;
   end record;

   type List_Of_Task_Type is array (Integer range<>) of Company_Task;

   task type Adding_Machine is
      entry Execute (New_Task : in out Company_Task);
      entry Fix;
      entry Run (New_Index : in Positive);
   end Adding_Machine;

   task type Multiplying_Machine is
      entry Execute (New_Task : in out Company_Task);
      entry Fix;
      entry Run (New_Index : in Positive);
   end Multiplying_Machine;

   Adding_Machines : array (1 .. Config.Number_Of_Adding_Machines) of Adding_Machine;
   Multiplying_Machines : array (1 .. Config.Number_Of_Multiplying_Machines) of Multiplying_Machine;
end Machines;
