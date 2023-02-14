package com.kavalok.family
{
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.MouseEvent;
	
	public class ItemView
	{
		static private const CHILD_SCALE:Number = 1.8;
		static private const PARENT_SCALE:Number = 2.3;
		
		private var _clickEvent:EventSender = new EventSender();
		
		private var _content:McChar;
		private var _model:CharModel;
		
		public function ItemView(content:McChar, char:Char = null)
		{
			_content = content;
			_content.buttonMode = true;
			
			initialize();
			createModel(char);
		}
		
		private function initialize():void
		{
			_content.charArea.visible = false;
			_content.addEventListener(MouseEvent.CLICK, onClick);
			
			selected = false;
		}
		
		public function createModel(char:Char):void
		{
			_model = new CharModel(char);
			
			if (char)
			{
				_content.nameField.text = char.id;
				_content.onlineStatus.visible = char.isOnline;
			}
			else
			{
				if(Global.charManager.isParent)
					ToolTips.registerObject(_content, 'addUser', ResourceBundles.FAMILY);
				GraphUtils.applySepiaEffect(_model);
				_content.nameField.text = '';
				_content.onlineStatus.visible = false;
			}
				
			_content.addChild(_model);
			_model.position = _content.charArea;
			_model.refresh(); 
			
			refresh();
		}
		
		public function refresh():void
		{
			_model.scale = (_model.char.isParent)
				? PARENT_SCALE
				: CHILD_SCALE;
		}
		
		private function onClick(e:MouseEvent):void
		{
			_clickEvent.sendEvent(this);
		}
		
		public function set selected(value:Boolean):void
		{
			_content.background.alpha = value ? 1 : 0;
		}
		
		public function get clickEvent():EventSender
		{
			 return _clickEvent;
		}
		
		public function get char():Char
		{
			 return _model.char;
		}

	}
}