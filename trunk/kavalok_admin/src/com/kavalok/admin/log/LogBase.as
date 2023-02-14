package com.kavalok.admin.log
{
	import com.kavalok.admin.log.data.AdminRemoteObject;
	import com.kavalok.admin.messages.events.ProcessedEvent;
	import com.kavalok.admin.log.data.BadMessage;
	import com.kavalok.admin.log.data.UserChatDataProvider;
	import com.kavalok.admin.log.data.UserModDataProvider;
	import com.kavalok.admin.log.data.UserDataProvider;
	import com.kavalok.admin.log.data.UserMessage;
	import com.kavalok.admin.log.data.UserReport;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LogService;
	
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
		import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Alert;
	import mx.controls.Label;
	import flash.events.MouseEvent;
		import mx.controls.TextArea;
	
	import org.goverla.controls.SizableTextArea;
	
	import org.goverla.collections.ArrayList;
	
	[Event(name="showFamily", type="com.kavalok.admin.users.events.ShowFamilyEvent")]
	public class LogBase extends HBox
	{
		private static const MAX_MESSAGES_COUNT : int = 500;
		
		[Bindable]
		public var dataGrid : DataGrid;
		[Bindable]
		public var dataGridL : DataGrid;
		[Bindable]
		public var modActionText : TextArea;
		[Bindable]
		public var onlineMods:Label;
		[Bindable]
		protected var dataProv : UserModDataProvider = new UserModDataProvider();
		[Bindable]
		protected var textFactory : ClassFactory = new ClassFactory(SizableTextArea);
		[Bindable]
		public var dataGridMod : DataGrid;
		[Bindable]
		public var permissionLevel : int;

		[Bindable]
		protected var userDataProvider : UserDataProvider = new UserDataProvider();
		[Bindable]
		protected var userChatDataProvider : UserChatDataProvider = new UserChatDataProvider();
		[Bindable]
		protected var userModDataProvider : UserModDataProvider = new UserModDataProvider();

		[Bindable]
		protected var messages : ArrayList = new ArrayList();
		[Bindable]
		protected var messagesMod : ArrayList = new ArrayList();
	
		[Bindable]
		protected var scrollable : Boolean = true;
		[Bindable]
		protected var scrollableb : Boolean = true;
			[Bindable]
		protected var scrollablec : Boolean = true;
		
		private var _remoteObject : AdminRemoteObject = new AdminRemoteObject();
		
		private var _leUserID : int;

		private var _methods : Object = {};
				private var timer:Timer;
		
		public function LogBase()
		{
			super();
			_methods["[b]"] = "addBlockWord";
			_methods["[s]"] = "addSkipWord";
			_methods["[a]"] = "addAllowedWord";
			_methods["[r]"] = processReport;
			_remoteObject.reportEvent.addListener(onUserReport);
			_remoteObject.charMessageEvent.addListener(onCharMessage);
			_remoteObject.badWordEvent.addListener(onBadWord);
			_remoteObject.modActionEvent.addListener(onModAction);
			new AdminService(onLoad).getAdminID();
			
			new AdminService(onGetConn).getAdminConnected();
			textFactory.properties = {editable : false, verticalScrollPolicy:'on'};
			userModDataProvider.reload();
			timer = new Timer(10000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}

		private function onTimerComplete(e:TimerEvent):void
		{
			refreshOnline();
		}
		
		internal function onUserSelect(userId : int) : void
		{
			userChatDataProvider.reload(userId);
			userDataProvider.load(userId);
		}
		
		
		public function reloadData():void
		{
		  userModDataProvider.reload();
		}

		public function onGetConn(result:String):void
		{
			onlineMods.text = result.slice(0, -2);
		}
		

		public function refreshOnline(e:MouseEvent = null):void
		{
			new AdminService(onGetConn).getAdminConnected();
		}

		public function onModAction(action:Object):void
		{	
			modActionText.text += action.id + " (" + action.date + "): " + action.message + "\n";

			if(action.message == "Logged in")
			{
				refreshOnline();
			}

			if(scrollablec)
			modActionText.verticalScrollPosition = modActionText.maxVerticalScrollPosition;

		}
		
		private function processReport(reportId : int) : void
		{
			new AdminService().setReportProcessed(reportId);
			new LogService().adminLog("Processed report " + reportId, 1, "log");
		}
		private function onUserReport(message : UserReport) : void
		{
			message.message = message.message.replace(new RegExp(message.login, "gm"), "<b>" + message.login + "</b>");
			addMessage(message);
		}
		private function onBadWord(message : BadMessage) : void
		{
			addMessage(message);
			//refreshOnline();
		}
		private function onCharMessage(message : UserMessage) : void
		{
			addMessage(message);
		}
		
		private function onLoad(result : int) : void
		{
		  _leUserID = result;
		  userModDataProvider.reload();
		}
		

		private function addMessage(message : UserMessage) : void
		{
			messages.addLast(message);
			while(messages.length > MAX_MESSAGES_COUNT)
				messages.removeFirst();
			if(scrollable && dataGrid)
			{
				dataGrid.verticalScrollPosition = dataGrid.maxVerticalScrollPosition;
			}
		}
		
		
	}
}