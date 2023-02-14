package com.kavalok.commands.char
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.commands.AsincCommand;
	import com.kavalok.services.CharService;
	
	public class GetCharCommand extends AsincCommand
	{
		private var _login:String;
		private var _userId:Number;
		private var _char:Char;
		
		public function GetCharCommand(login:String, userId:Number = 0, onComplete:Function = null)
		{
			super(onComplete);
			
			_login = login;
			_userId = userId;
		}
		
		override public function execute():void
		{
			if(_userId!=0)
				new CharService(onResult).getCharView(_userId);
			else
				new CharService(onResult).getCharViewLogin(_login);
		}
		
		private function onResult(result:Object):void
		{
			_char = new Char(result);
			Global.charsCache[_char.id] = _char;
			dispatchComplete();
		}
		
		public function get char():Char { return _char; }
	}
}