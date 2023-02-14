package com.kavalok.robotCombat.view
{
	import assets.combat.McBaseControls;
	import assets.combat.McCommandPanel;
	import assets.combat.McSpecialControls;
	
	import com.kavalok.Global;
	import com.kavalok.dto.robot.CombatActionTO;
	import com.kavalok.dto.robot.RobotItemTO;
	import com.kavalok.events.EventSender;
	import com.kavalok.flash.playback.MovieClipPlayer;
	import com.kavalok.gameplay.controls.CheckBox;
	import com.kavalok.gameplay.controls.RadioGroup;
	import com.kavalok.robotCombat.CombatSounds;
	import com.kavalok.robots.CombatConstants;
	import com.kavalok.robots.RobotItemSprite;
	import com.kavalok.utils.GraphUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	import gs.TweenLite;
	import gs.easing.Expo;
	
	public class ActionView
	{
		static private const ITEM_SIZE:Number = 30;
		
		private var _actionEvent:EventSender = new EventSender();
		
		private var _shieldDirection:String = CombatConstants.MIDDLE;
		private var _action:CombatActionTO;
		
		private var _content:McCommandPanel;
		private var _attackButtons:RadioGroup;
		private var _modeButton:CheckBox;
		
		private var _baseControls:McBaseControls;
		private var _specialControls:McSpecialControls;
		private var _itemSprites:Array = [];
		private var _enabled:Boolean = true;
		
		public function ActionView(content:McCommandPanel)
		{
			_content = content;
			_baseControls = _content.baseControls;
			_specialControls = _content.specialControls;
			initialize();
			createButtons();
			refreshPointer();
			refreshMode();
		}
		
		private function initialize():void
		{
			GraphUtils.optimizeSprite(_content.background);
			_content.modeClip.stop();
			_specialControls.circle.visible = false;
		}
		
		public function setItems(items:Array):void
		{
			for each (var itemSprite:RobotItemSprite in _itemSprites)
			{
				GraphUtils.detachFromDisplay(itemSprite);
			}
			
			for each (var item:RobotItemTO in items)
			{
				var sprite:RobotItemSprite = createItemSprite(item);
				_itemSprites.push(sprite);
			}
		}
		
		private function createItemSprite(item:RobotItemTO):RobotItemSprite
		{
			var sprite:RobotItemSprite = new RobotItemSprite(item);
			sprite.useView = false;
			sprite.buttonMode = true;
			sprite.background = GraphUtils.createRectSprite(ITEM_SIZE, ITEM_SIZE, 0, 0);
			sprite.loaderView.width = ITEM_SIZE; 
			sprite.loaderView.height = ITEM_SIZE;
			sprite.addEventListener(MouseEvent.MOUSE_OVER, onItemOver);
			sprite.addEventListener(MouseEvent.MOUSE_OUT, onItemOut);
			sprite.addEventListener(MouseEvent.CLICK, onItemClick);
			
			_specialControls.addChild(sprite);
			var angle:Number = item.position * Math.PI / 3.0;
			sprite.x = 0.5 * _specialControls.circle.width * Math.cos(angle) - 0.5 * ITEM_SIZE; 
			sprite.y = 0.5 * _specialControls.circle.width * Math.sin(angle) - 0.5 * ITEM_SIZE;
			
			return sprite;
		}
		
		private function onItemOver(e:MouseEvent):void
		{
			if (_enabled)
			{
				var sprite:Sprite = e.currentTarget as Sprite;
				sprite.filters = [new GlowFilter(0xFFFF00, 1, 6, 6, 5)];
			}
		}
		
		private function onItemOut(e:MouseEvent):void
		{
			if (_enabled)
			{
				var sprite:Sprite = e.currentTarget as Sprite;
				sprite.filters = [];
			}
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			var currentSprite:RobotItemSprite = RobotItemSprite(e.currentTarget);
			
			for each (var sprite:Sprite in _itemSprites)
			{
				if (sprite != currentSprite)
					sprite.alpha = 0.25;
			}
			 
			var item:RobotItemTO = currentSprite.item;
			_action = new CombatActionTO();
			_action.specialItemId = item.id;
			_actionEvent.sendEvent();
		}
		
		private function createButtons():void
		{
			_modeButton = new CheckBox(_content.modeButton);
			_modeButton.clickEvent.addListener(onModeClick);
			
			_baseControls.shieldBottomButton.addEventListener(MouseEvent.CLICK, onShieldBottomClick);
			_baseControls.shieldMiddleButton.addEventListener(MouseEvent.CLICK, onShieldMiddleClick);
			_baseControls.shieldTopButton.addEventListener(MouseEvent.CLICK, onShieldTopClick);
			
			_attackButtons = new RadioGroup();
			_attackButtons.addButton(new CheckBox(_baseControls.attackBottomButton));
			_attackButtons.addButton(new CheckBox(_baseControls.attackMiddleButton));
			_attackButtons.addButton(new CheckBox(_baseControls.attackTopButton));
			_attackButtons.clickEvent.addListener(onAttackClick);
		}
		
		private function onModeClick(sender:CheckBox):void
		{
			Global.playSound(CombatSounds.SELECT_MODE);
			new MovieClipPlayer(_content.modeClip).playInterval(1, _content.modeClip.totalFrames);
			refreshMode(); 
		}
		
		private function onAttackClick(sender:RadioGroup):void
		{
			Global.playSound(CombatSounds.SELECT_ATTACK);
			
			var attackDirection:String;
			if (_attackButtons.selectedIndex == 0)
				attackDirection = CombatConstants.BOTTOM;
			else if (_attackButtons.selectedIndex == 1)
				attackDirection = CombatConstants.MIDDLE;
			else
				attackDirection = CombatConstants.TOP;
			
			_action = new CombatActionTO();
			_action.attackDirection = attackDirection;
			_action.shieldDirection = _shieldDirection;
			_actionEvent.sendEvent();
		}
		
		public function refreshMode():void
		{
			_baseControls.visible = !_modeButton.checked;
			_specialControls.visible = _modeButton.checked; 	
		}
		
		private function onShieldBottomClick(e:MouseEvent):void
		{
			Global.playSound(CombatSounds.SELECT_SHIELD);
			_shieldDirection = CombatConstants.BOTTOM;
			refreshPointer();
		}
		
		private function onShieldMiddleClick(e:MouseEvent):void
		{
			Global.playSound(CombatSounds.SELECT_SHIELD);
			_shieldDirection = CombatConstants.MIDDLE;
			refreshPointer();
		}
		
		private function onShieldTopClick(e:MouseEvent):void
		{
			Global.playSound(CombatSounds.SELECT_SHIELD);
			_shieldDirection = CombatConstants.TOP;
			refreshPointer();
		}
		
		private function refreshPointer():void
		{
			var rotation:Number;
			if (_shieldDirection == CombatConstants.TOP)
				rotation = 60;
			else if (_shieldDirection == CombatConstants.BOTTOM)
				rotation = -60;
			else
				rotation = 0;
				
			TweenLite.to(_baseControls.shieldPointer, 0.5,
				{
					rotation: rotation,
					easy:Expo.easeOut
				}
			);
				
		}
		
		public function show():void
		{
			 _content.visible = true;
			 enabled = true;
			 
			 if (_attackButtons.selectedButton)
			 	_attackButtons.selectedButton.checked = false;
		}

		public function hide():void
		{
			 _content.visible = false;
		}
		
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			 _content.mouseEnabled = value;
			 _content.mouseChildren = value;
			 _content.filters = (!value) ?
			 	[new BlurFilter(4, 4)]
			 	: [];
			 	
			 if (value)
			 	resetItems();
		}
		
		private function resetItems():void
		{
			for each (var sprite:RobotItemSprite in _itemSprites)
			{
				sprite.alpha = 1;
				sprite.filters = [];
				sprite.refresh();
				
				if (sprite.item.remains == 0)
				{
					GraphUtils.disableMouse(sprite);
					sprite.alpha = 0.5;
				}
			}
		}
		
		public function get actionEvent():EventSender { return _actionEvent; }
		public function get action():CombatActionTO { return _action; }
	}
}