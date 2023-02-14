package ballmovement
{
	import flash.display.MovieClip;
	
	internal class BallClipMovement
	{
		private var clip:MovieClip;
		private var ball:MovieClip;
		
		public function  BallClipMovement(ball:MovieClip, clip:MovieClip)
		{
			this.ball = ball;
			this.clip = clip;	
		} 
		
		public function draw():ReturnResult
		{
			if (clip == null)
			{
				return new ReturnResult(true, true);
			}
			if (clip.currentFrame == clip.totalFrames)
			{
				clip.visible = false;
				clip.gotoAndStop(1);
				return new ReturnResult(true, true);
			}
			if (clip.currentFrame == 1)
			{
				ball.visible = false;
				clip.visible = true;
				clip.play();
			}
			return new ReturnResult(false, false); 
		}

	}
}