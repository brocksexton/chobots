package com.kavalok.services
{
	import com.kavalok.remoting.RemoteConnection;

	public class CharService extends Red5ServiceBase
	{
		public function CharService(resultHandler:Function = null, faultHandler:Function = null)
		{
			super(resultHandler, faultHandler);
		}

		public function saveDance(value:String, index:int) : void
		{
			doCall("saveDance", arguments);
		}
		
		public function purchaseSeasonPass() : void
		{
			doCall("purchaseSeasonPass", arguments);
		}
		
		public function savePlayerCard(stuffId:int) : void
		{
			doCall("savePlayerCard", arguments);
		}

		public function addBestFriend(charId:int):void
		{
			doCall("addBestFriend", arguments);
		}

		public function sendAchievement(userId:int, type:String, message:String) : void
		{
			doCall("sendAchievement",arguments);
		}
		
		public function isBestFriend(charId:int):void
		{
			doCall("isBestFriend", arguments);
		}

		public function getTier() : void
		{
			doCall("getTier",arguments);
		}
		
		public function getCrowns() : void
		{
			doCall("getCrowns",arguments);
		}
		
		public function addCrowns(amount:int) : void
		{
			doCall("addCrowns",arguments);
		}
		
		public function addCheck(id:int, check:int, type:String) : void
		{
			doCall("addCheck",arguments);
		}

		public function removeBestFriend(charId:int):void
		{
			doCall("removeBestFriend", arguments);
		}
		
		public function savePlayerCardColor(colorName:String) : void
		{
			doCall("savePlayerCardColor", arguments);
		}
		public function saveSettings(musicVolume:int, soundVolume:int,
			acceptRequests:Boolean, acceptNight:Boolean, showTips:Boolean, showCharNames : Boolean, publicLocation : Boolean, uiColler:int, defaultFrame:Boolean):void
		{
			doCall("saveSettings", arguments);
		}
		public function refreshStuffs(charName:String) : void
		{
		    doCall("refreshStuffs", arguments);
		}
		public function getMoneyReport() : void
		{
			doCall("getMoneyReport", arguments);
		}
		public function setLocale(locale:String) : void
		{
			doCall("setLocale", arguments);
		}
		
		public function getCharViewLogin(login:String) : void
		{
			doCall("getCharViewLogin", arguments);
		}

		public function getCharView(userId:int) : void
		{
			doCall("getCharView", arguments);
		}
		
		public function saveOutfits(outfit:String) : void
		{
			doCall("saveOutfits", arguments);
		}
		
		public function getFamilyInfo():void
		{
			doCall("getFamilyInfo", arguments);
		}	
		
		public function getCharStuffs() : void
		{
			doCall("getCharStuffs", arguments);
		}	
		
		public function saveCharStuffs(clothes : Array) : void
		{
			doCall("saveCharStuffs", arguments);
		}
		
		public function getCheck1() : void
		{
			doCall("getCheck1",arguments);
		}
		
		public function getCheck2() : void
		{
			doCall("getCheck2",arguments);
		}
		
		public function getCheck3() : void
		{
			doCall("getCheck3",arguments);
		}
		
		public function saveCharBody(body: String, color:int) : void
		{
			doCall("saveCharBody", arguments);
		}

		public function saveCharBodyNormal(body:String, color:int):void
		{
			doCall("saveCharBodyNormal", arguments);
		}
		
		public function saveBodyPanel(body: String, color:int, charId:String) : void
		{
			doCall("saveBodyPanel", arguments);
		}
		
		public function setGender(gender : String) : void
		{
			doCall("setGender", arguments);
		}
		
		public function C(money : int) : void
		{
			doCall("setMoney", arguments);
		}
		
		public function cS(candy:int):void
		{
			doCall("setCandy", arguments);
		}
		public function rC(candy:int):void
		{
			doCall("removeCandy", arguments);
		}
			
		public function setChatColor(chatColor : String, charName : String) : void
		{
			doCall("setChatColor", arguments);
		}
		
		public function setEmail(userId : int, email : String) : void
		{
			doCall("setEmail", arguments);
		}
		
		public function getCharHome(userId : int) : void
		{
			doCall("getCharHome", arguments);
		} 
//		public function getCharNames() : void
//		{
//			doCall("getCharNames", arguments);
//		}
	
		public function gK() : void
		{
			doCall("gK", arguments);
		}
		
		public function getCharBody() : void
		{
		  doCall("getCharBody", arguments);
		}
		
		public function checkChallenge(userId:int, check:int, type:String) : void
		{
			doCall("checkChallenge",arguments);
		}
		
		public function saveBodyPanelToDefault(color : int, charId : String) : void
		{
		  doCall("saveBodyPanelToDefault", arguments);
		}
		
		public function setChatColorToDefault(charId : String) : void
		{
		   doCall("setChatColorToDefault", arguments);
		}
		
		public function savePlayerCardColorDefault() : void
		{
		   doCall("savePlayerCardColorDefault", arguments);
		}
		public function enterGame(charName : String, pass:String) : void
		{
			doCall("enterGame", arguments);
		}
		
		public function getCharFriends():void
		{
			doCall("getCharFriends", arguments);
		}
		
		public function getCharMoney():void
		{
			doCall("getCharMoney", arguments);
		}

		public function getCharEmeralds():void
		{
			doCall("getCharEmeralds", arguments);
		}
		
		public function getCharSpin() : void
		{
			doCall("getCharSpin",arguments);
		}
		
		public function getCharGender():void
		{
			doCall("getCharGender", arguments);
		}
		public function getCharChatColor():void
		{
			doCall("getCharChatColor", arguments);
		}

		public function setCharFriend(friendId:int):void
		{
			doCall("setCharFriend", arguments);
		}
		
		public function addToBuddyList(mainID:int, otherID:int):void
		{
		   doCall("addToBuddyList", arguments);
		}
		
		public function removeCharFriends(friendsList:Array):void
		{
			doCall("removeCharFriends", arguments);
		}
		
		public function getIgnoreList():void
		{
			doCall("getIgnoreList", arguments);
		}
		
		public function setIgnoreChar(userId:int):void
		{
			doCall("setIgnoreChar", arguments);
		}

		public function removeIgnoreChar(userId:int):void
		{
			doCall("removeIgnoreChar", arguments);
		}
		public function makePresent(userId:int, stuffId:int):void
		{
			doCall("makePresent", arguments);
		}
		
		public function setUserInfo(userId:int, enabled:Boolean,
				chatEnabledByParent:Boolean, isParent:Boolean):void
		{
			doCall("setUserInfo", arguments);
		}
		
		public function getRobotTeam():void
		{
			doCall("getRobotTeam", arguments);
		}

		public function getCrew():void
		{
			doCall("getCrew", arguments);
		}
		
		public function getLastOnlineDay(userId:int):void
		{
			doCall("getLastOnlineDay", arguments);
		}
		
		public function processBonusBugs():void
		{
			trace("calling pBb");
			doCall("pBb", arguments); // processBonusBugs
			//doCall("pBbe", arguments);
		}
		
		public function getSessionTime(userId:int, date:Date):void
		{
			var date1:Date = new Date();
			date1.setDate(date.getDate());
			date1.hours = 0;
			date1.minutes = 0
			date1.seconds = 0;
			date1.milliseconds = 0;
			
			var date2:Date = new Date();
			date2.setDate(date1.getDate() + 1);
			date2.hours = 0;
			date2.minutes = 0
			date2.seconds = 0;
			date2.milliseconds = 0;
			
			doCall("getSessionTime", [userId, date1, date2]);
		}
	}
}