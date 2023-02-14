package com.kavalok.commands
{
	
	public interface ICancelableCommand extends IAsincCommand
	{
		function cancel():void;
	}
	
}