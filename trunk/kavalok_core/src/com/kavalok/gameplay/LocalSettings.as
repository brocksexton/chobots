package com.kavalok.gameplay
{
	import com.kavalok.Global;
	
	import flash.geom.Point;
	import flash.net.SharedObject;
	
	public class LocalSettings
	{
		static public const DEFAULT_LOCALE:String = 'enUS';
		static private const LOCAL_NAME:String = 'settings';
		static private const DEFAULT_MUSIC_VOLUME:Number = 0.4;
		static private const DEFAULT_SOUND_VOLUME:Number = 0.6;
		
		private var _so:SharedObject;
		private var _userData:Object;
		
		public function LocalSettings()
		{
			_so = SharedObject.getLocal(LOCAL_NAME);
		}
		
		public function set userId(value:String):void
		{
			if ( !(value in _so.data) )
			{
				_so.data[value] = {};
				_userData = _so.data[value];
			}
			else
			{
				_userData = _so.data[value];
			}
			
			if (_userData.messengerPosition == undefined)
				messengerPosition = new Point(25, 35);
		}
		
		public function get quality():int
		{
			 return (_so.data.quality == undefined)
			 	? 2
			 	: _so.data.quality;
		}
		public function set quality(value:int):void
		{
			 _so.data.quality = value;
		}
		
		public function get login():String
		{
			 return _so.data.login;
		}
		public function set login(value:String):void
		{
			 _so.data.login = value;
		}
		
		public function get passw():String
		{
			 return _so.data.passw;
		}
		public function set passw(value:String):void
		{
			 _so.data.passw = value;
		}
        
       	public function get pmClock():Boolean
		{
			if(_so.data.pmClock != null)
			 return _so.data.pmClock;
			else
			 return true;
		}
		public function set pmClock(value:Boolean):void
		{
			 _so.data.pmClock = value;
		}
        
        public function get panelUser():String
        {
        	return _so.data.panelUser;
        }

        public function set panelUser(value:String):void
        {
        	_so.data.panelUser = value;
        }
		public function get panelPassw():String
		{
			 return _so.data.panelPassw;
		}
		public function set panelPassw(value:String):void
		{
			 _so.data.panelPassw = value;
		}


		public function get newBuild():Boolean
		{
			 return _so.data.newBuild;
		}
		public function set newBuild(value:Boolean):void
		{
			 _so.data.newBuild = value;
		}

		
		public function get locationId():String
		{
			 return Global.locationManager.isStaticLocation(_userData.locationId)
			 	? _userData.locationId
			 	: null;
		}
		public function set locationId(value:String):void
		{
			 _userData.locationId = value;
		}
		
		public function get locale():String
		{
			return (_so.data.locale == undefined)
				? DEFAULT_LOCALE
				: _so.data.locale;
		}
		public function set locale(value:String):void
		{
			_so.data.locale = value;
		}
		
		public function get messengerPosition():Point
		{
			return new Point(
				_userData.messengerPosition.x,
				_userData.messengerPosition.y);
		}
		public function set messengerPosition(value:Point):void
		{
			_userData.messengerPosition = value;
		}
	}
}