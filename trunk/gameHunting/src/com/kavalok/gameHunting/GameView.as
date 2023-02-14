package com.kavalok.gameHunting
{
	import com.kavalok.events.EventSender;
	import com.kavalok.gameHunting.data.PlayerData;
	import com.kavalok.gameplay.controls.CheckBox;
	import com.kavalok.gameplay.controls.ProgressBar;
	import com.kavalok.gameplay.controls.RadioGroup;
	import com.kavalok.gameplay.KavalokConstants;
	import com.kavalok.Global;
	import com.kavalok.utils.Arrays;
	import com.kavalok.utils.GraphUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gameHunting.McHuntingStage;
	import gs.TweenLite;
	
	public class GameView
	{
		private var _closeEvent:EventSender = new EventSender();
		private var _changeShellEvent:EventSender = new EventSender();
		
		private var _content:McHuntingStage;
		private var _myHealth:ProgressBar;
		private var _hisHealth:ProgressBar;
		private var _shellGroup:RadioGroup;
		
		public function GameView(content:McHuntingStage)
		{
			_content = content;
			_myHealth = new ProgressBar(_content.myHealthBar);
			_hisHealth = new ProgressBar(_content.hisHealthBar);
			
			_content.myNameField.text = '';
			_content.myHealthBar.visible = false;
			_content.hisNameField.text = '';
			_content.hisHealthBar.visible = false;
			
			initShellGroup();
			
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function initShellGroup():void
		{
			_shellGroup = new RadioGroup();
			_shellGroup.clickEvent.addListener(onShellClick);
			
			for (var shellName:String in ShellFactory.shells)
			{
				var checkClip:MovieClip = _content.shellBox[shellName];
				GraphUtils.stopAllChildren(checkClip);
				_shellGroup.addButton(new CheckBox(checkClip));
			}
		}
		
		private function onShellClick(sender:RadioGroup):void
		{
			_changeShellEvent.sendEvent();
		}
		
		public function get currentShell():String
		{
			return _shellGroup.selectedButton.content.name;
		}
		
		public function set currentShell(value:String):void
		{
			for each (var button:CheckBox in _shellGroup.buttons)
			{
				if (button.content.name == value)
				{
					_shellGroup.selectedButton = button;
					break;
				}
			}
		}
		
		public function updatePlayer(player:Player):void
		{
			var field:TextField = (player.isMe) ? _content.myNameField : _content.hisNameField
			var bar:ProgressBar = (player.isMe) ? _myHealth : _hisHealth;
			
			TweenLite.to(bar, 1, { value: player.health / 100.0 } );
			
			if (field.text != player.name)
				field.text = player.name;
				
			if (!bar.content.visible)
				bar.content.visible = true;
		}
		
		public function showShell(shellName:String):void
		{
			var shellClass:Class = ShellInfo(ShellFactory.shells[shellName]).classSpriteOut;
			var shell:Sprite = new shellClass();
			shell.addEventListener(Event.ENTER_FRAME, onShellFrame);
			shell.x = Math.random() * KavalokConstants.SCREEN_WIDTH;
			shell.y = 0.2 * KavalokConstants.SCREEN_HEIGHT;
			_content.addChild(shell);
		}
		
		private function onShellFrame(e:Event):void
		{
			var shell:Sprite = Sprite(e.target);
			if (shell.width < 1)
			{
				shell.removeEventListener(Event.ENTER_FRAME, onShellFrame);
				GraphUtils.detachFromDisplay(shell);
			}
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			_closeEvent.sendEvent();
		}
		
		public function get closeEvent():EventSender { return _closeEvent; }
		public function get changeShellEvent():EventSender { return _changeShellEvent; }
		
	}
	
}