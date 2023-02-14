package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;

	[SWF(width='800', height='600', backgroundColor='0x006699', frameRate='24')]
	public class LocationMochiLoaderBase extends Sprite
	{
		static private const MORE_GAMES_URL:String = 'http://www.games.chobots.com';
		private static const WIDTH : uint = 900;
		private static const HEIGHT : uint = 510;
		private static const VERTICAL_MARGIN : int = 4;
		
		private var _loader:Loader;
		private var _background:McBackground;
		private var _border:McPartnerBorder;
		private var _moduleId:String;
		private var _loaderContent:MovieClip;
		private var _gameScale:Number;
		
		public function LocationLoaderBase(loaderContent:MovieClip, moduleId:String)
		{
			super();
			
			_loaderContent = loaderContent;
			_moduleId = moduleId;
			
			if (this.stage)
				initialize(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function traceInfo():void
		{
		}
		
		private function initialize(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			initStage();
			loadMain();
		}
		
		private function initStage():void
		{
			_gameScale = Math.min(stage.stageWidth / WIDTH, stage.stageHeight / HEIGHT);
			var gameWidth:int = WIDTH * _gameScale;
			var gameHeight:int = HEIGHT * _gameScale;
			
			lineClip.scaleX = 0;
			
			_loader = new Loader();
			_loader.x = int(0.5 * (stage.stageWidth - gameWidth));
			_loader.y = int(0.5 * (stage.stageHeight - gameHeight));
			_loader.scaleX = _gameScale;
			_loader.scaleY = _gameScale;
			
			_loaderContent.x = int(0.5 * (stage.stageWidth - gameWidth));
			_loaderContent.y = int(0.5 * (stage.stageHeight - gameHeight));
			_loaderContent.scaleX = _gameScale;
			_loaderContent.scaleY = _gameScale;
			
			bannerClip.alpha = 0;
			bannerClip.buttonMode = true;
			bannerClip.addEventListener(MouseEvent.CLICK, onMoreGamesClick);
			
			playButton.visible = false;
			playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
			moreGamesButton.visible = false;
			moreGamesButton.addEventListener(MouseEvent.CLICK, onMoreGamesClick);
			
			_background = new McBackground();
			_background.width = stage.stageWidth;
			_background.height = stage.stageHeight;
			_background.mouseChildren = false;
			_background.cacheAsBitmap = true;
			
			_border = new McPartnerBorder();
			_border.x = int(0.5 * (stage.stageWidth - gameWidth)) + 2;
			_border.y = int(0.5 * (stage.stageHeight - gameHeight)) + 2;
			_border.width = gameWidth + 2;
			_border.height = gameHeight + 2;
			_border.cacheAsBitmap = true;
			_border.mouseChildren = false;
			
			stage.addChild(_background);
			stage.addChild(_loader);
			stage.addChild(_loaderContent);
			stage.addChild(_border);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.tabChildren = false;
		}
		
		private function loadMain():void
		{
			var className:String = getQualifiedClassName(this);
			var mainURL:String = loaderInfo.url.replace(className, 'Main');
			mainURL += '?guest=guest';
			mainURL += '&moduleId=' + _moduleId;
			mainURL += '&scale=' + _gameScale;
			mainURL += '&referer=' + referer;
			
			var request:URLRequest = new URLRequest(mainURL);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.load(request);
		}
		
		private function onLoadProgress(e:ProgressEvent):void
		{
			var progressValue:Number = Number(e.bytesLoaded) / Number(e.bytesTotal);
			percentField.text = '' + int(progressValue * 100) + '%';
			lineClip.scaleX = progressValue;
		}
		
		private function onLoadComplete(e:Event):void
		{
			progressBar.visible = false;
			playButton.visible = true;
			moreGamesButton.visible = true;
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		public function get playButton():SimpleButton
		{
			 return _loaderContent.playButton;
		}
		
		public function get moreGamesButton():SimpleButton
		{
			 return _loaderContent.moreGamesButton;
		}
		
		public function get progressBar():MovieClip
		{
			 return _loaderContent.progressBar;
		}
		
		public function get lineClip():MovieClip
		{
			 return progressBar.lineClip;
		}
		
		public function get bannerClip():MovieClip
		{
			 return _loaderContent.bannerClip;
		}
		
		public function get percentField():TextField
		{
			 return progressBar.percentField;
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			_loaderContent.parent.removeChild(_loaderContent);
		}		
		
		private function onMoreGamesClick(e:MouseEvent):void
		{
			var url:String = MORE_GAMES_URL + '?src=' + referer;
			navigateToURL(new URLRequest(url), '_blank');
		}
		
		private function get referer():String
		{
			return URLUtil.getServerName(loaderInfo.loaderURL);
		}	
	}
}
