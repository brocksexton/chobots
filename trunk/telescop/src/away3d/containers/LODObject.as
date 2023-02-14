package away3d.containers
{
    import away3d.cameras.Camera3D;
    import away3d.core.base.*;
    import away3d.core.math.*;
    import away3d.core.utils.*;

    /**
    * 3d object container that is drawn only if its scaling to perspective falls within a given range.
    */ 
    public class LODObject extends ObjectContainer3D implements ILODObject
    {
    	/**
    	 * The maximum perspective value from which the 3d object can be viewed.
    	 */
        public var maxp:Number;
        
    	/**
    	 * The minimum perspective value from which the 3d object can be viewed.
    	 */
        public var minp:Number;
    	
	    /**
	    * Creates a new <code>LODObject</code> object.
	    * 
	    * @param	init			[optional]	An initialisation object for specifying default instance properties.
	    * @param	...childarray				An array of children to be added on instatiation.
	    */
        public function LODObject(init:Object = null, ...childarray)
        {
            super(init);
			
            maxp = ini.getNumber("maxp", Infinity);
            minp = ini.getNumber("minp", 0);

            for each (var child:Object3D in childarray)
                addChild(child);
        }
        
		/**
		 * @inheritDoc
		 * 
    	 * @see	away3d.core.traverse.ProjectionTraverser
    	 * @see	#maxp
    	 * @see	#minp
		 */
        public function matchLOD(camera:Camera3D):Boolean
        {
            var z:Number = camera.viewTransforms[this].tz;
            var persp:Number = camera.zoom / (1 + z / camera.focus);

            if (persp < minp)
                return false;
            if (persp >= maxp)
                return false;

            return true;
        }
    }
}
