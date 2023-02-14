package com.kavalok.dialogs
{
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.Global;
	import com.kavalok.events.EventSender;
	import com.kavalok.services.AdminService;
	import com.kavalok.char.Char;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.BuyConfirmCommand;
	import com.kavalok.gameplay.ResourceSprite;
	import com.kavalok.utils.TaskCounter;
	import com.kavalok.utils.ResourceScanner;

	import flash.external.ExternalInterface;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.DisplayObject;
	
	public class DialogItemView extends DialogViewBase
	{
		private var _content:DialogItem;
		private var _selectedColor:int;
		private var _selectedColorSec:int;
		private var _stuffSprite:StuffItemLightTO;
		
		private var _model:ResourceSprite;
		private var _newModel:ResourceSprite;
		
		private var _tasks:TaskCounter;
		
		public function DialogItemView(itemInfo:StuffItemLightTO, text:String = null, modal:Boolean = true)
		{
			_content = new DialogItem();
			super(_content, text, modal);
			
			_stuffSprite = itemInfo;

			//_content.priceText.priceTextField.text = "500";
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			
			_content.colorPicker.addEventListener(MouseEvent.MOUSE_MOVE, showSelectedColor);
			_content.colorPicker.addEventListener(MouseEvent.CLICK, onPickerClick);
			_content.colorPicker.buttonMode = true;
			_content.colorClip.color2.stop();
			_content.colorClip.color2.visible = false;
			
			_content.colorPickerSec.visible = false;
			_content.colorClipSec.visible = false;
			if(_stuffSprite.doubleColor) {
				_content.colorPickerSec.visible = true;
				_content.colorClipSec.visible = true;
				_content.colorPickerSec.addEventListener(MouseEvent.MOUSE_MOVE, showSelectedColorSec);
				_content.colorPickerSec.addEventListener(MouseEvent.CLICK, onPickerClickSec);
				_content.colorPickerSec.buttonMode = true;
				_content.colorClipSec.color2.stop();
				_content.colorClipSec.color2.visible = false;
			}
				
			_content.colorMask.stop();
			_content.colorMask.alpha = 0;
			_content.colorMask.addEventListener(Event.COMPLETE, onMaskComplete);
			_model = createModel();
		}
		
		private function createModel():ResourceSprite
		{
			var model:ResourceSprite = _stuffSprite.createModel();
			model.loadContent();
			
			GraphUtils.scale(model, _content.stuffRect.height, _content.stuffRect.width)
			_content.addChild(model);
			var modelRect:Rectangle = model.getBounds(_content);
			var positionRect:Rectangle = _content.stuffRect.getBounds(_content);
			model.x += (positionRect.x + 0.5 * positionRect.width)
				- (modelRect.x + 0.5 * modelRect.width)
			model.y += (positionRect.y + 0.5 * positionRect.height)
				- (modelRect.y + 0.5 * modelRect.height);
			
			return model;
		}
		
		private function onPickerClick(event:MouseEvent):void
		{
			_selectedColor = getCurrentColor();
			changeColor();
		}
		
		private function onPickerClickSec(event:MouseEvent):void
		{
			_selectedColorSec = getCurrentColorSec();
			changeColorSec();
		}
		
		private function showSelectedColor(e:Event):void
		{
			var rgb:Object = GraphUtils.toRGB(getCurrentColor());
			var colorTransform:ColorTransform = 
				new ColorTransform(rgb.r / 255.0, rgb.g / 255.0, rgb.b / 255.0);
			
			_content.colorClip.color1.transform.colorTransform = colorTransform;
			_content.colorClip.color2.transform.colorTransform = colorTransform;
		}
		
		private function showSelectedColorSec(e:Event):void
		{
			var rgb:Object = GraphUtils.toRGB(getCurrentColorSec());
			var colorTransform:ColorTransform = 
				new ColorTransform(rgb.r / 255.0, rgb.g / 255.0, rgb.b / 255.0);
			
			_content.colorClipSec.color1.transform.colorTransform = colorTransform;
			_content.colorClipSec.color2.transform.colorTransform = colorTransform;
		}
		
		private function changeColor():void
		{
			Global.isLocked = true;
			_stuffSprite.color = _selectedColor;
			_newModel = createModel();
			_newModel.mask = _content.colorMask;
			
			_content.colorClip.color2.visible = true;
			_content.colorClip.color2.gotoAndPlay(1);
			
			_content.colorClip.gotoAndStop(2);
			_content.colorMask.play();
			
			_tasks = new TaskCounter(1);
			_tasks.completeEvent.addListener(onColorComplete);
		}
		
		private function changeColorSec():void
		{
			Global.isLocked = true;
			_stuffSprite.colorSec = _selectedColorSec;
			_newModel = createModel();
			_newModel.mask = _content.colorMask;
			
			_content.colorClipSec.color2.visible = true;
			_content.colorClipSec.color2.gotoAndPlay(1);
			
			_content.colorClipSec.gotoAndStop(2);
			_content.colorMask.play();
			
			_tasks = new TaskCounter(1);
			_tasks.completeEvent.addListener(onColorComplete);
		}
		
		private function onMaskComplete(e:Event):void
		{			
			_content.colorMask.gotoAndStop(1);
			_content.colorClip.color2.stop();
			_content.colorClip.color2.visible = false;
			
			_content.colorClipSec.color2.stop();
			_content.colorClipSec.color2.visible = false;
			
			_content.animationClip.play();
			
			GraphUtils.detachFromDisplay(_model);
			_model = _newModel;
			_model.mask = null;
			_newModel = null;
			
			_tasks.completeTask();
		}
		
		private function onColorComplete():void
		{
			Global.isLocked = false;
		}
		
		private function getCurrentColor():int
		{
			return GraphUtils.getPixel(_content.colorPicker,
				 _content.colorPicker.mouseX,
				 _content.colorPicker.mouseY);
		}
		
		private function getCurrentColorSec():int
		{
			return GraphUtils.getPixel(_content.colorPickerSec,
				 _content.colorPickerSec.mouseX,
				 _content.colorPickerSec.mouseY);
		}
		
		private function onSaveClick(event : MouseEvent):void
		{
			new BuyConfirmCommand(500, onBuyAccept).execute();
		}
		
		private function onBuyAccept():void
		{
			new AddMoneyCommand(-500, "item color").execute();
			//ExternalInterface.call("console.log", "SelectedColor: " + _selectedColor + " ---- Sec: " + _selectedColorSec);
			if(_selectedColor > 0) { _stuffSprite.color = _selectedColor; }
			if(_selectedColorSec > 0) { _stuffSprite.colorSec = _selectedColorSec; }
			var updateList:Object = {};
			
			updateList[_stuffSprite.id] = _stuffSprite;
			Global.charManager.stuffs.updateItems(updateList);
			Global.charManager.stuffs.refresh();
			hide();
		}
		
		protected function onCloseClick(event : MouseEvent) : void
		{
			hide();
		}
	}
}