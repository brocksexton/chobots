package away3d.cameras
{
    import away3d.core.*;
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.math.*;
    import away3d.core.render.*;
    import away3d.core.utils.*;
    import away3d.events.CameraEvent;
    
    import flash.utils.*;
    
	/**
	 * Dispatched when the focus or zoom properties of a camera update.
	 * 
	 * @eventType away3d.events.CameraEvent
	 * 
	 * @see #focus
	 * @see #zoom
	 */
	[Event(name="cameraUpdated",type="away3d.events.CameraEvent")]
	
	/**
	 * Basic camera used to resolve a view.
	 * 
	 * @see	away3d.containers.View3D
	 */
    public class Camera3D extends Object3D
    {
        private var _aperture:Number = 22;
    	private var _dof:Boolean = false;
        private var _flipY:Matrix3D = new Matrix3D();
        private var _focus:Number;
        private var _zoom:Number;
        private var _fov:Number;
    	private var _view:Matrix3D = new Matrix3D();
        private var _screenVertex:ScreenVertex = new ScreenVertex();
        private var _vtActive:Array = new Array();
        private var _vtStore:Array = new Array();
        private var _vt:Matrix3D;
		private var _cameraupdated:CameraEvent;
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		private var _sz:Number;
		private var _persp:Number;
		
        private function notifyCameraUpdate():void
        {
            if (!hasEventListener(CameraEvent.CAMERA_UPDATED))
                return;
			
            if (_cameraupdated == null)
                _cameraupdated = new CameraEvent(CameraEvent.CAMERA_UPDATED, this);
                
            dispatchEvent(_cameraupdated);
        }
        
    	public var invView:Matrix3D = new Matrix3D();
    	
        /**
        * Dictionary of all objects transforms calulated from the camera view for the last render frame
        */
        public var viewTransforms:Dictionary;
        
        public function createViewTransform(node:Object3D):Matrix3D
        {
        	if (_vtStore.length)
        		_vtActive.push(_vt = viewTransforms[node] = _vtStore.pop());
        	else
        		_vtActive.push(_vt = viewTransforms[node] = new Matrix3D());
        	
        	return _vt
        }
        
        public function clearViewTransforms():void
        {
        	viewTransforms = new Dictionary(true);
        	_vtStore = _vtStore.concat(_vtActive);
        	_vtActive = new Array();
        }
        
		/**
		 * Used in <code>DofSprite2D</code>.
		 * 
		 * @see	away3d.sprites.DofSprite2D
		 */
		public function get aperture():Number
		{
			return _aperture;
		}
		
		public function set aperture(value:Number):void
		{
			_aperture = value;
			DofCache.aperture = _aperture;
		}
        
		/**
		 * Used in <code>DofSprite2D</code>.
		 * 
		 * @see	away3d.sprites.DofSprite2D
		 */
		public function get dof():Boolean
		{
			return _dof;
		}
		
		public function set dof(value:Boolean):void
		{
			_dof = value;
			if (_dof)
				enableDof();
			else
				disableDof();
		}		
		/**
		 * A divisor value for the perspective depth of the view.
		 */
		public function get focus():Number
		{
			return _focus;
		}
		
		public function set focus(value:Number):void
		{
			_focus = value;			
			DofCache.focus = _focus;
			notifyCameraUpdate();
		}
		
		/**
		 * Provides an overall scale value to the view
		 */
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void
		{
			_zoom = value;
			notifyCameraUpdate();
		}
		
		/**
		 * Defines the field of view of the camera in a vertical direction.
		 */
		public function get fov():Number
		{
			return _fov;
		}
		
		public function set fov(value:Number):void
		{
			_fov = value;
		}
		
		/**
		 * Used in <code>DofSprite2D</code>.
		 * 
		 * @see	away3d.sprites.DofSprite2D
		 */
        public var maxblur:Number = 150;
        
        /**
		 * Used in <code>DofSprite2D</code>.
		 * 
		 * @see	away3d.sprites.DofSprite2D
		 */
        public var doflevels:Number = 16;
    	
		/**
		 * Creates a new <code>Camera3D</code> object.
		 * 
		 * @param	init	[optional]	An initialisation object for specifying default instance properties.
		 */
        public function Camera3D(init:Object = null)
        {
            super(init);
            
            zoom = ini.getNumber("zoom", 10);
            focus = ini.getNumber("focus", 100);
            aperture = ini.getNumber("aperture", 22);
            maxblur = ini.getNumber("maxblur", 150);
	        doflevels = ini.getNumber("doflevels", 16);
            dof = ini.getBoolean("dof", false);
            
            var lookat:Number3D = ini.getPosition("lookat");
			
			_flipY.syy = -1;
			
            if (lookat != null)
                lookAt(lookat);
        }
        
        /**
		 * Used in <code>DofSprite2D</code>.
		 * 
		 * @see	away3d.sprites.DofSprite2D
		 */
        public function enableDof():void
        {
        	DofCache.doflevels = doflevels;
          	DofCache.aperture = aperture;
        	DofCache.maxblur = maxblur;
        	DofCache.focus = focus;
        	DofCache.resetDof(true);
        }
                
        /**
		 * Used in <code>DofSprite2D</code>
		 * 
		 * @see	away3d.sprites.DofSprite2D
		 */
        public function disableDof():void
        {
        	DofCache.resetDof(false);
        }
        
		/**
		 * Returns the transformation matrix used to resolve the scene to the view.
		 * Used in the <code>ProjectionTraverser</code> class
		 * 
		 * @see	away3d.core.traverse.ProjectionTraverser
		 */
        public function get view():Matrix3D
        {
        	invView.multiply(sceneTransform, _flipY);
        	_view.inverse(invView);
        	return _view;
        }
    	

    	
    	/**
    	 * Returns a <code>ScreenVertex</code> object describing the resolved x and y position of the given <code>Vertex</code> object.
    	 * 
    	 * @param	object	The local object for the Vertex. If none exists, use the <code>Scene3D</code> object.
    	 * @param	vertex	The vertex to be resolved.
    	 * 
    	 * @see	away3d.containers.Scene3D
    	 */
        public function screen(object:Object3D, vertex:Vertex = null):ScreenVertex
        {
            use namespace arcane;

            if (vertex == null)
                vertex = new Vertex(0,0,0);
                
			createViewTransform(object).multiply(view, object.sceneTransform);
            project(viewTransforms[object], vertex, _screenVertex);
            
            return _screenVertex
        }
        
       /**
        * Projects the vertex to the screen space of the view.
        */
        public function project(viewTransform:Matrix3D, vertex:Vertex, screenvertex:ScreenVertex):void
        {
        	_x = vertex.x;
        	_y = vertex.y;
        	_z = vertex.z;
        	
            _sz = _x * viewTransform.szx + _y * viewTransform.szy + _z * viewTransform.szz + viewTransform.tz;
    		/*/
    		//modified
    		var wx:Number = x * view.sxx + y * view.sxy + z * view.sxz + view.tx;
    		var wy:Number = x * view.syx + y * view.syy + z * view.syz + view.ty;
    		var wz:Number = x * view.szx + y * view.szy + z * view.szz + view.tz;
			var wx2:Number = Math.pow(wx, 2);
			var wy2:Number = Math.pow(wy, 2);
    		var c:Number = Math.sqrt(wx2 + wy2 + wz*wz);
			var c2:Number = (wx2 + wy2);
			persp = c2? projection.focus*(c - wz)/c2 : 0;
			sz = (c != 0 && wz != -c)? c*Math.sqrt(0.5 + 0.5*wz/c) : 0;
			//*/
    		//end modified
    		
            if (isNaN(_sz))
                throw new Error("isNaN(sz)");
            
            if (_sz*2 <= -focus) {
                screenvertex.visible = false;
                return;
            } else {
                screenvertex.visible = true;
            }

         	_persp = zoom / (1 + _sz / focus);

            screenvertex.x = (_x * viewTransform.sxx + _y * viewTransform.sxy + _z * viewTransform.sxz + viewTransform.tx) * _persp;
            screenvertex.y = (_x * viewTransform.syx + _y * viewTransform.syy + _z * viewTransform.syz + viewTransform.ty) * _persp;
            screenvertex.z = _sz;
            /*
            projected.x = wx * persp;
            projected.y = wy * persp;
			*/
        }
    	
		/**
		 * Rotates the camera in its vertical plane.
		 * 
		 * Tilting the camera results in a motion similar to someone nodding their head "yes".
		 * 
		 * @param	angle	Angle to tilt the camera.
		 */
        public function tilt(angle:Number):void
        {
            super.pitch(angle);
        }
    	
		/**
		 * Rotates the camera in its horizontal plane.
		 * 
		 * Panning the camera results in a motion similar to someone shaking their head "no".
		 * 
		 * @param	angle	Angle to pan the camera.
		 */
        public function pan(angle:Number):void
        {
            super.yaw(angle);
        }
		
		/**
		 * Duplicates the camera's properties to another <code>Camera3D</code> object.
		 * 
		 * @param	object	[optional]	The new object instance into which all properties are copied.
		 * @return						The new object instance with duplicated properties applied.
		 */
        public override function clone(object:Object3D = null):Object3D
        {
            var camera:Camera3D = (object as Camera3D) || new Camera3D();
            super.clone(camera);
            camera.zoom = zoom;
            camera.focus = focus;
            return camera;
        }
		
		/**
		 * Default method for adding a cameraUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnCameraUpdate(listener:Function):void
        {
            addEventListener(CameraEvent.CAMERA_UPDATED, listener, false, 0, false);
        }
		
		/**
		 * Default method for removing a cameraUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnCameraUpdate(listener:Function):void
        {
            removeEventListener(CameraEvent.CAMERA_UPDATED, listener, false);
        }
    }
}
