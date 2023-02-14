package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.char.Stuffs;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.messenger.McPresentWindow;
	import com.kavalok.services.StuffService;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ItemOfTheMonthMessage extends StuffMessageBase
	{
		public function ItemOfTheMonthMessage():void
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}
		
		override public function getText():String
		{
			return Global.messages.itemOfTheMonthMessage;
		}
	}
}