package com.kavalok.dialogs
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.kavalok.services.AdminService;
	import flash.events.MouseEvent;
	import com.kavalok.Global;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import com.kavalok.utils.GraphUtils;
	import flash.text.TextField;
	import com.kavalok.utils.Strings;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.localization.ResourceBundle;

	import com.kavalok.events.EventSender;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DialogAgentRulesView extends DialogViewBase
	{
		public var okButton:SimpleButton;
		public var rulesField:TextField;
		public var timeField:TextField;
		private var _ok:EventSender = new EventSender();
		public var rulesArr:Array = new Array();
		private var _timer:Timer;
		private var _canChat:Boolean;		
		private static var bundle:ResourceBundle = Global.resourceBundles.kavalok;
	
		public function DialogAgentRulesView(text:String, modal:Boolean = false)
		{
			super(content || new DialogAgentRules(), text, modal);
			okButton.addEventListener(MouseEvent.CLICK, onOkClick);
			GraphUtils.setBtnEnabled(okButton, false);
			showD();
			rulesArr = text.split("#");
			rulesField.text = "We've noticed you've been breaking the rules!\nA Chobots mediator requests that you stop with the following:\n";

			for each(var rule:String in rulesArr){
				rulesField.appendText("- " + Global.messages["warn_" + rule]);
			}

			rulesField.appendText("\nKeep in mind, Chobots is a family-friendly game and we do not tolerate bad behavior. If you continue, a Chobots moderator will take action against your account.");
		}

		public function showD():void
		{
			_timer = new Timer(1000, 30);
			_timer.start();
			timeField.text = "";
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
	
			if (Global.notifications.chatEnabled)
			{
				_canChat = true;
				Global.notifications.chatEnabled = false;
			}
			else
			{
				_canChat = false;
				Global.notifications.chatEnabled = false;
			}
		
		}

	
		
		private function onTimerComplete(event:TimerEvent):void
		{
			GraphUtils.setBtnEnabled(okButton, true);
			timeField.visible = false;
			if (_canChat)
			{
				Global.notifications.chatEnabled = true;
			}
			else
			{
				return;
			}
		
		}
		
		private function onTimer(event:TimerEvent):void
		{
			timeField.text = Strings.substitute(bundle.getMessage("youCanCloseThisIn"), _timer.repeatCount - _timer.currentCount);
		}
		
		public function get ok():EventSender
		{
			return _ok;
		}
		
		protected function onOkClick(event:MouseEvent):void
		{
			hide();
			ok.sendEvent();
		}
		

	}
}