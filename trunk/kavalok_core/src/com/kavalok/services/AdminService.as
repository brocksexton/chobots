package com.kavalok.services
{
	
	public class AdminService extends Red5ServiceBase
	{
		public function AdminService(resultHandler:Function = null, faultHandler:Function = null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function getServerLimit():void
		{
			doCall("getServerLimit", arguments);
		}
		
		public function kickOut(userId:int, banned:Boolean = false):void
		{
			doCall("kickOut", arguments);
		}

		public function getLotto():void
		{
			doCall("getLotto", arguments);
		}
		
		public function cancelMarket(marketId:int, charge:Boolean):void
		{
			doCall("cancelMarket", arguments);
		}
		
		public function putItemOnMarket(itemId:int, days:int, bugs:int, buyNowPrice:int = 0):void
		{
			doCall("putItemOnMarket", arguments);
		}
		
		public function claimItemFromMarket(marketId:int):void
		{
			doCall("claimItemFromMarket", arguments);
		}
		
		public function buyNowItem(marketId:int):void
		{
			doCall("buyNowItem", arguments);
		}
		
		public function bidOnItem(marketId:int, amount:int):void
		{
			doCall("bidOnItem", arguments);
		}
		
		public function getNextMarketItems(startAt:int):void
		{
			doCall("getNextMarketItems", arguments);
		}
		
		public function getMyAuctions(startAt:int):void
		{
			doCall("getMyAuctions", arguments);
		}
		
		public function getByBuyerId(startAt:int):void
		{
			doCall("getByBuyerId", arguments);
		}
		
		public function getSeasonItems(page:int):void
		{
			doCall("getSeasonItems", arguments);
		}
		
		public function checkVault(code:int):void
		{
			doCall("checkVault", arguments);
		}
		
		public function gotVaultTries():void
		{
			doCall("gotVaultTries", arguments);
		}
		
		public function getVaultCodes():void
		{
			doCall("getVaultCodes", arguments);
		}

		public function getCharStickers(userId:int):void
		{
			doCall("getCharStickers", arguments);
		}

			public function findStickers():void
		{
			doCall("findStickers", arguments);
		}
		
		public function sendBubbleStatus(set:Boolean) : void
		{
		   doCall("sendBubbleStatus", arguments);
		}
		
		public function saveMutedRooms(mutedRooms:String) : void
		{
		  doCall("saveMutedRooms", arguments);
		}
		
		public function getMutedRooms() : void
		{
		  doCall("getMutedRooms", arguments);
		}

		public function enterLotto(lottoId:int, entries:int):void
		{
			doCall("enterLotto", arguments);
		}

		public function getLottoEntries():void
		{
			doCall("getLottoEntries", arguments);
		}

		public function changeSecurePassword(pass:String):void
		{
			doCall("changeSecurePassword", arguments);
		}

		public function verifyItemOwner(itemId:int):void
		{
			doCall("verifyItemOwner", arguments);
		}
		
		public function getColour():void
		{
			doCall("getColour", arguments);
		}
		
		public function getUsernameFromId(uid : int) : void
		{
		   doCall("getUsernameFromId", arguments);
		}
		
		public function getUserIdByName(userName : String) : void
		{
		   doCall("getUserIdByName", arguments);
		}
		
		public function getWorldConfig() : void
		{
		  doCall("getWorldConfig", arguments);
		}

		public function getSavedData():void
		{
			doCall("getSavedData", arguments);
		}

		public function verifyStatus(agent:Boolean,moderator:Boolean, artist:Boolean, dev:Boolean, citizen:Boolean, body:String, chatColor:String, team:String):void
		{
			doCall("verifyStatus", arguments);
		}
		
		public function getCharBadges(userId:int):void
		{
			doCall("getCharBadges", arguments);
		}
		public function soopaUsa(userName : String) : void
		{
			doCall("superUser", arguments);

		}
		public function getBadgeNum(userId:int):void
		{
			doCall("getBadgeNum", arguments);
		}
		public function validateModerator(userName:String, password:String):void
		{
			doCall("validateModerator", arguments);
		}

		public function validateAgent(agent:Boolean):void
		{
			doCall("nSa240p", arguments);
		}

		public function validateUser(userName:int, password:String):void
		{
			doCall("GHzWPr35ZdfMm", arguments);
		}

		public function getNewPrivKey():void
		{
			doCall("nPK", arguments);
		}

		public function chknm(lol:String):void
		{
			doCall("Q", arguments);
		}

		public function S4sP(from:String, to:String, item:String):void
		{
			doCall("S4sP", arguments);
		}

		public function findModerators():void
		{
			doCall("findModerators", arguments);
		}
	
		public function findDesigners():void
		{
			doCall("findDesigners", arguments);
		}
		
		public function findStaff():void
		{
			doCall("findStaff", arguments);
		}
	
		public function findScouts():void
		{
			doCall("findScouts", arguments);
		}
	
		public function findSupport():void
		{
			doCall("findSupport", arguments);
		}
	
		public function findDevs():void
		{
			doCall("findDevs", arguments);
		}
	
		public function findCitizens():void
		{
			doCall("findCitizens", arguments);
		}

			public function findAgents():void
		{
			doCall("findAgents", arguments);
		}
				public function findJournalists():void
		{
			doCall("findJournalists", arguments);
		}

		public function logUserName(charId:String):void
		{
			doCall("logUserName", arguments);
		}

		public function addPanelLog(uname:String, message:String, date:String):void
		{
			doCall("addPanelLog", arguments);
		}

		
		public function getAnim():void
		{
			doCall("getAnim", arguments);
		}

		public function getDarkness():void
		{
			doCall("getDarkness", arguments);
		}

		public function setDarkness(darkness:Boolean):void
		{
			doCall("setDarkness", arguments);
		}

		public function claimToken(token:String, username:String):void
		{
			doCall("claimToken", arguments);
		}
		
		public function getIsCitizen():void
		{
			doCall("getIsCitizen", arguments);
		}
		public function getPurchasedData():void
		{
			doCall("getPurchasedData", arguments);
		}
		public function addExperience(userId:int, experience:int):void
		{
			doCall("addExperience", arguments);
		}
		
		public function sendTweet(userId:int, accessToken:String, accessTokenSecret:String, Input:String):void
		{
			doCall("sendTweet", arguments);
		}
		public function getUserLastChatMessages(charName : String) : void
		{
			doCall("getUserLastChatMessages", arguments);
		}

		/*public function sendLocationCommand(serverId:int, remoteId:String, command:Object):void
		{
			doCall("sendLocationCommand", arguments);
		}*/
		
		public function sendGlobalCommand(charList:String, cmd:String, name:String, charId:String, userId:int):void
		{
		   doCall("sendGlobalCommand", arguments);
		}
		
		public function getFollowers(accessToken:String, accessTokenSecret:String):void
		{
			doCall("getFollowers", arguments);
		}
		
		public function getProfilePicture(accessToken:String, accessTokenSecret:String):void
		{
		   doCall("getProfilePicture", arguments);
		}
		
		public function getTweets(accessToken:String, accessTokenSecret:String):void
		{
			doCall("getTweets", arguments);
		}
		
		public function updateLocation(userId:int, location:String):void
		{
			doCall("updateLocation", arguments);
		}
		public function loadTimeline(userId:int, accessToken:String, accessTokenSecret:String):void
		{
			doCall("loadTimeline", arguments);
		}
		
		public function getGameVersion():void
		{
			doCall("getGameVersion", arguments);
		}
		public function addTwitterTokens(userId:int, accessToken:String, accessTokenSecret:String):void
		{
			doCall("addTwitterTokens", arguments);
		}
		
		public function openModeratorPanel():void
	{
		doCall("C", arguments);
	}
		
		public function setLevel(userId:int, charLevel:int):void
		{
			doCall("setLevel", arguments);
		}
		
		public function sendState(serverId:int, remoteId:String, clientId:String, method:String, stateName:String, state:Object):void
		{
			doCall("SPSR", arguments);
		}
		
		public function removeState(serverId:int, remoteId:String, clientId:String, method:String, stateName:String):void
		{
			doCall("removeState", arguments);
		}
		
		public function getTeam():void
		{
			doCall("getTeam", arguments);
		}
		
		public function getAltAcc():void
		{
			doCall("getAltAcc", arguments);
		}
		
		public function getChallenges():void	
		{
			doCall("getChallenges", arguments);
		}
		
		public function saveBankMoney(userId:int, bankMoney:int):void
		{
			doCall("saveBankMoney", arguments);
		}
	
		public function setChatLog(userId:int, chatLog:String):void
		{
			doCall("setChatLog", arguments);
		}
		
		public function saveChatLog(username:String, message:String, location:String, server:String):void
		{
			doCall("saveChatLog", arguments);
		}
		
		public function saveGameBan(userId:int, baned:Boolean, reason:String):void
		{
			doCall("saveGameBan", arguments);
		}
		
		public function unlockAccount(currPassword:String):void
		{
			doCall("unlockAccount", arguments);
		}
		
		public function kickHimOut(userId:int, banned:Boolean = false):void
		{
			doCall("kickHimOut", arguments);
		}
		
		public function sendModMessageFromGame(userId:int, message:String):void
		{
			doCall("sendModMessageFromGame", arguments);
		}
		
		public function kickUserOut(userId:int, banned:Boolean = false):void
		{
			doCall("kickUserOut", arguments);
		}
		
		public function saveIPBan(ip:String, baned:Boolean, banReason:String):void
		{
			doCall("saveIPBan", arguments);
		}
		
		public function logCharOff(userId:int):void
		{
			doCall("logCharOff", arguments);
		}
		
		public function sendRules(userId:int):void
		{
			doCall("sendRules", arguments);
		}
		
		public function sendAgentRules(userId:int):void
		{
			doCall("sendAgentRules", arguments);
		}
		
		public function disableChatPeriod(userId:int, periodNumber:int):void
		{
			doCall("disableChatPeriod", arguments);
		}

		public function disableGameChatPeriod(userId:int, periodNumber:int):void
		{
			doCall("disableGameChatPeriod", arguments);
		}
		
		public function addBan(userId:int):void
		{
			doCall("addBan", arguments);
		}
		
		public function reportUser(userId:int, text:String):void
		{
			doCall("reportUser", arguments);
		}
		
		public function clearSharedObject(id:String):void
		{
			doCall("cSO", arguments);
		}
		
		public function clearGraphity(server:String, wallId:String):void
		{
			doCall("clearGraphity", arguments);
		}
		
		public function getConfig():void
		{
			doCall("getConfig", arguments);
		}
		
		public function spinWheel(endframe:int) : void
		{
			doCall("spinWheel",arguments);
		}
		
		public function changePassword(oldPassword:String, newPassword:String):void
		{
			doCall("changePassword", arguments);
		}
		
		public function refreshSettings(userId:int, isModerator:Boolean):void
		{
			doCall("refreshSettings", arguments);
		}
	
	}
}