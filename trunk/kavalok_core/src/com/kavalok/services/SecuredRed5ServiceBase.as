package com.kavalok.services
{
	import com.kavalok.security.SimpleEncryptor;
	
	
	public class SecuredRed5ServiceBase extends Red5ServiceBase
	{
		public static var securityKey : Array;

		private static var postponedCalls : Array = [];
		
		
		private static var executing : Boolean = false;
		
		private var resultHandler : Function;
		
		public function SecuredRed5ServiceBase(resultHandler:Function=null)
		{
			super(onResult, onFault);
			this.resultHandler = resultHandler;
		}
		
		protected override function processArguments(methodName : String, args : Array) : Array 
		{
			var encryptor : SimpleEncryptor = new SimpleEncryptor(securityKey);
			for(var i : int = 0; i < args.length; i++)
			{
				args[i] = encryptor.encrypt(args[i]);
			}
			return super.processArguments(methodName, args);
		}		
		override protected function doCall(methodName:String, args:Array):void
		{
			if(executing)
			{
				postponedCalls.push(new CallInfo(doCall, methodName, args));
			}
			else
			{
				executing = true;
				super.doCall(methodName, args);
			}
		}

		private function onResult(result : Array):void
		{
			securityKey = result;
			if(resultHandler != null)
				resultHandler(null);
			callNext();
		}

		private function onFault(result : Object):void
		{
			callNext();
		}
		
		private function callNext() : void
		{
			executing = false;
			if(postponedCalls.length > 0)
			{
				var callInfo : CallInfo = postponedCalls.pop();
				callInfo.doCall(callInfo.methodName, callInfo.args);
			}
		}

	}
}

internal class CallInfo
{
	public var doCall : Function;
	public var methodName : String;
	public var args : Array;
	
	public function CallInfo(doCall : Function, methodName : String, args : Array)
	{
		this.doCall = doCall;
		this.methodName = methodName;
		this.args = args;
	}
}