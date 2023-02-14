package org.goverla.managers
{
	import mx.rpc.AsyncDispatcher;

	import org.goverla.interfaces.IPropertiesInvalidable;

	public class PropertiesInvalidationManager
	{
		public static function get instance() : PropertiesInvalidationManager
		{
			if (_instance == null)
			{
				_instance = new PropertiesInvalidationManager();
			}
			return _instance;
		}

		private static var _instance : PropertiesInvalidationManager;

		public function invalidateProperties(target : IPropertiesInvalidable) : void
		{
			if (_targets.indexOf(target) < 0)
			{
				_targets.push(target);

				if (_dispatcher == null)
				{
					_dispatcher = new AsyncDispatcher(commitProperties, [], 0);
				}
			}
		}

		public function commitProperties() : void
		{
			for each (var target : IPropertiesInvalidable in _targets)
			{
				target.commitProperties();
			}
			_targets = [];
			_dispatcher = null;
		}

		private var _targets : Array = [];

		private var _dispatcher : AsyncDispatcher;

	}
}