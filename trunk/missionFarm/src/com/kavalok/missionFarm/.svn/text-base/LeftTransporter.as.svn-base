package com.kavalok.missionFarm
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	
	public class LeftTransporter extends FarmObject
	{
		
		private var _content:McLeftTransporter;
		
		
		public function LeftTransporter(content:McLeftTransporter, farm:FarmStage)
		{
			super('left', farm);
			
			_content = content;
			_btn = _content.btn;
			_position = GraphUtils.objToPoint(_farm.points.mcLeftPoint);
			
			_em.registerEvent(_content.mcVidro, Event.COMPLETE, onAnimComplete);
			
			attachToRemoteObject();
		}
		
		override public function goIn():void
		{
			_farm.sendUserPos(_position);
			_farm.sendSelectTool(Tools.VIDRO);
			Global.frame.tips.addTip('takeVidro');
			
			_content.mcVidro.gotoAndStop(1);
			refresh();
			
			send('rPlayAnim');
		}
		
		public function rPlayAnim():void
		{
			Global.playSound(F1_take);
			_content.mcVidro.gotoAndPlay(1);
			_content.mcAnim.play();
			refresh();
		}
		
		private function onAnimComplete(e:Event):void
		{
			_content.mcVidro.stop();
			_content.mcAnim.stop();
			refresh();
		}
		
		override public function refresh():void
		{
			var pointerClass:Class = (_content.mcVidro.currentFrame == _content.mcVidro.totalFrames)
				? MousePointer.HAND
				: MousePointer.BLOCKED;
			
			MousePointer.registerObject(_content.btn, pointerClass);
		}
		
		
	}
	
}