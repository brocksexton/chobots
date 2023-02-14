package com.kavalok.gameplay.frame.safeChat
{
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import com.kavalok.events.EventSender;
	import com.kavalok.utils.GraphUtils;
	import com.kavalok.Global;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class SafeChatInputView
	{
		SafeChatIcons;
		
		private static const MAX_ITEMS : uint = 9;
		
		private static var groups : Dictionary = getGroups();

		private var _currentGroup : SafeChatGroupView;
		private var _currentId : String;

		private var _inputView : SafeChatListView;
		
		private var _open : Boolean;
		private var timertwo:Timer;
		
		public static function getGroups() : Dictionary
		{
			var result : Dictionary = new Dictionary();
			result["chobots"] = ["hi", "bye", "me", "us", "you", "friend", "people", "angel", "family", "baby"];
			result["actions"] = ["mail", "chat", "say", "ask", "think", "sleep", "remember", "go", "come"
				, "can", "hope", "work", "shop", "relax", "idea", "wait", "take", "give", "touch", "taste", "smell", "hear", "see", "call", "food", "drink"];
			result["places"] = ["home", "movie", "here", "there", "restaurant", "party", "cafe", "missionAgency", "game"
				, "cinema", "spaceRacing", "garbageCollector", "sweetBattle", "rope", "missions", "academy",
				"checkers", "farm", "clothesShop", "magicShop", "cafePlace", "gamezone",
				"furnitureShop", "petShop", "park", "crab", "choboard", "asteroid", "robots", "choBall"];
			result["feel"] = ["love", "hate", "luck", "dancing", "happy", "sad", "crazy", "shutUp", "cry", "angry", "sick", "fear", "silence"];
			result["language"] = ["yes", "no", "dot", "question", "comma", "exclamation", "whereIs", "whoIs", "ok", "with", "without", "plus", "or"];
			result["time"] = ["morning", "noon", "evening", "night", "day", "year", "birthday", "time2min", "time5min", "time10min", "time15min", "time30min", "hour"
				, "infinity", "before", "after", "today", "yesterday", "tomorrow", "christmas"];
			result["fun"] = ["tv", "computer", "football", "internet", "surprise", "money", "music", "lamp"];
			result["descript"] = ["good", "bad", "much", "up", "down", "important", "in", "out", "big", "small", "hot", "cold", "same", "different"];
			return result;
		}
		
		private var _content : MovieClip;
		
		private var _openEvent : EventSender = new EventSender();
		
		public function SafeChatInputView(content : MovieClip)
		{
			_content = content;
			_inputView = new SafeChatListView(_content.safeChatInput, null, 0, true);
			GraphUtils.removeChildren(_content.safeChatInput);
			refreshBackspaceEnabled();
			_content.backspaceButton.addEventListener(MouseEvent.CLICK, onBackspaceClick);
			ToolTips.registerObject(_content.backspaceButton, "deleteLast", ResourceBundles.KAVALOK);
			
			for(var i : int = 0; i < _content.groups.numChildren; i++)
			{
				var child : MovieClip = MovieClip(_content.groups.getChildAt(i));
				new SafeChatItemView(child.name, child);
				child.addEventListener(MouseEvent.CLICK, onGroupClick);
			}
			
			timertwo = new Timer(300, 1);
			timertwo.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleteTwo);
			timertwo.start();
			
		}
		
		private function onTimerCompleteTwo(event:TimerEvent):void
		{
		  if(Global.bubbleValue == false && Global.charManager.isModerator != true){
		  _content.groups.enabled = false; 
		  ToolTips.registerObject(_content.groups, "chatMLocked", ResourceBundles.KAVALOK);
		  for(var ii : int = 0; ii < _content.groups.numChildren; ii++)
			{
				var childe : MovieClip = MovieClip(_content.groups.getChildAt(ii));
				childe.removeEventListener(MouseEvent.CLICK, onGroupClick);
				ToolTips.registerObject(childe, "chatMLocked", ResourceBundles.KAVALOK);
			} 
		  }else if(Global.bubbleValue == true){
		  _content.groups.enabled = true;
		  ToolTips.unRegisterObject(_content.groups);
		  for(var ie : int = 0; ie < _content.groups.numChildren; ie++)
			{
				var childd : MovieClip = MovieClip(_content.groups.getChildAt(ie));
				new SafeChatItemView(childd.name, childd);
				childd.addEventListener(MouseEvent.CLICK, onGroupClick);
				ToolTips.registerObject(childd, childd.name, ResourceBundles.SAFE_CHAT);
			} 
		}
		}
		
		public function get openEvent():EventSender
		{
			return _openEvent;
		}
		public function get message() : Array
		{
			return _inputView.items;
		}
		
		public function clear() : void
		{
			destroyCurrentGroup();
			_inputView.clear();
			refreshBackspaceEnabled();
			sendChangeOpen();
		}
		
		private function sendChangeOpen() : void
		{
			var value : Boolean = _inputView.items.length > 0;
			if(value != _open)
			{
				_open = value
				openEvent.sendEvent(_open);
			}
		}
		
		private function refreshBackspaceEnabled() : void
		{
			GraphUtils.setBtnEnabled(_content.backspaceButton, _inputView.items.length > 0);
		}
		private function onBackspaceClick(event : MouseEvent) : void
		{
			_inputView.removeLast()
			refreshBackspaceEnabled();
			sendChangeOpen();
		}
		
		private function onGroupClick(event : MouseEvent) : void
		{
		   if(Global.bubbleValue == false && Global.charManager.isModerator == true){	
			var id : String = _currentId;
			destroyCurrentGroup();
			
			var item : MovieClip = MovieClip(event.currentTarget);
			
			if(id == item.name)
				return;
			
			_currentGroup = new SafeChatGroupView(groups[item.name]);
			_currentGroup.content.y = - _currentGroup.content.height;
			_currentGroup.content.x = _content.safeChatInput.x;
			
			_currentGroup.itemClick.addListener(onItemClick);
			
			_content.addChild(_currentGroup.content);
			_currentId = item.name;
			}
			
			if(Global.bubbleValue == false && Global.charManager.isModerator != true){
			// do nothing
			}else if(Global.bubbleValue == true){
			
			var idd : String = _currentId;
			destroyCurrentGroup();
			
			var itemm : MovieClip = MovieClip(event.currentTarget);
			
			if(idd == itemm.name)
				return;
			
			_currentGroup = new SafeChatGroupView(groups[itemm.name]);
			_currentGroup.content.y = - _currentGroup.content.height;
			_currentGroup.content.x = _content.safeChatInput.x;
			
			_currentGroup.itemClick.addListener(onItemClick);
			
			_content.addChild(_currentGroup.content);
			_currentId = itemm.name;
			}
		}
		
		public function destroyCurrentGroup() : void
		{
			if(_currentGroup != null)
			{
				_content.removeChild(_currentGroup.content);
				_currentGroup.itemClick.removeListener(onItemClick);
				_currentGroup = null;
				_currentId = null;
			}
		}

		private function onItemClick(id : String) : void
		{
			if(_inputView.items.length < MAX_ITEMS)
			{
				_inputView.addItem(id);
				refreshBackspaceEnabled();
				sendChangeOpen();
			}
		}
		
		

	}
}