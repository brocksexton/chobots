package com.kavalok.membership
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.buy.BuyButtonsView;
	import com.kavalok.dialogs.buy.ItemOfTheMonthView;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.controls.ButtonBar;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.gameplay.controls.ViewStackSwitcher;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.events.MouseEvent;

	public class MembershipView extends FlashViewBase
	{
		private var _content : McMembership = new McMembership();
		private var _buttonBar : ButtonBar = new ButtonBar();
		private var _viewStack : ViewStackSwitcher = new ViewStackSwitcher();
		private var _closeEvent : EventSender = new EventSender();
		private var _pages : Array = ["citizenship", "creativity", "fun", "experience", "comingSoon"];
		public function MembershipView(showClose : Boolean)
		{
			
			super(_content);
			new ResourceScanner().apply(content);
			new BoldFormatter().apply(_content.tabButtons);
			new BuyButtonsView(_content.buttons);
			new ItemOfTheMonthView(_content.citizenship);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.closeButton.visible = showClose;
			
			_buttonBar.addButton(_content.tabButtons.citizenshipButton);
			_buttonBar.addButton(_content.tabButtons.creativityButton);
			_buttonBar.addButton(_content.tabButtons.funButton);
			_buttonBar.addButton(_content.tabButtons.experienceButton);
			_buttonBar.addButton(_content.tabButtons.comingSoonButton);
			
			_buttonBar.selectedIndexChangeEvent.addListener(onSelectedIndexChange);
			_viewStack.addPage(_content.citizenship)
			_viewStack.addPage(_content.creativity)
			_viewStack.addPage(_content.fun)
			_viewStack.addPage(_content.experience)
			_viewStack.addPage(_content.comingSoon)
			_buttonBar.selectedIndex = 0;
			_viewStack.selectedIndex = 0;
		}
		
		public function get closeEvent() : EventSender
		{
			return _closeEvent;
		}
		
		private function onCloseClick(event : MouseEvent) : void
		{
			closeEvent.sendEvent();
		}
		private function onSelectedIndexChange() : void
		{
			_viewStack.selectedIndex = _buttonBar.selectedIndex;
		}
		
		private function trackAnalytics(index : int):void
		{
			var page : String = _pages[index];
			Global.analyticsTracker.trackPageview("/f/membership/" + page);
		}
	}
}