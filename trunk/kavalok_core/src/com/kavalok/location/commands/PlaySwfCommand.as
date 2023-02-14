package com.kavalok.location.commands
{
	import com.junkbyte.console.Cc;
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest; // console
	
	public class PlaySwfCommand extends RemoteLocationCommand
	{
		public var url:String;
		
		private var _loader:Loader;
		
		private var _hash:String;
		
		public function PlaySwfCommand()
		{
			Cc.log("PlaySwfCommand instantiated");
			
			super();
		}
		
		override public function execute():void
		{
			var continueAnim:Boolean = false;
			if(_hash != Global.locationManager.location.locHash){
				trace("playswfcommand hash does not match roomhash");
				return;
			} else {
				trace(" playswf hash is right");
			}
			
			for each(var user:String in Global.animationsPeople)
			{
				if(Global.locationManager._location.doesCharExistWithName(user)) {
					continueAnim = true;
				}
			}
			
			//if(!continueAnim) 
			//	return;
			
			Cc.log("Trying to execute animation " + url);
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.load(new URLRequest(url));
		}
		
		private function onLoadComplete(e:Event):void
		{
			var movie:MovieClip = LoaderInfo(e.target).content as MovieClip;
			movie.mouseEnabled = false;
			movie.mouseChildren = false;
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

		public function get hash():String
		{
			return _hash;
		}

		public function set hash(value:String):void
		{
			_hash = value;
		}

	}
}