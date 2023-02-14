package com.kavalok.remoting.commands
{
   import com.kavalok.Global;
   
   public class AchievementCommand extends ServerCommandBase
   {
       
      
      public function AchievementCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var notify:String = String(parameter);
         Global.frame.showNotification(notify,"achievements");
      }
   }
}
