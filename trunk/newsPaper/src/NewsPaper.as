package {
	import com.kavalok.Global;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.newsPaper.LoadMessageCommand;
	import com.kavalok.newsPaper.TitleView;
	import com.kavalok.services.PaperService;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;

	public class NewsPaper extends WindowModule
	{
		private static const WIDTH : uint = 658;
		private static const NEWS_SCROLL_RECT : Rectangle = new Rectangle(0, 0, 658, 300);
		private static const FILTERS : Array = [new BlurFilter(100, 0, 1)];
		private static const TWEEN_FRAMES : uint = 4;
		
		private var _content : Background;
		private var _size : uint;
		private var _index : uint;
		private var _previousPage : NewsPage;
		private var _currentPage : NewsPage;
		private var _isTweening : Boolean;

		public function NewsPaper()
		{
		}
		
		override public function initialize():void
		{

			_content = new Background();
			_content.nextButton.visible = false;
			_content.nextButton.addEventListener(MouseEvent.CLICK, onNextClick);
			_content.previousButton.visible = false;
			_content.previousButton.addEventListener(MouseEvent.CLICK, onPrevClick);
			addChild(_content);
			_content.newsContainer.scrollRect = NEWS_SCROLL_RECT;
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			new PaperService(onGetSize).getMessagesCount();
			readyEvent.sendEvent();
		}
		
		private function changePage(diff : int) : void
		{
			if(_isTweening)
				return;
			var clip : MovieClip = diff == 1 ? _content.leftClip : _content.rightClip;
			clip.play();
			_index+=diff;
			if(_previousPage != null)
			{
				_content.newsContainer.removeChild(_previousPage);
			}
			_previousPage = _currentPage;
			createCurrentPage();
			_currentPage.x = -diff * WIDTH;
			_currentPage.filters = FILTERS;
			_previousPage.filters = FILTERS;
			new SpriteTweaner(_previousPage, {x : diff * WIDTH}, TWEEN_FRAMES, eventManager);
			new SpriteTweaner(_currentPage, {x : 0}, TWEEN_FRAMES, eventManager, onTweenComplete);
			_isTweening = true;

			_content.newsContainer.addChild(_currentPage);
			loadMessage();
			refreshButtons();
		}
		private function createCurrentPage() : void
		{
			_currentPage = new NewsPage();
			_currentPage.cacheAsBitmap = true;
			Global.resourceBundles.kavalok.registerTextField(_currentPage.loadingText, "loading");
			_content.newsContainer.addChild(_currentPage);
		}
		private function onNextClick(event : MouseEvent) : void
		{
			changePage(-1);
		}
		private function onPrevClick(event : MouseEvent) : void
		{
			changePage(1);
		}
		private function onGetSize(result : uint) : void
		{
			_size = result;
			_index = _size;
			if(_size > 0)
			{
				createCurrentPage();
				loadMessage();
				refreshButtons();
			}
		}
		
		private function onTweenComplete(page : NewsPage) : void
		{
			_currentPage.filters = null;
			_previousPage.filters = null;
			_isTweening = false;
		}
		private function loadMessage() : void
		{
			if(_size == _index)
			{
				_currentPage.loadingText.visible = false;
				var view : TitleView = new TitleView(_size);
				_currentPage.addChild(view.content);
				view.pageChange.addListener(onPageChange);
			}
			else
			{
				var command : LoadMessageCommand = new LoadMessageCommand(_currentPage, _index);
				command.execute();
			}
		}
		
		private function refreshButtons() : void
		{
			_content.previousButton.visible = _size > _index;
			_content.nextButton.visible = _index > 0;
		}
		private function onPageChange(index : uint) : void
		{
			changePage(index);
		}
		private function onCloseClick(event : MouseEvent) : void
		{
			closeModule();
		}
		
	}
}
