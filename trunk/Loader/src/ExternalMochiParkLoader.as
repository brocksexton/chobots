package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import mochi.as3.MochiAd;

	[SWF(width='900', height='510', backgroundColor='0x006699', frameRate='24')]
	public dynamic class ExternalMochiParkLoader extends MovieClip
	{
		//static private const MAIN_ADDRESS:String = 'http://local.kavalok.com/1/';
		static private const MAIN_ADDRESS:String = 'http://www.chobots.com/game/';
		//static private const MAIN_ADDRESS:String = 'file:///D|/chobots/kavalok/bin/';
		
		private var _loader:Loader;
	
		public function ExternalMochiParkLoader()
		{
			var domain:String = MAIN_ADDRESS.match(/(?<=\/\/)([^\/]+)/)[0];
			Security.allowDomain('*');
			
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			scrollRect = new Rectangle(0, 0, 900, 510);
			
			MochiAd.showPreGameAd( {
				id:'70bc5a8619fd2a00',
				clip:this,
				res:"900x510",
				onplay:startGame
			});
		}
		
		private function onError(e:IOErrorEvent):void
		{
			trace(e.text);
		}

		private function startGame():void
		{
			var swfName:String = loaderInfo.url.match(/(?<=ExternalMochi).+\.swf/g)[0];
			var url:String = MAIN_ADDRESS + swfName;
			
			_loader = new Loader();
			_loader.load(new URLRequest(url));
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			_loader.visible = false;
			addChild(_loader);
			_loader.visible = false;
		}
	}
}
