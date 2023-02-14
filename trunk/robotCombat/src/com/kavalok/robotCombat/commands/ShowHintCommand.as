package com.kavalok.robotCombat.commands
{
	import assets.combat.McHint;
	
	import com.kavalok.robotCombat.view.ModuleViewBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import gs.TweenGroup;
	import gs.TweenLite;
	
	public class ShowHintCommand extends ModuleCommandBase
	{
		private var _text:String;
		private var _coords:Point;
		private var _content:McHint;
		
		public function ShowHintCommand(text:String, coords:Point)
		{
			_text = text;
			_coords = coords;
			super();
		}
		
		override public function execute():void
		{
			createContent();
			show();
		}
		
		private function show():void
		{
			TweenLite.from(_content, 0.5, {
				alpha: 0,
				onComplete: hide
			});
		}
		
		private function hide():void
		{
			TweenLite.to(_content, 1.0, {
				alpha: 0,
				delay: 1,
				onComplete: onComplete
			});
		}
		
		private function onComplete():void
		{
			GraphUtils.detachFromDisplay(_content);
			dispathComplete();	
		}
		
		private function createContent():void
		{
			_content = new McHint();
			GraphUtils.optimizeSprite(_content);
				
			var field:TextField = _content.pointsField;
			ModuleViewBase.initTextField(field);
			field.multiline = false;
			field.wordWrap = false;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.text = _text;
			
			combat.root.addChild(_content);
			_content.x = _coords.x - 0.5 * _content.width;
			_content.y = _coords.y - 1.5 * _content.height;
		}
		
	}
}