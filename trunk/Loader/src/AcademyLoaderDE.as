package
{
	import flash.display.MovieClip;
	

	[SWF(width='900', height='510', backgroundColor='0x006699', frameRate='24')]
	public class AcademyLoaderDE extends LocationLoaderBase
	{
		public function AcademyLoaderDE()
		{
			super(new McChessLoaderDE(), 'locAcademy', 'http://www.chobots.de', 'deDE');
		}
	}
}