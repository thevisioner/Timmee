package timmee.core.appStates
{
	import timmee.core.Application;
	import timmee.core.ApplicationSettings;
	import timmee.core.ApplicationState;
	import timmee.core.Constants;
	import timmee.events.ApplicationTimerEvent;
	import timmee.events.NotificationIconEvent;
	
	
	public class RestingState extends ApplicationState
	{
		public function RestingState(context:Application)
		{
			super(context, ApplicationState.RESTING);
		}
		
		
		override public function enter(prevState:ApplicationState = null):void
		{
			super.enter(prevState);
			
			timer.updateSessionLength(_context.shouldTakeLongBreak ? ApplicationSettings.longBreakLength : ApplicationSettings.shortBreakLength);
			
			timerWindow.updateRemainingTime(timer.remainingTime);
			timerWindow.updateSessionLength(timer.sessionLength);
			timerWindow.updateProgress(timer.progress);
			timerWindow.updateAppStateByName(_name);
		}
		
		
		override public function start():void
		{
			super.start();
			
			icon.trayIcon.tooltip = Constants.getString(Constants.NOTIFICATION_ICON_TOOLTIP_RESTING);
			menu.updateAppStateByName(_name);
			
			if (!timerWindow.visible)
			{
				_context.activateWindow(timerWindow);
			}
		}
		
		
		override public function toString():String
		{
			return "[RestingState name=\"" + name + "\"]";
		}
		
		
		
		
		override protected function iconClickHandler(event:NotificationIconEvent):void
		{
			_context.activateWindow(timerWindow);
		}
		
		
		override protected function tickHandler(event:ApplicationTimerEvent):void
		{
			icon.updateProgress(timer.progress);
			icon.drawIcon();
			
			timerWindow.updateProgress(timer.progress);
			timerWindow.updateRemainingTime(timer.remainingTime);
		}
		
		
		override protected function sessionEndHandler(event:ApplicationTimerEvent):void
		{
			_context.changeStateByName(ApplicationState.WAITING);
		}
	}
}