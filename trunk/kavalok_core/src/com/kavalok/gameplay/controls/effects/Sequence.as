package com.kavalok.gameplay.controls.effects
{
	public class Sequence extends EffectBase
	{
		private var _effects : Array;
		
		public function Sequence(...effects)
		{
			super();
			_effects = effects;
		}
		
	}
}