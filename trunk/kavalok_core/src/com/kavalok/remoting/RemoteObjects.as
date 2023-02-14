package com.kavalok.remoting
{
	public class RemoteObjects
	{
		private static var _instance : RemoteObjectsInstance;
		
		public static function get instance():RemoteObjectsInstance
		{
			if(_instance == null)
			{
				_instance = new RemoteObjectsInstance();
			}
			return _instance;
		}

	}
}
	import com.kavalok.remoting.RemoteConnection;
	import com.kavalok.remoting.RemoteObject;
	import com.kavalok.remoting.interfaces.IClient;
	
	import flash.utils.Dictionary;
	

internal class RemoteObjectsInstance
{
	private var _remoteObjects : Dictionary = new Dictionary();
	
	public function RemoteObjectsInstance()
	{
		RemoteConnection.instance.disconnectEvent.addListener(disconnect);
	}
	
	public function disconnect() : void
	{
		for each(var remoteObject : RemoteObject in _remoteObjects)
		{
			if(remoteObject)
				remoteObject.dispose();
		}
		_remoteObjects = new Dictionary();
	}
	
	public function removeAllClients(remoteObjectId : String) : void
	{
		var remoteObject : RemoteObject = RemoteObject(_remoteObjects[remoteObjectId]);
		if(remoteObject != null)
		{
			remoteObject.dispose();
			_remoteObjects[remoteObjectId] = null;
		}
		
	}

	public function removeClient(remoteObjectId : String, client : IClient) : void
	{
		var remoteObject : RemoteObject = RemoteObject(_remoteObjects[remoteObjectId]);
		if(remoteObject == null)
			return;
		remoteObject.removeClient(client);
		if(remoteObject.clients == 0)
		{
			remoteObject.dispose();
			delete _remoteObjects[remoteObjectId];
		}
	}
	
//	public function restoreState(remoteObjectId : String, state : Object, chars : Array) : void
//	{
//		if(_remoteObjects[remoteObjectId])
//		{
//			var remoteObject : RemoteObject = RemoteObject(_remoteObjects[remoteObjectId]);
//			remoteObject.restoreStates(state, chars);
//		}
//	}
	
	public function addClient(remoteObjectId : String, client : IClient) : void
	{
		var remoteObject : RemoteObject;
		if(_remoteObjects[remoteObjectId] == null)
		{
			remoteObject = new RemoteObject(remoteObjectId);
			_remoteObjects[remoteObjectId] = remoteObject;
		}
		else
		{
			remoteObject = RemoteObject(_remoteObjects[remoteObjectId]);
		}
		remoteObject.addClient(client);
	}
	
}
