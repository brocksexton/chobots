package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.char.actions.MagicAction;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.location.commands.StuffRainCommand;
	import com.kavalok.services.MagicServiceNT;
	import com.kavalok.services.StuffServiceNT;
	import com.kavalok.ui.LoadingSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MiniMagicView
	{
		static private const MAGIC_PERIOD:int = 15 * 60; //seconds
		
		private var _content:McMagicView = new McMagicView();
		private var _applyEvent:EventSender = new EventSender();
		private var _loading:LoadingSprite;
		private var _mPeriod:int;
		
		public function MiniMagicView()
		{
			ToolTips.registerObject(_content.playButton, 'magicPlayButton', ResourceBundles.KAVALOK);
			_content.playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			if (Global.charManager.magicItem)
			{
				Global.locationManager.location.sendUserAction(MagicAction, {name: Global.charManager.magicItem, ivm: "magicItem"});
				new MagicServiceNT().updateMagicDate();
			}
			else if (Global.charManager.magicStuffItemRain)
			{
				if (Global.charManager.magicStuffItemRainCount > 0)
				{
					Global.locationManager.location.sendUserAction(MagicAction);
					new StuffServiceNT(magicStuffRainItemRetreived).getStuffType(Global.charManager.magicStuffItemRain);
				}
			}
			onResult(0);
			_applyEvent.sendEvent();
		}
		
		private function magicStuffRainItemRetreived(stuffType:StuffTypeTO):void
		{
			
			for (var i:int = 0; i < Global.charManager.magicStuffItemRainCount; i++)
			{
				var comm:StuffRainCommand = new StuffRainCommand();
				comm.fileName = stuffType.fileName;
				comm.itemId = stuffType.id;
				comm.stuffType = stuffType.type;
				Global.locationManager.location.sendCommand(comm);
			}
			new MagicServiceNT().updateMagicDate();
		}
		
		public function refresh():void
		{
			_loading = new LoadingSprite(_content.getBounds(_content));
			_content.addChild(_loading);
			_content.playButton.visible = false;
			_content.textField.visible = false;
			
			new MagicServiceNT(onResult).getMagicPeriod();
		}
		
		private function onResult(period:int):void
		{
			_mPeriod = period;
			if (_loading)
				GraphUtils.detachFromDisplay(_loading);
			
			_content.playButton.visible = true;
			_content.textField.visible = true;
			
			if (period > MAGIC_PERIOD || period == -1)
			{
			
				_content.textField.text = Global.messages.magicReady;
				GraphUtils.setBtnEnabled(_content.playButton, true);
			}
			else
			{
				if(getoneMinute)
				_content.textField.text = Strings.substitute(Global.messages.magicNotReady1, String(Math.ceil((MAGIC_PERIOD - period) / 60.0)));
				else
				_content.textField.text = Strings.substitute(Global.messages.magicNotReady, String(Math.ceil((MAGIC_PERIOD - period) / 60.0)));
				var valSet:Boolean = (Global.charManager.hasTools || Global.charManager.isModerator) ? true : false;
				GraphUtils.setBtnEnabled(_content.playButton, valSet);
			}
		}
		
		public function get applyEvent():EventSender
		{
			return _applyEvent;
		}
		
		public function get content():MovieClip
		{
			return _content;
		}

		public function get getoneMinute():Boolean
		{
			if((Math.ceil((MAGIC_PERIOD - _mPeriod) / 60.0)) == 1)
			return true;
			else
			return false;
		}
	}
}
