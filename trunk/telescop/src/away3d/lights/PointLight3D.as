package away3d.lights
{
    import away3d.containers.*;
    import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.light.*;
    import away3d.core.math.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
    import away3d.materials.*;
    import away3d.primitives.Sphere;
    
    import flash.display.*;
	
    /**
    * Lightsource that colors all shaded materials proportional to the dot product of the distance vector with the normal vector.
    * The scalar value of the distance is used to calulate intensity using the inverse square law of attenuation.
    */
    public class PointLight3D extends Object3D implements ILightProvider, IClonable
    {
    	use namespace arcane;
    	
		private var _ls:PointLight = new PointLight();
        private var _debugPrimitive:Sphere;
        private var _debugMaterial:ColorMaterial;
        private var _debug:Boolean;
		
		/**
		 * Defines the color of the light object.
		 */
        public var color:int;
		
		/**
		 * Defines a coefficient for the ambient light intensity.
		 */
        public var ambient:Number;
		
		/**
		 * Defines a coefficient for the diffuse light intensity.
		 */
        public var diffuse:Number;
		
		/**
		 * Defines a coefficient for the specular light intensity.
		 */
        public var specular:Number;
		
		/**
		 * Defines a coefficient for the overall light intensity.
		 */
        public var brightness:Number;
        
        /**
        * Toggles debug mode: light object is visualised in the scene.
        */
        public function get debug():Boolean
        {
        	return _debug;
        }
        
        public function set debug(val:Boolean):void
        {
        	_debug = val;
        }
        
		public function get debugPrimitive():Object3D
		{
			if (!_debugPrimitive)
				_debugPrimitive = new Sphere();
			
			if (!_debugMaterial) {
				_debugMaterial = new ColorMaterial();
				_debugPrimitive.material = _debugMaterial;
			}
			
            _debugMaterial.color = color;
            
			return _debugPrimitive;
		}
		
		/**
		 * Creates a new <code>PointLight3D</code> object.
		 * 
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function PointLight3D(init:Object = null)
        {
            super(init);
            
            color = ini.getColor("color", 0xFFFFFF);
            ambient = ini.getNumber("ambient", 1);
            diffuse = ini.getNumber("diffuse", 1);
            specular = ini.getNumber("specular", 1);
            brightness = ini.getNumber("brightness", 1000);
            debug = ini.getBoolean("debug", false);
        }
        
		/**
		 * @inheritDoc
		 */
        public function light(consumeer:ILightConsumer):void
        {
            _ls.x = scenePosition.x;
            _ls.y = scenePosition.y;
            _ls.z = scenePosition.z;
            _ls.light = this;
            _ls.red = (color & 0xFF0000) >> 16;
            _ls.green = (color & 0xFF00) >> 8;
            _ls.blue  = (color & 0xFF);
            _ls.ambient = ambient*brightness;
            _ls.diffuse = diffuse*brightness;
            _ls.specular = specular*brightness;
            consumeer.pointLight(_ls);
        }
		
		/**
		 * Duplicates the light object's properties to another <code>PointLight3D</code> object
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied
		 * @return						The new object instance with duplicated properties applied
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var light:PointLight3D = (object as PointLight3D) || new PointLight3D();
            super.clone(light);
            light.color = color;
            light.ambient = ambient;
            light.diffuse = diffuse;
            light.specular = specular;
            light.debug = debug;
            return light;
        }

    }
}
