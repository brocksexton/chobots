package away3d.core.render
{
	import away3d.containers.View3D;
	import away3d.core.*;
	import away3d.core.draw.*;
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
    /**
    * Drawing session object that renders all drawing primitives into a <code>Bitmap</code> container.
    */
	public class BitmapRenderSession extends AbstractRenderSession
	{
		use namespace arcane;
		
		private var _container:Bitmap;
		private var _width:int;
		private var _height:int;
		private var _bitmapwidth:int;
		private var _bitmapheight:int;
		private var _scale:Number;
		private var _cm:Matrix;
		private var _cx:Number;
		private var _cy:Number;
		private var _base:BitmapData;
		private var mStore:Array = new Array();
		private var mActive:Array = new Array();
		private var layers:Array = [];
		private var layer:DisplayObject;
		
		/**
		 * Creates a new <code>BitmapRenderSession</code> object.
		 *
		 * @param	scale	[optional]	Defines the scale of the pixel resolution in base pixels. Default value is 2.
		 */
		public function BitmapRenderSession(scale:Number = 2)
		{
			if (_scale <= 0)
				throw new Error("scale cannot be negative or zero");
			
			_scale = scale;
        }
        
		/**
		 * @inheritDoc
		 */
		public override function getContainer(view:View3D):DisplayObject
		{
			if (!_containers[view])
        		return _containers[view] = new Bitmap();
        	
			return _containers[view];
		}
        
		/**
		 * Returns a bitmapData object containing the rendered view.
		 * 
		 * @param	view	The view object being rendered.
		 * @return			The bitmapData object.
		 */
		public function getBitmapData(view:View3D):BitmapData
		{
			_container = getContainer(view) as Bitmap;
			
			if (!_container.bitmapData) {
				_bitmapwidth = int((_width = view.clip.maxX - view.clip.minX)/_scale);
	        	_bitmapheight = int((_height = view.clip.maxY - view.clip.minY)/_scale);
	        	
	        	return _container.bitmapData = new BitmapData(_bitmapwidth, _bitmapheight, true, 0);
			}
        	
			return _container.bitmapData;
		}
        
		/**
		 * @inheritDoc
		 */
        public override function addDisplayObject(child:DisplayObject):void
        {
            //add child to layers
            layers.push(child);
            child.visible = true;
        	
			//add child to children
            children[child] = child;
            
            _layerDirty = true;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function addLayerObject(child:Sprite):void
        {
            //add child to layers
            layers.push(child);
            child.visible = true;       
            
            //add child to children
            children[child] = child;
            
            newLayer = child;
        }
        
		/**
		 * @inheritDoc
		 */
        protected override function createLayer():void
        {
            //create new canvas for remaining triangles
            if (doStore.length) {
            	_shape = doStore.pop();
            } else {
            	_shape = new Shape();
            }
            
            //update graphics reference
            graphics = _shape.graphics;
            
            //store new canvas
            doActive.push(_shape);
            
            //add new canvas to layers
            layers.push(_shape);
            
            _layerDirty = false;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function clear(view:View3D):void
        {
	        super.clear(view);
	        
        	if (updated) {
        		_container = getContainer(view) as Bitmap;
	        	_base = getBitmapData(view);
	        	
	        	_cx = _container.x = view.clip.minX;
				_cy = _container.y = view.clip.minY;
				_container.scaleX = _scale;
				_container.scaleY = _scale;
	        	
	        	_cm = new Matrix();
	        	_cm.scale(1/_scale, 1/_scale);
				_cm.translate(-view.clip.minX/_scale, -view.clip.minY/_scale);
				
	        	//clear base canvas
	        	_base.lock();
	        	_base.fillRect(_base.rect, 0);
	            
	            //remove all children
	            children = new Dictionary(true);
	            newLayer = null;
	            
	            //remove all layers
	            layers = [];
	            _layerDirty = true;
	        }
	        
        	_container.filters = filters;
        	_container.alpha = alpha || 1;
        	_container.blendMode = blendMode || BlendMode.NORMAL;
        }
        
		/**
		 * @inheritDoc
		 */
        public override function render(view:View3D):void
        {
	        super.render(view);
	        	
        	if (updated) {
	            for each (layer in layers)
	            	_base.draw(layer, _cm, layer.transform.colorTransform, layer.blendMode, _base.rect);
	           	
	           _base.unlock();
	        }
        }
        
		/**
		 * @inheritDoc
		 */
        public override function clone():AbstractRenderSession
        {
        	return new BitmapRenderSession(_scale);
        }
                
	}
}