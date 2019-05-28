limited with Machines;
limited with Boards;
limited with Positions;
limited with Service_Center;
with Config;

package Company is
   type Worker_Info is record
      Impatient : Boolean;
      Executed_Tasks : Integer;
   end record;

   task type Commands_Type;
   type Commands_Access is access Commands_Type;
   procedure Run_Company;

   Commands : Commands_Access;
end Company;
