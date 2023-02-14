package com.kavalok.location.modifiers
{
	import com.kavalok.Global;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.location.LocationBase;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class QuestQModifier
	{
		public static const PREFIX : String = "questQ_"; 
		private var _object : DisplayObject;
		private var _name : String;
		
		public function QuestQModifier(object : DisplayObject)
		{
			_object = object;
			_object.alpha = 0;
			_name = object.name.split("_")[1];
			

			trace("Welcome. Satellites have already been placed at: " + Global.charManager.satellitesPlaced);

			if(Global.charManager.satellitesPlaced.indexOf(Global.locationManager.locationId) != -1)
			plynextFrame();
			else if(Global.charManager.currentQuest == "questQ" && Global.charManager.satellitesMustPlace.indexOf(Global.locationManager.locationId) != -1)
			refresh();
		}
		

		
		private function refresh() : void
		{
			MousePointer.registerObject(_object, MousePointer.ACTION);
			_object.addEventListener(MouseEvent.CLICK, onObjectClick);
			
		}

		private function onObjectClick(e:MouseEvent):void
		{
			var _loc:LocationBase = Global.locationManager.location;
			_loc.sendMoveUser(_object.x, _object.y);

			MousePointer.unRegisterObject(_object);
			_object.removeEventListener(MouseEvent.CLICK, onObjectClick);
			Global.locationManager.location.sendAddBonus(200, "satellite questQ");

			plynextFrame();

			Global.charManager.satellitesPlaced.push(Global.locationManager.locationId);
			Global.charManager.satellitesMustPlace.splice(Global.charManager.satellitesMustPlace.indexOf(Global.locationManager.locationId), 1);
			if(Global.charManager.isModerator)
			trace("Done! Now must place at: " + Global.charManager.satellitesMustPlace);
		}

		private function plynextFrame():void
		{
			_object.alpha=100;
			var obj:MovieClip = _object as MovieClip;
			obj.gotoAndStop(36);
		}

	}
}