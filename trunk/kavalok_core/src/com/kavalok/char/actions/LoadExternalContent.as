package com.kavalok.char.actions
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	
	public class LoadExternalContent extends CharActionBase
	{
		private var _loader:Loader;
		
		override public function execute():void
		{
			if (Security.sandboxType != Security.LOCAL_TRUSTED)
			{
				var context:LoaderContext = new LoaderContext()
				context.applicationDomain = ApplicationDomain.currentDomain;
				context.securityDomain = SecurityDomain.currentDomain;
			}
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.load(new URLRequest(url), context);
		}
			
		private function onLoadComplete(e:Event):void
		{
			var movie:MovieClip = LoaderInfo(e.target).content as MovieClip;
			if (movie)
			{
				Global.locationContainer.addChild(movie);
				movie.addEventListener(Event.ENTER_FRAME, onMovieFrame);
			}
			else
			{
				LoaderInfo(e.target).content['execute']();
			}
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
		
		public function get url():String
		{
			 return _parameters.url;
		}
		
	}
}