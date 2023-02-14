package com.kavalok.gameplay
{
	import com.kavalok.Global;
	import com.kavalok.constants.Locations;
	import com.kavalok.gameplay.notifications.Notification;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.RandomTimer;
	
	import flash.geom.Point;

	public class LocationBot
	{
		private var _timer : RandomTimer;
		private var _location:LocationBase;
		
		private var _randomMessages : Array	= 
			["Кагдила, красавчег"
			, "Превед дарагой, куда спешишь в такой жара"
			, "хм... панаехали тут..."
			, "я устал, хачу любви.. ла-ла-ла"
			, "ой, кто здесь"
			, "дарагой, где ты был"
			, "бегал"
			, "но футболка совсем не пахнет"
			, "тут може бути ваша реклама"
			, "лорем іпсум долор сіт амет"
			, "timeo danaos"
			, "homo homini lupus est!"];
			
		
		public function LocationBot(location:LocationBase)
		{
			_location = location;
			_timer = new RandomTimer(Global.root, 0.5, 10);
			_timer.tick.addListener(onTick);
			_timer.start();
		}
		
		private function moveBot():void
		{
			var point:Point = GraphUtils.getRandomZonePoint(_location.ground); 
			_location.user.stopMoving();
			_location.sendMoveUser(point.x, point.y);
		}
		
		private function onTick() : void
		{
				
			//var command : int = Math.random() * 2;
			var command : int = 0; 
			switch(command)
			{
				case 0:
					var message:String = Arrays.randomItem(_randomMessages); 
					Global.notifications.sendNotification(new Notification(Global.charManager.charId, Global.charManager.userId, message));
					break;
				case 1:
					var newLoc : String = _location.locId == Locations.LOC_0 ? Locations.LOC_1 : Locations.LOC_0;
					_timer.stop();
					Global.moduleManager.loadModule(newLoc);
					break; 
				default:
					moveBot();
			}
		}
		
		
	}
}