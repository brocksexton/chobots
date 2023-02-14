package com.kavalok.dto.robot
{
	import com.kavalok.Global;
	import com.kavalok.robots.RobotTypes;
	import com.kavalok.utils.Strings;
	
	import flash.net.registerClassAlias;
	
	public class RobotItemTO
	{
		public static function initialize() : void
		{
			registerClassAlias("com.kavalok.dto.robot.RobotItemTO", RobotItemTO);
		}
		
		public var id:int;
		public var robotId:int;
		public var color:int;
		public var position:int;
	
		public var level:int; 
		public var name:String;
		public var robotName:String;
		public var placement:String;
		public var price:int;
		public var premium:Boolean;
		public var hasColor:Boolean;
		
		public var attack:int;
		public var defence:int;
		public var accuracy:int;
		public var mobility:int;
		
		public var energy:int;
		
		public var expirationDate:Date;
		public var lifeTime:int;
		public var useCount:int = -1;
		public var remains:int = -1;
		public var info:String;
		public var percent:Boolean;
		
		public function RobotItemTO()
		{
		}
		
		public function get parameters():Object
		{
			 return Strings.getParameters(info);
		}
		
		public function get isBody():Boolean
		{
			 return placement == RobotTypes.BODY;
		}
		
		public function get isBaseItem():Boolean
		{
			 return RobotTypes.BASE_ITEMS.indexOf(placement) >= 0;
		}
		
		public function get isCustomItem():Boolean
		{
			 return RobotTypes.CUSTOM_ITEMS.indexOf(placement) >= 0;
		}
		
		public function get isSpecialItem():Boolean
		{
			 return placement == RobotTypes.SPECIAL_ITEM;
		}
		
		public function get isArtifact():Boolean
		{
			 return placement == RobotTypes.ARTIFACT;
		}
		
		public function acceptsRobot(name:String):Boolean
		{
			return robotName == '*' || robotName == name;
		}
		
		public function get used():Boolean
		{
			 return robotId != -1;
		}
		
		public function unUse():void
		{
			robotId = -1;
			position = 0;
		}
		
		public function useBy(robotId:int, position:int):void
		{
			this.robotId = robotId;
			this.position = position;
		}
		
		public function get daysLeft():int
		{
			return (expirationDate.time - Global.getServerTime().time)
				/ 1000.0 / 3600.0 / 24.0; 
		}
		
		public function get localizedName():String
		{
			 return Global.resourceBundles.robotItems.messages[name];
		}

	}
}