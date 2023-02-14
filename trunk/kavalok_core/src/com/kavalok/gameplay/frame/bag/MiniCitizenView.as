package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.char.actions.MagicAction;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.remoting.commands.TweetSuccess;
	import com.kavalok.services.MagicServiceNT;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MiniCitizenView
	{
		static private const MAGIC_PERIOD:int = 15 * 60; //seconds
		
		private var _content:McCitizenView = new McCitizenView();
		private var _applyEvent:EventSender = new EventSender();
		private var _loading:LoadingSprite;
		
		public function MiniCitizenView()
		{
			
			if(!Global.charManager.hasRobot)
			GraphUtils.setBtnEnabled(_content['robotButton'], false);
			else
			GraphUtils.setBtnEnabled(_content['robotButton'], true);

			ToolTips.registerObject(_content['clothesButton'], 'clothesButton', ResourceBundles.KAVALOK);
			_content['clothesButton'].addEventListener(MouseEvent.CLICK, onClothesClick);
				ToolTips.registerObject(_content['showerButton'], 'showerButton', ResourceBundles.KAVALOK);
			_content['showerButton'].addEventListener(MouseEvent.CLICK, onShowerClick);
			ToolTips.registerObject(_content['robotButton'], 'robotButton', ResourceBundles.KAVALOK);
			_content['robotButton'].addEventListener(MouseEvent.CLICK, onRobotsClick);
		}
		
		public function refresh():void
		{
			if(!Global.charManager.hasRobot)
			GraphUtils.setBtnEnabled(_content.robotButton, false);
			else
			GraphUtils.setBtnEnabled(_content.robotButton, true);
		}
		private function onClothesClick(e:MouseEvent):void
		{
			Global.moduleManager.loadModule(Modules.HOME_CLOTHES);
			_applyEvent.sendEvent();
		}

			private function onRobotsClick(e:MouseEvent):void
		{
			Global.moduleManager.loadModule("robotConfig");
			_applyEvent.sendEvent();
		}

		private function onShowerClick(e:MouseEvent):void
		{
			Global.moduleManager.loadModule(Modules.CHAR_BODY);
			_applyEvent.sendEvent();
		}
		
		public function get applyEvent():EventSender { return _applyEvent; }
		public function get content():MovieClip { return _content; }
	}
}
