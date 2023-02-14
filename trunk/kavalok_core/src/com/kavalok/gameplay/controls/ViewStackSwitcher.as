package com.kavalok.gameplay.controls
{
	import com.kavalok.collections.ArrayList;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.gameplay.controls.effects.HideEffect;
	import com.kavalok.gameplay.controls.effects.IEffect;
	import com.kavalok.gameplay.controls.effects.ShowEffect;
	
	public class ViewStackSwitcher
	{
		public var showEffect : IEffect = new ShowEffect();
		public var hideEffect : IEffect = new HideEffect();

		private var _pages : ArrayList = new ArrayList();
		private var _selectedPage : ViewStackPage;
		
		
		public function ViewStackSwitcher()
		{
		}
		
		public function set selectedIndex(value : int) : void
		{
			selectedPage = _pages[value];
		}
		
		public function get selectedIndex() : int
		{
			return _pages.indexOf(_selectedPage);
		}
		
		public function indexOf(page:ViewStackPage):int
		{
			 return _pages.indexOf(page);
		}
		
		public function get pagesCount() : int
		{
			return _pages.length;
		}
		
		public function get selectedPage():ViewStackPage
		{
			return _selectedPage;
		}
		
		public function set selectedPage(value:ViewStackPage) : void
		{
			if(selectedPage == value)
				return;
				
			if(selectedPage)
			{
				selectedPage.onHide();
				hideEffect.play(selectedPage.content);
			}
			
			_selectedPage = value;
			_selectedPage.content.visible = true;
			_selectedPage.onShow();
			showEffect.play(selectedPage.content);
		}
		
		
		public function addPage(page:ViewStackPage) : void
		{
			_pages.addItem(page);
			page.content.visible = false;
		}
		
		public function removePage(page:ViewStackPage) : void
		{
			_pages.removeItem(page);
			if(page == _selectedPage) 
			{
				_selectedPage = null;
			} 
		}

	}
}