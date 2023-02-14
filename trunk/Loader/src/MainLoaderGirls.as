package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	[SWF(width='900', height='510', backgroundColor='0xffffff', frameRate='24')]
	public class MainLoaderGirls extends Sprite
	{
		private static const WIDTH : uint = 507;
		private static const HEIGHT : uint = 464;
		private static const VERTICAL_MARGIN : int = 4;
		
		private var _loader:Loader;
		private var _view:McLoaderWhite;
		private var _background:McBackgroundWhite;
		private var _border:Sprite;
		private var _borderContent:Sprite;
		
		public function MainLoaderGirls()
		{
			super();
			if (this.stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function traceInfo():void
		{
			trace(this);
			trace(this.loaderInfo.url);
			trace(this.loaderInfo.loaderURL);
			trace('[parameterInfo:]')
			for (var paramName:String in this.loaderInfo.parameters)
			{
				trace(paramName + ': ' + this.loaderInfo.parameters[paramName])
			}
		}
		
		private function initialize(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			traceInfo();
			initStage();
			loadMain();
		}
		
		private function loadMain():void
		{

			var parameters:String = '';
			for (var paramName:String in loaderInfo.parameters)
			{
				if (parameters.length > 0)
					parameters += '&';
				parameters += paramName + '=' + loaderInfo.parameters[paramName];
			}
			
			var mainURL:String = loaderInfo.url.replace('MainLoaderGirls.swf', 'MainGirls.swf');
			if (parameters.length > 0)
				mainURL += '?' + parameters+'&moduleId=girlsRegistration';
			
			var request:URLRequest = new URLRequest(mainURL);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.load(request);
		}
		
		private function initStage():void
		{
			
			_loader = new Loader();
			_view = new McLoaderWhite();
			
			
			
			_background = new McBackgroundWhite();
			_background.mouseEnabled = false;
			_background.mouseChildren = false;
			_background.cacheAsBitmap = true;
			
			_border = new Sprite();
			_border.cacheAsBitmap = true;
			_border.mouseChildren = false;
			_border.mouseEnabled = false;
			
			stage.addChild(_background);
			stage.addChild(_loader);
			_view.width=WIDTH;
			_view.height=HEIGHT;
			stage.addChild(_view);
			_view.width=WIDTH;
			_view.height=HEIGHT;
			//stage.addChild(_border);
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.tabChildren = false;
			//stage.addEventListener(Event.RESIZE, adjustBackgroundWidth);
			//adjustBackgroundWidth();
		}
		
		private function adjustBackgroundWidth(e:Event = null) : void
		{
			var newBorderContent:Sprite = null;
			
			_background.width = stage.stageWidth;
			_background.x = int (0.5 * (WIDTH - _background.width));
			
			if(_background.width > WIDTH)
			{
				 if (!(_borderContent is McDefaultBorder))
				 {
					newBorderContent = new McDefaultBorder();
					_background.y = -VERTICAL_MARGIN;
					_background.height = HEIGHT + 2 * VERTICAL_MARGIN;
				}
			}	
			else
			{
				 if (!(_borderContent is McPartnerBorder))
				 {
					newBorderContent = new McPartnerBorder();
					_background.y = 0;
					_background.height = HEIGHT;
				}
			}
			
			if (newBorderContent)
			{
				if (_borderContent)
					_border.removeChild(_borderContent);
				_borderContent = newBorderContent;
				_border.addChild(_borderContent);
			}
		}

		private function onLoadProgress(e:ProgressEvent):void
		{
			var percent:int = e.bytesLoaded / e.bytesTotal * 100; 
			_view.txtPercent.text = percent.toString() + '%'; 
		}
		
		private function onLoadComplete(e:Event):void
		{
			_view.mcAnim.gotoAndStop(_view.mcAnim.totalFrames);
			_view.parent.removeChild(_view);
			trace('[complete]');
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			trace(e.toString());
		}
	}
}
