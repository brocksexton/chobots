package com.kavalok.wardrobe.view
{
	import assets.wardrobe.McWardrobe;
	
	import com.kavalok.Global;
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.constants.Modules;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.wardrobe.ModuleController;
	
	import flash.events.MouseEvent;

	public class CharView extends ModuleController
	{
		private var _model:CharModel;
		private var _content:McWardrobe
		
		public function CharView(content:McWardrobe)
		{
			super();
			_content = content;
			initialize();
			
			_content.btnPrev.addEventListener(MouseEvent.MOUSE_DOWN, onPrevClick);
			_content.btnNext.addEventListener(MouseEvent.MOUSE_DOWN, onNextClick);
			_content.btnClear.addEventListener(MouseEvent.MOUSE_DOWN, onClearClick);
			_content.btnRandom.addEventListener(MouseEvent.MOUSE_DOWN, onRandomClick);
			
			ToolTips.registerObject(_content.btnClear, 'clear', Modules.HOME_CLOTHES);
			ToolTips.registerObject(_content.btnRandom, 'random', Modules.HOME_CLOTHES);
			
			wardrobe.usedChangeEvent.addListener(refresh);
			refresh();
		}
		
		private function initialize():void
		{
			_content.charPosition.visible = false;
			
			var char:Char = new Char();
			char.body = Global.charManager.body;
			char.color = Global.charManager.color;
			
			_model = new CharModel(char);
			_model.buttonMode = true;
			_model.refresh();
			_model.addEventListener(MouseEvent.CLICK, onModelClick);
			_content.addChild(_model);
			
			GraphUtils.fitToObject(_model, _content.charPosition);
		}
		
		private function refresh():void
		{
			var usedClothes:Array = wardrobe.usedClothes; 
			_model.char.clothes = usedClothes;
			_model.reload();
			GraphUtils.setBtnEnabled(_content.btnClear, usedClothes.length > 0);
		}
		
		public function hitTestItem(item:ItemSprite):Boolean
		{
			return _model.hitTestObject(item);	
		}
		
		private function onRandomClick(e:MouseEvent):void
		{
			wardrobe.randomize();
		}
		
		private function onModelClick(e:MouseEvent):void
		{
			wardrobe.unUseLast();
		}
		
		private function onClearClick(e:MouseEvent):void
		{
			wardrobe.unUseAll();
		}
		
		private function onPrevClick(e:MouseEvent):void
		{
			_model.rotateLeft();
		}
		
		private function onNextClick(e:MouseEvent):void
		{
			_model.rotateRight();
		}
	}
}