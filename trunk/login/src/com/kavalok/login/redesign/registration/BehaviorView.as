package com.kavalok.login.redesign.registration
{
	import com.kavalok.gameplay.controls.EnabledButton;
	import com.kavalok.gameplay.controls.ViewStackSwitcher;
	import com.kavalok.gameplay.controls.effects.AlphaHideEffect;
	import com.kavalok.gameplay.controls.effects.AlphaShowEffect;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class BehaviorView extends WizardViewBase
	{
		
		private var _content : McBehavior;
		private var _nextButton : EnabledButton;
		private var _agreeButton : EnabledButton;
		
		public function BehaviorView(content:McBehavior)
		{
			_content = content;
			super(content);
			
			
			_agreeButton = new EnabledButton(_content.agreeButton);
			_content.agreeButton.addEventListener(MouseEvent.CLICK, nextEvent.sendEvent);
			_content.backButton.addEventListener(MouseEvent.CLICK, backEvent.sendEvent);
			new EnabledButton(_content.backButton);

		}
		
		
		
	}
}