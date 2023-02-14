package com.kavalok.missionFarm
{
	
	import com.kavalok.Global;
	import com.kavalok.constants.Modules;
	import com.kavalok.gameplay.Music;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.location.LocationBase;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.services.SOService;
	
	import flash.events.MouseEvent;
	
	public class FarmStage extends LocationBase
	{
		private static const LOC_ID:String = 'missionFarm';

		static public const FIELD_VALUE:int = 1;
		static public const COW_VALUE:int = 1;
		static public const VIDRO_VALUE:int = 1;
		static public const BAD_CHAR_VALUE:int = 1;
		static public const MILK_MULTIPLIER:int = 2;
		
		private var _location:McLocation;
		
		private var _fields:Object = {};
		private var _grows:Grows;
		private var _cow:Cow;
		private var _milk:Milk;
		private var _leftTransport:LeftTransporter;
		private var _badChars:BadChars;
		
		private var _currentField:Field;
		private var _currentTool:String;
		private var _counter:int;
		private var _points:int = 0;
		
		private var _fightSound:Array = [F1_shot1, F1_shot2, F1_shot3];
		
		//{ #region init
		
		public function FarmStage(remoteId:String)
		{
			super(LOC_ID, remoteId);
			
			_location = new McLocation();
			
			setContent(_location);
			
			_charModelsFactory = new Models();
			_location.mcPoints.visible = false;
			
			createFields();
			
			_milk	= new Milk(_location.mcMilk, this);
			_cow	= new Cow(_location.mcCow, this);
			_grows 	= new Grows(this);
			_badChars = new BadChars(this);
			_leftTransport = new LeftTransporter(_location.mcLeftTransporter, this);
			
			ToolTips.registerObject(_location.mcLeftTransporter.btn, 'vidro', Modules.MISSION_FARM);
			ToolTips.registerObject(_location.mcCow.btn, 'korovaMoo', Modules.MISSION_FARM);
			
			new Tool(this, _location.btnLopata, Tools.LOPATA, 'lopata', 'toDig');
			new Tool(this, _location.btnKosa, Tools.KOSA, 'kosa', 'toCut');
			new Tool(this, _location.btnGanj, Tools.GANJ, 'ganj', 'toSmoke');
			new Tool(this, _location.btnWater, Tools.WATER, 'water', 'toWater');
			new Tool(this, _location.btnGun, Tools.GUN, 'gun', 'toKill');
			
			_location.visible = false;
			
			//cheat
			
			_location.mcLeftTransporter.addEventListener(MouseEvent.MOUSE_DOWN,
				function(e:MouseEvent):void
				{
					if (e.ctrlKey && Global.superUser)
					{
						_grows.sendAddGrow();
						user.speed = 10;
					}
				}
			);
		}
		
		override public function rSetCharModel(stateId:String, state:Object):void
		{
			super.rSetCharModel(stateId, state);
			
			var modelName:String = state.modelName;
			
			if (modelName == Models.LOPATA)
				Global.playSound(F1_dig1)
			else if (modelName == Models.GANJ)
				Global.playSound(F1_plantseed);
			else if (modelName == Models.WATER)
				Global.playSound(F1_pour);
			else if (modelName == Models.KOSA)
				Global.playSound(F1_mow);
			else if (modelName == Models.FIGHT)
			{
				var sndNum:int = Math.random() * _fightSound.length
				Global.playSound(_fightSound[sndNum]);
			}
				
				
		}
		
		protected override function get musicList():Array
		{
			return Music.MISSION;
		}
		
		public function sendBonus(value:int):void
		{
			_points += value;
			sendAddBonus(value, Competitions.FARM);
			new CompetitionService().addResult(Competitions.FARM, value);
		}
		
		override public function restoreState(states:Object):void
		{
			super.restoreState(states);
			_location.visible = true;
		}
		
		private function createFields():void
		{
			for (var i:int = 0; i < _location.mcFields.numChildren; i++)
			{
				var mc:McField = McField(_location.mcFields.getChildAt(i));
				var field:Field = new Field('field' + i.toString(), mc, this);
				field.completeEvent.addListener(onFieldComplete);
				
				_fields[field.id] = field;
				
				addPoint(field);
			}
		}
		
		//} #region init
		
		private function updateObjects():void
		{
			_cow.refresh();
			_milk.refresh();
			_badChars.refresh();
			_grows.refresh();
			
			for each (var field:Field in _fields)
			{
				field.refresh();
			}
		}
		
		public function sendSelectTool(tool:String):void
		{
			_currentTool = tool;
			
			Global.charManager.tool = tool;
			sendUserTool(tool);
			
			updateObjects();
		}
		
		private function onFieldComplete():void
		{
			if (_grows.growCount < Grows.MAX_COUNT)
				_grows.sendAddGrow();
		}
		
		public function onMilk():void
		{
			sendBonus(_points * MILK_MULTIPLIER);
			_points = 0;
		}
		
		public function get points():McFarmPoints
		{
			return _location.mcPoints;
		}
		
		public function get currentTool():String { return _currentTool; }
		
		public function get location():McLocation { return _location; }
		
		public function get grows():Grows { return _grows; }
		public function get milk():Milk { return _milk; }
		public function get badChars():BadChars { return _badChars; }
	}
	
}

