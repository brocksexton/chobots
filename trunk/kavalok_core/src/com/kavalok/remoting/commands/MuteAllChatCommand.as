package com.kavalok.remoting.commands
{
	import com.kavalok.Global;
	import com.kavalok.remoting.commands.ServerCommandBase;
	
	public class MuteAllChatCommand extends ServerCommandBase
	{

		public function MuteAllChatCommand()
		{
		  super();
		}
		
		override public function execute():void
		{
		  var sett:Boolean = true;
		  var str:String = String(parameter);
		  
		  if(str == "true"){
		  sett = true;
		  }else{
		  sett = false;
		  }
		   
			if(sett == true){
			Global.bubbleValue = true;
			}else if(sett == false){
			Global.bubbleValue = false;
			}
		}
	
	}
}