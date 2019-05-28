with Config;

package Positions is
   type Worker_Info is record
      Impatient : Boolean;
      Executed_Tasks : Integer;
   end record;

   type List_Of_Worker_Info is array (Integer range<>) of Worker_Info;

   protected type Worker_Info_Board is
      procedure Add_Info (Index : in Integer; Impatient : Boolean);
      procedure Increment_Executed (Index : in Integer);
      procedure Print_Workers;
   private
      Board : List_Of_Worker_Info (1 .. Config.Number_Of_Workers);
   end Worker_Info_Board;

   task type Chief_Type;

   task type Customer_Type is
      entry Run (New_Index : in Positive);
   end Customer_Type;

   task type Worker_Type is
      entry Run (New_Index : in Positive; New_Impatient : in Boolean);
   end Worker_Type;

   Chief : Chief_Type;
   Workers_Info : Worker_Info_Board;
   Workers : array (1 .. Config.Number_Of_Workers) of Worker_Type;
   Customers : array (1 .. Config.Number_Of_Customers) of Customer_Type;
end Positions;