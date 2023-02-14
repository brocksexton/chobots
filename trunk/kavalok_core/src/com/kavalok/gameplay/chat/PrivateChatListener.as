package com.kavalok.gameplay.chat
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.comparing.ClassRequirement;
	import com.kavalok.utils.comparing.PropertyCompareRequirement;
	import com.kavalok.utils.comparing.RequirementsCollection;
	
	public class PrivateChatListener
	{
		public function PrivateChatListener()
		{
		}
		
		public function initialize() : void
		{
			Global.notifications.receiveNotificationEvent.addListener(onReceiveNotification);
		}
		
		private function onReceiveNotification(notification : Notification) : void
		{
			if(notification.fromLogin != null && notification.toLogin == Global.charManager.charId)
			{
				var classReq : ClassRequirement = new ClassRequirement(PrivateChatMessage);
				var fromReq : PropertyCompareRequirement = new PropertyCompareRequirement("sender", notification.fromLogin);
				var req : RequirementsCollection = new RequirementsCollection();
				req.addItem(classReq);
				req.addItem(fromReq);
				if(!Arrays.containsByRequirement(Global.inbox.messages, req))
				{
					var message : PrivateChatMessage = new PrivateChatMessage(notification);
					message.execute();
				}
			}
		}

	}
}