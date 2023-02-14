package com.kavalok.location.commands
{
	import com.kavalok.location.LocationBase;
	import com.kavalok.remoting.RemoteCommand;
	
	public class RemoteLocationCommand extends RemoteCommand
	{
		public var location:LocationBase;
		
		public function RemoteLocationCommand()
		{
			super();
		}
	}
}