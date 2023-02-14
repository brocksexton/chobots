package com.kavalok.admin.users
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.dto.stuff.StuffTypeAdminTO;
	import com.kavalok.dto.stuff.StuffTypeTO;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.utils.GraphUtils;
		import com.kavalok.char.Char;
		import com.kavalok.localization.Localiztion;
	import com.kavalok.char.CharModel;
		import com.kavalok.services.CharService;
	
		import flash.events.Event;
	import mx.core.UIComponent;
	
	public class CharModelView extends UIComponent
	{
		//private var _stuffModel:ResourceSprite;
		private var _charName:String;
		private var _model:CharModel;

		
		public function CharModelView()
		{
			width = 100;
			height = 100;
			trace("checkpoint 1");
		}
		
		public function set char(value:String):void 
		{
			_charName = value;
			trace("checkpoint 2");
		}

		public function initLol():void
		{
			trace("checkpoint 3");

			_model = new CharModel();
			_model.refresh();
			this.addChild(_model);
			GraphUtils.fitToObject(_model, this);
			updateCharModel();

		}

		protected function updateCharModel(e:Event = null):void
		{
			trace("checkpoint 4");

			_model.char.id = _charName;
			new CharService(onCharInfo).getCharViewLogin(_charName);
			
		}

		private function onCharInfo(result:Object):void
		{
			trace("checkpoint 5");

			if (result)
				_model.char = new Char(result);
		}
		
		
	}
	
}