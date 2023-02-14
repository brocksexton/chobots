package away3d.core.render
{
	import away3d.containers.*;
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.clip.*;
	import away3d.core.draw.*;
	import away3d.core.light.*;
	import away3d.core.traverse.*;
	import away3d.events.Object3DEvent;
	import away3d.events.SessionEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
    
	/**
	 * Dispatched when the render contents of the session require updating.
	 * 
	 * @eventType away3d.events.SessionEvent
	 */
	[Event(name="sessionUpdated",type="away3d.events.SessionEvent")]
	
    /**
    * Abstract Drawing session object containing the method used for drawing the view to screen.
    * Not intended for direct use - use <code>SpriteRenderSession</code> or <code>BitmapRenderSession</code>.
    */
	public class AbstractRenderSession extends EventDispatcher
	{
		use namespace arcane;
		/** @private */
		arcane var _containers:Dictionary = new Dictionary(true);
		/** @private */
		arcane var _shape:Shape;
		/** @private */
        arcane var _renderSource:Object3D;
		/** @private */
        arcane var _layerDirty:Boolean;
		/** Array for storing old displayobjects to the canvas */
		arcane var doStore:Array = new Array();
		/** Array for storing added displayobjects to the canvas */
		arcane var doActive:Array = new Array();
		/** @private */
		arcane function notifySessionUpdate():void
		{
			if (!hasEventListener(SessionEvent.SESSION_UPDATED))
                return;
			
            if (!_sessionupdated)
                _sessionupdated = new SessionEvent(SessionEvent.SESSION_UPDATED, this);
            
            dispatchEvent(_sessionupdated);
		}
		/** @private */
        arcane function internalAddSceneSession(session:AbstractRenderSession):void
        {
        	sessions = [session];
        	session.addOnSessionUpdate(onSessionUpdate);
        }
		/** @private */
        arcane function internalRemoveSceneSession(session:AbstractRenderSession):void
        {
        	sessions = [];
        	session.removeOnSessionUpdate(onSessionUpdate);
        }
		/** @private */
        arcane function internalAddOwnSession(object:Object3D):void
        {
        	object.addEventListener(Object3DEvent.SESSION_UPDATED, onObjectSessionUpdate);
        }
		/** @private */
        arcane function internalRemoveOwnSession(object:Object3D):void
        {
        	object.removeEventListener(Object3DEvent.SESSION_UPDATED, onObjectSessionUpdate);
        }
        
		private var _renderers:Dictionary = new Dictionary(true);
		private var _renderer:IPrimitiveConsumer;
        private var _session:AbstractRenderSession;
        private var _sessionupdated:SessionEvent;
        private var a:Number;
        private var b:Number;
        private var c:Number;
        private var d:Number;
        private var tx:Number;
        private var ty:Number;
        private var v0x:Number;
        private var v0y:Number;
        private var v1x:Number;
        private var v1y:Number;
        private var v2x:Number;
        private var v2y:Number;       
        private var a2:Number;
        private var b2:Number;
        private var c2:Number;
        private var d2:Number;
		private var m:Matrix = new Matrix();
        private var cont:Shape;
        private var ds:DisplayObject;
        private var time:int;
        private var materials:Dictionary;
        private var primitive:DrawPrimitive;
        private var triangle:DrawTriangle;
        
        private function onObjectSessionUpdate(object:Object3DEvent):void
        {
        	notifySessionUpdate();
        }
        
        protected function onSessionUpdate(event:SessionEvent):void
        {
        	dispatchEvent(event);
        }
        
		/** @private */
        protected var i:int;
        
        public var parent:AbstractRenderSession;
        
        public var updated:Boolean;
        
        public var primitives:Array;
        
        /**
        * Placeholder for filters property of containers
        */
        public var filters:Array;
        
        /**
        * Placeholder for alpha property of containers
        */
        public var alpha:Number = 1;
        
        /**
        * Placeholder for blendMode property of containers
        */
        public var blendMode:String;
        
        /**
        * Array of child sessions.
        */
       	public var sessions:Array;
       	
       	/**
       	 * Dictionary of sprite layers for rendering composite materials.
       	 * 
       	 * @see away3d.materials.CompositeMaterial#renderTriangle()
       	 */
       	public var spriteLayers:Array = new Array();
       	
       	/**
       	 * Holds the last added layer sprite.
       	 */
       	public var newLayer:Sprite;
       			
		/**
		 * Dictionary of child displayobjects.
		 */
		public var children:Dictionary = new Dictionary(true);
        
        /**
        * Reference to the current graphics object being used for drawing.
        */
        public var graphics:Graphics;
        
        public var priconsumers:Dictionary = new Dictionary(true);
        
        public var consumer:IPrimitiveConsumer;
		
		public function get renderer():IPrimitiveConsumer
		{
			return _renderer;
		}
		
		public function set renderer(val:IPrimitiveConsumer):void
		{
			if (_renderer == val)
				return;
			
			_renderer = val;
			
			clearRenderers();
			
			for each (_session in sessions)
				_session.clearRenderers();
		}
        
		/**
		 * Adds a session as a child of the session object.
		 * 
		 * @param	session		The session object to be added as a child.
		 */
        public function addChildSession(session:AbstractRenderSession):void
        {
        	if (sessions.indexOf(session) != -1)
        		return;
        	
        	sessions.push(session);
        	session.addOnSessionUpdate(onSessionUpdate);
        	session.parent = this;
        }
        
		/**
		 * Removes a child session of the session object.
		 * 
		 * @param	session		The session object to be removed.
		 */
        public function removeChildSession(session:AbstractRenderSession):void
        {
        	session.removeOnSessionUpdate(onSessionUpdate);
        	
        	var index:int = sessions.indexOf(session);
            if (index == -1)
                return;
            
            sessions.splice(index, 1);	
        }
        
        public function clearChildSessions():void
        {
        	for each (_session in sessions)
        		_session.removeOnSessionUpdate(onSessionUpdate);
        		
        	sessions = new Array();
        }
        
       	/**
       	 * Creates a new render layer for rendering composite materials.
       	 * 
       	 * @see away3d.materials.CompositeMaterial#renderTriangle()
       	 */
        protected function createLayer():void
        {
			throw new Error("Not implemented");
        }
        
		/**
		 * Returns a display object representing the container for the specified view.
		 * 
		 * @param	view	The view object being rendered.
		 * @return			The display object container.
		 */
		public function getContainer(view:View3D):DisplayObject
		{
			throw new Error("Not implemented");
		}
		
		public function getConsumer(view:View3D):IPrimitiveConsumer
		{
			if (_renderers[view])
				return _renderers[view];
			
			if (_renderer)
				return _renderers[view] = _renderer.clone();
			
			if (parent)
				return _renderers[view] = parent.getConsumer(view).clone();
			
			return _renderers[view] = (view.renderer as IPrimitiveConsumer).clone();
		}
		
        public function getTotalFaces(view:View3D):int
        {
        	var output:int = getConsumer(view).list().length;
			
			for each (_session in sessions)
				output += _session.getTotalFaces(view);
				
			return output;
        }
        
		/**
		 * Clears the render session.
		 */
        public function clear(view:View3D):void
        {
        	updated = view.updated || view.forceUpdate || view.scene.updatedSessions[this];
			
        	for each(_session in sessions)
       			_session.clear(view);
        	
			if (updated) {
	        	for each (var sprite:Sprite in spriteLayers) {
	        		sprite.graphics.clear();
	        		if (sprite.numChildren) {
	        			var i:int = sprite.numChildren;
	        			while (i--) {
	        				ds = sprite.getChildAt(i);
	        				if (ds is Shape)
	        					(ds as Shape).graphics.clear();
	        			}
	        		}
	        	}
	        	
	        	//clear child canvases
	            i = doActive.length;
	            while (i--) {
	            	cont = doActive.pop();
	            	cont.graphics.clear();
	            	doStore.push(cont);
	            }
	            
	            //clear primitives consumer
	            getConsumer(view).clear(view);
			}
        }
        
        public function render(view:View3D):void
        {
	        //index -= priconsumer.length;
        	for each(_session in sessions)
       			_session.render(view);
       		
        	if (updated)
	            (getConsumer(view) as IRenderer).render(view);
        }
        
        public function clearRenderers():void
        {
        	_renderers = new Dictionary(true);
        }
        
        /**
        * Adds a display object to the render session display list.
        * 
        * @param	child	The display object to add.
        */
        public function addDisplayObject(child:DisplayObject):void
        {
        	throw new Error("Not implemented");
        }        
        
        /**
        * Adds a layer sprite to the render session display list.
        * Doesn't update graphics so that elements in comosite materials
        * can render in separate layers.
        * 
        * @param	child	The display object to add.
        */
        public function addLayerObject(child:Sprite):void
        {
            throw new Error("Not implemented");
        }
        
        /**
        * Draws a non-scaled bitmap into the graphics object.
        */
        public function renderBitmap(bitmap:BitmapData, v0:ScreenVertex, smooth:Boolean = false):void
        {
        	if (_layerDirty)
        		createLayer();
        	
        	m.identity();
        	m.tx = v0.x-bitmap.width/2; m.ty = v0.y-bitmap.height/2;
            graphics.lineStyle();
            graphics.beginBitmapFill(bitmap, m, false,smooth);
            graphics.drawRect(v0.x-bitmap.width/2, v0.y-bitmap.height/2, bitmap.width, bitmap.height);
            graphics.endFill();
        }
        
        /**
         * Draws a bitmap with a precalculated matrix into the graphics object.
         */
        public function renderScaledBitmap(primitive:DrawScaledBitmap, bitmap:BitmapData, mapping:Matrix, smooth:Boolean = false):void
        {
        	if (_layerDirty)
        		createLayer();
        	
            if (primitive.rotation != 0) {           
	            graphics.beginBitmapFill(bitmap, mapping, false, smooth);
	            graphics.moveTo(primitive.topleft.x, primitive.topleft.y);
	            graphics.lineTo(primitive.topright.x, primitive.topright.y);
	            graphics.lineTo(primitive.bottomright.x, primitive.bottomright.y);
	            graphics.lineTo(primitive.bottomleft.x, primitive.bottomleft.y);
	            graphics.lineTo(primitive.topleft.x, primitive.topleft.y);
	            graphics.endFill();
            } else {
	            graphics.beginBitmapFill(bitmap, mapping, false, smooth);	            
	            graphics.drawRect(primitive.minX, primitive.minY, primitive.maxX-primitive.minX, primitive.maxY-primitive.minY);
            	graphics.endFill();
            }
        }
        
        /**
         * Draws a segment element into the graphics object.
         */
        public function renderLine(v0:ScreenVertex, v1:ScreenVertex, width:Number, color:uint, alpha:Number):void
        {
        	if (_layerDirty)
        		createLayer();
        	
            graphics.lineStyle(width, color, alpha);
            graphics.moveTo(v0.x, v0.y);
            graphics.lineTo(v1.x, v1.y);
        }
        
        /**
         * Draws a triangle element with a bitmap texture into the graphics object.
         */
        public function renderTriangleBitmap(bitmap:BitmapData, map:Matrix, v0:ScreenVertex, v1:ScreenVertex, v2:ScreenVertex, smooth:Boolean, repeat:Boolean, layerGraphics:Graphics = null):void
        {
        	if (_layerDirty)
        		createLayer();
        	
        	a2 = (v1x = v1.x) - (v0x = v0.x);
        	b2 = (v1y = v1.y) - (v0y = v0.y);
        	c2 = (v2x = v2.x) - v0x;
        	d2 = (v2y = v2.y) - v0y;
        	
			m.a = (a = map.a)*a2 + (b = map.b)*c2;
			m.b = a*b2 + b*d2;
			m.c = (c = map.c)*a2 + (d = map.d)*c2;
			m.d = c*b2 + d*d2;
			m.tx = (tx = map.tx)*a2 + (ty = map.ty)*c2 + v0x;
			m.ty = tx*b2 + ty*d2 + v0y;
			
			if (layerGraphics) {
				layerGraphics.lineStyle();
	            layerGraphics.moveTo(v0x, v0y);
	            layerGraphics.beginBitmapFill(bitmap, m, repeat, smooth && (v0x*(d2 - b2) - v1x*d2 + v2x*b2 > 400));
	            layerGraphics.lineTo(v1x, v1y);
	            layerGraphics.lineTo(v2x, v2y);
	            layerGraphics.endFill();
	  		} else {
	  			graphics.lineStyle();
	            graphics.moveTo(v0x, v0y);       
	            graphics.beginBitmapFill(bitmap, m, repeat, smooth && (v0x*(d2 - b2) - v1x*d2 + v2x*b2 > 400));
	            graphics.lineTo(v1x, v1y);
	            graphics.lineTo(v2x, v2y);
	            graphics.endFill();
	  		}
        }
        
        /**
         * Draws a triangle element with a fill color into the graphics object.
         */
        public function renderTriangleColor(color:int, alpha:Number, v0:ScreenVertex, v1:ScreenVertex, v2:ScreenVertex):void
        {
        	if (_layerDirty)
        		createLayer();
        	     	
            graphics.lineStyle();
            graphics.moveTo(v0.x, v0.y); // Always move before begin will to prevent bugs
            graphics.beginFill(color, alpha);
            graphics.lineTo(v1.x, v1.y);
            graphics.lineTo(v2.x, v2.y);
            graphics.endFill();
        }
        
        /**
         * Draws a wire triangle element into the graphics object.
         */
        public function renderTriangleLine(width:Number, color:int, alpha:Number, v0:ScreenVertex, v1:ScreenVertex, v2:ScreenVertex):void
        {
        	if (_layerDirty)
        		createLayer();
        	
            graphics.lineStyle(width, color, alpha);
            graphics.moveTo(v0x = v0.x, v0y = v0.y);
            graphics.lineTo(v1.x, v1.y);
            graphics.lineTo(v2.x, v2.y);
            graphics.lineTo(v0x, v0y);
        }
        
        /**
         * Draws a wire triangle element with a fill color into the graphics object.
         */
        public function renderTriangleLineFill(width:Number, color:int, alpha:Number, wirecolor:int, wirealpha:Number, v0:ScreenVertex, v1:ScreenVertex, v2:ScreenVertex):void
        {
        	if (_layerDirty)
        		createLayer();
        	
            if (wirealpha > 0)
                graphics.lineStyle(width, wirecolor, wirealpha);
            else
                graphics.lineStyle();
    
            graphics.moveTo(v0.x, v0.y);

            if (alpha > 0)
                graphics.beginFill(color, alpha);
    
            graphics.lineTo(v1.x, v1.y);
            graphics.lineTo(v2.x, v2.y);
    
            if (wirealpha > 0)
                graphics.lineTo(v0.x, v0.y);
    
            if (alpha > 0)
                graphics.endFill();
        }
        
        /**
         * Draws a fog element into the graphics object.
         */
        public function renderFogColor(clip:Clipping, color:int, alpha:Number):void
        {
        	if (_layerDirty)
        		createLayer();
        	
        	graphics.lineStyle();
            graphics.beginFill(color, alpha);
            graphics.drawRect(clip.minX, clip.minY, clip.maxX - clip.minX, clip.maxY - clip.minY);
            graphics.endFill();
        }
		
		/**
		 * Duplicates the render session's properties to another render session.
		 * 
		 * @return						The new render session instance with duplicated properties applied
		 */
        public function clone():AbstractRenderSession
        {
        	throw new Error("Not implemented");
        }
		
		/**
		 * Default method for adding a sessionUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function addOnSessionUpdate(listener:Function):void
        {
            addEventListener(SessionEvent.SESSION_UPDATED, listener, false, 0, false);
        }
		
		/**
		 * Default method for removing a sessionUpdated event listener
		 * 
		 * @param	listener		The listener function
		 */
        public function removeOnSessionUpdate(listener:Function):void
        {
            removeEventListener(SessionEvent.SESSION_UPDATED, listener, false);
        }
	}
}