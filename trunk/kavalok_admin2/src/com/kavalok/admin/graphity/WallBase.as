package com.kavalok.admin.graphity
{
	import com.kavalok.graphity.LineShape;
	import com.kavalok.services.AdminService;
	import com.kavalok.utils.GraphUtils;
	import mx.events.FlexEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import org.goverla.utils.UIUtil;

	public class WallBase extends Panel
	{
		static private const MIN_WIDTH:Number = 200;
		static private const MAX_WIDTH:Number = 900;
		static private const DEFAULT_WIDTH:Number = 400;
		static private const HEIGHT_KOEF:Number = 0.75;
		
		
		private var _wallId:String;
		
		[Bindable]
		public var charId:String = "";
		
		public var canvas:UIComponent;
		public var clearButton:Button;
		
		private var _lines:Sprite = new Sprite();
		private var _active:Boolean = false;
		private var _server:Object;
		
		public function WallBase()
		{
			super();
		}
		
		static public function get defaultScale():Number
		{
			return (DEFAULT_WIDTH - MIN_WIDTH) / (MAX_WIDTH - MIN_WIDTH);
		}
		
		[Bindable]
		public function get wallId():String
		{
			return _wallId;
		}
		public function set wallId(value:String):void
		{
			_wallId = value;
			update();
		}
		[Bindable]
		public function get server():Object
		{
			return _server;
		}
		public function set server(value:Object):void
		{
			_server = value;
			update();
		}
		public function set scale(value:Number):void
		{
			width = MIN_WIDTH + value * (MAX_WIDTH - MIN_WIDTH);
			height = width * HEIGHT_KOEF;
			
			if (_lines.numChildren > 0)
			{
				validateNow();
				applyScale();
			}
		}
		
		protected function onInitialize():void
		{
			canvas.addChild(_lines);
		}
		
		public function clear():void
		{
			new AdminService().clearGraphity(server.name, wallId);
			update();
		}
		
		public function set active(value : Boolean):void
		{
			if(value != _active)
			{
				_active = value;
				update();
			}
		}
		
		private function update(e:Event = null):void
		{
			if (server && wallId && _active)
				Updater.updateWall(onGetGraphity, server.name, wallId);
				//new AdminService(onGetGraphity).getGraphity(server.name, wallId);
		}
		
		private function onGetGraphity(result:Array):void
		{
			UIUtil.removeChildren(_lines)
			
			for each (var state:Object in result)
			{
				addLine(state);
			}
			
			if (_active)
				applyScale();
		}
		
		private function applyScale():void
		{
			UIUtil.scale(_lines, canvas.height, canvas.width);
			var bounds:Rectangle = _lines.getBounds(canvas);
			GraphUtils.alignCenter(_lines, new Rectangle(0, 0, canvas.width, canvas.height));
		}
		
		private function addLine(state:Object):void
		{
			var line:LineShape = new LineShape();
			line.restoreFromState(state);
			line.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			line.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_lines.addChild(line);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			charId = LineShape(e.currentTarget).owner;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			charId = "";
		}
	}
}