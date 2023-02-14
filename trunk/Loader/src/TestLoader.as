package
{
	[SWF(width='700', height='510', backgroundColor='0x006699', frameRate='24')]
	public class TestLoader extends LocationLoaderBase
	{
		public function TestLoader()
		{
			super(new McSweatBattleLoader(), 'locPark');
		}
	}
}