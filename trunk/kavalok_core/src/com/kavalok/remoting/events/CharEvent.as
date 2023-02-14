package com.kavalok.remoting.events
{
	import com.kavalok.events.DefaultEvent;

	public class CharEvent extends DefaultEvent
	{
		private var _charId : String;
		
		public function CharEvent(charId : String)
		{
			super();
			_charId = charId;
		}
		
		public function get charId() : String
		{
			return _charId;
		}
		
	}
}