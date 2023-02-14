package com.kavalok.danceConstructor
{
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.dance.BoneParts;
	import com.kavalok.gameplay.controls.FlashViewBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;

	public class BoneModelViewBase extends FlashViewBase
	{
		protected var charInfo : Object
		protected var model : CharModel;
		protected var bone : BoneParts;
		private var _content : MovieClip;
		public function BoneModelViewBase(content:MovieClip, charInfo : Object)
		{
			_content = content;
			super(content);
			this.charInfo = charInfo;

			model = new CharModel();
			model.refresh();
			model.readyEvent.addListener(onModelReady);
			
			 
			GraphUtils.scale(model, _content.charZone.height, _content.charZone.width);
			GraphUtils.removeChildren(_content.charZone);
			_content.charZone.addChild(model);
			model.char = new Char(charInfo);
		}
		
		protected function onModelReady():void
		{
			model.content.mouseChildren = true;
			model.content.mouseEnabled = true;
			bone = new BoneParts(model.content);
		}
		
	}
}