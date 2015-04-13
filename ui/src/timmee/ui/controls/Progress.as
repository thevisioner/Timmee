package timmee.ui.controls
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	import timmee.core.Constants;
	
	
	public class Progress extends Sprite
	{
		private static const BAR_WIDTH:int = 240;
		private static const BAR_HEIGHT:int = 4;
		
		
		public var bar:Shape
		
		private var _progress:Number;
		private var _state:String;
		
		
		public function Progress()
		{
			super();
		}
		
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		
		public function initialize():void
		{
			mouseChildren = false;
			mouseEnabled = false;
			
			bar = new Shape();
			addChild(bar);
			
			_progress = 0;
			_state = Constants.TIMER_STATE_STOPPED;
		}
		
		
		public function dispose():void
		{
			if (bar)
			{
				if (contains(bar))
				{
					removeChild(bar);
				}
				
				bar = null;
			}
			
			_progress = 0;
			_state = Constants.TIMER_STATE_STOPPED;
		}
		
		
		public function updateState(state:String):void
		{
			_state = state;
			updateBarGraphics();
		}
		
		public function updateProgress(value:Number):void
		{
			if (value < 0) value = 0;
			if (value > 1) value = 1;
			
			_progress = value;
			updateBarGraphics();
		}
		
		
		private function updateBarGraphics():void
		{
			bar.graphics.clear();
			bar.graphics.beginFill(getBarColorByState(_state), 1.0);
			bar.graphics.drawRect(0, 0, (BAR_WIDTH * _progress) >> 0, BAR_HEIGHT);
			bar.graphics.endFill();
		}
		
		
		private function getBarColorByState(state:String):uint
		{
			var color:uint;
			
			switch (state)
			{
				case Constants.TIMER_STATE_PAUSED:
					color = Constants.COLOR_PAUSED;
					break;
				
				case Constants.TIMER_STATE_RUNNING:
					color = Constants.COLOR_RUNNING;
					break;
				
				case Constants.TIMER_STATE_STOPPED:
					color = Constants.COLOR_STOPPED;
					break;
			}
			
			return color;
		}
	}
}