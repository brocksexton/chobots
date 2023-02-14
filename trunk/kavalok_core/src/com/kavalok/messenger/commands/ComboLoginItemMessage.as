package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class ComboLoginItemMessage extends StuffMessageBase
	{
		public var days:int;

		public function ComboLoginItemMessage():void
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}

		override protected function showStuff(caption:String, text:String, onClose:Function=null):void
		{
			super.showStuff(caption, Strings.substitute(Global.messages.comboLoginItemMessage, days), onClose);
		}
	}
}



