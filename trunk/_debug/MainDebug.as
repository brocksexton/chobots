package  
{
	import com.kavalok.StartupInfo;
	
	import flash.display.Sprite;
	
	[SWF(width='900', height='510', backgroundColor='0xeAAAAAA', framerate='24')]
	public class MainDebug extends Sprite
	{
		public function MainDebug() 
		{
			var info:StartupInfo = new StartupInfo();
			info.debugMode = true;
			info.url = 'localhost/kavalok';
			info.login = 'canab';
			info.moduleId = 'loc0';
			
			new Kavalok(info, this);
		}
	}
}