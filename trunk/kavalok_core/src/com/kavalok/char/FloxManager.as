package com.kavalok.char
{
	/*
	Author: Maxym Hryniv & Jake Parker
	*/
	import com.kavalok.Global;
	import flash.events.*;
	import flash.system.Security;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.xml.*;
	import flash.utils.getQualifiedClassName;

	public class FloxManager
	{
		//private var loader:Loader = new Loader();
		private var url:URLRequest = new URLRequest("/flx.swf?");
		private var loadedSWF:Object = new Object();

		public function FloxManager()
		{
			Security.allowDomain('*');
			//trace("new floxmanager class instantiated");
			//loader.load(url);
			//loader.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
		}

		private function initHandler(e:Event):void
		{
			//loadedSWF = loader.content;
			trace("event is ready");
		}
		public function logIn():void
		{
			trace("event is logging in");
			//loadedSWF.initPlayer(Global.gameVersion);
			
		}

	}
}





