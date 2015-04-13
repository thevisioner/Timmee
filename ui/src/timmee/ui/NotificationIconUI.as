package timmee.ui
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	
	public final class NotificationIconUI extends Sprite
	{
		public var fill:MovieClip;
		public var state:MovieClip;
		
		private var _initialized:Boolean;
		
		private var prevFrameLabel:String;
		
		
		public function NotificationIconUI()
		{
			super();
			initialize();
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			state = fill.getChildByName("fill_state") as MovieClip;
			_initialized = true;
		}
		
		public function dispose():void
		{
			_initialized = false;
			state = null;
		}
		
		
		public function gotoFrameWithProgress(value:Number):Boolean
		{
			value = value % 1.00;
			if (value < 0) {
				value = 1.00 + value;
			}
			
			var frame:int = fill.totalFrames * value;
			if (frame === 0) frame = 1;
			
			if (frame !== fill.currentFrame)
			{
				fill.gotoAndStop(frame);
				return true;
			}
			
			return false;
		}
		
		public function setProgressState(frameLabel:String):Boolean
		{
			if (state && frameLabel && state.currentLabel !== frameLabel)
			{
				state.gotoAndStop(frameLabel);
				return true;
			}
			
			return false;
		}
	}
}