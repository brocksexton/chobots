package com.kavalok.char.actions
{
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	public class MoodAction extends CharActionBase
	{
		override public function execute():void
		{
			var moodId:String = _parameters.moodId;
			var moodClass:Class = Class(getDefinitionByName(moodId));
			var mood:Sprite = new moodClass();
			
			var anim:McMoodAnim = new McMoodAnim();
			GraphUtils.replaceContent(anim.mcModel, mood);
			
			anim.y = -_char.model.height - 20;
			anim.addEventListener(Event.COMPLETE, onMoodComplete);
			_char.content.addChild(anim);
			_char.moodId = moodId;
		}
		
		private function onMoodComplete(e:Event):void
		{
			var mc:MovieClip = MovieClip(e.target);
			mc.stop();
			_char.content.removeChild(mc);
		}
	
	}
}