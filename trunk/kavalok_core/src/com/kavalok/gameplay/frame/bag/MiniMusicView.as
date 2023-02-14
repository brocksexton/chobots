package com.kavalok.gameplay.frame.bag
{
	import com.kavalok.Global;
	import com.kavalok.char.actions.MusicAction;
	import com.kavalok.events.EventSender;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.utils.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	public class MiniMusicView
	{
		static private const NUM_ITEMS:int = 3;
		static private const BTN:String = 'btn';
		
		private var _content:McMusic = new McMusic();
		private var _applyEvent:EventSender = new EventSender();
		private var _selectedBtn:SimpleButton;
		private var bTimer:Timer = new Timer(3400);
		
		public function MiniMusicView()
		{
			new ResourceScanner().apply(_content);
			initButtons();
		}
		
		private function initButtons():void
		{
			for (var i:int = 0; i < NUM_ITEMS; i++)
			{
				var button:SimpleButton = _content[BTN + (i + 1)];
				button.addEventListener(MouseEvent.CLICK, onButtonClick);
			}
		}
		
		private function onButtonClick(e:MouseEvent):void
		{
				
				bTimer.addEventListener(TimerEvent.TIMER, enableBtn);

				var musicNum:String = SimpleButton(e.currentTarget).name.replace(BTN, '');
				var musicName:String = Global.charManager.instrument;
				
				Global.locationManager.location.sendUserAction(MusicAction, {name: musicName, num: musicNum});
				bTimer.start();

				for (var i:int = 0; i < NUM_ITEMS; i++)
				{
				var button:SimpleButton = _content[BTN + (i + 1)];
				GraphUtils.setBtnEnabled(button, false);
				}
				
				_applyEvent.sendEvent();
			
		}
		
		private function enableBtn(e:TimerEvent):void
		{
				bTimer.reset();
				for (var i:int = 0; i < NUM_ITEMS; i++)
				{
				var button:SimpleButton = _content[BTN + (i + 1)];
				GraphUtils.setBtnEnabled(button, true);
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
	
	}
}
