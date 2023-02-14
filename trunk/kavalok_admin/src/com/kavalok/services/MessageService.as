package com.kavalok.services
{
	import com.kavalok.remoting.RemoteCommand;
	
	public class MessageService extends Red5ServiceBase
	{
		public function MessageService(resultHandler:Function = null, faultHandler:Function = null)
		{
			super(resultHandler, faultHandler);
		}
		
		public function findAllowedWord(part : String, firstResult : int, maxResults : int): void
		{
			doCall("findAllowedWord", arguments);
		}
		public function findBlockWord(part : String, firstResult : int, maxResults : int): void
		{
			doCall("findBlockWord", arguments);
		}
		public function findSkipWord(part : String, firstResult : int, maxResults : int): void
		{
			doCall("findSkipWord", arguments);
		}
		public function findReviewWord(part : String, firstResult : int, maxResults : int): void
		{
			doCall("findReviewWord", arguments);
		}

		public function modAction(user:String, action:String, date:String):void
		{
			doCall("modAction", arguments);
		}

		public function removeAllowedWord(id : int): void
		{
			doCall("removeAllowedWord", arguments);
		}
		public function removeBlockWord(id : int): void
		{
			doCall("removeBlockWord", arguments);
		}
		public function removeSkipWord(id : int): void
		{
			doCall("removeSkipWord", arguments);
		}
		public function removeReviewWord(id : int): void
		{
			doCall("removeReviewWord", arguments);
		}
		public function addBlockWord(word : String): void
		{
			doCall("addBlockWord", arguments);
		}
		public function addSkipWord(word : String): void
		{
			doCall("addSkipWord", arguments);
		}

        public function processAdminMessage(messageId : uint) : void 
        {
            doCall("processAdminMessage", arguments);
        }
        public function sendAdminMessage(message : String, locales : Array) : void 
        {
            doCall("sendAdminMessage", arguments);
        }
		public function addAllowedWord(word : String, checkReview : Boolean = false): void
		{
			doCall("addAllowedWord", arguments);
		}
		public function addReviewWord(word : String): void
		{
			doCall("addReviewWord", arguments);
		}
		public function getBlockWords(firstResult : int, maxResults : int): void
		{
			doCall("getBlockWords", arguments);
		}
		public function getReviewWords(firstResult : int, maxResults : int): void
		{
			doCall("getReviewWords", arguments);
		}
		public function getSkipWords(firstResult : int, maxResults : int): void
		{
			doCall("getSkipWords", arguments);
		}
		public function getAllowedWords(firstResult : int, maxResults : int): void
		{
			doCall("getAllowedWords", arguments);
		}
		public function sendChat(remoteId : String, message : Object): void
		{
			doCall("sC", arguments);
		}
		
		public function sendCommand(userId:Number, command:RemoteCommand, offline:Boolean = false, showInLog:Boolean = true) : void
		{
			doCall("sendCommand", [userId, command.getProperties(), offline, showInLog]);
		}
		
		public function deleteCommand(commandId:Number) : void
		{
			doCall("deleteCommand", arguments);
		}
		public function locationPublicChat(message:Object, sharedObjId : String) : void
		{
			doCall("lPC", arguments);
		}
	}
}