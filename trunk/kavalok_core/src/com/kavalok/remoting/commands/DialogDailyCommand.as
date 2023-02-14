package com.kavalok.remoting.commands
{
   import com.kavalok.dialogs.Dialogs;
   
   public class DialogDailyCommand extends ServerCommandBase
   {
       
      
      public function DialogDailyCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var bugs:String = String(parameter);
         Dialogs.showBugsDialog(bugs);
      }
   }
}
