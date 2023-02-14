package com.kavalok.kongregateLoader.utils
{
	import com.kavalok.loaders.ILoaderView;
	
	import flash.display.Sprite;

	public class LoaderViewDecorator implements ILoaderView
	{
		private var _view : ILoaderView;
		
		private var _startPercent : Number;
		private var _endPercent : Number;
		
		public function LoaderViewDecorator(view : ILoaderView, startPercent : Number, endPercent : Number)
		{
			_view = view;
			_startPercent = startPercent;
			_endPercent = endPercent;
		}

		public function set percent(value:int):void
		{
			_view.percent = _startPercent + value / 100 * (_endPercent - _startPercent);
		}
		
		public function get content():Sprite
		{
			return _view.content;
		}
		
	}
}