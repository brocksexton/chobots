package com.kavalok.remoting.commands
{
   import com.kavalok.dialogs.Dialogs;
   
   public class DialogOKCommand extends ServerCommandBase
   {
       
      
      public function DialogOKCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var notify:String = String(parameter);
         Dialogs.showOkDialog(notify);
      }
   }
}
