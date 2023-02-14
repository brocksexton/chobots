package com.kavalok.home
{
	import com.kavalok.Global;
	import com.kavalok.dto.stuff.StuffItemLightTO;
	import com.kavalok.dto.stuff.StuffTOBase;
	import com.kavalok.interfaces.ICommand;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;

	public class LoadFurnitureCommand implements ICommand
	{
		private static const DRAG_CLASS_NAME : String = "McDrag";
		
		private var _location : HomeLocation;
		private var _item : StuffItemLightTO;
		
		public function LoadFurnitureCommand(location : HomeLocation, item : StuffItemLightTO)
		{
			_location = location;
			_item = item;
		}

		public function execute():void
		{
			Global.classLibrary.callbackOnReady(onLoad, [_item.url]);
		}
		
		private function onLoad() : void
		{
			var furniture : MovieClip = MovieClip(Global.classLibrary.getInstance(_item.url, StuffTOBase.MODEL_CLASS_NAME));
			var drag : MovieClip = MovieClip(Global.classLibrary.getInstance(_item.url, DRAG_CLASS_NAME));
			if(drag == null)
			{
				drag = MovieClip(Global.classLibrary.getInstance(_item.url, StuffTOBase.MODEL_CLASS_NAME));
				GraphUtils.hideConfigs(drag);
			}
			_location.addFurnitureObject(_item, furniture, drag);
		}
		
		
	}
}