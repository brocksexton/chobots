package com.kavalok.gameplay.infoPanel
{
	import com.kavalok.char.CharModel;
	import com.kavalok.char.CharModels;
	import com.kavalok.commands.AsincMacroCommand;
	import com.kavalok.commands.char.GetCharModelCommand;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.layout.TileLayout;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.converting.ToPropertyValueConverter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class InfoContent extends Sprite
	{
		static public const TEXT_SIZE:int = 18;
		static public const TEXT_COLOR:int = 0xFFFFFF;
		static public const TEXT_SPEED:int = 2;
		static public const PANEL_COLOR:int = 0x9800FF;
		static public const PANEL_ALPHA:Number = 0.25;
		static public const PANEL_HEIGH:Number = 25;
		static public const PANEL_POSITION:Number = 5;
		
		private var _completeEvent:EventSender = new EventSender();
		private var _readyEvent:EventSender = new EventSender();
		
		private var _bounds:Rectangle
		private var _data:XML;
		private var _panel:Sprite;
		private var _field:TextField;
		private var _models:Array = [];
		
		public function InfoContent(data:XML, bounds:Rectangle)
		{
			_data = data;
			_bounds = bounds;
			
			mouseChildren = false;
			mouseEnabled = false;
			
			retriveData();
			GraphUtils.adjustSaturation(this, -50);
		}
		
		private function retriveData():void
		{
			var command:AsincMacroCommand = new AsincMacroCommand();
			
			var charNames:Array = Strings.safeSplit(_data.charNames);
			var charModels:Array = Strings.safeSplit(_data.charModels);
			
			for (var i:int = 0; i < charNames.length; i++)
			{
				var charName:String = charNames[i];
				var charModel:String = CharModels.STAY;
				var direction:int = 2;
				
				if (i < charModels.length)
					charModel = charModels[i];
				else if(charModels.length > 0)
					charModel = String(Arrays.lastItem(charModels));
					
				if (charModel.indexOf('-') > 0)
				{
					charModel = charModel.split('-')[0];
					direction = parseInt(charModel.split('-')[1]);
				}
				
				var modelCommand:GetCharModelCommand =
					new GetCharModelCommand(charName, charModel)
				
				_models.push(modelCommand); 
				command.add(modelCommand);
			}
			
			command.completeEvent.addListener(onDataReady);
			command.execute();
		}
		
		private function onDataReady(command:AsincMacroCommand):void
		{
			_models = Arrays.getConverted(_models, new ToPropertyValueConverter('model'));
			
			var modelContent:Sprite = new Sprite();
			for each (var model:CharModel in _models)
			{
				modelContent.addChild(model);
			}
			var layout:TileLayout = new TileLayout(modelContent);
			layout.direction = TileLayout.HORIZONTAL;
			layout.distance = 30;
			layout.maxItems = 6;
			layout.apply();
			
			addChild(modelContent);
			modelContent.x = 40;
			modelContent.y = 80;
			
			createText();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			_readyEvent.sendEvent();
		}
		
		private function createText():void
		{
			_panel = GraphUtils.createRectSprite(
				_bounds.width, PANEL_HEIGH, PANEL_COLOR, PANEL_ALPHA);
			_panel.x = 0;
			_panel.y = _bounds.bottom - _panel.height - PANEL_POSITION;
			_panel.cacheAsBitmap = true;
			
			_field = createTextField();
			_field.x = int(_bounds.right);
			_field.y = int(_panel.y + 0.5 * _panel.height - 0.5 * _field.height);
			
			addChild(_panel);
			addChild(_field);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_field.x -= TEXT_SPEED;
			
			if (_field.x < -_field.width)
			{
				deactivate();
				_completeEvent.sendEvent();
			}
		}
		
		private function deactivate(e:Event = null):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, deactivate);
		}
		
		private function destroy(e:Event = null):void
		{
			deactivate();
			for each (var model:CharModel in _models)
			{
				model.destroy();
			}
		}
		
		private function createTextField():TextField
		{
			var format:TextFormat = new TextFormat();
			format.font = KavalokConstants.DEFAULT_FONT;
			format.size = TEXT_SIZE;
			format.color = TEXT_COLOR;
			
			var field:TextField = new TextField();
			field.selectable = false;
			field.multiline = false;
			field.text = text;
			field.setTextFormat(format);
			field.width = field.textWidth + 10;
			field.height = field.textHeight + 5;
			field.cacheAsBitmap = true;
			field.filters = [new BlurFilter(2, 0)];
			
			return field; 
		}
		
		public function get text():String
		{
			 return _data.text[Localiztion.locale];
		}

		public function get completeEvent():EventSender { return _completeEvent; }
		public function get readyEvent():EventSender { return _readyEvent; }
	}
}