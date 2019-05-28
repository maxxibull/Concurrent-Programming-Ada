with Machines; use Machines;
with Config;

package Boards is
   type Company_Product is record
      Value : Integer;
   end record;

   type List_Of_Product_Type is array (Integer range<>) of Company_Product;

   protected type Tasks_Board is
      entry Add_Task (New_Task : in Company_Task);
      entry Get_Task (Next_Task : out Company_Task);
      procedure Print_Tasks;
   private
      Board : List_Of_Task_Type (0 .. (Config.Max_Amount_Of_Company_Tasks - 1));
      Amount : Integer := 0;
      Head : Integer := 0;
      Tail : Integer := -1;
   end Tasks_Board;

   protected type Store_Board is
      entry Add_Product (New_Product : in Company_Product);
      entry Get_Product (Next_Product : out Company_Product);
      procedure Print_Products;
   private
      Board : List_Of_Product_Type (0 .. (Config.Max_Amount_Of_Company_Products - 1));
      Amount : Integer := 0;
      Head : Integer := 0;
      Tail : Integer := -1;
   end Store_Board;

   Tasks : Tasks_Board;
   Products : Store_Board;
end Boards;
