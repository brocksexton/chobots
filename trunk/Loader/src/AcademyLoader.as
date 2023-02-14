package
{
	import flash.display.MovieClip;
	

	[SWF(width='900', height='510', backgroundColor='0x006699', frameRate='24')]
	public class AcademyLoader extends LocationLoaderBase
	{
		public function AcademyLoader()
		{
			super(new McChessLoader(), 'locAcademy');
		}
	}
}