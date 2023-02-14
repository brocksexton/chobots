package com.kavalok.locGraphity
{
	import com.kavalok.Global;
	import com.kavalok.location.LocationBase;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	
	public class Location extends LocationBase
	{
		private var _stage:McLocation = new McLocation();
		private var _wall:WallController;
		
		public function Location(locId:String)
		{
			super(locId);
			setContent(_stage);
			
			var wallContent:Sprite = new Sprite();
			
			var wallArea:Sprite = _stage.wallArea;
			wallArea.alpha = 0;
			
			GraphUtils.optimizeSprite(_stage.background2);
			GraphUtils.optimizeSprite(_stage.texture);
			GraphUtils.attachBefore(wallContent, _stage.texture);
			
			_stage.texture.mouseEnabled = false;
			_stage.texture.mouseChildren = false;
			_stage.locCitizenEntryPoint.visible = Global.charManager.isCitizen;
			
			_wall = new WallController(locId, wallContent, wallArea, _stage.toolbar);
		}
		
		override public function destroy():void
		{
			_wall.destroy();
			super.destroy();
		}
	}
}