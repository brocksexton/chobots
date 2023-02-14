package com.kavalok.gameChess.view
{
	import com.kavalok.char.Char;
	import com.kavalok.char.CharModel;
	import com.kavalok.char.CharModels;
	import com.kavalok.gameChess.Controller;
	import com.kavalok.utils.GraphUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import gameChess.McGameWindow;
	import gameChess.McPlayerFilters;
	
	public class PlayersView extends Controller
	{
		static private const MODEL_SCALE:Number = 1.5;
		
		private var _content:McGameWindow;
		private var _models:Array = [];
		private var _activeModel:CharModel;
		private var _activeFilters:Array;
		
		public function PlayersView(content:McGameWindow)
		{
			_content = content;
			
			_activeFilters = GraphUtils.getFilters(McPlayerFilters);
			
			_content.myPosition.visible = false;
			_content.hisPosition.visible = false;
			_content.myName.text = '';
			_content.hisName.text = '';
			_content.lostGameButton.visible = false;

			
			client.playerAddEvent.addListener(onPlayerAdded);
			client.playerRemoveEvent.addListener(onPlayerRemoved);
			client.playerActivateEvent.addListener(onPlayerActivate);
			
			client.victoryEvent.addListener(onVictory);
		}
		
		private function onVictory(playerNum:int):void
		{
			_content.lostGameButton.visible = false;
			client.playerRemoveEvent.removeListener(onPlayerRemoved);
			setActiveModel(null);
			
			if (playerNum == -1)
			{
				CharModel(_models[0]).setModel(CharModels.DANCE_VICTORY);
				CharModel(_models[1]).setModel(CharModels.DANCE_VICTORY);
			}
			else
			{
				CharModel(_models[playerNum]).setModel(CharModels.DANCE_VICTORY);
			}
		}
		
		private function onPlayerAdded(playerNum:int):void
		{
			var char:Char = client.players[playerNum];
			var model:CharModel = new CharModel(char);
			model.scale = MODEL_SCALE;
			model.refresh();
			
			_content.addChild(model);
			
			var atBottom:Boolean = game.playerNum == playerNum
								|| game.playerNum == -1 && playerNum == 0;
			
			var nameField:TextField = atBottom
				? _content.myName
				: _content.hisName;
				
			var position:Sprite = atBottom
				? _content.myPosition
				: _content.hisPosition;
			
			nameField.text = char.id;
			GraphUtils.setCoords(model, position);
			
			_models[playerNum] = model;
		}
		
		private function onPlayerRemoved(playerNum:int):void
		{
			_content.lostGameButton.visible = false;
			GraphUtils.detachFromDisplay(_models[playerNum]);
			setActiveModel(null);
			_models[playerNum] = null;
		}
		
		private function onPlayerActivate(playerNum:int):void
		{
			setActiveModel(_models[playerNum]);
		}
		
		private function setActiveModel(model:CharModel):void
		{
			if (_activeModel)
				_activeModel.filters = [];
			
			_activeModel = model;
			
			if (_activeModel)
				_activeModel.filters = _activeFilters;
		}
		
	}
	
}