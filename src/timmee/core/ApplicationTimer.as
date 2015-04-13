package timmee.core
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import timmee.events.ApplicationTimerEvent;
	
	
	public class ApplicationTimer extends EventDispatcher
	{
		private var timer:Timer;
		private var startTime:int;
		private var delay:Boolean;
		private var delayOffset:int;
		private var tickEvent:ApplicationTimerEvent;
		private var sessionEndEvent:ApplicationTimerEvent;
		private var sessionLengthChangedEvent:ApplicationTimerEvent;
		
		private var _elapsedTime:int;
		private var _sessionLength:int;
		private var _initialized:Boolean;
		private var _currentState:String;
		
		
		public function ApplicationTimer()
		{
			super(null);
			initialize();
		}
		
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		
		public function get progress():Number
		{
			var progress:Number = delay ? delayOffset / _sessionLength : _elapsedTime / _sessionLength;
			if (progress > 1) progress = 1;
			return progress;
		}
		
		
		public function get remainingTime():int
		{
			return delay ? _sessionLength - delayOffset : _sessionLength - _elapsedTime;
		}
		
		public function get sessionLength():int
		{
			return _sessionLength;
		}
		
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			timer = new Timer(Constants.TIMER_ACCURACY_STEP_DELAY);
			timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
			
			tickEvent = new ApplicationTimerEvent(ApplicationTimerEvent.TICK, false, true);
			sessionEndEvent = new ApplicationTimerEvent(ApplicationTimerEvent.SESSION_END, false, true);
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER, timerHandler, false);
				timer.reset();
				timer = null;
			}
			
			sessionEndEvent = null;
			_currentState = null;
			tickEvent = null;
		}
		
		
		public function start():void
		{
			if (timer.running) return;
			
			_currentState = Constants.TIMER_STATE_RUNNING;
			startTime = getTimer();
			_elapsedTime = 0;
			
			delayOffset = 0;
			delay = true;
			
			timer.start();
		}
		
		public function stop():void
		{
			if (!timer.running) return;
			
			_currentState = Constants.TIMER_STATE_STOPPED;
			timer.reset();
		}
		
		public function pause():void
		{
			if (!timer.running) return;
			
			_currentState = Constants.TIMER_STATE_PAUSED;
			var delta:int = startTime - getTimer();
			_elapsedTime += delta;
			timer.reset();
		}
		
		public function resume():void
		{
			if (timer.running) return;
			
			_currentState = Constants.TIMER_STATE_RUNNING;
			startTime = getTimer();
			
			delayOffset = _elapsedTime;
			delay = true;
			
			timer.start();
		}
		
		public function reset():void
		{
			_currentState = Constants.TIMER_STATE_STOPPED;
			_elapsedTime = 0;
			timer.reset();
		}
		
		
		public function updateSessionLength(value:Number):void
		{
			_sessionLength = value;
		}
		
		
		private function timerHandler(event:TimerEvent):void
		{
			event.stopImmediatePropagation();
			
			timer.reset();
			
			var delta:int = getTimer() - startTime;
			_elapsedTime += delta;
			
			if (delay && (_elapsedTime - delayOffset) >= Constants.TIMER_START_DELAY)
			{
				_elapsedTime -= Constants.TIMER_START_DELAY;
				delay = false;
			}
			
			if (_elapsedTime < _sessionLength)
			{
				dispatchEvent(tickEvent);
				
				const accuracy:int = Constants.TIMER_ACCURACY_STEP_DELAY;
				var inaccuracy:int = accuracy - (delta % accuracy);
				timer.delay = accuracy + (inaccuracy >> 1);
				
				if (timer.delay > _sessionLength - _elapsedTime)
				{
					timer.delay = _sessionLength - _elapsedTime;
				}
				
				startTime = getTimer();
				timer.start();
			}
			else
			{
				dispatchEvent(sessionEndEvent);
			}
		}
	}
}