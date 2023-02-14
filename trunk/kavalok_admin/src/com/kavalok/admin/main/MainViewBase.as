package com.kavalok.admin.main
{
	import com.kavalok.admin.login.Login;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.login.AuthenticationManager;
	import com.kavalok.remoting.BaseDelegate;
	import com.kavalok.remoting.BaseRed5Delegate;
	import com.kavalok.remoting.RemoteConnection;
	
	import flash.events.NetStatusEvent;
	
	import mx.containers.ViewStack;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import flash.events.Event;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;
	
	import org.goverla.errors.NotImplementedError;

	public class MainViewBase extends ViewStack
	{
		static public const LOGIN_URL_FORMAT:String
			= RemoteConnection.CONNECTION_URL_FORMAT + "/kavalok";
			
		public var login : Login;
		
		public function MainViewBase()
		{
			super();
			Localiztion.locale = "enUS";
			Localiztion.getBundle(ResourceBundles.SERVER_SELECT);
			Localiztion.getBundle(ResourceBundles.KAVALOK);
			BaseDelegate.defaultFaultHandler = onServiceFault;
		}
		
		protected function onCreationComplete(event : FlexEvent) : void
		{
			var numberString:String = Application.application.parameters["hash"];
			var host:String = URLUtil.getServerName(Application.application.url);
			BaseRed5Delegate.defaultConnectionUrl = StringUtil.substitute(
				LOGIN_URL_FORMAT, "game.chobots.world");
			BaseDelegate.defaultFaultHandler = onServiceFault;
			
			RemoteConnection.instance.setHash = numberString;
			RemoteConnection.instance.isAdmin = true;
			RemoteConnection.instance.connectEvent.addListener(onConnect);
			RemoteConnection.instance.error.addListener(onError);
			RemoteConnection.instance.disconnectEvent.addListener(onDisconnect);
			
			RemoteConnection.instance.connect();
		}
		
		protected function onConnect() : void
		{
			login.visible = true;
			login.login.addListener(onTryLogin);
		}
		public function tryLogin(login : String, pass : String) : void
		{
			throw new NotImplementedError("abstract method must be implemented in superclass");
		}
		protected function onTryLogin(args : Array) : void
		{
			tryLogin(args[0], args[1]);
		}
		protected function onLoginFault(fault : Object = null) : void
		{
			Alert.show("Login error please try one more time");
		}
		protected function onLoginResult(result : String) : void
		{
			if(result == AuthenticationManager.SUCCESS)
			{
				selectedIndex = 1;
			}
			else
			{
				onLoginFault();
			}
		}
		private function onError(fault : NetStatusEvent) : void
		{
			Alert.show("Connection error " + fault.info.description);
		}
		private function onDisconnect() : void
		{
			Alert.show("Disconnect");
		}
		private function onServiceFault(fault : Object) : void
		{
			Alert.show("Service call error " + fault.description);
		}
	}
}