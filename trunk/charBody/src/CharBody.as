package {
	import com.kavalok.Global;
	import com.kavalok.char.CharModel;
	import com.kavalok.charBody.McContent;
	import com.kavalok.constants.Modules;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.commands.BuyConfirmCommand;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.modules.WindowModule;
	import com.kavalok.services.CharService;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.ResourceScanner;
	import com.kavalok.utils.TaskCounter;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	public class CharBody extends WindowModule
	{
		static public const MODEL_SCALE:Number = 2.3;
		static public const PRICE:Number = 500;
		
		private var _content:McContent = new McContent();
		private var _bundle:ResourceBundle = Localiztion.getBundle(Modules.CHAR_BODY);
		private var _model:CharModel;
		private var _newModel:CharModel;
		private var _selectedColor:int;
		
		public var _tasks:TaskCounter;
		
		override public function initialize():void
		{
			_content.priceBox.visible = parameters.payed;
			_content.priceBox.priceField.text = PRICE.toString();
			initContent();
			_model = createModel();
			
			GraphUtils.addChildAtCenter(_content, this);
			
			readyEvent.sendEvent();
		}
		
		private function initContent():void
		{
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			
			_content.colorPicker.addEventListener(MouseEvent.MOUSE_MOVE, showSelectedColor);
			_content.colorPicker.addEventListener(MouseEvent.CLICK, onPickerClick);
			_content.colorPicker.buttonMode = true;
			
			_content.colorClip.color2.stop();
			_content.colorClip.color2.visible = false;
			
			_content.colorMask.stop();
			_content.colorMask.alpha = 0;
			_content.colorMask.addEventListener(Event.COMPLETE, onMaskComplete);
			
			GraphUtils.removeChildren(_content.charContainer);
			new ResourceScanner().apply(_content);
		}
		
		private function onPickerClick(event:MouseEvent):void
		{
			if (Global.charManager.isGuest)
			{
				new RegisterGuestCommand().execute();
				return;
			}
			
			_selectedColor = getCurrentColor();
			
			if(parameters.payed)
				new BuyConfirmCommand(PRICE, changeColor).execute();
			else
				changeColor();
		}
		
		private function showSelectedColor(e:Event):void
		{
			var rgb:Object = GraphUtils.toRGB(getCurrentColor());
			var colorTransform:ColorTransform = 
				new ColorTransform(rgb.r / 255.0, rgb.g / 255.0, rgb.b / 255.0);
			
			_content.colorClip.color1.transform.colorTransform = colorTransform;
			_content.colorClip.color2.transform.colorTransform = colorTransform;
		}
		
		private function changeColor():void
		{
			if(parameters.payed)
				new AddMoneyCommand(-PRICE, "shower").execute();
				
			Global.isLocked = true;
			Global.charManager.color = _selectedColor;
			 
			_newModel = createModel();
			_newModel.mask = _content.colorMask;
				
			_content.colorClip.color2.visible = true;
			_content.colorClip.color2.gotoAndPlay(1);
			
			_content.colorClip.gotoAndStop(2);
			_content.colorMask.play();
			
			_tasks = new TaskCounter(2);
			_tasks.completeEvent.addListener(onColorComplete);
			
			new CharService(_tasks.completeTask).saveCharBodyNormal(
				Global.charManager.body,
				Global.charManager.color);
		}
		
		private function getCurrentColor():int
		{
			return GraphUtils.getPixel(_content.colorPicker,
				 _content.colorPicker.mouseX,
				 _content.colorPicker.mouseY);
		}
		
		private function createModel():CharModel
		{
			var model:CharModel = new CharModel();
			model.char.body = Global.charManager.body;
			model.char.color = Global.charManager.color;
			model.scale = MODEL_SCALE;
			model.refresh();
			
			_content.charContainer.addChild(model);
			
			return model;
		}
		
		private function onMaskComplete(e:Event):void
		{
			_content.colorMask.gotoAndStop(1);
			_content.colorClip.color2.stop();
			_content.colorClip.color2.visible = false;
			
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
		
		private function onCloseClick(e:MouseEvent):void
		{
			closeModule();
		}
	}
	
}
