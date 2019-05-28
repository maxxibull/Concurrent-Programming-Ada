package Config is

   Min_Value_Of_Argument : constant Integer := 0;
   Max_Value_Of_Argument : constant Integer := 10;

   Max_Amount_Of_Company_Tasks : constant Integer := 5;
   Max_Amount_Of_Company_Products : constant Integer := 10;
   Max_Amount_Of_Crash_Reports : constant Integer := 4;

   Number_Of_Workers : constant Integer := 4;
   Number_Of_Customers : constant Integer := 6;
   Number_Of_Adding_Machines : constant Integer := 2;
   Number_Of_Multiplying_Machines : constant Integer := 2;
   Number_Of_Service_Center_Workers : constant := 3;

   Time_To_Sleep_For_Worker : constant Duration := 0.5;
   Time_To_Sleep_For_Customer : constant Duration := 2.0;
   Time_To_Sleep_For_Chief : constant Duration := 0.5;
   Time_To_Sleep_For_Adding_Machine : constant Duration := 2.0;
   Time_To_Sleep_For_Multiplying_Machine : constant Duration := 2.0;
   Time_To_Sleep_For_Service_Center_Worker : constant Duration := 0.5;

   Time_To_Wait_For_Impatient_Worker : constant Duration := 1.0;

   Probability_Of_Crash : constant Integer := 15; -- from 0 to 100

   Is_Chatty_Mode : constant Boolean := False;

end Config;
