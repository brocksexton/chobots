package com.kavalok.location.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.media.Sound;
import flash.media.SoundTransform;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class PlayMP3Command extends RemoteLocationCommand
	{
		public var url:String
		
		private var _loader:Loader;
		
		public function PlayMP3Command()
		{
			super();
		}
		
		override public function execute():void
		{
			trace("RECEIVED. " + url);
	/*	Global.musicVolume = 0;
		var urlReq:URLRequest = new URLRequest(url);
	    var sound:Sound = new Sound();
		var sndVol:Number = Global.soundVolume / 100;
		sound.load(urlReq);
		sound.play(0, 1, new SoundTransform(sndVol));*/
		Global.music.playSong(url);
		}
		
		private function onLoadComplete(e:Event):void
		{
	
		}
	
	}
}