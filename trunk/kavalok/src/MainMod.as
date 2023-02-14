package
{
	//{ imports region
	import com.kavalok.Global;
	import com.kavalok.char.CharManager;
	import com.kavalok.StartupInfo;
	import com.kavalok.utils.URLUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	import flash.text.TextField;

	import flash.external.ExternalInterface;

	//} imports region

	[SWF(width='900', height='510', backgroundColor='0x056699', framerate='30')]
	public class MainMod extends Sprite
	{
		
		public function MainMod()
		{
			super();
			Security.allowDomain('*');
			if (this.stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function traceInfo():void
		{
			trace(this);
			trace(this.loaderInfo.url);
			trace('[parameterInfo:]')
			for (var paramName:String in this.loaderInfo.parameters)
			{
				trace(paramName + ': ' + this.loaderInfo.parameters[paramName])
			}
		}
		
		private function initialize(e:Event = null):void
		{
			traceInfo();
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			var swfURL:String = loaderInfo.url.split('&')[0];
			
			var serverName:String = "secure.chobotsuniverse.com";
			
			var info:StartupInfo = new StartupInfo();
			info.prefix = loaderInfo.parameters.guest;

			//info.url = serverName + '/kavalok';
			
			
			info.url = "secure.chobotsuniverse.com/kavalok";
			
			var tf:TextField = new TextField();
			tf.text = info.url;
		//	addChild(tf);
			
			
		//	info.url = "rtmp://185.53.128.164/kavalok"
			info.locale = loaderInfo.parameters.locale;
			info.partnerUid = loaderInfo.parameters.partnerUid;
			info.homeURL = loaderInfo.parameters.homeURL;
			info.version = loaderInfo.parameters.version;
			info.moduleId = loaderInfo.parameters.moduleId;
			
			info.mppc_src = loaderInfo.parameters.mppc_src;
			info.mppc_cid = loaderInfo.parameters.mppc_cid;
			info.mppc_keywords = loaderInfo.parameters.mppc_keywords;
			info.mppc_referrer = loaderInfo.parameters.mppc_referrer;
			info.mppc_activationUrl = loaderInfo.parameters.mppc_activationUrl
			info.mppc_partner = loaderInfo.parameters.mppc_partner;
			
			if (loaderInfo.parameters.hasOwnProperty('scale'))
				Global.scale = loaderInfo.parameters.scale;
				
					if (loaderInfo.parameters.hasOwnProperty('mod'))
						Global.debugging = loaderInfo.parameters.mod;
			 
			Global.referer = loaderInfo.parameters.referer;
			
			var kavalok : Kavalok = new Kavalok(info, this);
		}
		
		private function getServerNameFromURL(url:String):String
		{
			return "secure.chobotsuniverse.com" 
		}

		public function getLocation(urlStr:String):String {
			var urlPattern:RegExp = new RegExp("(http|https)://(www|)(.*?\.(com|org|net))","i");
			var found:Object =  urlPattern.exec(urlStr);
			return found[3].toString();
		}

	}
}
