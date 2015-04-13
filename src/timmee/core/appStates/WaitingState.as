package timmee.core.appStates
{
	import timmee.core.Application;
	import timmee.core.ApplicationState;
	import timmee.core.Constants;
	import timmee.events.ApplicationTimerEvent;
	import timmee.events.NotificationIconEvent;
	import timmee.events.NotificationWindowEvent;
	
	
	public class WaitingState extends ApplicationState
	{
		public function WaitingState(context:Application)
		{
			super(context, ApplicationState.WAITING);
		}
		
		
		override public function enter(prevState:ApplicationState = null):void
		{
			super.enter();
			
			icon.updateTimerState(Constants.TIMER_STATE_RUNNING);
			icon.drawIcon();
			
			timer.updateSessionLength(Constants.NOTIFICATION_DELAY);
			timer.start();
			
			if (timerWindow.visible) timerWindow.hide();
			
			if (prevState.name === ApplicationState.WORKING)
			{
				notificationWindow.updateText(_context.shouldTakeLongBreak ?
					Constants.NOTIFICATION_LONG_BREAK_TEXT : Constants.NOTIFICATION_SHORT_BREAK_TEXT, _context.sessionIndex);
			}
			else if (prevState.name === ApplicationState.RESTING)
			{
				notificationWindow.updateText(Constants.NOTIFICATION_RETURN_TO_WORK_TEXT);
			}
			
			notificationWindow.updateTimerState(Constants.TIMER_STATE_RUNNING);
			
			_context.activateWindow(notificationWindow);
		}
		
		
		override public function exit():void
		{
			if (notificationWindow.visible)
			{
				notificationWindow.hide();
			}
			
			super.exit();
		}
		
		
		override public function start():void
		{
			if (_context.lastState.name === ApplicationState.WORKING)
			{
				_context.changeStateByName(ApplicationState.RESTING);
			}
			else if (_context.lastState.name === ApplicationState.RESTING)
			{
				_context.changeStateByName(ApplicationState.WORKING);
			}
			
			_context.currentState.start();
		}
		
		
		override public function toString():String
		{
			return "[WaitingState name=\"" + name + "\"]";
		}
		
		
		
		
		override protected function iconClickHandler(event:NotificationIconEvent):void
		{
			_context.activateWindow(notificationWindow);
		}
		
		
		override protected function tickHandler(event:ApplicationTimerEvent):void
		{
			notificationWindow.updateProgress(timer.progress);
		}
		
		
		override protected function sessionEndHandler(event:ApplicationTimerEvent):void
		{
			if (_context.lastState.name === ApplicationState.WORKING)
			{
				_context.changeStateByName(ApplicationState.RESTING);
				start();
			}
			else if (_context.lastState.name === ApplicationState.RESTING)
			{
				_context.changeStateByName(ApplicationState.WORKING);
			}
		}
		
		
		override protected function postponeHandler(event:NotificationWindowEvent):void
		{
			_context.changeStateByName(_context.lastState.name);
			_context.smartDivideSessionLength();
			_context.incrementSessionIndex(-1);
			_context.currentState.start();
		}
	}
}