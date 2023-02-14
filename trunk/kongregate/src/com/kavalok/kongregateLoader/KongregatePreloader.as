package com.kavalok.kongregateLoader
{
	import com.kavalok.events.EventSender;
	import com.kavalok.flash.geom.Point;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.loaders.LocationLoaderView;
	import com.kavalok.loaders.ViewLoader;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.comparing.RequirementsCollection;
	import com.kongregate.as3.client.KongregateAPI;
	import com.kongregate.as3.client.events.KongregateEvent;
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;

	public class KongregatePreloader extends Sprite
	{
		private static const GUEST_NAME : String = "Guest";
		private static const SCREEN_HEIGHT : Number = 420;
		private static const SCREEN_WIDTH : Number = 700;
		private static const FILE_FORMAT : String = "http://alpha-static.s3.amazonaws.com/game/{0}.swf";
//		private static const FILE_FORMAT : String = "{0}.swf";
		
		private var _view : LocationLoaderView;
		private var _loader : ViewLoader;
		private var _api : KongregateAPI;
		private var _gameName : String;
		
		public function KongregatePreloader(gameName : String)
		{
			super();
			_gameName = gameName;
			EventSender;AddMoneyCommand;Point;RequirementsCollection;
			Security.allowDomain("www.kavalok.com");
			Security.allowDomain("www.chobots.com");
			Security.allowDomain("chat.kongregate.com");
			Security.allowDomain("kongregate.com");
			Security.allowDomain("s1.chobots.com");
			Security.allowDomain("alpha-static.s3.amazonaws.com");
			scaleX = SCREEN_WIDTH / KavalokConstants.SCREEN_WIDTH;
			scaleY = scaleX;
			this.y = (SCREEN_HEIGHT - KavalokConstants.SCREEN_HEIGHT * scaleX) / 2;

			
			_api = new KongregateAPI();
			_api.addEventListener(KongregateEvent.COMPLETE, onApiComplete);
			addChild(_api);
			
		}
		
		private function onApiComplete(event : KongregateEvent) : void
		{
			var url : String = Strings.substitute(FILE_FORMAT, _gameName);
			_view = new LocationLoaderView();
			addChild(_view.content);
			_loader = new ViewLoader(_view);
//			addChild(_loader);
			
			var context : LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
//			context.securityDomain = SecurityDomain.currentDomain;
			_loader.load(new URLRequest(url), context);
			
			_loader.completeEvent.addListener(onComplete);
		}
		
		private function onComplete() : void
		{
			
			removeChild(_view.content);
			_view = null;
//			removeChild(_loader);
			var name : String = _api.user.getName();
			var isGuest : Boolean = Strings.startsWidth(name, GUEST_NAME);
			if(isGuest)
				name = GUEST_NAME;
			Object(_loader.content).kongregateUser = {name : name, isGuest : isGuest};
			addChild(_loader.content);
		}
		
	}
}