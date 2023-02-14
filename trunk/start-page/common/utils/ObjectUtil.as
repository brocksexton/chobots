package common.utils
{
	import flash.system.ApplicationDomain;
	
	public class ObjectUtil
	{
		static public function createInstance(className:String, domain:ApplicationDomain = null,
			...params):Object
		{
			if (!domain)
				domain = ApplicationDomain.currentDomain;
				
			var result:Object = null;
			
			if (domain.hasDefinition(className))
			{
				var classRef:Class = domain.getDefinition(className) as Class;
				
				if (params.length == 1)
					result = new classRef(params[0]);
				else if (params.length == 2)
					result = new classRef(params[0], params[1]);
				else if (params.length == 3)
					result = new classRef(params[0], params[1], params[2]);
				else if (params.length == 4)
					result = new classRef(params[0], params[1], params[2], params[3]);
				else if (params.length == 5)
					result = new classRef(params[0], params[1], params[2], params[3], params[4]);
				else
					result = new classRef();
			}
			else
			{
				throw new Error('Defenition of "' + className + '" not found');
			}
			
			return result;
		}
		
		
	}
	
}