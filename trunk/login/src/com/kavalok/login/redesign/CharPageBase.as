package com.kavalok.login.redesign
{
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.gameplay.ViewStackPage;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;

	public class CharPageBase extends ViewStackPage
	{
		private var _login : String;
		private var _content : MovieClip;
		private var _model:CharModel;
		
		public function CharPageBase(content:MovieClip)
		{
			_content = content;
			super(content);
			createCharModel();
		}
		
		public function get login() : String
		{
			return _login;
		}
		
		public function set login(value:String) : void
		{
			_login = value;
		}

		private function createCharModel():void
		{
			_model = new CharModel();
			_model.readyEvent.addListener(onCharViewReady);
			_model.refresh();
			
			_content.addChild(_model);
			
			GraphUtils.applySepiaEffect(_model);
			GraphUtils.fitToObject(_model, _content.charZone);
			
			_content.removeChild(_content.charZone); 
			
			updateCharModel();
		}
		
		private function onCharInfo(result:Object):void
		{
			if (result)
				_model.char = new Char(result);
		}
		

		protected function updateCharModel(e:Event = null):void
		{
			if (login && login.length > 0)
			{
				_model.char.id = login;
				new CharService(onCharInfo).getCharViewLogin(login);
			}
		}
		
		private function onCharViewReady():void
		{
			_model.filters = [];
			_model.transform.colorTransform = new ColorTransform();
		}
		
	}
}