package com.kavalok.services
{
	import com.junkbyte.console.Cc;
	import com.kavalok.dto.UserTO;
	import com.kavalok.messenger.commands.MailMessage;
	import com.kavalok.remoting.RemoteCommand;

 // console
	
	public class AdminService extends Red5ServiceBase
	{
		public function AdminService(resultHandler:Function=null, faultHandler:Function=null)
		{
			super(resultHandler, faultHandler);
		}
		
/*	public function sendMail(subject : String , text : String , locales : Array) : void
	{
		doCall("sendMail", arguments);
	}*/
		
		public function flushChatWordCaches():void 
		{
			doCall("fcc", arguments);
		}

		public function getStuffGroupNum():void
		{
			doCall("getStuffGroupNum", arguments);
		}
		public function getChallenges():void		
			{
				doCall("getChallenges", arguments);
			}

		public function saveChallenges(date1:String, date2:String, date3:String, date4:String, event1:String, event2:String, event3:String, event4:String, image1:String, image2:String, image3:String, image4:String, featured:String):void
		{
			doCall("saveChallenges", arguments);
		}

		public function sendNotification(notify:String):void
		{
			doCall("sendNotification", arguments);
		}

		public function getAdminConnected():void
		{
			doCall("getAdminConnected", arguments);
		}

		public function saveStuffGroupNum(groupNum:int):void
		{
			doCall("saveStuffGroupNum", arguments);
		}

		public function setDirection(userName:String, modifierInfo:String):void
		{
			doCall("setDirection", arguments);
		}

		public function setDirectionGlobal(modifierInfo:String):void
		{
			doCall("setDirectionGlobal", arguments);
		}
		
		public function getAdminID():void
		{
		  doCall("getAdminID", arguments);
		}

		
		public function setModMessages(first:String, last:String):void
		{
		  doCall("setModMessages", arguments);
		}
	
		public function getServerLimit():void
		{
			doCall("getServerLimit", arguments);
		}
		public function setServerLimit():void
		{
			doCall("setServerLimit", arguments);
		}
		public function getPermissionLevel(login : String):void
		{
			doCall("getPermissionLevel", arguments);
		}

		public function getPanelName(login : String):void
		{
			doCall("getPanelName", arguments);
		}
			public function getMagic(login : String):void
			{
				doCall("getMagic", arguments);
			}
		public function moveUsers(fromId:int, toId:int):void
		{
			doCall("moveUsers", arguments);
		}
		public function setBanDate(userId : int, date:Date):void
		{
			doCall("setBanDate", arguments);
		}

		public function setDisableChatPeriod(userId : int, periodNumber:int):void
		{
			doCall("setDisableChatPeriod", arguments);
		}

		public function getGraphity(server:String, wallId:String):void
		{
			doCall("getGraphity", arguments);
		}

		public function clearGraphity(server:String, wallId:String):void
		{
			doCall("clearGraphity", arguments);
		}
		
		public function getSharedObjects() : void
		{
			doCall("getSharedObjects", arguments);
		}
		
		public function sendState(serverId:int, remoteId:String, clientId:String, method:String, stateName:String, state:Object):void
		{
			doCall("snSt", arguments);
		}

		public function removeState(serverId:int, remoteId:String, clientId:String, method:String, stateName:String):void
		{
			doCall("removeState", arguments);
		}
		
		public function sendLocationCommand(serverId:int, remoteId:String, command:RemoteCommand):void
		{
			doCall("sendLocationCommand", [serverId, remoteId, command.getProperties()]);
			Cc.info("sending location command: " + serverId + " loc: " + remoteId); 
		}
		
		public function getRainableStuffs():void
		{
			doCall("getRainableStuffs", arguments);
		}
		
		public function clearSharedObject(serverId : int, sharedObjectId : String) : void
		{
			doCall("cSO", arguments);
		}
		
		public function setReportsProcessed(userId : int) : void
		{
			doCall("setReportsProcessed", arguments);
		}
		
		public function setReportProcessed(reportId : int) : void
		{
			doCall("setReportProcessed", arguments);
		}
		
		public function getReports(firstResult : int, maxResults : int) : void
		{
			doCall("getReports", arguments);
		}

        public function serverMaintenance(drawingEnabled : Boolean ) : void
 		{
			doCall("serverMaintenance", arguments);
		}

		/*public function sendGlobalMessage(text : String) : void
		{
			doCall("sendGlobalMessage", arguments);
		}*/

		public function sendGlobalMessageToChobotsWorld(text : String, locales : Array) : void
        {
            doCall("sendGlobalMessageToChobotsWorld", arguments);
        }
 	
 		public function refreshBuild(force : Boolean):void
 		{
 			doCall("refreshBuild", arguments);
 		}


		public function sendCharMessage(userId : int, text : String) : void
		{
			doCall("sendCharMessage", arguments);
		}

		public function getAdminMessages(firstResult : uint, maxResults : uint) : void
		{
			doCall("getAdminMessages", arguments);
		}

		public function addMoney(userId : int , money : int, reason : String) : void {
			doCall("addMoney", arguments);
		}

		public function setMessageProcessed(id : int) : void {
			doCall("setMessageProcessed", arguments);
		}
		
		public function getConfig() : void {
			doCall("getConfig", arguments);
		}

		public function saveConfig(registrationEnabled : Boolean, guestEnabled:Boolean, adyenEnabled : Boolean, spamMessagesLimit : int, serverLimit : int, gameVersion : int, savedData:String) : void {
			doCall("saveConfig", arguments);
		}
	
		public function getWorldConfig() : void {
			doCall("getWorldConfig", arguments);
		}

		public function saveWorldConfig(safeModeEnabled : Boolean, drawingWallDisabled:Boolean) : void {
			doCall("saveWorldConfig", arguments);
		}

		public function reboot(serverName : String) : void
		{
			doCall("reboot", arguments);
		}

		public function moveWWW(serverName : String) : void
		{
			doCall("moveWWW", arguments);
		}
		
		public function saveUserData(userId : int, activated : Boolean, chatEnabled : Boolean,
			chatEnabledByParent : Boolean, agent:Boolean, baned:Boolean, drawEnabled:Boolean, artist:Boolean, status:String, pictureChat:Boolean) : void
		{
			doCall("saveUserData", arguments);
		}
		
		public function saveBadgeData(userId : int, agent:Boolean, moderator:Boolean, dev:Boolean, des:Boolean, staff:Boolean, suppport:Boolean, journalist:Boolean, scout:Boolean, forumer:Boolean) : void
		{
			doCall("saveBadgeData", arguments);
		}
		
		public function saveChatData(userId : int, selectedChat:String) : void
		{
			doCall("saveChatData", arguments);
		}
		
		public function addTwitterTokens(userId :int, accessToken : String, accessTokenSecret : String) : void
		{
		    doCall("addTwitterTokens", arguments);
	    }
		
		public function getTokens() : void
		{
		    doCall("getTokens", arguments);
		}


		public function saveCharInfo(userId : int, charInfo:String) : void
		{
			doCall("saveCharInfo", arguments);
		}

		public function saveUserBan(userId : int, baned:Boolean, banReason:String) : void
		{
			doCall("saveUserBan", arguments);
		}
		public function saveUserTimeBan(userId : int, baned:Boolean, banReason:String, until:Date) : void
		{
			doCall("saveUserTimeBan", arguments);
		}
		
		public function saveIPBan(ip: String, baned : Boolean, banReason : String) : void
		{
			doCall("saveIPBan", arguments);
		}
		
		public function getLastChatMessages(userId : int) : void
		{
			doCall("getLastChatMessages", arguments);
		}
		
		public function getModMessages(firstResult : uint, maxResults : uint) : void
		{
		  doCall("getModMessages", arguments);
		}
		
		public function getUser(userId : int) : void
		{
			doCall("getUser", arguments);
		}
		
		public function getUsers(serverId : int, filters : Array, firstResult : int, maxResults : int) : void
		{
			doCall("getUsers", arguments);
		}
		
		public function sendRules(userId : int) : void
		{
			doCall("sendRules", arguments);
		}
		
		public function superUser(userName : String) : void
		{
			doCall("superUser", arguments);
		}
		
		public function applyMod(userId : int, modInput : String) : void
		{
			doCall("applyMod", arguments);
		}
		
		public function applyModGlobal(modInput : String) : void
		{
			doCall("applyModGlobal", arguments);
		}
		
		public function removeAllMods(modInput : String) : void
		{
		   doCall("removeAllMods", arguments);
		}
	
		public function xfpe35(action : String) : void
		{
			doCall("xfpe35", arguments);
		}
	
		public function adminExperience(userId : int, experience : int) : void
		{
			doCall("adminExperience", arguments);
		}
		
		public function sendModMessage(userId: int, message : String) : void
		{
			doCall("sendModMessage", arguments);
		}
		public function kickOut(userId : int, baned : Boolean) : void
		{
			doCall("kickOut", arguments);
		}
		
		public function setMailServerAvailable(id : int, available : Boolean) : void
		{
			doCall("setMailServerAvailable", arguments);
		}
		
		public function getMailServers() : void
		{
			doCall("getMailServers", arguments);
		}
		
		public function setServerAvailable(id : int, available : Boolean) : void
		{
			doCall("setServerAvailable", arguments);
		}

		public function addCitizenship(userId : int, months : int, days : int, reason : String) : void
		{
			doCall("addCitizenship", arguments);
		}
		public function addStuff(userId : int, stuffTypeId : int, color : int, colorSec : int, reason : String) : void
		{
			doCall("addStuff", arguments);
		}

		public function deleteUser(userId : int) : void
		{
			doCall("deleteUser", arguments);
		}
		
		public function restoreUser(userId : int) : void
		{
			doCall("restoreUser", arguments);
		}
		
	}
}