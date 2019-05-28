with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Config;

package Service_Center is
   type Crash_Report is record
      Machine_Type : Character;
      Machine_Index : Integer;
   end record;

   type List_Of_Crash_Report_Type is array (Integer range<>) of Crash_Report;

   protected type Service_Center_Type is
      entry Add_Report (New_Report : in Crash_Report);
      entry Get_Report (Existing_Report : out Crash_Report);
      entry Fix_Machine (Fixed_Report : in Crash_Report);
   private
      New_Reports : List_Of_Crash_Report_Type (0 .. Config.Max_Amount_Of_Crash_Reports - 1);
      Sent_Reports : List_Of_Crash_Report_Type  (0 .. Config.Max_Amount_Of_Crash_Reports - 1);
      New_Reports_Amount : Integer := 0;
      New_Reports_Head : Integer := 0;
      New_Reports_Tail : Integer := -1;
      Sent_Reports_Amount : Integer := 0;
      Sent_Reports_Head : Integer := 0;
      Sent_Reports_Tail : Integer := -1;
   end Service_Center_Type;

   task type Service_Center_Worker_Type is
      entry Run (New_Index : in Positive);
   end Service_Center_Worker_Type;

   Service_Center_Task : Service_Center_Type;
   Service_Center_Workers : array (1 .. Config.Number_Of_Service_Center_Workers) of Service_Center_Worker_Type;
end Service_Center;
