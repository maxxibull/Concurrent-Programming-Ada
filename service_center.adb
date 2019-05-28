with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Machines; use Machines;
with Config;

package body Service_Center is
   protected body Service_Center_Type is
      entry Add_Report (New_Report : in Crash_Report)
        when New_Reports_Amount < Config.Max_Amount_Of_Crash_Reports is
      begin
         if (for all I in New_Reports'Range =>
               (New_Reports (I).Machine_Type /= New_Report.Machine_Type or
                    New_Reports (I).Machine_Index /= New_Report.Machine_Index))
           and
             (for all I in Sent_Reports'Range =>
                (Sent_Reports (I).Machine_Type /= New_Report.Machine_Type or
                     Sent_Reports (I).Machine_Index /= New_Report.Machine_Index))
         then
            New_Reports_Tail := (New_Reports_Tail + 1) mod Config.Max_Amount_Of_Crash_Reports;
            New_Reports (New_Reports_Tail) := New_Report;
            New_Reports_Amount := New_Reports_Amount + 1;
         end if;
      end Add_Report;

      entry Get_Report (Existing_Report : out Crash_Report)
        when New_Reports_Amount > 0 is
      begin
         Existing_Report := New_Reports (New_Reports_Head);
         Sent_Reports_Tail := (Sent_Reports_Tail + 1) mod Config.Max_Amount_Of_Crash_Reports;
         Sent_Reports (Sent_Reports_Tail) := New_Reports (New_Reports_Head);
         New_Reports (New_Reports_Head).Machine_Index := -1;
         New_Reports_Head := (New_Reports_Head + 1) mod Config.Max_Amount_Of_Crash_Reports;
         New_Reports_Amount := New_Reports_Amount - 1;
         Sent_Reports_Amount := Sent_Reports_Amount + 1;
      end Get_Report;

      entry Fix_Machine (Fixed_Report : in Crash_Report)
        when Sent_Reports_Amount > 0 is
      begin
         Inner : for I in Sent_Reports'Range loop
            if Sent_Reports (I).Machine_Type = Fixed_Report.Machine_Type and
              Sent_Reports (I).Machine_Index = Fixed_Report.Machine_Index then
               Sent_Reports (I) := Sent_Reports (Sent_Reports_Head);
               Sent_Reports (Sent_Reports_Head).Machine_Index := -1;
               Sent_Reports_Head := (Sent_Reports_Head + 1) mod Config.Max_Amount_Of_Crash_Reports;
               Sent_Reports_Amount := Sent_Reports_Amount - 1;
               exit Inner;
            end if;
         end loop Inner;
      end Fix_Machine;
   end Service_Center_Type;

   task body Service_Center_Worker_Type is
      New_Report : Crash_Report;
      Index : Positive;

   begin
      accept Run (New_Index : in Positive) do
         Index := New_Index;
      end Run;

      loop
         Service_Center_Task.Get_Report (New_Report);

         case New_Report.Machine_Type is
            when '+' =>
               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[34m" & "service center worker" & Index'Image & ":" & ESC & "[0m" &
                              " going to fix adding machines" & New_Report.Machine_Index'Image);
               end if;

               delay Config.Time_To_Sleep_For_Service_Center_Worker;
               Adding_Machines (New_Report.Machine_Index).Fix;

               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[34m" & "service center worker" & Index'Image & ":" & ESC & "[0m" &
                              " fixed adding machines" & New_Report.Machine_Index'Image);
               end if;
            when '*' =>
               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[34m" & "service center worker" & Index'Image & ":" & ESC & "[0m" &
                              " going to fix multiplying machines" & New_Report.Machine_Index'Image);
               end if;

               delay Config.Time_To_Sleep_For_Service_Center_Worker;
               Multiplying_Machines (New_Report.Machine_Index).Fix;

               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[34m" & "service center worker" & Index'Image & ":" & ESC & "[0m" &
                              " fixed multiplying machines" & New_Report.Machine_Index'Image);
               end if;
            when others =>
               if Config.Is_Chatty_Mode then
                  Put_Line (ESC & "[34m" & "service center worker" & Index'Image & ":" & ESC & "[0m" &
                              " wrong type of machine!");
               end if;
         end case;

         Service_Center_Task.Fix_Machine (New_Report);
      end loop;
   end Service_Center_Worker_Type;
end Service_Center;
