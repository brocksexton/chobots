package com.kavalok.utils
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
		
	public class ClassLibrary
	{
		private var _modules:Object = {};
		
		public function ClassLibrary()
		{
		}
		
		public function getClass(url:String, className:String):Class
		{
			var domain:ApplicationDomain = Module(_modules[url]).domain;
			
			return domain.hasDefinition(className)
				? Class(domain.getDefinition(className))
				: null;
		}
		
		public function getInstance(url:String, className:String):Object
		{
			var domain:ApplicationDomain = Module(_modules[url]).domain;
			if (domain.hasDefinition(className))
			{
				var objectClass:Class = Class(domain.getDefinition(className));
				return new objectClass();  
			}
			else
			{
				trace('class ' + className + ' not found in ' + url);
				return null;
			}
		}
		
		public function getDomain(url:String):ApplicationDomain
		{
			var module:Module = _modules[url];
			
			return (module)
				? module.domain
				: null;
		}
		
		public function callbackOnReady(listener:Function, urlList:Array):void
		{
			var task:TaskCounter = new TaskCounter();
			
			for each (var url:String in urlList)
			{
				var module:Module;
				
				if (url in _modules)
				{
					module = _modules[url];	
				}
				else
				{
					module = new Module(url);
					_modules[url] = module;
				}
				
				if (!module.isComplete)
				{
					task.addCount();
					module.completeEvent.addListener(task.completeTask);
				}
			}
			
			if (task.isEmpty)
				listener();
			else
				task.completeEvent.addListener(listener);
		}
		
	}
}
	
import flash.system.ApplicationDomain;
import flash.net.URLRequest;
import flash.events.Event;
import com.kavalok.events.EventSender;
import com.kavalok.loaders.SafeLoader;
	
internal class Module
{
	public var loader:SafeLoader;
	public var domain:ApplicationDomain;
	public var completeEvent:EventSender = new EventSender();
	public var isComplete:Boolean = false;
	
	public function Module(url:String)
	{
		loader = new SafeLoader();
		loader.completeEvent.addListener(onLoadComplete);
		loader.load(new URLRequest(url));
	}
	
	private function onLoadComplete():void
	{
		isComplete = true;
		domain = loader.contentLoaderInfo.applicationDomain;
		completeEvent.sendEvent();
		completeEvent.removeListeners();
	}
}
