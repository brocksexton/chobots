package com.kavalok.pinball.spaceBuilders
{
	import com.kavalok.pinball.PinballUtil;
	import com.kavalok.pinball.space.EventSpace;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import com.kavalok.errors.NotImplementedError;
	import org.rje.glaze.engine.dynamics.RigidBody;

	public class DynamicSpaceBuilderBase implements IDynamicSpaceBuilder
	{
		private var _name : String;
		private var _ballBody : RigidBody;
		private var _processors : Array = [];
		
		public function DynamicSpaceBuilderBase(name : String, ballBody : RigidBody)
		{
			_name = name;
			_ballBody = ballBody;
		}

		public function step():void
		{
			for each(var processor : IDynamicProcessor in _processors)
			{
				if(processor.tryStart())
					break;
			}
		}
		
		public function stop():void
		{
			for each(var processor : IDynamicProcessor in _processors)
			{
				processor.stop();
			}
			
		}
		public function process(displayObject:DisplayObject, space:EventSpace, game : GamePinball):void
		{
			if(displayObject is MovieClip && MovieClip(displayObject).name == _name)
			{
				var movie : MovieClip = MovieClip(displayObject);
				var params : Object = (movie.params != null) ? PinballUtil.getParams(movie.params) : new Object();
				if(movie.params != null)
				{
					movie.params.visible = false;
				}
				_processors.push(createProcessor(game, space, movie, _ballBody, params));
			}
		}
		
		protected function createProcessor(game : GamePinball, space : EventSpace, movie : MovieClip, ballBody : RigidBody, params : Object) : IDynamicProcessor
		{
			throw new NotImplementedError()
		}
		
		
	}
}