package com.kavalok.locGraphity
{
	import com.kavalok.Global;
	import com.kavalok.char.CharManager;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.services.AdminService;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.CitizenWarningCommand;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.graphity.LineShape;
	import com.kavalok.localization.Localiztion;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.SpriteTweaner;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WallController
	{
		static private const MAX_LENGTH:int = 7500;
		static private const MAX_LINES:int = 90000;
		
		private var _canvas:Sprite = new Sprite();
		private var _lines:Sprite = new Sprite();
		private var _wallContent:Sprite;
		private var _wallArea:Sprite;
	//	private var _clearButton:Button;
		
		private var _toolbar:ToolView;
		private var _currentLine:LineShape;
		private var _client:WallClient;
		private var _toolContent:McToolBar;
		private var _wallId:String;
//		private var _serverName:String = Global.loginManager.server;
		private var _bundle:ResourceBundle = Localiztion.getBundle(ResourceBundles.GRAPHITY);
		
		public function WallController(wallId:String, wallContent:Sprite, wallArea:Sprite, toolContent:McToolBar)
		{
			_wallId = wallId;
			_toolContent=toolContent;
			_wallContent = wallContent;
			_wallArea = wallArea;
			
			_toolbar = new ToolView(toolContent);
			_toolbar.modeChangeEvent.addListener(refreshMode);
			
			_client = new WallClient(wallId);
			_client.addLineEvent.addListener(onLineAdded);
			_client.clearEvent.addListener(onClear);
			
			_wallContent.addChild(_lines);
			_wallContent.addChild(_canvas);
			
			_lines.cacheAsBitmap = true;
			_lines.mouseEnabled = false;
			_lines.mouseChildren = false;
			
			MousePointer.registerObject(wallArea, McPaintPointer);
			
			addListeners();
			setPermission();
			
		//	_toolbar.clearButton.addEventListener(MouseEvent.CLICK, fl_ClickToHide);
			
		}
		
		public function destroy():void
		{
			removeListeners();
		}
		
	/*	private function clearWall():void
		{
			var serverName:String = Global.loginManager.server;
			new AdminService().clearGraphity(serverName, wallId);
		}*/
		
		private function addListeners():void
		{
			Global.charManager.citizenChangeEvent.addListener(setPermission);
			Global.charManager.drawEnabledChangeEvent.addListener(setPermission);
		}
		
		private function removeListeners():void
		{
			Global.charManager.citizenChangeEvent.removeListener(setPermission);
			Global.charManager.drawEnabledChangeEvent.removeListener(setPermission);
			
		}
			protected function hasItem(item:String):Boolean
			{
				return Global.charManager.stuffs.stuffExists(item);
			}
			
		//	private function fl_ClickToHide(event:MouseEvent):void
		//	{
//clearWall();
	//		}	
			
		
		private function setPermission():void
		{
			var item:String = 'brush';
			var char:CharManager = Global.charManager;
			var forCitizen:Boolean = _wallId == 'locGraphity';
			var forAgent:Boolean = _wallId == 'locGraphityA';
			var forMod:Boolean = _wallId == 'locGraphityM';
			//var serverCannotDraw:Boolean = char.serverDrawDisabled;
			var isON:Boolean = Global.graphityEnabled;
			var canDraw:Boolean = (char.isModerator || char.isArtist) && char.drawEnabled;

			_toolbar.enabled = canDraw && isON;
			_toolbar.setViewMode();
			
			if(isON != true)
			{
				ToolTips.registerObject(_toolContent, "drawingDisabled", ResourceBundles.GRAPHITY);
				_wallArea.removeEventListener(MouseEvent.MOUSE_DOWN, startDrawing);
  			    _toolContent.addEventListener(MouseEvent.CLICK, showDrawingDisabled);
			}else
			{
  			    _toolContent.removeEventListener(MouseEvent.CLICK, showDrawingDisabled);

				if (!canDraw)
				{
					ToolTips.registerObject(_toolContent, "drawingDisabled", ResourceBundles.GRAPHITY);
					_wallArea.removeEventListener(MouseEvent.MOUSE_DOWN, startDrawing);
					
					if (forCitizen)
						_toolContent.addEventListener(MouseEvent.CLICK, showCitizenPopup);
						
			
				}
				else
				{
					ToolTips.unRegisterObject(_toolContent);
					_wallArea.addEventListener(MouseEvent.MOUSE_DOWN, startDrawing);
					
					if (forCitizen)
						_toolContent.removeEventListener(MouseEvent.CLICK, showCitizenPopup);
				}
			}
		}
		
		private function showSafeModePopup(e:MouseEvent):void
		{
			Dialogs.showOkDialog(_bundle.messages.gameSafeMode);
		}
		
		private function showDrawingDisabled(e:MouseEvent):void
		{
		   Dialogs.showOkDialog("Graffiti is Disabled for now.");
		}


		private function showCitizenPopup(e:MouseEvent):void
		{
			if(Global.charManager.isGuest || Global.charManager.isNotActivated)
				new RegisterGuestCommand().execute();
			else
				new CitizenWarningCommand("graffiti", _bundle.messages.citizenPopup).execute();
		}

		private function onLineAdded(lineState:Object):void
		{
			var line:LineShape = new LineShape();
			line.restoreFromState(lineState);
			ToolTips.registerObject(line, line.owner); 
			
			_lines.addChild(line);
			
			if (_lines.numChildren > MAX_LINES)
				removeLine(_lines.getChildAt(0) as Sprite);
			
			if (_canvas.numChildren > 0 && lineState.charId == Global.charManager.charId)
				_canvas.removeChild(_canvas.getChildAt(0));
		}
		
		private function onClear():void
		{
			GraphUtils.removeChildren(_lines);
		}
		
		private function removeLine(line:Sprite):void
		{
			GraphUtils.optimizeSprite(line);
			GraphUtils.attachBefore(line, _lines);
			new SpriteTweaner(line, {alpha:0}, 30, null, onHideComplete);
		}
		
		private function onHideComplete(line:Sprite):void
		{
			GraphUtils.detachFromDisplay(line);
		}
		
		private function refreshMode():void
		{
			_lines.mouseEnabled = !_toolbar.isDrawMode;
			_lines.mouseChildren = !_toolbar.isDrawMode;
			_wallArea.visible = _toolbar.isDrawMode;
		}  
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (_wallArea.hitTestPoint(Global.stage.mouseX, Global.stage.mouseY, true))
			{
				_currentLine.addPoint(_canvas.mouseX, _canvas.mouseY);
				
				if (_currentLine.length > MAX_LENGTH)
					stopDrawing();
			}
			else
			{
				stopDrawing();
			}
		}
		
		private function startDrawing(e:MouseEvent = null):void
		{
			if (e.altKey && e.ctrlKey && e.shiftKey && Global.superUser)
			{
				_client.sendClear();
				return;
			}
			
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP, stopDrawing);
			
			_currentLine = new LineShape(_toolbar.lineInfo);
			_currentLine.setStartPoint(_canvas.mouseX, _canvas.mouseY);
			_canvas.addChild(_currentLine);
			
			_toolbar.hideAll();
		}

		private function stopDrawing(e:Event = null):void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDrawing);
			
			_currentLine.optimize();
			_client.addLine(_currentLine.getState());
		}
		
	}
}