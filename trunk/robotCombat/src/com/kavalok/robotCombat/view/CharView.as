package com.kavalok.robotCombat.view
{
	import assets.combat.McPlayerClip;
	
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.utils.GraphUtils;
	
	import flash.text.TextField;
	
	public class CharView extends ModuleViewBase
	{
		private var _container:McPlayerClip;
		private var _nameField:TextField;
		
		public function CharView(container:McPlayerClip, nameField:TextField)
		{
			_container = container;
			_nameField = nameField;
			
			_container.maskClip.visible = false;
			initTextField(_nameField);
			GraphUtils.optimizeSprite(_container);
		}
		
		public function setChar(char:Char):void
		{
			_nameField.text = char.id;
			
			var model:CharModel = new CharModel(char);
			model.refresh();
			model.x = 0.5 * _container.width;
			model.y = _container.height + 25;
			model.scale = 2;
			_container.addChildAt(model, 1);
			model.mask = _container.maskClip;
		}

	}
}