package com.kavalok.gameSweetBattle
{
	import com.kavalok.utils.EventManager;
	import com.kavalok.events.EventSender;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ActionPanel
	{
		private var _content:McActionPanel;
		private var _buttons:Array = [];
		private var _selection:MovieClip;
		
		private var _selectionEvent:EventSender = new EventSender();
		
		private var _em:EventManager = GameSweetBattle.eventManager;
		
		public function ActionPanel(content:McActionPanel)
		{
			_content = content;
			
			initButtons();
		}
		
		private function initButtons():void
		{
			for (var i:int = 0; i < _content.numChildren; i++) 
			{
				var mc:MovieClip = _content.getChildAt(i) as MovieClip;
				
				if (mc == null) 
					continue;
				
				var btn:MovieClip = mc.getChildByName('btn') as MovieClip;
				
				if (btn == null) 
					continue;
					
				mc.buttonMode = true;
				mc.btn.stop();
				mc.caption.mouseEnabled = false;
				mc.caption.mouseChildren = false;
				mc.caption.field.text = '';
				
				_em.registerEvent(mc, MouseEvent.ROLL_OVER, onBtnOver);
				_em.registerEvent(mc, MouseEvent.ROLL_OUT, onBtnOut);
				_em.registerEvent(mc, MouseEvent.MOUSE_DOWN, onBtnPress);
				
				_buttons.push(mc);
			}
			
		}
		
		private function onBtnOver(e:MouseEvent):void 
		{
			var mc:MovieClip = MovieClip(e.currentTarget);
			
			if (mc != _selection) 
			{
				mc.btn.gotoAndStop(2);
			}
		}
		
		private function onBtnOut(e:MouseEvent):void 
		{
			var mc:MovieClip = MovieClip(e.currentTarget);
			
			if (mc != _selection) 
			{
				mc.btn.gotoAndStop(1);
			}
		}
		
		private function onBtnPress(e:MouseEvent):void 
		{
			var mc:MovieClip = MovieClip(e.currentTarget);
			
			if (mc != _selection) 
			{
				setCurrent(mc.name);
				_selectionEvent.sendEvent();
			}
			
		}
		
		public function setCurrent(name:String):void
		{
			if (_selection)
			{
				_selection.btn.gotoAndStop(1);
				_selection.buttonMode = true;
			}
			
			_selection = MovieClip(_content.getChildByName(name));
			_selection.btn.gotoAndStop(3);
			_selection.buttonMode = false;
		}
		
		public function setButtonCount(name:String, count:int):void
		{
			var mc:MovieClip = MovieClip(_content.getChildByName(name));
			if(mc == null)
				return;
			if (count == -1) 
				mc.caption.field.text = '';
			else 
				mc.caption.field.text = count.toString();
		}
		
		public function setButtonAccess(name:String, enabled:Boolean):void
		{
			var mc:MovieClip = MovieClip(_content.getChildByName(name));
			if(mc == null)
				return;
			mc.alpha = (enabled) ? 1 : 0.5;
			mc.mouseEnabled = enabled;
			mc.mouseChildren = enabled;
		}
		
		/*private function setBtnEnabled(mc:MovieClip, enabled:Boolean):void
		{
		}*/
		
		public function set visible(value:Boolean):void 
		{
			_content.visible = value;
		}
		
		public function get selectionEvent():EventSender { return _selectionEvent; }
		
		public function get selectionID():String
		{
			return _selection.name;
		}
		
	}
}