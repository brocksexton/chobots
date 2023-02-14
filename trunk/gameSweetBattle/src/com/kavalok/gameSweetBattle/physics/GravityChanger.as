package com.kavalok.gameSweetBattle.physics
{
	import com.kavalok.flash.playback.MovieClipPlayer;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.utils.Timers;
	
	import flash.display.MovieClip;
	
	import org.rje.glaze.engine.dynamics.RigidBody;
	
	public class GravityChanger extends ClientBase
	{
		private var _engine : PhysicsEngine;
		private var _clip : MovieClip;
		private var _blocked : Boolean = false;
		private var _inverted : Boolean = false;
		private var _physixObject : PhysicsObject;
		public function GravityChanger(engine : PhysicsEngine, remoteId : String, body : MasslesForceBody, clip : MovieClip)
		{
			super();
			connect(remoteId);
			_physixObject = new PhysicsObject(RigidBody.STATIC_BODY, body);
			_physixObject.collideHandler = onCollision;
			_engine = engine;
			engine.addObject(_physixObject);
			_clip = clip;
			_clip.gotoAndStop(0);
		}
		
		private function onCollision(object1 : PhysicsObject, object2 : PhysicsObject) : void
		{
			if(_blocked)
				return;
			_blocked = true;
			if(object2.owner.isUser)
			{
				send("rChangeGravity");
			}
			Timers.callAfter(unblock, 1000);
		}
		
		public function rChangeGravity() : void
		{
			var endFrame : int = _inverted ? 1 : _clip.totalFrames;
			var player : MovieClipPlayer = new MovieClipPlayer(_clip);
			player.playInterval(_clip.currentFrame, endFrame);
			_engine.invertGravity();
			_inverted = !_inverted;
		}
		
		private function unblock() : void
		{
			_blocked = false;
		}

	}
}