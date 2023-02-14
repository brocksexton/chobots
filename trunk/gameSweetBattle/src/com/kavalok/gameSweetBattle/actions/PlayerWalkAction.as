package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.GameStage;
	import com.kavalok.gameSweetBattle.fightAction.WalkFightAction;
	import com.kavalok.gameplay.MousePointer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PlayerWalkAction extends StaticActionBase
	{
		static public const ID:String = 'playerWalk';
		
		protected var _walkArea:Sprite;
		
		public function PlayerWalkAction(stage : GameStage):void
		{
			super(WalkFightAction)
			this.stage = stage;
			_walkArea = Sprite(stage.field.getChildByName('mc_walkArea'));
			_walkArea.cacheAsBitmap = true;
			_walkArea.alpha = 0;
			_walkArea.visible = false;
			
			MousePointer.registerObject(_walkArea, MousePointer.WALK);
		}

		override public function get id():String
		{
			return ID;
		}
		
		public override function activate():void
		{
			stage.em.removeEvent(_walkArea, MouseEvent.MOUSE_DOWN);
			stage.em.registerEvent(_walkArea, MouseEvent.MOUSE_DOWN, onWalkAreaPress);
			_walkArea.visible = true;
		}
		
		public override function terminate():void
		{
			_walkArea.visible = false;
		}
		
		protected function onWalkAreaPress(e:MouseEvent):void 
		{
			var x:int = stage.field.mouseX;
			var y:int = stage.field.mouseY;
			sendFightEvent( { x : x, y : y} );
		}
		
	}
}