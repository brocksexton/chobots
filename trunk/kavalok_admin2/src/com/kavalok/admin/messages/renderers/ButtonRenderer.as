package com.kavalok.admin.messages.renderers
{
	import com.kavalok.admin.messages.events.ProcessedEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;

	public class ButtonRenderer extends Button
	{
		public var dataField : String = "visible";
		
		public function ButtonRenderer()
		{
			super();
			label="set processed";
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(data[dataField] == false)
				callLater(hide);
		}
		
		private function hide() : void
		{
			visible = false;
		}
		
		private function onClick(event : MouseEvent) : void
		{
			data[dataField] = false;
			visible = false;
			dispatchEvent(new ProcessedEvent(data.id));
		}
		
		
	}
}