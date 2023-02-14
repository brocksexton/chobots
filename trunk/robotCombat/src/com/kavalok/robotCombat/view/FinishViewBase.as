package com.kavalok.robotCombat.view
{
	import com.kavalok.Global;
	import com.kavalok.dto.robot.CombatResultTO;
	import com.kavalok.robotCombat.commands.QuitCommand;
	import com.kavalok.robots.Robot;
	import com.kavalok.utils.Strings;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import gs.TweenLite;
	import gs.easing.Expo;
	
	public class FinishViewBase extends ModuleViewBase
	{
		private var _content:Sprite;
		
		public function FinishViewBase(content:Sprite)
		{
			super();
			_content = content;
			initialize();
			closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function initialize():void
		{
			initTextField(captionField);
			initTextField(expField);
			initTextField(levelField);
			initButton(closeButton);
			
			Global.resourceBundles.kavalok.registerButton(closeButton, 'close'); 
			
			var robot:Robot = combat.myPlayer.robot;
			var result:CombatResultTO = combat.myPlayer.result;
			var earnedExp:int = result.experience - robot.experience;
			
			captionField.text = captionText;
			expField.text = bundle.messages.experience + ': '
				+ (earnedExp > 0 ? '+' : '') + earnedExp;
			
			levelField.visible = (result.level != robot.level);
			levelField.text = Strings.substitute(
				bundle.messages.reachedLevel, String(result.level));
		}
		
		protected function get captionField():TextField { return _content['captionField']; }
		protected function get expField():TextField { return _content['expField']; }
		protected function get levelField():TextField { return _content['levelField']; }
		protected function get closeButton():SimpleButton { return _content['closeButton']; }
		
		protected function get captionText():String { return null; }
		
		private function onCloseClick(e:MouseEvent):void
		{
			new QuitCommand().execute();
		}
		
		public function show():void
		{
			combat.root.addChild(_content);
			TweenLite.from(_content, 0.5, {alpha:0, ease:Expo.easeOut});
		}
		
	}
}