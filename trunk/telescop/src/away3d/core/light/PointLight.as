package away3d.core.light
{
	import away3d.lights.*;

    /**
    * Point light primitive
    */
    public class PointLight extends LightPrimitive
    {
    	/**
    	 * The x coordinates of the <code>PointLight3D</code> object.
    	 */
        public var x:Number;
        
    	/**
    	 * The y coordinates of the <code>PointLight3D</code> object.
    	 */
        public var y:Number;
        
    	/**
    	 * The z coordinates of the <code>PointLight3D</code> object.
    	 */
        public var z:Number;
        
    	/**
    	 * A reference to the <code>PointLight3D</code> object used by the light primitive.
    	 */
        public var light:PointLight3D;
    }
}

