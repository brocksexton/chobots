package com.kavalok.gameMoney
{
	import com.kavalok.Global;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.SinglePlayerGame;
	import com.kavalok.utils.GraphUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameStage extends SinglePlayerGame
	{
		static public var info:LevelInfo = new LevelInfo();
		
		private var _stage:McGame = new McGame();
		private var _panelView:PanelView;
		
		private var _columns:/*Array*/Array = [];
		private var _selection:/*Cell*/Array = [];
		
		private var _rowCount:int = Config.ROW_COUNT;
		private var _colCount:int = Config.COL_COUNT;
		private var _numTypes:int;
		private var _selectionFilters:Array;
		private var _progress:Number = 0;
		private var _cellsCount:int = 0;
		private var _cellsTotal:int = 0;
		private var _moveCounter:int;
		private var _frameCounter:int = 0;
		private var _actionEnabled:Boolean;
		private var _stars:Stars;
		
		private var _coinSounds:Array = [g_coin1, g_coin2, g_coin3];
		
		public function GameStage()
		{
			initialize(_stage);
			
			_numTypes = info.numTypes;
			_frameCounter = info.time;
			
			_stars = new Stars(_stage);
			_stars.events = events;
			_stars.create();
			
			_selectionFilters = _stage.mcCell.filters;
			_stage.removeChild(_stage.mcCell);
			_stage.mcField.mcBg.gotoAndStop(_numTypes);
			_stage.mcField.mcBg.btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
			_stage.mcField.mcBg.btnPlay.visible = (_numTypes <= Config.MONEY_TYPES.length);
			
			_panelView = new PanelView(_stage.mcControlPanel);
			_panelView.dropEvent.addListener(onDropClick);
			_panelView.dropEnabled = false;
			_panelView.time = _frameCounter;
			updatePanel();
		}
		
		override public function start():void
		{
			_actionEnabled = true;
		}
		
		private function onDropClick(e:Event):void
		{
			if (_actionEnabled)
				dropCells();
		}
		
		private function onEnterFrame(e:Event):void
		{
			_panelView.time = _frameCounter++;
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			Global.playSound(next_level);
			_stage.mcField.mcBg.visible = false;
			_panelView.dropEnabled = true;
			_stars.destroy();
			
			createField();
			updateField();
			updatePanel();
			
			events.registerEvent(_stage, Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createField():void
		{
			_columns = [];
			
			for (var j:int = 0; j < _colCount; j++)
			{
				_columns[j] = [];
				
				for (var i:int = 0; i < _rowCount; i++)
				{
					_cellsTotal++;
					
					var typeNum:int = int(Math.random() * _numTypes);
					
					createCell(j, typeNum);
				}
			}
		}
		
		private function createCell(j:int, typeNum:int):Cell
		{
			_cellsCount++;
			
			var cell:Cell = new Cell(typeNum, events);
			cell.selectionFilters = _selectionFilters;
			cell.maxY = _stage.mcBackground.height + cell.content.height;
			cell.col = j;
			cell.row = _columns[j].length;
			
			cell.overHandler = onCellOver;
			cell.outHandler = onCellOut;
			cell.pressHandler = onCellPress;
			cell.destroyHandler = onCellDestroy;
			
			_columns[j].push(cell);
			_stage.mcField.addChild(cell.content);
			
			return cell;
		}
		
		private function onCellDestroy(cell:Cell):void
		{
			_stage.mcField.removeChild(cell.content);
			_cellsCount--;
			updatePanel();
			
			if (_cellsCount == 0) // || true
			{
				finishLevel();
			}
		}
		
		private function dropCells(e:Event = null):void
		{
			var types:Array = getExistingTypes();
			
			var state:int = 0;
			
			for (var j:int = 0; j < _columns.length; j++)
			{
				var flag:Boolean;
				
				if (state == 0)
				{
					if (_columns[j + 1].length > 0)
					{
						state = 1;
					}
					else
					{
						continue;
					}
				}
				else if (state == 1)
				{
					if (_columns[j].length == 0)
					{
						state = 2;
					}
				}
				else if (state == 2)
				{
					break;
				}
				
				if (_columns[j].length < _rowCount)
				{
					var typeNum:int = int(Math.random() * types.length);
					var cell:Cell = createCell(j, types[typeNum]);
						
					cell.content.x = getX(j);
					cell.content.y = -_stage.mcField.y;
					cell.endY = getY(cell.row);
					cell.moveCompleteHandler = onDropComplete;
					_moveCounter++;
					cell.moveDown();
				}
			}
			
			updatePanel();
		}
		
		private function getExistingTypes():Array
		{
			var types:Array = [];
			
			for each (var column:Array in _columns)
			{
				for each (var cell:Cell in column)
				{
					if (types.indexOf(cell.type) == -1)
					{
						types.push(cell.type);
					}
				}
			}
			
			return types;
		}
		
		private function onDropComplete(cell:Cell):void
		{
			if (--_moveCounter == 0)
			{
				finishAction();
			}
		}
		
		private function onCellOver(cell:Cell):void
		{
			selectRecursive(cell);
			
			if (_selection.length < Config.SELECTION_MIN)
				clearSelection();
		}
		
		private function onCellOut(cell:Cell):void
		{
			clearSelection();
		}
		
		private function onCellPress(cell:Cell):void
		{
			if (_selection.length > 0)
			{
				playCoinSound();
				destroySelection();
			}
			else
			{
				
			}
		}
		
		private function playCoinSound():void
		{
			var soundClass:Class = Class(_coinSounds[int(Math.random() * _coinSounds.length)]);
			Global.playSound(soundClass);
		}
		
		private function clearSelection():void
		{
			for each (var cell:Cell in _selection)
			{
				cell.selected = false;
			}
			
			_selection = [];
		}
		
		private function destroySelection():void
		{
			var processColumns:Object = {};
			
			for each (var cell:Cell in _selection)
			{
				_columns[cell.col][cell.row] = null;
				processColumns[cell.col] = _columns[cell.col];
				cell.doDestroyAction();
			}
			
			_selection = [];
			
			_moveCounter = 0;
			
			disableActions();
			
			for each (var column:Array in processColumns)
			{
				compactCells(column);
			}
			
			if (_moveCounter == 0)
			{
				compactColumns();
			}
			
			updatePanel();
		}
		
		private function compactCells(column:Array):void
		{
			var i:int = 0;
			
			while (i < column.length)
			{
				var cell:Cell = column[i];
				
				if (cell == null)
				{
					column.splice(i, 1);
				}
				else
				{
					if (cell.row != i)
					{
						_moveCounter++;
						cell.row = i;
						cell.endY = getY(cell.row);
						cell.moveCompleteHandler = onMoveDownComplete;
						cell.moveDown();
					}
					
					i++;
				}
			}
		}
		
		private function onMoveDownComplete(cell:Cell):void
		{
			if (--_moveCounter == 0)
			{
				compactColumns();
			}
		}
		
		private function compactColumns():void
		{
			var j:int = 0;
			
			while (j < _columns.length)
			{
				var column:Array = _columns[j];
				
				if (column.length == 0)
					_columns.splice(j, 1)
				else
					j++;
			}
			
			var flag:Boolean = false;
			while (_columns.length < _colCount)
			{
				flag = !flag;
				
				if (flag)
					_columns.splice(0, 0, [])
				else
					_columns.splice(_columns.length, 0, []);
			}
			
			finishAction();
		}
		
		private function finishAction():void
		{
			updateField();
			
			if (noMoreActions())
			{
				dropCells();
			}
			else
			{
				enableActions();
			}
		}
		
		private function selectRecursive(cell:Cell):void
		{
			_selection.push(cell);
			cell.selected = true;
			
			var nextCell:Cell;
			
			nextCell = getLeft(cell);
			if (nextCell && nextCell.type == cell.type && !nextCell.selected)
					selectRecursive(nextCell);
			
			nextCell = getRight(cell);
			if (nextCell && nextCell.type == cell.type && !nextCell.selected)
					selectRecursive(nextCell);
			
			nextCell = getUp(cell);
			if (nextCell && nextCell.type == cell.type && !nextCell.selected)
					selectRecursive(nextCell);
			
			nextCell = getDown(cell);
			if (nextCell && nextCell.type == cell.type && !nextCell.selected)
					selectRecursive(nextCell);
		}
		
		//{ region getCells
		
		private function getLeft(cell:Cell):Cell
		{
			if (cell.col > 0 && _columns[cell.col - 1].length > cell.row)
				return _columns[cell.col - 1][cell.row]
			else
				return null;
		}
		
		private function getRight(cell:Cell):Cell
		{
			if (cell.col < _columns.length - 1 && _columns[cell.col + 1].length > cell.row)
				return _columns[cell.col + 1][cell.row]
			else
				return null;
		}
		
		private function getUp(cell:Cell):Cell
		{
			if (cell.row < _columns[cell.col].length - 1)
				return _columns[cell.col][cell.row + 1]
			else
				return null;
		}
		
		private function getDown(cell:Cell):Cell
		{
			if (cell.row > 0)
				return _columns[cell.col][cell.row - 1]
			else
				return null;
		}
		
		//} endregion
		
		private function updateField():void
		{
			for (var j:int = 0; j < _columns.length; j++)
			{
				for (var i:int = 0; i < _columns[j].length; i++)
				{
					var cell:Cell = _columns[j][i];
					cell.row = i;
					cell.col = j;
					cell.content.x = getX(cell.col);
					cell.content.y = getY(cell.row);
				}
			}
		}
		
		private function noMoreActions():Boolean
		{
			var flag:Boolean = false;
			
			for (var j:int = 0; j < _columns.length; j++)
			{
				for each (var cell:Cell in _columns[j])
				{
					flag = true;
					
					var numCells:int = 1;
					var nextCell:Cell;
					
					nextCell = getLeft(cell);
					if (nextCell && nextCell.type == cell.type)
						numCells++;
					
					nextCell = getRight(cell);
					if (nextCell && nextCell.type == cell.type)
						numCells++;
					
					nextCell = getUp(cell);
					if (nextCell && nextCell.type == cell.type)
						numCells++;
					
					nextCell = getDown(cell);
					if (nextCell && nextCell.type == cell.type)
						numCells++;
						
					if (numCells >= Config.SELECTION_MIN)
						return false;
				}
			}
			
			return flag;
		}
		
		private function updatePanel():void
		{
			_panelView.progress = 1 - _cellsCount / _cellsTotal;
		}
		
		private function getX(col:int):Number
		{
			return (col + 0.5 - 0.5 * _columns.length) * Config.CELL_SPACE
		}
		
		private function getY(row:int):Number
		{
			return - (row + 0.5) * Config.CELL_SPACE
		}
		
		private function enableActions():void
		{
			_actionEnabled = true;
			GraphUtils.enableMouse(_stage.mcField);
		}
		
		private function disableActions():void
		{
			_actionEnabled = false;
			GraphUtils.disableMouse(_stage.mcField);
		}
		
		private function finishLevel():void
		{
			info = new LevelInfo();
			
			var money:int = Config.MONEY_VALUE[_numTypes];
			new AddMoneyCommand(money, Competitions.COINS, true).execute();
			Global.addExperience(1);
			trace("coin rain value: " + _numTypes);
			
			info.numTypes = _numTypes + 1;
				
			info.time = _frameCounter;
			
			replayEvent.sendEvent();
		}
		
	}
	
}