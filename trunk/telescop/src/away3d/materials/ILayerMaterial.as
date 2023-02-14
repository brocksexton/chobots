package away3d.materials
{
    import away3d.core.base.*;
    import away3d.core.draw.*;
    import away3d.core.utils.*;
    
    import flash.display.*;
    import flash.geom.*;
	
    /**
    * Interface for materials that can be layered using <code>CompositeMaterial</code> or <code>BitmapMaterialContainer</code>.
    * 
    * @see away3d.materials.CompositeMaterial
    * @see away3d.materials.BitmapMaterialContainer
    */
    public interface ILayerMaterial extends IMaterial
    {
    	/**
    	 * Renders a bitmapData surface object for the speficied face.
    	 * 
    	 * @param	face			The face object onto which the rendered sufrace is applied.
    	 * @param	containerRect	The rectangle object defining the bounds of the face in uv-space.
    	 * @param	parentFaceVO	The value object of the preceeding surface.
    	 * 
    	 * @see away3d.materials.BitmapMaterailContainer
    	 */
        function renderBitmapLayer(tri:DrawTriangle, containerRect:Rectangle, parentFaceVO:FaceVO):FaceVO;
        
        /**
        * Renders a material layer for the specified triangle.
        * 
    	 * @param	tri				The drawtriangle used for render information.
    	 * @param	layer			The parent layer into which the triangle is drawn.
    	 * @param	parentFaceVO	Defines the sprite level for the layer.
    	 */
        function renderLayer(tri:DrawTriangle, layer:Sprite, level:int):void;
    }
}
