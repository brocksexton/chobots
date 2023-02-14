package {
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharManager;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.modules.LocationModule;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.ServerService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;

	import com.kavalok.remoting.RemoteConnection;

	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;


	public class ServerSelect extends LocationModule
	{
		private static const CITIZENS_LIMIT : int = 50;

		private var _background : Background;
		private var _servers : Array;
		private var _limit : int;
		private var _lol:Boolean = false;

		public function ServerSelect()
		{

		}

		override public function initialize():void
		{
			_background = new Background();
			//	_background.maintenance.visible=false;
			addChild(_background);
			new ResourceScanner().apply(this);
			for(var i : uint = 0; i < _background.numChildren; i++)
			{
				var child : DisplayObject = _background.getChildAt(i);
				if(child is SimpleButton)
				{
					child.visible = false;
				}
			}
			Global.isLocked = true;
			new AdminService(onGetLimit).getServerLimit();

		}


		private function onGetLimit(result : int) : void
		{
			_limit = result;
			new ServerService(onGetServers).getServers();
		}
		private function onGetServers(result : Array) : void
		{
			Global.isLocked = false;
			_servers = result;
			readyEvent.sendEvent();

			MousePointer.resetIcon();

			for each(var server : Object in result)
			{
				var button : SimpleButton = _background[server.name];

				if(Global.testingMode)
				button.visible = false;
				else
				button.visible = true;
				var serverAvailable:Boolean = server.load < _limit || Global.superUser;
				GraphUtils.setBtnEnabled(button, serverAvailable);
				button.addEventListener(MouseEvent.CLICK, onServerClick);

				var states : Array = [button.upState, button.downState, button.overState];
				for each(var state : Sprite in states)
				{
					var bar : ProgressBar = ProgressBar(GraphUtils.findInstance(state, ProgressBar));
					bar.progress.height = bar.height * server.load / _limit;
				}
			}

		//	new AdminService(onGetCitizen).getIsCitizen();
			//Global.isLocked = true;
			/*if(Global.testingMode){
				var qr33:SimpleButton = _background["Serv7"];
				qr33.visible = true;
				serverAvailable = true;
				GraphUtils.setBtnEnabled(qr33, Global.testingMode);
				qr33.addEventListener(MouseEvent.CLICK, onServerClick);
			}*/
		}
		 /*
		private function onGetCitizen(result:Boolean):void
		{

			if(result){
				var qr33:SimpleButton = _background["Serv4"];
				qr33.visible = true;

				GraphUtils.setBtnEnabled(qr33, true);
				qr33.addEventListener(MouseEvent.CLICK, onServerClick);
				_lol = true;
			} else {
				var qr43:SimpleButton = _background["Serv4"];
				qr43.visible = true;

				GraphUtils.setBtnEnabled(qr43, false);
				//qr33.addEventListener(MouseEvent.CLICK, onServerClick);]
				_lol = false;
			}

			Global.isLocked = false;
		}
		*/

		private function onServerClick(event : MouseEvent) :void
		{
			var button : SimpleButton = SimpleButton(event.currentTarget);
			var server : Object = Arrays.firstByRequirement(_servers, new PropertyCompareRequirement("name", button.name));
			//	parameters.info.server = server.name;
			//	destroyEvent.sendEvent(this);

			if (button.name == "Serv6"){
				return;
				//	} else if (button.name == "Serv4" && _lol){
					//	parameters.info.server = "Serv4";
					//	destroyEvent.sendEvent(this);
						} else {
						parameters.info.server = server.name;
						destroyEvent.sendEvent(this);
						Global.buildNum = server.build;

						/*
						if (Global.buildNum != Global.gameVersion){
							//Global.isLocked = true;
							Dialogs.showOkDialog("Please restart your browser, a new version of Chobots has been released!", false);
							RemoteConnection.instance.disconnect();
						}
						*/

					}


				}

			}
		}
