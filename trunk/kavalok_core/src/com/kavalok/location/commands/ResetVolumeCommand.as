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
	
	public class ResetVolumeCommand extends RemoteLocationCommand
	{
		public var url:Number;
		
		private var _loader:Loader;
		
		public function ResetVolumeCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if(Global.lockMusic == false){
		Global.musicVolume=url;
		Global.music.volume=url/100;
	}
		}
		
		private function onLoadComplete(e:Event):void
		{
	
		}
	
	}
}