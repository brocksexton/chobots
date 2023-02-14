﻿package away3d.sprites{    import away3d.containers.*;    import away3d.core.*;    import away3d.core.base.*;    import away3d.core.draw.*;    import away3d.core.project.MovieClipSpriteProjector;    import away3d.core.render.*;    import away3d.core.utils.*;        import flash.display.DisplayObject;		/**	 * Spherical billboard (always facing the camera) sprite object that uses a movieclip as it's texture.	 * Draws individual display objects inline with z-sorted triangles in a scene.	 */    public class MovieClipSprite extends Object3D    {        private var _center:Vertex = new Vertex();		private var _sc:ScreenVertex;		private var _persp:Number;		private var _ddo:DrawDisplayObject;				/**		 * Defines the displayobject to use for the sprite texture.		 */        public var movieclip:DisplayObject;                /**        * Defines the overall scaling of the sprite object        */        public var scaling:Number;                /**        * An optional offset value added to the z depth used to sort the sprite        */        public var deltaZ:Number;                /**        * Defines whether the sprite should scale with distance from the camera. Defaults to false        */		public var rescale:Boolean;    			/**		 * Creates a new <code>MovieClipSprite</code> object.		 * 		 * @param	movieclip			The displayobject to use as the sprite texture.		 * @param	init	[optional]	An initialisation object for specifying default instance properties.		 */        public function MovieClipSprite(movieclip:DisplayObject, init:Object = null)        {            super(init);            this.movieclip = movieclip;            scaling = ini.getNumber("scaling", 1);            deltaZ = ini.getNumber("deltaZ", 0);			rescale = ini.getBoolean("rescale", false);			projector = ini.getObject("projector", IPrimitiveProvider) as IPrimitiveProvider;                        if (!projector)            	projector = new MovieClipSpriteProjector();        }    }}