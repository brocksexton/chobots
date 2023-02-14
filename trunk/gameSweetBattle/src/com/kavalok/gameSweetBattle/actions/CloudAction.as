package com.kavalok.gameSweetBattle.actions
{
	import com.kavalok.gameSweetBattle.CloudSight;
	import com.kavalok.gameSweetBattle.Config;
	import com.kavalok.gameSweetBattle.Player;
	import com.kavalok.gameSweetBattle.fightAction.CloudFightAction;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsObject;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class CloudAction extends StaticActionBase
	{
		public static const ID:String = 'weaponCloud';
		
		
		private var _sight:CloudSight;
		private var _targetPos:Number;
		
		public function CloudAction()
		{
			super(CloudFightAction);
			_countTotal = 1;
		}

		public override function get id():String
		{
			return ID;
		}
		
		
		public override function activate():void
		{
			_sight = new CloudSight();
			_sight.fightEvent.setListener(onFight);
			stage.content.addChild(_sight.content);
		}
		
		public override function terminate():void
		{
			if (_sight)
				removeSight();
		}
		
		private function removeSight():void
		{
			stage.content.removeChild(_sight.content)
			_sight = null;
		}
		
		private function onFight():void
		{
			addCount(-1);
			
			var p:Point = new Point(_sight.position, 0);
			GraphUtils.transformCoords(p, _sight.content, stage.field);
			removeSight();
			
			sendFightEvent( { x : p.x } );
		}
		
		
		
	}
	
}