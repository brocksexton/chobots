package away3d.core.light
{
	import away3d.containers.*;
	import away3d.core.*;
	import away3d.core.base.*;
	import away3d.core.math.*;
	import away3d.events.*;
	import away3d.lights.*;
	
	import flash.display.*;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.*;
	import flash.utils.Dictionary;

    /**
    * Directional light primitive.
    */
    public class DirectionalLight extends LightPrimitive
    {
    	use namespace arcane;
    	
        private var _colorMatrix:ColorMatrixFilter = new ColorMatrixFilter();
        private var _normalMatrix:ColorMatrixFilter = new ColorMatrixFilter();
    	private var _matrix:Matrix = new Matrix();
    	private var _shape:Shape = new Shape();
        private var quaternion:Quaternion = new Quaternion();
        private var invTransform:Matrix3D = new Matrix3D();
    	private var transform:Matrix3D = new Matrix3D();
    	private var nx:Number;
    	private var ny:Number;
    	private var mod:Number;
        private var cameraTransform:Matrix3D;
        private var cameraDirection:Number3D = new Number3D();
        private var halfVector:Number3D = new Number3D();
        private var halfQuaternion:Quaternion = new Quaternion();
        private var halfTransform:Matrix3D = new Matrix3D();
        private var _red:Number;
		private var _green:Number;
		private var _blue:Number;
        private var _szx:Number;
        private var _szy:Number;
        private var _szz:Number;
		
        private var direction:Number3D = new Number3D();
        
        /**
        * Transform dictionary for the diffuse lightmap used by shading materials.
        */
        public var diffuseTransform:Dictionary;
        
        /**
        * Transform dictionary for the specular lightmap used by shading materials.
        */
        public var specularTransform:Dictionary;
        
        /**
        * Color transform used in cached shading materials for combined ambient and diffuse color intensities.
        */
        public var ambientDiffuseColorTransform:ColorTransform;
        
        /**
        * Color transform used in cached shading materials for ambient intensities.
        */
        public var diffuseColorTransform:ColorTransform;
        
        /**
        * Colormatrix transform used in DOT3 materials for resolving color in the normal map.
        */
        public var colorMatrixTransform:Dictionary = new Dictionary(true);
        
        /**
        * Colormatrix transform used in DOT3 materials for resolving normal values in the normal map.
        */
        public var normalMatrixTransform:Dictionary = new Dictionary(true);
        
    	/**
    	 * A reference to the <code>DirectionalLight3D</code> object used by the light primitive.
    	 */
        public var light:DirectionalLight3D;
        
        /**
        * Updates the bitmapData object used as the lightmap for ambient light shading.
        * 
        * @param	ambient		The coefficient for ambient light intensity.
        */
		public function updateAmbientBitmap(ambient:Number):void
        {
        	this.ambient = ambient;
        	ambientBitmap = new BitmapData(256, 256, false, int(ambient*red << 16) | int(ambient*green << 8) | int(ambient*blue));
        	ambientBitmap.lock();
        }
        
        /**
        * Updates the bitmapData object used as the lightmap for diffuse light shading.
        * 
        * @param	diffuse		The coefficient for diffuse light intensity.
        */
        public function updateDiffuseBitmap(diffuse:Number):void
        {
        	this.diffuse = diffuse;
    		diffuseBitmap = new BitmapData(256, 256, false, 0x000000);
    		diffuseBitmap.lock();
    		_matrix.createGradientBox(256, 256, 0, 0, 0);
    		var colArray:Array = new Array();
    		var alphaArray:Array = new Array();
    		var pointArray:Array = new Array();
    		var i:int = 15;
    		while (i--) {
    			var r:Number = (i*diffuse/14);
    			if (r > 1) r = 1;
    			var g:Number = (i*diffuse/14);
    			if (g > 1) g = 1;
    			var b:Number = (i*diffuse/14);
    			if (b > 1) b = 1;
    			colArray.push((r*red << 16) | (g*green << 8) | b*blue);
    			alphaArray.push(1);
    			pointArray.push(int(30+225*2*Math.acos(i/14)/Math.PI));
    		}
    		_shape.graphics.clear();
    		_shape.graphics.beginGradientFill(GradientType.LINEAR, colArray, alphaArray, pointArray, _matrix);
    		_shape.graphics.drawRect(0, 0, 256, 256);
    		diffuseBitmap.draw(_shape);
        	
        	//update colortransform
        	diffuseColorTransform = new ColorTransform(diffuse*red/255, diffuse*green/255, diffuse*blue/255, 1, 0, 0, 0, 0);
        }
        
        /**
        * Updates the bitmapData object used as the lightmap for the combined ambient and diffue light shading.
        * 
        * @param	ambient		The coefficient for ambient light intensity.
        * @param	diffuse		The coefficient for diffuse light intensity.
        */
        public function updateAmbientDiffuseBitmap(ambient:Number, diffuse:Number):void
        {
        	this.diffuse = diffuse;
    		ambientDiffuseBitmap = new BitmapData(256, 256, false, 0x000000);
    		ambientDiffuseBitmap.lock();
    		_matrix.createGradientBox(256, 256, 0, 0, 0);
    		var colArray:Array = new Array();
    		var alphaArray:Array = new Array();
    		var pointArray:Array = new Array();
    		var i:int = 15;
    		while (i--) {
    			var r:Number = (i*diffuse/14 + ambient);
    			if (r > 1) r = 1;
    			var g:Number = (i*diffuse/14 + ambient);
    			if (g > 1) g = 1;
    			var b:Number = (i*diffuse/14 + ambient);
    			if (b > 1) b = 1;
    			colArray.push((r*red << 16) | (g*green << 8) | b*blue);
    			alphaArray.push(1);
    			pointArray.push(int(30+225*2*Math.acos(i/14)/Math.PI));
    		}
    		_shape.graphics.clear();
    		_shape.graphics.beginGradientFill(GradientType.LINEAR, colArray, alphaArray, pointArray, _matrix);
    		_shape.graphics.drawRect(0, 0, 256, 256);
    		ambientDiffuseBitmap.draw(_shape);
        	
        	//update colortransform
        	ambientDiffuseColorTransform = new ColorTransform(diffuse*red/255, diffuse*green/255, diffuse*blue/255, 1, ambient*red, ambient*green, ambient*blue, 0);
        }
        
        /**
        * Updates the bitmapData object used as the lightmap for specular light shading.
        * 
        * @param	specular		The coefficient for specular light intensity.
        */
        public function updateSpecularBitmap(specular:Number):void
        {
        	this.specular = specular;
    		specularBitmap = new BitmapData(512, 512, false, 0x000000);
    		specularBitmap.lock();
    		_matrix.createGradientBox(512, 512, 0, 0, 0);
    		var colArray:Array = new Array();
    		var alphaArray:Array = new Array();
    		var pointArray:Array = new Array();
    		var i:int = 15;
    		while (i--) {
    			colArray.push((i*specular*red/14 << 16) + (i*specular*green/14 << 8) + i*specular*blue/14);
    			alphaArray.push(1);
    			pointArray.push(int(30+225*2*Math.acos(Math.pow(i/14,1/20))/Math.PI));
    		}
    		_shape.graphics.clear();
    		_shape.graphics.beginGradientFill(GradientType.RADIAL, colArray, alphaArray, pointArray, _matrix);
    		_shape.graphics.drawCircle(255, 255, 255);
    		specularBitmap.draw(_shape);
        }
        
        /**
        * Clears the transform and matrix dictionaries used in the shading materials.
        */
        public function clearTransform():void
        {
        	diffuseTransform = new Dictionary(true);
        	specularTransform = new Dictionary(true);
        	colorMatrixTransform = new Dictionary(true);
        	normalMatrixTransform = new Dictionary(true);
        }
		
    	/**
    	 * Updates the direction vector of the directional light.
    	 */
        public function updateDirection(e:Object3DEvent):void
        {
        	//update direction vector
        	direction.x = light.x;
        	direction.y = light.y;
        	direction.z = light.z;
        	direction.normalize();
        	
        	nx = direction.x;
        	ny = direction.y;
        	mod = Math.sqrt(nx*nx + ny*ny);
        	transform.rotationMatrix(ny/mod, -nx/mod, 0, -Math.acos(-direction.z));
        	clearTransform();
        }
        
        /**
        * Updates the transform matrix for the diffuse lightmap.
        * 
        * @see diffuseTransform
        */
        public function setDiffuseTransform(source:Object3D):void
        {
        	if (!diffuseTransform[source])
        		diffuseTransform[source] = new Matrix3D();
        	
        	diffuseTransform[source].multiply3x3(transform, source.sceneTransform);
        	diffuseTransform[source].normalize(diffuseTransform[source]);
        }
        
        /**
        * Updates the transform matrix for the specular lightmap.
        * 
        * @see specularTransform
        */
        public function setSpecularTransform(source:Object3D, view:View3D):void
        {
			//find halfway matrix between camera and direction matricies
			cameraTransform = view.camera.transform;
			cameraDirection.x = -cameraTransform.sxz;
			cameraDirection.y = -cameraTransform.syz;
			cameraDirection.z = -cameraTransform.szz;
			halfVector.add(cameraDirection, direction);
			halfVector.normalize();
			
			nx = halfVector.x;
        	ny = halfVector.y;
        	mod = Math.sqrt(nx*nx + ny*ny);
        	halfTransform.rotationMatrix(-ny/mod, nx/mod, 0, Math.acos(-halfVector.z));
			
			if (!specularTransform[source][view])
				specularTransform[source][view] = new Matrix3D();
				
        	specularTransform[source][view].multiply3x3(halfTransform, source.sceneTransform);
        	specularTransform[source][view].normalize(specularTransform[source][view]);
        }
        
        /**
        * Updates the color transform matrix.
        * 
        * @see colorMatrixTransform
        */
        public function setColorMatrixTransform(source:Object3D):void
        {
        	_red = red/127;
			_green = green/127;
			_blue = blue/127;
        	_colorMatrix.matrix = [_red, _red, _red, 0, -381*_red, _green, _green, _green, 0, -381*_green, _blue, _blue, _blue, 0, -381*_blue, 0, 0, 0, 1, 0];
        	colorMatrixTransform[source] = _colorMatrix.clone();
        }
        
        /**
        * Updates the normal transform matrix.
        * 
        * @see normalMatrixTransform
        */
        public function setNormalMatrixTransform(source:Object3D):void
        {
        	_szx = diffuseTransform[source].szx;
			_szy = diffuseTransform[source].szy;
			_szz = diffuseTransform[source].szz;
        	_normalMatrix.matrix = [_szx, 0, 0, 0, 127 - _szx*127, 0, -_szy, 0, 0, 127 + _szy*127, 0, 0, _szz, 0, 127 - _szz*127, 0, 0, 0, 1, 0];
        	normalMatrixTransform[source] = _normalMatrix.clone();
        }
    }
}

