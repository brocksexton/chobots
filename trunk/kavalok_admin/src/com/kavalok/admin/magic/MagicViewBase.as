package com.kavalok.admin.magic 
{
	import com.kavalok.constants.ClientIds;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.remoting.RemoteCommand;
	import com.kavalok.services.AdminService;
	import com.kavalok.services.LocationInfoService;
	
	import mx.containers.Canvas;
	
	import org.goverla.utils.Strings;
	
	/**
	 * ...
	 * @author Canab
	 */
	public class MagicViewBase extends Canvas
	{
		static public const LOCATION_ID:String = ClientIds.LOCATION;
		static public const ADD_MODIFIER_FUNC:String = 'rAddLocationModifier';
		static public const REMOVE_MODIFIER_FUNC:String = 'rRemoveLocationModifier';
		
		private var _serverId:int = -1;
		private var _remoteId:String = null;
		
		private var _currentRoomHash:String;
		
		[Bindable] public var sendEnabled:Boolean;
		
		[Bindable] public var permissionLevel : int;
		
		public function MagicViewBase() 
		{
			super();
		}
		
		[Bindable]
		public function get serverId():int { return _serverId; }
		public function set serverId(value:int):void 
		{
			_serverId = value;
			refreshEnabled();
		}
		
		[Bindable]
		public function get remoteId():String { return _remoteId; }
		
		public function set remoteId(value:String):void 
		{
			_remoteId = value;
			getRoomHash();
			
			refreshEnabled();
		}
		
		private function getRoomHash():void
		{
			if ( _remoteId.length > 4 && _remoteId.substr(0, 4).toLowerCase() == "home" ) {
				// is not a public location, is home
				trace("is home");
				currentRoomHash = _remoteId;
				return;
			} else {
				new LocationInfoService(onGetRoomHash, onErrorGettingRoomHash).gh(_remoteId);
			}
		}
		
		private function onErrorGettingRoomHash(e:* = null):void
		{
			trace("error getting room hash... " + e);
		}
		
		private function onGetRoomHash(e:String):void
		{
			currentRoomHash = e;
		}
		
		private function refreshEnabled():void
		{
			sendEnabled = !Strings.isBlank(remoteId);
		}
		
		protected function sendModifierState(modifierName:String, state:Object):void 
		{
			new AdminService().sendState(
				serverId,
				remoteId,
				LOCATION_ID,
				ADD_MODIFIER_FUNC, 
				getStateName(modifierName),
				state);
		}
		
		protected function clearModifierState(modifierName:String):void 
		{
			new AdminService().removeState(
				serverId,
				remoteId,
				LOCATION_ID,
				REMOVE_MODIFIER_FUNC, 
				getStateName(modifierName)
			);
		}
		
		protected function sendLocationCommand(command:RemoteCommand):void 
		{
			new AdminService().sendLocationCommand(serverId, remoteId, command);
		}
		
		private function getStateName(modifierName:String):String
		{
			return KavalokConstants.MODIFIER_PREFIX + modifierName;
		}

		public function get currentRoomHash():String
		{
			return _currentRoomHash;
		}

		public function set currentRoomHash(value:String):void
		{
			_currentRoomHash = value;
		}
		
		
	}

}