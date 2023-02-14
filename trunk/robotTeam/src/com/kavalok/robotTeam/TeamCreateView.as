package com.kavalok.robotTeam
{
	import com.kavalok.Global;
	import com.kavalok.dialogs.Dialogs;
	import com.kavalok.gameplay.controls.ColorPicker;
	import com.kavalok.localization.ResourceBundle;
	import com.kavalok.robots.RobotConstants;
	import com.kavalok.utils.SpriteDecorator;
	import com.kavalok.utils.Strings;
	
	import flash.events.MouseEvent;
	
	import robotTeam.McCreateTeam;
	
	public class TeamCreateView
	{
		private var _content:McCreateTeam;
		private var _colorPicker:ColorPicker;
		private var _bundle:ResourceBundle = Global.resourceBundles.robots;
		
		public function TeamCreateView()
		{
			createContent();
			
			_colorPicker.clickEvent.addListener(onColorClick);
			_content.closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
			_content.okButton.addEventListener(MouseEvent.CLICK, onOkClick);
		}
		
		private function createContent():void
		{
			_content = new McCreateTeam();
			_colorPicker = new ColorPicker(_content.colorPicker);
			
			module.initTextField(_content.createCaption);
			module.initTextField(_content.colorCaption);
			module.initTextField(_content.priceField);
			module.initButton(_content.okButton);
			
			_content.createCaption.text = _bundle.messages.createTeam;
			_content.colorCaption.text = _bundle.messages.teamColor;
			_content.helpField.text = _bundle.messages.teamHelp;
			_content.priceField.text = Strings.substitute(
				Global.messages.priceBugs, RobotConstants.TEAM_PRICE);
			Global.resourceBundles.kavalok.registerButton(_content.okButton, "ok");
		}
		
		private function onColorClick(sender:ColorPicker):void
		{
			SpriteDecorator.decorateColor(_content.colorPointer, _colorPicker.color, 0);
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			module.closeModule();
		}
		
		private function onOkClick(e:MouseEvent):void
		{
			new CreateTeamCommand(_colorPicker.color).execute();
		}
		
		public function show():void
		{
			Dialogs.showDialogWindow(_content);
		}
		
		public function hide():void
		{
			Dialogs.hideDialogWindow(_content);
		}
		
		protected function get module():RobotTeam
		{
			return RobotTeam.instance;
		}
	}
}