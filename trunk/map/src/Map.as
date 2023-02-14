package {
	import com.kavalok.Global;
	import com.kavalok.char.CharModels;
	import com.kavalok.char.DefaultModelsFactory;
	import com.kavalok.char.Directions;
	import com.kavalok.commands.location.GotoLocationCommand;
	import com.kavalok.constants.Locations;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.map.McMap;
	import com.kavalok.map.McOverFilter;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Sequence;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.Strings;
	import flash.display.SimpleButton;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Map extends WindowModule
	{
		static private const OBJECT_PREFIX:String = 'obj_';
		static private const MODEL_SCALE:Number = 0.5;
		static private const FRAMES_PER_STEP:uint = 10;

		private var _content:McMap = new McMap();
		private var _overFilters:Array = new McOverFilter().object.filters;
		private var _objects:Object = {};
		private var _selectedButton:InteractiveObject;
		private var _randomLocation:Boolean;
		private var _bundle:ResourceBundle = Localiztion.getBundle(ResourceBundles.MAP);
		private var _partyLoc:String;
		
		
		override public function initialize() : void
		{
			GraphUtils.optimizeBackground(_content.background);
			GraphUtils.optimizeSprite(_content.fore);
			new AdminService(gotParty).getSavedData();
			_content.exitButton.visible = !parameters.closeDisabled;
			_content.exitButton.addEventListener(MouseEvent.CLICK, onExitClick);
			_content.selectButton.addEventListener(MouseEvent.CLICK, onServerSelectClick);
			_content.partyIcon.visible = false;
			
			Localiztion.getBundle("serverSelect").registerTextField(
				_content.townNameField, Global.loginManager.server);
				
			ToolTips.registerObject(_content.selectButton, 'changeServer', ResourceBundles.MAP);
			
			for(var i:int = 0; i < _content.map.numChildren; i++)
			{
				var child:DisplayObject = _content.map.getChildAt(i);
				if (child is Sprite && Strings.startsWidth(child.name, OBJECT_PREFIX))
				{
					initMapObject(child as Sprite);
				}
			}
			
			addChild(_content);
			readyEvent.sendEvent();
			
			placeChar();
		}
		
		private function gotParty(result:String):void
		{
			var loc:String = result.split("_")[1];
			_partyLoc = loc;
			var onValue:String = result.split("_")[0];
			var enabled:Boolean = (onValue == "on") ? true : false;

			if(enabled){

				_content.partyIcon.partyLoc.text = Global.messages[loc];
				_content.partyIcon.visible = true;
				_content.partyIcon.addEventListener(MouseEvent.CLICK, onPartyClick);
				ToolTips.registerObject(_content.partyIcon, "Click here to go to " + Global.messages[loc]);
			}
		}

		private function onPartyClick(e:MouseEvent):void
		{
			ToolTips.unRegisterObject(_content.partyIcon);
			var command:GotoLocationCommand = new GotoLocationCommand(_partyLoc);
			command.completeEvent.addListener(closeModule);
			command.execute();
		}
		private function placeChar():void
		{
			_selectedButton = _objects[Global.locationManager.locationId];
			if(_selectedButton)
			{
				_selectedButton.filters = _overFilters;
				_selectedButton.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			} 
			else
			{
				_selectedButton = _content.map[Global.locationManager.locationId];
			}
			
			if(_selectedButton)
			{
				var model : MovieClip = new DefaultModelsFactory().getModel(false, CharModels.STAY, Directions.DOWN);
				model.scaleX = model.scaleY = MODEL_SCALE;
				model.x = _selectedButton.x;
				model.y = _selectedButton.y;
				_content.map.addChild(model);
				new Sequence(model, [{alpha:0.5}, {alpha:1}], FRAMES_PER_STEP, null, true);
			}
		}
		
		private function initMapObject(clip:Sprite):void
		{
			clip.buttonMode = true;
			clip.mouseChildren = false;
			clip.cacheAsBitmap = true;
			clip.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			clip.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			clip.addEventListener(MouseEvent.CLICK, onClick);
			
			var objectId:String = clip.name.split('_')[1];
			ToolTips.registerObject(clip, objectId, ResourceBundles.MAP);
			_objects[objectId] = clip;
		}
		
		private function onOver(e:MouseEvent):void
		{
			Sprite(e.currentTarget).filters = _overFilters;
		}
		
		private function onOut(e:MouseEvent):void
		{
			Sprite(e.currentTarget).filters = [];
		}
		
		private function onClick(e:MouseEvent):void
		{
			var parts:Array = e.currentTarget.name.split('_');
			
			if (parts.length >= 3)
			{
				var locationId:String = (_randomLocation)
					? Locations.getRandomLocation()
					: parts[2];
				
				if (locationId != Global.locationManager.locationId)
					changeLocation(locationId);
				else
					closeModule();
			}
		}
		
		private function changeLocation(locationId:String):void
		{
			if(locationId == Modules.HOME)
			{
				closeModule();
				Global.locationManager.goHome();
			}
			else
			{
				var command:GotoLocationCommand = new GotoLocationCommand(locationId);
				command.completeEvent.addListener(closeModule);
				command.execute();
			}
		}
		
		private function onServerSelectClick(event : MouseEvent) : void
		{
			closeModule();
			Global.loginManager.chooseServerManual();
		}
		
		private function onExitClick(event : MouseEvent) : void
		{
			closeModule();
		}
		
	}
}
