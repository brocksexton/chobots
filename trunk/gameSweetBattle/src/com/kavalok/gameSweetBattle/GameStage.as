package com.kavalok.gameSweetBattle
{
	import com.kavalok.Global;
	import com.kavalok.URLHelper;
	import com.kavalok.collections.ArrayList;
	import com.kavalok.dialogs.DialogOkView;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.events.EventSender;
	import com.kavalok.gameSweetBattle.actions.*;
	import com.kavalok.gameSweetBattle.fightAction.IFightAction;
	import com.kavalok.gameSweetBattle.physics.PhysicsEngine;
	import com.kavalok.gameSweetBattle.physics.Surface;
	import com.kavalok.gameplay.commands.AddMoneyCommand;
	import com.kavalok.gameplay.constants.Competitions;
	import com.kavalok.games.NotReadyClient;
	import com.kavalok.games.ReadyClient;
	import com.kavalok.loaders.LocationLoaderView;
	import com.kavalok.loaders.SafeLoader;
	import com.kavalok.remoting.ClientBase;
	import com.kavalok.remoting.RemoteObjects;
	import com.kavalok.services.CompetitionService;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.EventManager;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.utils.Strings;
	import com.kavalok.utils.Timers;
	import com.kavalok.utils.comparing.ClassRequirement;
	import com.kavalok.utils.converting.ToPropertyValueConverter;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	public class GameStage extends ClientBase
	{
		private static const LAND_FORMAT : String = "land{0}";
		//{ #region members
		private var _content:Sprite = new Sprite();
		private var _field:MovieClip;
		private var _engine:PhysicsEngine;
		private var _surface:Surface;
		
		private var _destroyedPlayers:/*Player*/Array = [];
		private var _players:/*Player*/Array = [];
		private var _user:Player;
		
		private var _fieldNum:int;
		private var _loader:SafeLoader;
		
		private var _actionPanel:ActionPanel;
		private var _actionList:Object = { };
		
		private var _scroller:StageScroller;
		private var _txtHealth:TextField;
		private var _currentAction:StaticActionBase;
		
		private var _quitEvent:EventSender = new EventSender();
		private var _replayEvent:EventSender = new EventSender();
		private var _em:EventManager = GameSweetBattle.eventManager;
		private var _root:Sprite;
		private var _locked:Boolean;
		private var _waitingDialog : DialogOkView;
		private var _charStates : Object = {};
		private var _landLoader : SafeLoader;
		private var _loaderView : LocationLoaderView;
		private var _lands : Array;
		
		//} #region members
		
		//{ #region init
		public function GameStage(remoteId:String, stageNum:int, root : Sprite, lands : Array):void
		{
			LandAction;
			_fieldNum = stageNum;
			_root = root;
			_lands = lands;
			connect(remoteId);
		}
		
		public function get em():EventManager
		{
			return _em;
		}
		public function get user():Player
		{
			return getPlayer(clientCharId);
		}
		
		private function get stageWidth() : Number
		{
			return _field["mc_walkArea"].width;
		}
		
		override public function disconnect():void
		{
			if(_waitingDialog != null)
			{
				_waitingDialog.hide();
				_waitingDialog = null;
			}
//			_engine.stop();
			RemoteObjects.instance.removeAllClients(_remoteId);
		}
		
		
		
		override public function restoreState(state:Object):void
		{
			super.restoreState(state);
			for(var stateId : String in states)
			{
				if(isCharState(stateId))
				{
					_charStates[stateId] = states[stateId];
				}
			}
			
			if(states.land)
			{
				loadLand();
			}
			else
			{
				setLand();
			}
//			createObjects(new GameBackround());
			var state:Object = Global.charManager.getCharState();
			sendUserState("rCharClothes", state);
		}
		
		public function rSetLand(stateName : String, state : Object) : void
		{
			loadLand();
		}
		private function setLand() : void
		{
			lockState("rSetLand", "land", {index : Arrays.randomItem(_lands)});
		}
		
		private function loadLand() : void
		{
			_loaderView = new LocationLoaderView();
			_root.addChild(_loaderView.content);
			var land : String = Strings.substitute(LAND_FORMAT, states.land.index);
			_landLoader = new SafeLoader(_loaderView);
			_landLoader.completeEvent.addListener(onLandLoaded);
			_landLoader.load(new URLRequest(URLHelper.resourceURL(land, GameSweetBattle.ID)));
		}
		
		private function onLandLoaded() : void
		{
			_root.removeChild(_loaderView.content);
			var content : MovieClip = MovieClip(_landLoader.content);
			createObjects(content.location);			
			var notReadyClient : NotReadyClient = new NotReadyClient(remoteId);
			
			Timers.callAfter(ready, 1000);
		}
		
		public function rCharClothes(stateId : String, state : Object) : void
		{
			_charStates[stateId] = state;
		}
		
		public function sendRemoveBubble() : void
		{
			send("rRemoveBubble", clientCharId);
		}
				
		public function rRemoveBubble(charId : String) : void
		{
			var player : Player = getPlayer(charId);
			if(player != null && !player.isUser)
			{
				player.removeBubble();
			}
		}
		public function sendAddUserBubble() : void
		{
			send("rAddUserBubble", clientCharId);
		}
		
		public function rAddUserBubble(charId : String) : void
		{
			var player : Player = getPlayer(charId);
			if(!player.isUser)
			{
				player.rAddBubble();
			}
		}
		private function ready():void
		{
			var readyClient : ReadyClient = new ReadyClient(remoteId);
			readyClient.ready.addListener(onReady);
			_waitingDialog = Dialogs.showOkDialog(Global.resourceBundles.kavalok.messages.waitingForOtherPlayers, false, null, false);
		}
		private function onReady():void
		{
			if(_waitingDialog == null)
				return;
			
			_waitingDialog.hide();
			_waitingDialog = null;
			createPlayers();
			
			registerAction(new PlayerWalkAction(this));
			registerAction(new BrickAction());
			registerAction(new CakeAction());
			registerAction(new GumAction());
			registerAction(new PlateAction());
			registerAction(new StarsAction());
			registerAction(new PlayerRunAction(this));
			registerAction(new CloudAction());
			registerAction(new CornAction());
			registerAction(new BubbleAction());
			registerAction(new MashinGunAction());
			registerLandActions();
			activateUser();
		}
		private function createObjects(field:MovieClip):void
		{
			_root.addChild(_content);
			// stage
			_field = field;
			_content.addChild(_field);
			
			//controls
			var controls:McStageControls = new McStageControls();
			_content.addChild(controls);
			
			//scroller
			_scroller = new StageScroller(stageWidth, _field, _field['mc_bg']);
			
			// health
			_txtHealth = controls.txtHealth;
			_txtHealth.text = Config.PLAYER_HEALTH.toString();
			
			// engine
			_engine = new PhysicsEngine(_field, _em, field, remoteId);
			_engine.bounds = new Rectangle(0, 0, Config.GAME_WIDTH, Config.GAME_HEIGHT);
			_engine.createWorld(_field['mc_world']);
			_engine.actionEvent.addListener(onEngineAction);
			_field.removeChild(_field['mc_world']);
			
			// action panel
			_actionPanel = new ActionPanel(controls.mcActionPanel);
			_actionPanel.visible = false;
			_actionPanel.selectionEvent.setListener(onActionSelect);
			
			// quit
			_em.registerEvent(controls.btnQuit, MouseEvent.MOUSE_DOWN, _quitEvent.sendEvent)
			
			// surface
			_surface = new Surface(_field['mc_ground'], _field["mc_walkArea"]);
			_field['mc_walkArea'].visible = false;
		}
		
		public function createPlayers():void
		{
			_players = [];
			
			var ids:Array = remote.connectedChars;
			ids.sort();
			
			var numPlayers:int = ids.length;
			var distance:Number = 0.8 * stageWidth / (numPlayers + 1);
			for (var i:int = 0; i < ids.length; i++)
			{
				var player:Player = new Player(this, _engine, ids[i]);
				
				player.x = 0.5 * stageWidth + distance * (i - 0.5*(numPlayers-1));
				var pIndex:int = _surface.getNearestVertIndex(player.position);
				player.position = _surface.getPoint(pIndex);
				player.rotation = _surface.getAngle(pIndex) / Math.PI * 180;
				player.healthHandler = updateHealth;
				player.destroyHandler = destroyPlayer;
				player.update();
				Timers.callAfter(player.update);
				
				if (player.isUser)
				{
					_user = player;
				}
				
				player.setModelClass(PlayerModelStay);
				
				_players.push(player);
			}
		}
		
		private function registerLandActions():void
		{
			var configs : MovieClip = _field.configs;
			if(configs == null)
				return;
			var fields : Array = GraphUtils.getAllChildren(configs, new ClassRequirement(TextField));
			for each(var field : TextField in fields)
			{
				var config : Object = GraphUtils.textToParameters(field.text);
				
				var type : Class = getDefinitionByName(config.className) as Class;//ReflectUtil.getTypeByName();
				var action : StaticActionBase = new type(field.name, config);
				registerEngineAction(action);
			}
		}
		private function registerEngineAction(action:StaticActionBase):void
		{
			action.stage = this;
			action.fightEvent.addListener(onEngineActionFight);
			_actionList[action.id] = action;
		}
		private function registerAction(action:StaticActionBase):void
		{
			action.stage = this;
			action.fightEvent.addListener(onActionFight);
			_actionList[action.id] = action;
		}
		//} #region init
		
		public function sendUserHealth(damage : Number):void
		{
			send("rUserHealth", clientCharId, damage);
		}
		
		public function rUserHealth(playerId : String, damage : Number) : void
		{
			var player : Player = getPlayer(playerId);
			if(player != null)
			{
				player.updateHealth(damage);
			}
		}
		
		public function updateHealth():void
		{
			_txtHealth.text = _user.health.toString();
		}
		
		public function selectDefaultAction():void
		{
			unLockActions();
			selectUserAction(PlayerWalkAction.ID);
		}
		public function sendInvertGravity():void
		{
			send("rInvertGravity");
		}
		
		public function rInvertGravity():void
		{
			
		}
		
		public function activateUser():void
		{
			_scroller.centerEvent.removeListeners();
			
			_scroller.centerEvent.addListener(startAction);
			
			_scroller.centerView(user.position);
			engine.start();
			
		}
		
		private function startAction():void
		{
			enableActions();
			updatePanelButtons();

			_actionPanel.visible = true;
			
			selectUserAction(PlayerWalkAction.ID);
		}
		
		private function onActionSelect():void
		{
			selectUserAction(_actionPanel.selectionID);
		}
		
		public function sendStopUser():void
		{
			user.stopMove();
			send("rStopUser", clientCharId, user.x, user.y);
		}

		public function selectUserAction(actionId:String):void
		{
			if(user == null)
				return;
			if(_currentAction != null)
			{
				_currentAction.terminate();
			}
			
			_currentAction = _actionList[actionId];
			_currentAction.enabled = true;
			_currentAction.activate();
			
			_actionPanel.setCurrent(actionId);
			
			user.setModelClass(_currentAction.showModel);
		}
		
		public function rStopUser(playerId : String, x : Number, y : Number) : void
		{
			var player : Player = getPlayer(playerId);
			if(player && !player.isUser)
			{
				player.stopMove();
				player.x = x;
				player.y = y;
			}
		}
		
		private function onEngineAction(id:String):void
		{
			var action : StaticActionBase = _actionList[id];
			action.activate();
		}
		private function onEngineActionFight(data:Object):void
		{
			send('rFight', clientCharId, data);
		}
		private function onActionFight(data:Object):void
		{
			if(_locked || _currentAction == null)
				return;
			
			_currentAction.addCount(-1);
			updatePanelButtons();
			_currentAction = null;
			send('rFight', clientCharId, data);
		}
		
		public function rFight(charId : String, data:Object):void
		{
			var action : StaticActionBase = _actionList[data.actionId];
			var player : Player = getPlayer(charId);
			var fightAction : IFightAction = action.createAction(player, data);
			fightAction.execute();
		}
		
		private function removeDisconnected():void
		{
			for each (var player:Player in _players)
			{
				if (player.destroyed || remote.connectedChars.indexOf(player.id) == -1)
				{
					destroyPlayer(player);
				}
				else
				{
					player.update();
				}
			}
		}
		
		//{ region actions
		
		public function unLockActions():void
		{
			for each (var action:StaticActionBase in _actionList)
			{
				_actionPanel.setButtonAccess(action.id, action.enabled);
			}
			_locked = false;
		}
		
		public function lockActions():void
		{
			for each (var action:StaticActionBase in _actionList)
			{
				_actionPanel.setButtonAccess(action.id, false);
			}
			_locked = true;
		}
		
		
		public function disableActions():void
		{
			for each (var action:StaticActionBase in _actionList)
			{
				action.enabled = false;
			}
		}
		
		public function enableActions():void
		{
			for each (var action:StaticActionBase in _actionList)
			{
				action.enabled = true;
			}
		}
		
		public function updatePanelButtons():void
		{
			for each (var action:StaticActionBase in _actionList)
			{
				_actionPanel.setButtonCount(action.id, action.countTotal);
			}
		}
		//} #region actions

		override public function charDisconnect(charId:String):void
		{
			super.charDisconnect(charId);
			removeDisconnected();
				
		}
		
		private function destroyPlayer(player:Player):void
		{
			player.destroy();
			_players.splice(_players.indexOf(player), 1);
			_destroyedPlayers.unshift(player);
			if(_players.length == 1)
			{	
				_engine.stop();
				destroyPlayer(_players[0]);
				showResult();
			}
		}
		
		//{ #region finish stage
		
		public function showResult():void
		{
			var ids : ArrayList = Arrays.getConverted(_destroyedPlayers, new ToPropertyValueConverter("id"));
			var dialog : DialogOkView = Dialogs.showGameResults(ids, _charStates);
			dialog.ok.addListener(quitEvent.sendEvent);
			var winner : Boolean = (ids[0] == clientCharId); 
			var money:int = winner ? 100 : 10; 
			var livePlayers : int = 0;
			for each(var player : Player in _destroyedPlayers)
			{
				if(player.health > 0)
					livePlayers++;
			}
			if(_destroyedPlayers.length > livePlayers)
			{
				new AddMoneyCommand(money, Competitions.SWEET_BATTLE).execute();
				
				if (winner){
					Global.addExperience(5);
					Global.sendAchievement("ac26;","Win any contest");
				} else {
					Global.addExperience(2);
				}
				
				if(winner)
					new CompetitionService().addCompetitorResult(Player(_destroyedPlayers[1]).id, Competitions.SWEET_BATTLE, 1); 
				
				Global.sendAchievement("ac26;","Sweet Battle");
			}
		}
		
		//} #region finish stage
		
		private function getPlayer(id:String):Player
		{
			for each (var player:Player in _players)
			{
				if (player.id == id)
				{
					return player;
				}
			}
			
			return null;
		}
		
		public function get quitEvent():EventSender { return _quitEvent; }
		
		public function get replayEvent():EventSender { return _replayEvent; }
		
		public function get engine():PhysicsEngine { return _engine; }
		
		public function get field():Sprite { return _field; }
		
		public function get actionPanel():ActionPanel { return _actionPanel; }
		
		public function get surface():Surface { return _surface; }
		
		public function get actionList():Object { return _actionList; }
		
		public function get content():flash.display.Sprite { return _content; }
		
	}
}
