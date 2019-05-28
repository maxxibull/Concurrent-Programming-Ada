with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Config;

package body Boards is
   protected body Store_Board is
      entry Add_Product (New_Product : in Company_Product)
        when Amount < Config.Max_Amount_Of_Company_Products is
      begin
         Tail := (Tail + 1) mod Config.Max_Amount_Of_Company_Products;
         Board(Tail) := New_Product;
         Amount := Amount + 1;
      end Add_Product;

      entry Get_Product (Next_Product : out Company_Product)
        when Amount > 0 is
      begin
         Next_Product := Board(Head);
         Head := (Head + 1) mod Config.Max_Amount_Of_Company_Products;
         Amount := Amount - 1;
      end Get_Product;

      procedure Print_Products is
      begin
         Put_Line (ESC & "[32m" & "Store Board" & ESC & "[0m");

         if Amount = 0 then
            Put_Line ("[]");
         elsif Head <= Tail then
            Put ("[ ");
            for I in Head .. Tail loop
               Put ("{" & Board(I).Value'Image & " } ");
            end loop;
            Put_Line("]");
         elsif Head > Tail then
            Put ("[ ");
            for I in Head .. Board'Last loop
               Put ("{" & Board(I).Value'Image & " } ");
            end loop;
            for I in Board'First .. Tail loop
               Put ("{" & Board(I).Value'Image & " } ");
            end loop;
            Put_Line("]");
         end if;

         Put_Line ("================");
      end Print_Products;
   end Store_Board;

   protected body Tasks_Board is
      entry Add_Task (New_Task : in Company_Task)
        when Amount < Config.Max_Amount_Of_Company_Tasks is
      begin
         Tail := (Tail + 1) mod Config.Max_Amount_Of_Company_Tasks;
         Board(Tail) := New_Task;
         Amount := Amount + 1;
      end Add_Task;

      entry Get_Task (Next_Task : out Company_Task)
        when Amount > 0 is
      begin
         Next_Task := Board(Head);
         Head := (Head + 1) mod Config.Max_Amount_Of_Company_Tasks;
         Amount := Amount - 1;
      end Get_Task;

      procedure Print_Tasks is
      begin
         Put_Line (ESC & "[32m" & "Tasks Board" & ESC & "[0m");

         if Amount = 0 then
            Put_Line ("[]");
         elsif Head <= Tail then
            Put ("[ ");
            for I in Head .. Tail loop
               Put ("{" & Board(I).First_Argument'Image & " " &
                      Board(I).Second_Argument'Image & " " &
                      Board(I).Operation_Symbol'Image & " } ");
            end loop;
            Put_Line("]");
         elsif Head > Tail then
            Put ("[ ");
            for I in Head .. Board'Last loop
               Put ("{" & Board(I).First_Argument'Image & " " &
                      Board(I).Second_Argument'Image & " " &
                      Board(I).Operation_Symbol'Image & " } ");
            end loop;
            for I in Board'First .. Tail loop
               Put ("{" & Board(I).First_Argument'Image & " " &
                      Board(I).Second_Argument'Image & " " &
                      Board(I).Operation_Symbol'Image & " } ");
            end loop;
            Put_Line("]");
         end if;

         Put_Line ("================");
      end Print_Tasks;
   end Tasks_Board;
end Boards;
