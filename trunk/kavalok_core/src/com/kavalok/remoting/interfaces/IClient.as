package com.kavalok.remoting.interfaces
{
	import com.kavalok.remoting.RemoteObject;
	
	public interface IClient
	{
		function get id() : String;
		function set remote(value : RemoteObject) : void;
		function restoreState(state : Object) : void;
		function charDisconnect(charId : String) : void;
		function charConnect(charId : String) : void;
		function disconnect() : void;
	}
}