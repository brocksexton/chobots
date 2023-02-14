package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.char.actions.MagicAction;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.services.MagicServiceNT;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.constants.Modules;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MiniCandyView
	{
		static private const MAGIC_PERIOD:int = 15 * 60; //seconds
		
		private var _content:McCandyView = new McCandyView();
		private var _applyEvent:EventSender = new EventSender();
		private var _loading:LoadingSprite;
		
		public function MiniCandyView()
		{
			Global.charManager.candyChangeEvent.addListener(refresh);
		//new ResourceScanner().apply(_content);	
			_content.exchangeButton.addEventListener(MouseEvent.CLICK, onExchangeClick);
			_content.candyValue.text = Global.charManager.candy.toString();
			
		}
		
		public function refresh():void
		{
			_content.candyValue.text = Global.charManager.candy.toString();
		}
		private function onExchangeClick(e:MouseEvent):void
		{
			//Dialogs.showNinaDialog("Jaquona the Witch's Cauldron");
			_applyEvent.sendEvent();
		}
		
		public function get applyEvent():EventSender { return _applyEvent; }
		public function get content():MovieClip { return _content; }
	}
}
