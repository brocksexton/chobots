package com.kavalok.gameplay.infoPanel
{
	import com.kavalok.gameplay.StarField;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.GraphUtils;
	import flash.display.Loader;
	import com.kavalok.utils.SpriteTweaner;
	import flash.net.URLRequest;
	import flash.system.Security;
	import com.kavalok.services.AdminService;
	    import flash.system.ApplicationDomain; 
	
	import core.McStar;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	
	public class AgentSpy extends ClientBase
	{
		static public const PREFIX:String = 'agent_loader';
		static public const PANEL_ID:String = 'agentLoader'
		static public const DATA_STATE:String = 'dataState'
		static public const STARS_SPEED:int = 3;
		
		private var _display:Sprite;
		private var dfEer:Loader = new Loader();
		private var _mask:DisplayObject;
		private var _content:InfoContent;
		private var _stars:StarField;
		private var _r25s:ApplicationDomain;
		private var _contentData:XML;
		private var _altAcc:String;
		
		public function AgentSpy(display:Sprite)
		{
			
			new AdminService(onGetAlternative).getAltAcc();
			Security.allowDomain('*');
			_display = display;
			_mask = _display.getChildAt(0);
			_display.mask = _mask;
		_display.addChild(dfEer);
			
		}
		
		private function onGetAlternative(charName:String):void
		{
			
	

			trace("GOT ALTERNATIVE....");
			if(charName){
			_altAcc = charName;
					dfEer.load(new URLRequest("http://chobots.net/game/Main.swf"));

					dfEer.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoaded);
		}	else{
			return;
			}
					}
					
				private	function onSwfLoaded(e:Event):void
					{
						var lol:DisplayObject = _display.getChildAt(1);

						var mw:Number = 409.15;
						var mh:Number = 243.50;
						lol.width = mw;
						lol.height = mh;
						_display.removeChild(dfEer);
						_display.addChild(dfEer);

						_r25s = LoaderInfo(e.target).applicationDomain;
						cutey.startupInfo.login = _altAcc;
						cutey.startupInfo.moduleId = "loc3";
						cutey.isAgentGuest = true;
						
					}

		
		override public function get id():String
		{
			return PANEL_ID;
		}
		
	private	function get cutey():Object
		{
			return getAClass("com.kavalok.Global");
		}

	public	function getAClass(fullName:String):Class
		{
			return Class(_r25s.getDefinition(fullName));
		}
	}
}