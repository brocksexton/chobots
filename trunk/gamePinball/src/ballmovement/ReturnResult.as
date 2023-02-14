package ballmovement
{
	internal class ReturnResult
	{
		public var finishedDrawing:Boolean;
		public var exitDrawing:Boolean;
		
		public function ReturnResult(finishedDrawing:Boolean, exitDrawing:Boolean):void
		{
			this.finishedDrawing = finishedDrawing;
			this.exitDrawing = exitDrawing;
		}

	}
}