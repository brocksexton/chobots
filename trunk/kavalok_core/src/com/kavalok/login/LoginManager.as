package com.kavalok.login
{
	import com.junkbyte.console.Cc;
	import com.kavalok.Global;
	import com.kavalok.StartupInfo;
	import com.kavalok.char.CharManager;
	import com.kavalok.constants.BrowserConstants;
	import com.kavalok.constants.Modules;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.dto.ServerPropertiesTO;
	import com.kavalok.dto.login.PartnerLoginCredentialsTO;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.messenger.commands.MessageBase;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.modules.ModuleEvents;
	import com.kavalok.remoting.BaseRed5Delegate;
	import com.kavalok.remoting.BaseDelegate;
	import com.kavalok.remoting.ConnectCommand;
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.services.LoginService;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.ServerService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.IdleManager;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.Timers;
	import com.kavalok.utils.GraphityUtil;
	
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	public class LoginManager
	{
		
		private var _info:StartupInfo;
		private var _autoLogin:Boolean;
		private var _server:String;
		private var _partnerUid:String;
		private var _connectCommand:ConnectCommand = new ConnectCommand();
		private var _logedIn:Boolean = false;
		private var _firstEnter:Boolean = true;
		private var _serverSelected:Boolean = false;
		private var _leServer:String;
		private var _leParameters:Object;
		private var _leLocation:String;
		
		private static var _idleManager:IdleManager;
		
		public function LoginManager()
		{
			_connectCommand.errorEvent.addListener(onConnectFault);
			//RemoteConnection.instance.forceDisconnectEvent.addListener(onDisconnect);
		//	RemoteConnection.instance.error.addListener(onError);
			
		}
		
		public function get logedIn():Boolean
		{
			return _logedIn;
		}
		
		public function get userLogin():String
		{
			return _info.login;
		}
		
		public function get server():String
		{
			return _server;
		}
		
		public function login(startupInfo:StartupInfo):void
		{
			_autoLogin = Boolean(startupInfo.login);
			_server = startupInfo.server;
			_info = startupInfo;
			_connectCommand.connectEvent.addListener(onConnectSuccess);
			BaseRed5Delegate.defaultConnectionUrl = Strings.substitute(RemoteConnection.CONNECTION_URL_FORMAT, startupInfo.url);
			BaseDelegate.defaultFaultHandler = onServiceFault;
			_connectCommand.execute();
		}
		
		public function chooseServerAuto():void
		{
			new LoginService(onGetMostLoadedServer).getMostLoadedServer(_info.prefix ? _info.moduleId : "loc3");
		}
		
		public function chooseServerManual():void
		{
			var events:ModuleEvents = Global.moduleManager.loadModule(Modules.SERVER_SELECT, {info: _info});
			events.destroyEvent.addListener(onServerSelect);
		}
		
		public function onGetMostLoadedServer(servername:String):void
		{
			if (servername)
			{
				changeServer(servername, _info.prefix ? _info.moduleId : "loc3");
			}
			else
			{
				var events:ModuleEvents = Global.moduleManager.loadModule(Modules.SERVER_SELECT, {info: _info});
				events.destroyEvent.addListener(onServerSelect);
			}
		}
		
		public function changeServer(server:String, location:String, parameters:Object = null):void
		{

			trace(server);
			Global.isLocked = true;

				_server = server;
				_info.moduleId = location;
				_info.moduleParams = parameters;
				_info.server = server;
				new ServerService(onGetServer).getServerAddress(server);
		
		}

		private function onGotCitizen(result:String):void
		{

				Global.isLocked = true;
				_server = _leServer;
				_info.moduleId = _leLocation;
				_info.moduleParams = _leParameters;
				_info.server = _leServer;
				new ServerService(onGetServer).getServerAddress(_leServer);
			
		}
		
		private function onGetServer(url:String):void
		{
			RemoteConnection.instance.disconnect();
			BaseRed5Delegate.defaultConnectionUrl = Strings.substitute(RemoteConnection.CONNECTION_URL_FORMAT, url);
			RemoteConnection.instance.forceDisconnectEvent.addListener(onDisconnect);
			_info.url = url;
			_serverSelected = true;
			login(_info);
		}
		
		
		private function onConnectSuccess():void
		{
			_connectCommand.connectEvent.removeListener(onConnectSuccess);
			new LoginService(onGetServerProperties).getServerProperties();
		}
		
		private function onGetServerProperties(result:ServerPropertiesTO):void
		{
			Global.serverProperties = result;
			doLogin();
		}
		
		private function doLogin():void
		{
			Global.isLocked = false;
			_partnerUid = Global.startupInfo.partnerUid;
			var service:LoginService = new LoginService(onLoginSuccess, onLoginFault);
			
			Global.userName = _info.login;
			if (_info.prefix)
			{
				if (!_serverSelected)
				{
					///if (Global.testingMode)
					   // changeServer("Serv7", "loc3");

					 if (Global.charManager.age <= 10)
						
						chooseServerManual();
					else
						chooseServerManual();
				}
				//else
				//	service.freeLoginByPrefix(_info.prefix);
			}
			else if (_info.login)
			{
				if (_autoLogin)
				service.freeLogin(_info.login, CharManager.DEFAULT_BODY, 0, Localiztion.locale, _info.password);
				else
					service.login(_info.login, _info.password, Localiztion.locale);
			}
			else if (_partnerUid)
			{
				new LoginService(onGetPartnerCredentials, onLoginFault).getPartnerLoginInfo(_partnerUid);
			}
			else if (_info.moduleId)
			{
				if (Global.moduleManager.loading)
					Global.moduleManager.abortLoading();
				Global.moduleManager.loadModule(_info.moduleId, {info: _info});
			}
			else
			{
				if (Global.moduleManager.loading)
					Global.moduleManager.abortLoading();
				var events:ModuleEvents = Global.moduleManager.loadModule(Modules.LOGIN, {info: _info});
				events.destroyEvent.addListener(onGuiLogin);
			}
				//}
		}
		
		private function onServerSelect(module:ModuleBase):void
		{
			changeServer(_info.server, _info.moduleId);
		}
		
		private function processLogin():void
		{
			new LoginService(onLoginSuccess, onLoginFault).login(_info.login, _info.password, Localiztion.locale);
		}
		
		private function onGuiLogin(module:ModuleBase):void
		{
			_logedIn = true;
			//if (Global.testingMode)
			//		    changeServer("Serv7", "loc3");
			 if (Global.charManager.age <= 10)
				//chooseServerAuto();
				chooseServerManual();
			else
				chooseServerManual();
				//chooseServerAuto();
		}
		
		private function onGetPartnerCredentials(result:PartnerLoginCredentialsTO):void
		{
			if (!result.needRegistartion)
			{
				_info.login = result.login;
				Global.partnerUserId = result.userId;
				chooseServerManual();
			}
			else
			{
				var moduleParameters:Object = {info: _info, mode: LoginModes.REGISTER_FROM_PARTNER, partnerUid: _partnerUid}
				var events:ModuleEvents = Global.moduleManager.loadModule(Modules.LOGIN, moduleParameters);
				events.destroyEvent.addListener(onGuiLogin);
			}
		}
		private function onServiceFault(fault : Object) : void
		{
			//Dialogs.showOkDialog("Service call error " + fault.description)
			ExternalInterface.call("console.log", "Service call error " + fault.description);
		}
		private function onLoginSuccess(result:String):void
		{
			_logedIn = true;
			if (_info.prefix)
				_info.login = result;
			
			initChar();
			
			if (_firstEnter)
			{
				_firstEnter = false;
				checkPlayerVersion();
			}
		
			//must be called cause securityKey will be loaded
		}
		
		private function onLoginFault(result:Object):void
		{
			Dialogs.showOkDialog("Login fault :" + _info.login + ". Try to clear out your browser cache. If it doesn't work, contact support.");
		}
		
		private function initChar():void
		{
			Global.isLocked = true;
			Global.charManager.readyEvent.addListener(onCharReady);
			Global.charManager.initialize();
		}
		
		private function onCharReady():void
		{
			if (_idleManager == null)
			{
				_idleManager = new IdleManager();
				_idleManager.start();
			}
			Global.charManager.readyEvent.removeListener(onCharReady);
			Global.isLocked = false;
			Global.frame.initialize();
			Global.charManager.stuffs.processStuffCommands();
			Global.borderContainer.addChild(Global.frame.content);
			createLocation();
		}
		
		public function createLocation():void
		{
			var moduleId:String;
			var params:Object;
			
			if (_info.moduleId)
			{
				moduleId = _info.moduleId;
				params = _info.moduleParams;
			}
			else if (Global.charManager.firstLogin)
			{
				moduleId = Arrays.randomItem(KavalokConstants.STARTUP_LOCS);
			}
			else
			{
				moduleId = Modules.MAP;
				params = {closeDisabled: true};
			}
			
			Global.moduleManager.loadModule(moduleId, params);
			new GraphityUtil().loadGraphity();
		}
		
		private function checkPlayerVersion():void
		{
			var version:String = Capabilities.version;
			var str1:String = version.split(' ')[1];
			var majorNum:String = str1.split(',')[0];
			
			if (majorNum == '9')
			{
				var text:String = Strings.substitute(Global.messages.updateFlashPlayer, '<u><a target="_blank" href="http://get.adobe.com/flashplayer/">http://get.adobe.com/flashplayer/</a></u>');
				var message:MessageBase = new MessageBase();
				message.sender = Global.messages.chobotsTeam;
				message.text = text;
				Global.inbox.addMessage(message);
			}
		}
		
		private function onConnectFault(event:NetStatusEvent):void
		{
			showError(event.info);
		}
		
		private function onDisconnect():void
		{
			showError();
		}
		
		private function onError(fault : NetStatusEvent):void
		{
			Dialogs.showOkDialog("error " + fault.info.description);
		}
		private static function traceServiceError(info:Object):void
		{
			trace('Service error:');
			for (var prop:String in info)
			{
				trace(prop, info[prop]);
			}
		}
		
		private static function parseDataFromStackTrace(stackTrace:String):Object
		{
			//extract function name from the stack trace
			var parsedDataObj:Object = {fileName: "", packageName: "", className: "", functionName: ""};
			var nameResults:Array;
			//extract the package from the class name
			var matchExpression:RegExp;
			var isFileNameFound:Boolean;
			//if running in debugger you are going to remove that data
			var removeDebuggerData:RegExp;
			removeDebuggerData = /\[.*?\]/msgi;
			stackTrace = stackTrace.replace(removeDebuggerData, "");
			//remove the Error message at the top of the stack trace
			var removeTop:RegExp;
			removeTop = /^Error.*?at\s/msi;
			stackTrace = stackTrace.replace(removeTop, "");
			stackTrace = "at " + stackTrace;
			//get file name
			matchExpression = /(at\s)*(.*?)_fla::/i;
			nameResults = stackTrace.match(matchExpression);
			if (nameResults != null && nameResults.length > 2)
			{
				parsedDataObj.fileName = nameResults[2];
				parsedDataObj.fileName = parsedDataObj.fileName.replace(/^\s*at\s/i, "") + ".fla";
				isFileNameFound = true;
			}
			//match timeline data
			matchExpression = /^at\s(.*?)::(.*?)\/(.*?)::(.*?)\(\)/i;
			nameResults = stackTrace.match(matchExpression);
			
			if (nameResults != null && nameResults.length > 4)
			{
				if (!isFileNameFound)
				{
					parsedDataObj.fileName = String(nameResults[1]).replace(/_fla$/i, ".fla");
					parsedDataObj.fileName = parsedDataObj.fileName.replace(/^at\s/i, "");
				}
				parsedDataObj.packageName = String(nameResults[1]);
				parsedDataObj.className = String(nameResults[2]);
				parsedDataObj.functionName = String(nameResults[4]);
			}
			else
			{
				//match function in a class of format com.package::SomeClass/somefunction()
				matchExpression = /^at\s(.*?)::(.*?)\/(.*?)\(\)/i;
				nameResults = stackTrace.match(matchExpression);
				if (nameResults != null && nameResults.length > 3)
				{
					if (!isFileNameFound)
					{
						parsedDataObj.fileName = String(nameResults[2]) + ".as";
					}
					parsedDataObj.packageName = nameResults[1];
					parsedDataObj.className = nameResults[2];
					parsedDataObj.functionName = String(nameResults[3]);
				}
				else
				{
					//match a contructor with $iinit
					matchExpression = /^at\s(.*?)::(.*?)\$(.*?)\(\)/i;
					nameResults = stackTrace.match(matchExpression);
					if (nameResults != null && nameResults.length > 3)
					{
						if (!isFileNameFound)
						{
							parsedDataObj.fileName = String(nameResults[2]) + ".as";
						}
						parsedDataObj.packageName = String(nameResults[1]);
						parsedDataObj.className = String(nameResults[2]);
						parsedDataObj.functionName = String(nameResults[2]);
					}
					else
					{
						//match a contructor that looks like this com.package::SomeClassConstructor()
						matchExpression = /^at\s(.*?)::(.*?)\(\)/i;
						nameResults = stackTrace.match(matchExpression);
						if (nameResults != null && nameResults.length > 2)
						{
							if (!isFileNameFound)
							{
								parsedDataObj.fileName = String(nameResults[2]) + ".as";
							}
							parsedDataObj.packageName = String(nameResults[1]);
							parsedDataObj.className = String(nameResults[2]);
							parsedDataObj.functionName = String(nameResults[2]);
						}
						else
						{
							//can't find a match - this is a catch all, you never know, 
							//if you find situations where this does not work please , 
							//post the solution in the comments.
							if (!isFileNameFound)
							{
								parsedDataObj.fileName = "NO_DATA";
							}
							parsedDataObj.packageName = "NO_DATA";
							parsedDataObj.className = "NO_DATA";
							parsedDataObj.functionName = "NO_DATA";
						}
					}
				}
			}
			return parsedDataObj;
		}
		
		public static function showError(info:Object = null):void
		{
			
			var locMess:String = Global.resourceBundles.kavalok.messages.connectionErrorRedirect;
			var message:String = locMess ? locMess : "Connection error. You will be redirected to Chobots homepage in a few seconds";
			trace("Connection error info: " + info);
			traceServiceError(info);
			Dialogs.showErrorDialog();
			//Dialogs.showOkDialog("Connection error. You will be redirected to the Chobots homepage in a few seconds.", false);
			if(Global.startupInfo.url.indexOf("s2.kavalok.net") != -1)
			Timers.callAfter(doRedirect, 15000);
			//first thing that needs to be done is an error needs to be thrown,
			//this will give you a stack trace for the place where the error was thrown.
			var parsedData:Object;
			var stackTrace:String;

			//here is where the error is artificialy  thrown,
			try
			{
				throw new Error("");
			}
			catch (e:Error)
			{
				stackTrace = e.getStackTrace();
			}
			parsedData = parseDataFromStackTrace(stackTrace);
			trace("stackTrace: " + stackTrace);
			trace("fileName : " + parsedData.fileName);
			trace("packageName : " + parsedData.packageName);
			trace("className : " + parsedData.className);
			trace("functionName : " + parsedData.functionName);
			
		//	Dialogs.showOkDialog(locMess, false);
		
		}
		
		private static function doRedirect():void
		{
			var si:StartupInfo = Global.startupInfo;
			var redirectURL:String;
			if (si)
				redirectURL = si.redirectURL;
			else if (ExternalInterface.available)
				ExternalInterface.call("document.location.reload()");
			if (redirectURL)
				navigateToURL(new URLRequest("http://chobotsuniverse.com/"), BrowserConstants.SELF);
		}
	}
}

