﻿package common.commands
{
	
	public interface ICancelableCommand extends IAsincCommand
	{
		function cancel():void;
	}
	
}