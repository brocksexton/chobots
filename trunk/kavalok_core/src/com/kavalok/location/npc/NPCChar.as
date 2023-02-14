package com.kavalok.location.npc
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.SpectEntryPoint;
	import com.kavalok.location.entryPoints.SpriteEntryPoint;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class NPCChar
	{
		private var _activateEvent:EventSender = new EventSender();
		private var _dialogCompleteEvent:EventSender = new EventSender();
		
		private var _content:Sprite;
		private var _location:LocationBase;
		private var _dialog:NPCDialog;
		
		public function NPCChar(content:Sprite, charZone:Sprite, location:LocationBase)
		{
			_content = content;
			_location = location;
			
			_dialog = new NPCDialog(this);
			_dialog.completeEvent.addListener(onDialogComplete);
			
			MousePointer.registerObject(_content, MousePointer.ACTION);
			
			initContent();
			createEntryPoint(charZone);
		}
		
		private function initContent():void
		{
			GraphUtils.addBoundsRect(_content);
			_content.mouseChildren = false;
			_content.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function createEntryPoint(charZone:Sprite):void
		{
			var entryPoint:SpectEntryPoint = new SpectEntryPoint(_content, charZone, _location.content);
			entryPoint.goInEvent.addListener(onActivate);
			
			_location.addPoint(entryPoint);
		}
		
		private function onActivate(sender:SpriteEntryPoint):void
		{
			activateEvent.sendEvent();
		}
		
		private function onDialogComplete():void
		{
			_dialogCompleteEvent.sendEvent();
		}
		
		public function showDialog(messages:Array):void
		{
			_dialog.showDialog(messages);
		}
		
		private function destroy(e:Event):void
		{
			_dialog.stop();
		}
		
		public function get activateEvent():EventSender { return _activateEvent; }
		public function get dialogCompleteEvent():EventSender { return _dialogCompleteEvent; }
		
		public function get content():Sprite { return _content; }

	}
}