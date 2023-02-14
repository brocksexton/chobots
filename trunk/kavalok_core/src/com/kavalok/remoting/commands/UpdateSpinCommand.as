package com.kavalok.remoting.commands
{
   import com.kavalok.Global;
   import com.kavalok.dialogs.Dialogs;
   
   public class UpdateSpinCommand extends ServerCommandBase
   {
       
      
      public function UpdateSpinCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
        Global.charManager.spinAmount = Number(parameter);
      }
   }
}
