package away3d.loaders.data
{
	import away3d.animators.skin.Channel;
		
	/**
	 * Data class for an animation channel
	 */
	public class ChannelData
	{
		/**
		 * The name of the channel used as a unique reference.
		 */
		public var name:String;
		
		/**
		 * The channel object.
		 */
		public var channel:Channel;
		
		/**
		 * The xml object
		 */
		public var xml:XML;
	}
}