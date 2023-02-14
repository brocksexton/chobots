package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DialogRulesView extends FlashViewBase
	{
		private static const SECONDS:int = 30;
		
		private static var bundle:ResourceBundle = Global.resourceBundles.kavalok;
		
		private var _content:DialogRules;
		
		private var _timer:Timer;
		
		private var _canChat:Boolean;
		
		public function DialogRulesView()
		{
			_content = new DialogRules();
			super(_content);
			_content.mc_okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			GraphUtils.setBtnEnabled(_content.mc_okButton, false);
			bundle.registerMessage(_content.rulesField, "htmlText", "rules");
		}
		
		public function hide():void
		{
			GraphUtils.detachFromDisplay(_content);
		}
		
		public function show():void
		{
			_timer = new Timer(1000, SECONDS);
			_timer.start();
			_content.timeField.text = "";
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			Dialogs.showDialogWindow(_content, true);
			
			trace("b4: " + _canChat);
			trace(Global.notifications.chatEnabled);
			if (Global.notifications.chatEnabled)
			{
				_canChat = true;
				trace("afta: " + _canChat)
				Global.notifications.chatEnabled = false;
			}
			else
			{
				trace("afta: " + _canChat);
				_canChat = false;
				Global.notifications.chatEnabled = false;
			}
		
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			GraphUtils.setBtnEnabled(_content.mc_okButton, true);
			_content.timeField.visible = false;
			if (_canChat)
			{
				trace("canChat....");
				Global.notifications.chatEnabled = true;
			}
			else
			{
				trace("cannot chat....");
				return;
			}
		
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_content.timeField.text = Strings.substitute(bundle.getMessage("youCanCloseThisIn"), _timer.repeatCount - _timer.currentCount);
		}
		
		private function onOkClick(event:MouseEvent):void
		{
			hide();
		}
	}
}