package com.kavalok.admin.graphity
{
	import com.kavalok.services.AdminService;
	
	public class Updater
	{
		static private var _list:Array = [];
		static private var _busy:Boolean = false;
		static private var _currentCall:CallInfo;
		
		public function Updater()
		{
			
		}
		
		static public function updateWall(callback:Function, serverName:String, wallId:String):void
		{
			var info:CallInfo = new CallInfo();
			info.callback = callback;
			info.serverName = serverName;
			info.wallId = wallId;
			
			_list.push(info);
			
			if (!_busy)
				callNext();
		}
		
		static private function callNext():void
		{
			_busy = true;
			
			_currentCall = _list.pop();
			new AdminService(onGetGraphity, onFault).getGraphity(_currentCall.serverName, _currentCall.wallId);
		}
		
		static private function onGetGraphity(result:Array):void
		{
			_currentCall.callback(result);
			
			if (_list.length > 0)
				callNext();
			else
				_busy = false;
		}
		
		static private function onFault(result:Object):void
		{
			if (_list.length > 0)
				callNext();
			else
				_busy = false;
		}
	}
	
}

internal class CallInfo
{
	public var callback:Function;
	public var serverName:String;
	public var wallId:String;
}