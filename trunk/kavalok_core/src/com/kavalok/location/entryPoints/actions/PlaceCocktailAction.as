package com.kavalok.location.entryPoints.actions
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.constants.StuffTypes;
	import com.kavalok.location.LocationBase;
	import com.kavalok.location.entryPoints.ChairEntryPoint;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import com.kavalok.collections.ArrayList;
	import com.kavalok.interfaces.ICommand;
	import com.kavalok.utils.comparing.PropertyComparer;

	public class PlaceCocktailAction implements ICommand
	{
		private static const ANIMATION_CLASS : String = "McAnimation";

		private var _entryPoint : ChairEntryPoint;
		private var _state : Object;
		private var _stateId : String;
		private var _location : LocationBase;
		
		public function PlaceCocktailAction(entryPoint : ChairEntryPoint, stateId : String, state : Object, location : LocationBase)
		{
			_entryPoint = entryPoint;
			_state = state;
			_location = location;
			_stateId = stateId;
		}

		public function execute():void
		{
			var model : MovieClip = MovieClip(Global.classLibrary.getInstance(URLHelper.stuffURL(_state.file,StuffTypes.COCKTAIL), ANIMATION_CLASS));
			var table : MovieClip = _location.charContainer[_state.table];
			table.cocktailsPlace.addChild(model);
			_entryPoint.registerCocktail(_stateId, model);;
			model.x = _state.x;
			model.y = _state.y;
			updateTableZOrder(table.cocktailsPlace);
		}
		
		private function updateTableZOrder(place : MovieClip):void
		{
			var cocktails : ArrayList = new ArrayList();
			for(var i : uint = 0; i < place.numChildren; i++)
			{
				var child : MovieClip = place.getChildAt(i) as MovieClip;
				if(getQualifiedClassName(child) == ANIMATION_CLASS)
				{
					cocktails.addItem(child);
				}
			}
			cocktails.sortBy(new PropertyComparer("y"));
			for each(var cocktail : MovieClip in cocktails)
			{
				place.setChildIndex(cocktail, cocktails.getItemIndex(cocktail));
			}
		}
		
	}
}