package com.kavalok.remoting
{
	import com.kavalok.Global;
	import com.kavalok.char.CharManager;
	import com.kavalok.remoting.interfaces.IClient;
	
	import com.kavalok.errors.IllegalStateError;
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.ReflectUtil;
	
	public class ClientBase implements IClient
	{
		protected var states : Object;
		
		private var _id:String = null;
		
		private var _connectEvent : EventSender = new EventSender();
		public function get connectEvent():EventSender
		{
			 return _connectEvent;
		}
		
		private var _remote : RemoteObject;
		protected var _remoteId : String;
		
		public function ClientBase()
		{
		}
		
		public function get charStates() : Array
		{
			var result : Array = [];
			for(var state : String in states)
			{
				if(isCharState(state))
					result.push(state);
			}
			return result;
		}
		
		public function get id() : String
		{
			if (_id == null)
				_id = ReflectUtil.getTypeName(this);
				 
			return _id;
		}

		public function set remote(value : RemoteObject) : void
		{
			_remote = value;
		}
		
		public function get connected() : Boolean
		{
			return states != null;
		}
		public function get remote() : RemoteObject
		{
			return _remote;
		}
		
		public function disconnect() : void
		{
			if(_remoteId != null)
			{
				RemoteObjects.instance.removeClient(_remoteId, this);
				states = null;
				_remoteId = null;
			}
		}
		
		public function connect(remoteId : String) : void
		{
			_remoteId = remoteId;
			RemoteObjects.instance.addClient(remoteId, this);
		}
		
		public function charConnect(charId : String) : void 
		{
			states[getCharStateId(charId)] = {};
		}
		
		public function charDisconnect(charId : String) : void 
		{
			delete states[getCharStateId(charId)];
//			states[getCharStateId(charId)] = null;
		}
		
		public function restoreState(state : Object) : void
		{
			states = state;
			 connectEvent.sendEvent();
		}
		
		public function removeState(method : String, stateName : String) : void
		{
			remote.removeState(this, method, stateName);
		}
		
		public function sendState(method : String, stateName : String, state : Object, lockState : Boolean = false) : void
		{
			ensureConnected();
			remote.sendState(this, method, stateName, state, lockState);
		}

		public function send(method : String, ...args) : void
		{
			ensureConnected();
			remote.send(this, method, args);
		}
		
		public function sendUserState(functionName:String, state:Object):void
		{
			sendState(functionName, userStateId, state);
		}
		
		public function isCharState(stateId:String):Boolean
		{
			return stateId.indexOf(CharManager.CHAR_STATE_PREFIX) == 0;
		}
		
		public function unlockState(stateId:String, method : String = null):void
		{
			sendState(method, stateId, {});
		}
		
		public function lockState(method:String, stateId:String, state : Object = null):void
		{
			if(state == null)
			{
				state = new Object();
			}
			state.owner = Global.enteredUser;
			sendState(method, stateId, state, true);
		}
			
		public function extractCharId(stateId:String):String
		{
			return stateId.substr(CharManager.CHAR_STATE_PREFIX.length); 
		}
		
		public function get clientCharId():String
		{
			return Global.enteredUser;
		}
		public function get clientUserId():int
		{
			return Global.charManager.userId;
		}
		
		public function get userState():Object
		{
			return states[userStateId];
		}
		
		public function getCharState(charId : String):Object
		{
			return states[getCharStateId(charId)];
		}
		
		public function getCharStateId(charId : String):String
		{
			return CharManager.CHAR_STATE_PREFIX + charId;
		}
		
		public function get userStateId():String
		{
			return Global.charManager.getCharStateId(clientCharId);
		}
		
		public function get remoteId():String
		{
			return _remoteId;
		}
		
		private function ensureConnected() : void
		{
			if(!connected)
				trace("trying to send while client is not connected " + id);
		}
		
	}
}