package com.kavalok.family
{
	import com.kavalok.Global;
	import com.kavalok.StartupInfo;
	import com.kavalok.char.Char;
	import com.kavalok.constants.Modules;
	import com.kavalok.login.LoginModes;
	import com.kavalok.modules.ModuleBase;
	import com.kavalok.modules.ModuleEvents;
	import com.kavalok.utils.Debug;
	import com.kavalok.utils.ResourceScanner;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FamilyView
	{
		private var _content:McFamily = new McFamily();
		private var _infoView:InfoView = new InfoView(_content.itemInfo);
		private var _module:Family;
		private var _items:Array = [];
		private var _selection:ItemView;
		private var _previousLocId:String;
		private var _previousLocParams:Object;
		
		public function FamilyView(module:Family)
		{
			_previousLocId = module.parameters.locId || Global.locationManager.locationId;
			_previousLocParams = module.parameters.params || Global.locationManager.location.invitationParams;
			
			//trace(_previousLocId, _previousLocParams);
			//Debug.traceObject(_previousLocParams);
			
			_module = module;
			_infoView.changeEvent.addListener(onPropertyChange);
			
			initForm();
			initFamily();
			
			selection = _items[0];
		}
		
		private function initFamily():void
		{
			for (var i:int = 0; i < _content.familyClip.numChildren; i++)
			{
				var char:Char = (i <= _module.chars.length)
					? _module.chars[i]
					: null; 
				
				var itemClip:McChar = McChar(_content.familyClip.getChildAt(i));
				var item:ItemView = new ItemView(itemClip, char);
				item.clickEvent.addListener(onItemClick);
				
				_items.push(item);
			}
		}
		
		private function onItemClick(item:ItemView):void
		{
			selection = item;
		}
		
		private function onPropertyChange():void
		{
			_selection.refresh();
		}
		
		private function set selection(item:ItemView):void
		{
			if (_selection)
				_selection.selected = false;
				
			_selection = item;
			_selection.selected = true;
			
			refresh();
		}
		
		public function refresh():void
		{
			var charExists:Boolean = (_selection.char.id != null); 
			
			_infoView.content.visible = charExists;
			_content.registerButton.visible = !charExists && Global.charManager.isParent;
			
			if (charExists)
				_infoView.char = _selection.char;
			
		}
		
		private function initForm():void
		{
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.registerButton.addEventListener(MouseEvent.CLICK, onRegisterClick);
			
			new ResourceScanner().apply(_content);
		}
		
		private function onRegisterFinish(module : ModuleBase):void
		{
			Global.moduleManager.loadModule(Modules.FAMILY, {locId : _previousLocId, params : _previousLocParams});
		}
		private function onCloseClick(e:MouseEvent):void
		{
			_module.closeModule();
			//Global.moduleManager.loadModule(_previousLocId, _previousLocParams);
		}
		
		private function onRegisterClick(e:MouseEvent):void
		{
			_module.closeModule();
			var parameters:Object = 
			{
				info: new StartupInfo(),
				mode: LoginModes.REGISTER_FROM_FAMILY,
				familyEmail: Global.charManager.email
			}
			var events : ModuleEvents = Global.moduleManager.loadModule(Modules.LOGIN, parameters);
			events.destroyEvent.addListener(onRegisterFinish);
		}
		
		public function get content():Sprite { return _content; }

	}
}