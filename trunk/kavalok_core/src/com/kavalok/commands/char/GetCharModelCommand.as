package com.kavalok.commands.char
{
	import com.kavalok.char.CharModel;
	import com.kavalok.char.CharModels;
	import com.kavalok.commands.AsincCommand;

	public class GetCharModelCommand extends AsincCommand
	{
		private var _login:String;
		private var _userId:Number;
		private var _model:CharModel;
		private var _modelName:String;
		private var _direction:int;

		public function GetCharModelCommand(login:String, modelName:String=CharModels.STAY, direction:int=-1)
		{
			_login=login;
			_modelName=modelName;
			_direction=direction;
		}

		override public function execute():void
		{
			new GetCharCommand(_login, 0, onGetChar).execute();
		}

		private function onGetChar(sender:GetCharCommand):void
		{
			_model=new CharModel(sender.char);
			_model.readyEvent.addListener(onModelReady);
			_model.setModel(_modelName, _direction);
		}

		private function onModelReady():void
		{
			dispatchComplete();
		}

		public function get model():CharModel
		{
			return _model;
		}
	}
}

