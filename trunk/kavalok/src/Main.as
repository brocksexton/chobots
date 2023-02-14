package
{

	import com.junkbyte.console.Cc;
	import com.kavalok.Global;
	import com.kavalok.StartupInfo;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.remoting.commands.ShowTimelineTwitter;
	import com.kavalok.utils.URLUtil;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import flash.external.ExternalInterface;

	[SWF(width='900', height='510', backgroundColor='0x006699', framerate='24')]
	public class Main extends Sprite

	{
		public function Main()
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
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			var info:StartupInfo = new StartupInfo();
			if(loaderInfo.parameters.hasOwnProperty("secure"))
			{
				info.secure = loaderInfo.parameters.secure;
			}
			else
			{
				info.secure = "true";
			}
			
			info.prefix = loaderInfo.parameters.guest;
			info.url = 'game.kavalok.net/kavalok';
			info.locale = loaderInfo.parameters.locale;
			info.partnerUid = loaderInfo.parameters.partnerUid;
			info.homeURL = loaderInfo.parameters.homeURL;
			info.version = loaderInfo.parameters.version;
			info.moduleId = loaderInfo.parameters.moduleId;
			Global.allowCache = loaderInfo.parameters.mppc_pid;
			info.mppc_src = loaderInfo.parameters.mppc_src;
			info.mppc_cid = loaderInfo.parameters.mppc_cid;
			info.mppc_keywords = loaderInfo.parameters.mppc_keywords;
			info.mppc_referrer = loaderInfo.parameters.mppc_referrer;
			info.mppc_activationUrl = loaderInfo.parameters.mppc_activationUrl;
			info.mppc_partner = loaderInfo.parameters.mppc_partner;
			info.disableQualityAuto = loaderInfo.parameters.disableQualityAuto;
			info.hash = loaderInfo.parameters.hash;

			if (loaderInfo.parameters.hasOwnProperty('scale'))
				Global.scale = loaderInfo.parameters.scale;

			Global.referer = loaderInfo.parameters.referer;

			Cc.log("connecting to : " + info.url);

			Global.localSettings.pmClock = false;
			var kavalok : Kavalok = new Kavalok(info, this);

			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem(Global.gameVersion.toString(), false, false, true);
			var item2:ContextMenuItem = new ContextMenuItem(instanceName(), false, false, true);
			menu.customItems.push(item2);
			menu.customItems.push(item);
			this.contextMenu = menu;

			var t:ShowTimelineTwitter;
		}

		private function instanceName():String
		{
			return CONFIG::VERSION;
		}

	}
}
