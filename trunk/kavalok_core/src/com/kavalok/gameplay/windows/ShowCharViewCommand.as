package com.kavalok.gameplay.windows
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.commands.char.GetCharCommand;
	import com.kavalok.interfaces.ICommand;
	
	public class ShowCharViewCommand implements ICommand
	{
		public var showChat:Boolean = false;
		
		private var _charId:String;
		private var _userId:int;
		private var _moodId:String;
		private var _useCache:Boolean = true;
		private var _window:CharWindowView;
		
		public function ShowCharViewCommand(charId:String, userId:Number, moodId:String = null, useCache:Boolean = false)
		{
			_charId = charId;
			_userId = userId;
			_useCache = useCache;
			_moodId = moodId;
		}
		
		public function execute():void
		{
			var window:CharWindowView = Global.windowManager.getCharWindow(_charId);
			
			if (window)
			{
				window.showChat();
				Global.windowManager.activateWindow(window);
			}
			else
			{
				//if (_useCache && (_charId in Global.charsCache))
				//	showWindow(Global.charsCache[_charId]);
				//else
					showWindow(null);
			}
		}
		
		private function showWindow(char:Char):void
		{
			_window = new CharWindowView(_charId);
			_window.moodId = _moodId;

				new GetCharCommand(_charId, _userId, onCharViewResult).execute();
			
			Global.windowManager.showWindow(_window);
		}
		
		private function onCharViewResult(sender:GetCharCommand):void
		{
			setChar(sender.char);
		}
		
		private function setChar(char:Char):void
		{
			_window.char = char;
			if (showChat)
				_window.showChat(true);
		}
	
	}
}