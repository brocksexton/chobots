package com.kavalok.stuffCatalog.view
{
	import com.kavalok.Global;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.gameplay.frame.bag.StuffSprite;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteDecorator;
	
	import flash.display.Sprite;

	public class StuffItemView extends ItemViewBase
	{
		private var _stuffSprite:StuffSprite;
		private var _content:Sprite;
		
		public function StuffItemView(itemInfo:StuffSprite)
		{
			_stuffSprite = itemInfo;
			addChild(createContent());
			refresh();
		}
		
		private function createContent():Sprite
		{
			_content = Sprite(Global.classLibrary.getInstance(_stuffSprite.url, 'McStuffLarge')); 
			if(!_content)
				_content = Sprite(Global.classLibrary.getInstance(_stuffSprite.url, 'McStuff'));
			
			GraphUtils.scale(_content, 150, 150);
			
			return _content;
		}
		
		override public function refresh():void
		{
			SpriteDecorator.decorateColor(_content, _stuffSprite.color, _stuffSprite.colorSec);
		}
		
	}
}