package
{
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class BannerBase extends MovieClip
	{
		public const OVER_SOUND:String = 'SndOver';
		
		private var _channel:SoundChannel;
		private var _overAnimation:MovieClip;
		
		function BannerBase()
		{
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			
			var baner:MovieClip = getChildAt(0) as MovieClip;
			baner.mouseChildren = false;
			baner.opaqueBackground = 0;
			
			_overAnimation = baner.getChildByName('mcOverAnimation') as MovieClip;
		}

		public function onClick(e:MouseEvent):void
		{
		   if(url.indexOf("http:") != 0)
				return;
		   var request : URLRequest = new URLRequest(url);
		   navigateToURL(request, '_blank');
		   //navigateToURL(request, '_self');
		}
		
		public function onOver(e:MouseEvent):void
		{
			if (_channel)
				return;
				
			if (_overAnimation)
				_overAnimation.gotoAndPlay(2);
			
			if (ApplicationDomain.currentDomain.hasDefinition(OVER_SOUND))
			{
				var soundClass:Class = ApplicationDomain.currentDomain.getDefinition(OVER_SOUND) as Class;
				var sound:Sound = new soundClass();
				_channel = sound.play();
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
		}
		
		private function onSoundComplete(e:Event):void
		{
			_channel = null;
		}
		
		public function get url():String
		{
			return this.loaderInfo.parameters.clickTAG || this.loaderInfo.parameters.url;
		}
	}
}