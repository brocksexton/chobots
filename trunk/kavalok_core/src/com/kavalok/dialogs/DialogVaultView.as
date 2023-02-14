package com.kavalok.dialogs
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.events.EventSender;
	import com.kavalok.services.AdminService;
	import com.kavalok.dialogs.DialogYesNoView;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.Strings;
	
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class DialogVaultView extends DialogViewBase
	{
		public var exitButton:SimpleButton; 
		public var starButton:SimpleButton; 
		public var hashButton:SimpleButton; 
		public var keypad:MovieClip; 
		public var successLights:MovieClip; 
		public var safeNumbers:TextField; 
		public var accessGranted:TextField;
		public var safeWheel:MovieClip;
		public var nextNumber:int = 1;
		public var timer:Timer;
		
		public function DialogVaultView(text:String, modal:Boolean = false)
		{
			super(content || new DialogVault(), text, modal);
			new AdminService(onGetCodes).getVaultCodes();
			exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			accessGranted.visible = false;
			successLights.gotoAndStop(1);
			safeWheel.gotoAndPlay(1);
		}
		
		private function onGetCodes(result:Boolean):void
		{	
			if(result) {
				
				starButton.addEventListener(MouseEvent.CLICK, onClearClick);
				hashButton.addEventListener(MouseEvent.CLICK, onHashClick);
				ToolTips.registerObject(hashButton,"Try Code!");
				ToolTips.registerObject(starButton,"Clear!");
				for(var i:int = 0; i < keypad.numChildren; i++)
				{
					var child:DisplayObject = keypad.getChildAt(i);
					if (child is SimpleButton && Strings.startsWidth(child.name, "button_"))
					{
						initObject(child as SimpleButton);
					}
				}
			} else {
				keypad.mouseChildren = false;
				ToolTips.registerObject(keypad,"All codes have been cracked!");
				GraphUtils.setBtnEnabled(starButton, false);
				GraphUtils.setBtnEnabled(hashButton, false);
				accessGranted.visible = true;
				accessGranted.textColor = 0xFF0000;
				accessGranted.text = "ERROR";
			}
		}
		
		private function initObject(clip:SimpleButton):void
		{
			clip.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClearClick(e:MouseEvent):void
		{
			nextNumber = 1;
			safeNumbers.text = "----";
		}
		
		private function onHashClick(e:MouseEvent):void
		{
			Global.isLocked = true;
			new AdminService(onGetResult).checkVault(parseInt(safeNumbers.text));
		}
	
		private function onClick(e:MouseEvent):void
		{
			var numberPressed:String = e.currentTarget.name.split('_')[1];
			if(nextNumber <= 4) {
				safeNumbers.text = safeNumbers.text.substr(0,nextNumber-1) + numberPressed + safeNumbers.text.substr(nextNumber);
				nextNumber = nextNumber+1;
			}
		}
		
		private function onGetResult(result:int):void
		{
			if(result == 0) {
				accessGranted.visible = true;
				accessGranted.textColor = 0x00FF00;
				accessGranted.text = "ACCESS GRANTED";
				successLights.gotoAndStop(3);
				safeWheel.gotoAndPlay(2);
			} else {
				successLights.gotoAndStop(2);
				safeWheel.gotoAndPlay(27);
				accessGranted.visible = true;
				accessGranted.textColor = 0xFF0000;
				if(result == 1) {
					accessGranted.text = "ACCESS DENIED";
				} else if(result == 2) {
					accessGranted.text = "NO ATTEMPTS LEFT";
				}
				safeNumbers.textColor = 0xFF0000;
			}
			timer = new Timer(1000, 1)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
		}
		
		private function onTimerComplete(e:TimerEvent):void
		{
			Global.isLocked = false;
			accessGranted.visible = false;
			timer.stop();
			nextNumber = 1;
			safeNumbers.text = "----";
			successLights.gotoAndStop(1);
			safeNumbers.textColor = 0x00FF00;
		}
		
		private function onExitClick(event:MouseEvent):void
		{
			Global.frame.refresh();
			hide();
		}
	}
}