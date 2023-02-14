package com.kavalok.gameplay.notifications
{
	public interface INotification
	{
		function get fromLogin() : String;
		function get toLogin() : String;
		function get fromUserId() : Number;
		function get toUserId() : Number;
		function get message() : Object;
		function get sentDate(): String;
		function getText():String;
	}
}