package com.kavalok.messenger.commands
{
	import com.kavalok.Global;
	import com.kavalok.utils.Strings;

	public class CitizenMembershipMessage extends MessageBase
	{

		public var expireDate:Date;
		public var extended:Boolean;
		public var months:int;
		public var days:int;
		public var tryMembership:Boolean;
		public var reason:String;

		public function CitizenMembershipMessage()
		{
			Global.resourceBundles.kavalok.registerMessage(this, "sender", "chobotsTeam");
		}

		override public function show():void
		{
			var month:String=expireDate.getMonth() + 1 < 10 ? "0" + (expireDate.getMonth() + 1) : "" + (expireDate.getMonth() + 1);

			var hours:String=expireDate.getHours() < 10 ? "0" + expireDate.getHours() : "" + expireDate.getHours();

			var mins:String=expireDate.getMinutes() < 10 ? "0" + expireDate.getMinutes() : "" + expireDate.getMinutes();

			var textToUse:String=Global.resourceBundles.kavalok.messages["monthMembershipBought" + months];
			var text:String;

			if (reason){
				if(days){
					textToUse=Global.resourceBundles.kavalok.messages["membershipPresentDays"];
					text=Strings.substitute(textToUse, expireDate.getDate(), month, expireDate.getFullYear(), hours, mins, days, reason);
				}else{
					textToUse=Global.resourceBundles.kavalok.messages["membershipPresentMonths"];
					text=Strings.substitute(textToUse, expireDate.getDate(), month, expireDate.getFullYear(), hours, mins, months, reason);
				}
			}else if (tryMembership)
			{
				textToUse=Global.resourceBundles.kavalok.messages["tryMembershipMessage"];
				text=Strings.substitute(textToUse, expireDate.getDate(), month, expireDate.getFullYear(), hours, mins, days);
			}
			else 
			{
				if (extended)
				{
					textToUse=Global.resourceBundles.kavalok.messages["monthMembershipExtended" + months];
				}
				text=Strings.substitute(textToUse, expireDate.getDate(), month, expireDate.getFullYear(), hours, mins);
			}
			showInfo(Global.messages.citizenshipMessageCaption, text);
		}
		
		override public function getIcon():Class
		{
			return McMsgCitizenIcon;
		}
		
		override public function execute():void
		{
			if (Global.frame.initialized)
			{
				if (tryMembership)
				{
					if (!(Global.charManager.isAgent || Global.charManager.isModerator))
					{
						Global.charManager.drawEnabled=false;
						Global.charManager.drawEnabledChangeEvent.sendEvent();
					}
				}

				Global.charManager.citizen=true;
				Global.charManager.citizenExpirationDate=expireDate;
				Global.charManager.refreshMoney();
				Global.frame.refreshStatus();
			}
			super.execute();
		}

	}
}

