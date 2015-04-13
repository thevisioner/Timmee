package timmee.core.appStates
{
	import timmee.core.Application;
	import timmee.core.ApplicationSettings;
	import timmee.core.ApplicationState;
	import timmee.core.Constants;
	import timmee.events.ApplicationTimerEvent;
	import timmee.events.NotificationIconEvent;
	
	
	public class WorkingState extends ApplicationState
	{
		public function WorkingState(context:Application)
		{
			super(context, ApplicationState.WORKING);
		}
		
		
		override public function enter(prevState:ApplicationState = null):void
		{
			super.enter(prevState);
			
			icon.updateProgress(timer.progress);
			icon.drawIcon();
			
			timer.updateSessionLength(ApplicationSettings.sessionLength);
			
			timerWindow.updateRemainingTime(timer.remainingTime);
			timerWindow.updateSessionLength(timer.sessionLength);
			timerWindow.updateProgress(timer.progress);
			timerWindow.updateAppStateByName(_name);
		}
		
		
		override public function start():void
		{
			super.start();
			
			icon.trayIcon.tooltip = Constants.getString(Constants.NOTIFICATION_ICON_TOOLTIP_WORKING);
			menu.updateAppStateByName(_name);
			
			if (!timerWindow.visible)
			{
				_context.activateWindow(timerWindow);
			}
		}
		
		
		override public function toString():String
		{
			return "[WorkingState name=\"" + name + "\"]";
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
			_context.incrementSessionIndex(+1);
		}
	}
}