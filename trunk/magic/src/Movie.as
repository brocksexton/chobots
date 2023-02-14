package
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class Movie extends MagicBase
	{
		private var _loader:Loader;
		
		public function Movie()
		{
			super();
		}
		
		override public function execute():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.load(new URLRequest(fileName));
		}
		
		private function onLoadComplete(e:Event):void
		{
			var movie:MovieClip = LoaderInfo(e.target).content as MovieClip;
			Global.locationContainer.addChild(movie);
			movie.addEventListener(Event.ENTER_FRAME, onMovieFrame);
		}
		
		private function onMovieFrame(e:Event):void
		{
			var movie:MovieClip = e.target as MovieClip;
			if (movie.currentFrame == movie.totalFrames)
			{
				GraphUtils.stopAllChildren(movie);
				GraphUtils.detachFromDisplay(movie);
				movie.removeEventListener(Event.ENTER_FRAME, onMovieFrame);
			}
		}
		
		public function get fileName():String
		{
			 return loaderInfo.parameters.fileName;
		}
	}
}