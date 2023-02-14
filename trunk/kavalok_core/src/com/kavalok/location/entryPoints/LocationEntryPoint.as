package com.kavalok.location.entryPoints
{
	import com.kavalok.Global;
	import com.kavalok.commands.location.GotoLocationCommand;
	import com.kavalok.constants.Locations;
	import com.kavalok.constants.Modules;
	import com.kavalok.constants.ResourceBundles;
	import com.kavalok.events.EventSender;
	import com.kavalok.char.Stuffs;
	import com.kavalok.gameplay.MousePointer;
	import com.kavalok.gameplay.ToolTips;
	import com.kavalok.gameplay.commands.RegisterGuestCommand;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class LocationEntryPoint implements IEntryPoint
	{
		private static const RETURN:String = 'return';
		
		private var _activateEvent:EventSender = new EventSender();
		private var _locId:String;
		private var _params:Object = {};
		
		private var _content:MovieClip;
		
		public static function accept(sprite:Sprite):Boolean
		{
			return GraphUtils.getConfigString(sprite) != null;
		}
		
		/*public function LocationEntryPoint(content:MovieClip)
		{
			_content = content;
			
			if (!(_content.getChildAt(0) is SimpleButton))
				_content.alpha = 0;
			
			_locId = GraphUtils.getLocationId(_content);
			_params = GraphUtils.getParameters(_content) || {};
			
			if (('forAgentsOnly' in _params) && Global.charManager.isAgent)
				_content.visible = true;
			else if (('forAgentsOnly' in _params) && Global.charManager.isModerator)
			    _content.visible = true;	
			else
			    _content.visible = false;
			
			if (_locId == RETURN)
			{
				_locId = Global.locationManager.prevLocId;
				_params = Global.locationManager.prevLocParameters || {};
				if(_locId == Modules.HOME) //TODO: remove this hack
				{
					_locId = Locations.LOC_0;
					_params = {};
				}
			}
			
			if (_params.moderator == 'true')
			{
				_content.visible = Global.charManager.isModerator
					|| Global.superUser;
			}
			
			if (_params.superUser == 'true')
			{
				_content.visible = Global.superUser;
			}
			
			var tipText:String = _params.tipText || _locId; 
			if (tipText)
				ToolTips.registerObject(content, tipText, ResourceBundles.KAVALOK);
			
			_content.addEventListener(MouseEvent.CLICK, onMouseDown);
			_content.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_content.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}*/
		
		public function LocationEntryPoint(content:MovieClip)
		{
			_content = content;
			
			if (!(_content.getChildAt(0) is SimpleButton))
				_content.alpha = 0;
			
			_locId = GraphUtils.getLocationId(_content);
			_params = GraphUtils.getParameters(_content) || {};
			
			if (('forAgentsOnly' in _params) && !Global.charManager.isAgent)
				_content.visible = false;
			
			if (('forMerchantsOnly' in _params || 'locEmeralds' in _params) && !Global.charManager.isMerchant)
				_content.visible = false;

			if (_locId == RETURN)
			{
				_locId = Global.locationManager.prevLocId;
				_params = Global.locationManager.prevLocParameters || {};
				if(_locId == Modules.HOME) //TODO: remove this hack
				{
					_locId = Locations.LOC_0;
					_params = {};
				}
			}
			if (_params.requireItem != null)
			{
				_content.visible = Global.charManager.stuffs.stuffExists(_params.requireItem.toString());
				trace("requires: " + _params.requireItem.toString());
			}
			if (_params.moderator == 'true')
			{
				_content.visible = Global.charManager.isModerator
					|| Global.superUser;
			}
			
			if (_params.superUser == 'true')
			{
				_content.visible = Global.superUser;
			}
			
			var tipText:String = _params.tipText || _locId; 
			if (tipText)
				ToolTips.registerObject(content, tipText, ResourceBundles.KAVALOK);
			
			_content.addEventListener(MouseEvent.CLICK, onMouseDown);
			_content.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_content.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		public function destroy():void{}
		
		private function onMouseOver(e:MouseEvent):void
		{
			var icon:MovieClip = new McPointerExit();
			
			icon.rotation = Math.atan2(
				_content.y - 0.5 * Global.stage.height,
				_content.x - 0.5 * Global.stage.width
			) / Math.PI * 180;
			
			MousePointer.setIcon(icon);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			MousePointer.resetIcon();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_activateEvent.sendEvent(this);
		}
		
		public function get charPosition():Point
		{
			return GraphUtils.transformCoords(new Point(0,0), _content, Global.root);
		}
		
		public function goIn():void
		{
			if (_params.guest == "false" && Global.charManager.isGuest)
			{
				new RegisterGuestCommand().execute();
			}
			else
			{
				new GotoLocationCommand(_locId, _params).execute();
			}
		}
		
		public function goOut():void {}
		
		public function get activateEvent():EventSender { return _activateEvent; }
		
		public function get locId():String { return _locId; }
		
		public function get remoteId():String
		{
			if (_params && ('remoteId' in _params))
				return _params.remoteId;
			else
				return _locId;
		}
		
	}
}
