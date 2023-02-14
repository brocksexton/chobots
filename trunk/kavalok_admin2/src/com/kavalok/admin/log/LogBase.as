package com.kavalok.admin.log
{
	import com.kavalok.admin.log.data.AdminRemoteObject;
	import com.kavalok.admin.log.data.BadMessage;
	import com.kavalok.admin.log.data.UserChatDataProvider;
	import com.kavalok.admin.log.data.UserDataProvider;
	import com.kavalok.admin.log.data.UserMessage;
	import com.kavalok.admin.log.data.UserReport;
	import com.kavalok.services.AdminService;
	
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	
	import org.goverla.collections.ArrayList;
	
	[Event(name="showFamily", type="com.kavalok.admin.users.events.ShowFamilyEvent")]
	public class LogBase extends HBox
	{
		private static const MAX_MESSAGES_COUNT : int = 500;
		
		[Bindable]
		public var dataGrid : DataGrid;
		[Bindable]
		public var permissionLevel : int;

		[Bindable]
		protected var userDataProvider : UserDataProvider = new UserDataProvider();
		[Bindable]
		protected var userChatDataProvider : UserChatDataProvider = new UserChatDataProvider();

		[Bindable]
		protected var messages : ArrayList = new ArrayList();
	
		[Bindable]
		protected var scrollable : Boolean = true;
		
		private var _remoteObject : AdminRemoteObject = new AdminRemoteObject();

		private var _methods : Object = {};
		
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
		}
		
		internal function onUserSelect(userId : int) : void
		{
			userChatDataProvider.reload(userId);
			userDataProvider.load(userId);
		}
		
		
		private function processReport(reportId : int) : void
		{
			new AdminService().setReportProcessed(reportId);
		}
		private function onUserReport(message : UserReport) : void
		{
			message.message = message.message.replace(new RegExp(message.login, "gm"), "<b>" + message.login + "</b>");
			addMessage(message);
		}
		private function onBadWord(message : BadMessage) : void
		{
			addMessage(message);
		}
		private function onCharMessage(message : UserMessage) : void
		{
			addMessage(message);
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