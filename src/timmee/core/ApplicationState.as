package timmee.core
{
	import timmee.desktop.NotificationIcon;
	import timmee.desktop.NotificationMenu;
	import timmee.display.NotificationWindow;
	import timmee.display.TimerWindow;
	import timmee.events.ApplicationTimerEvent;
	import timmee.events.NotificationIconEvent;
	import timmee.events.NotificationWindowEvent;
	
	
	public class ApplicationState extends Object
	{
		public static const WORKING:String = "working";
		public static const RESTING:String = "resting";
		public static const WAITING:String = "waiting";
		
		protected var _context:Application;
		protected var _name:String;
		
		
		protected var icon:NotificationIcon;
		protected var menu:NotificationMenu;
		protected var timer:ApplicationTimer;
		protected var timerWindow:TimerWindow;
		protected var notificationWindow:NotificationWindow;
		
		
		public function ApplicationState(context:Application, name:String)
		{
			super();
			
			_context = context;
			_name = name;
			
			icon = _context.icon;
			menu = _context.menu;
			timer = _context.timer;
			timerWindow = _context.timerWindow;
			notificationWindow = _context.notificationWindow;
		}
		
		
		public function get context():Application
		{
			return _context;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		
		public function enter(prevState:ApplicationState = null):void
		{
			icon.addEventListener(NotificationIconEvent.CLICK, iconClickHandler, false, 0, true);
			icon.updateTimerState(Constants.TIMER_STATE_STOPPED);
			icon.drawIcon();
			
			menu.updateTimerState(Constants.TIMER_STATE_STOPPED);
			menu.updateAppStateByName(name);
			
			timer.reset();
			timer.addEventListener(ApplicationTimerEvent.SESSION_END, sessionEndHandler, false, 0, true);
			timer.addEventListener(ApplicationTimerEvent.TICK, tickHandler, false, 0, true);
			
			timerWindow.updateTimerState(Constants.TIMER_STATE_STOPPED);
			notificationWindow.addEventListener(NotificationWindowEvent.POSTPONE, postponeHandler, false, 0, true);
		}
		
		public function exit():void
		{
			icon.removeEventListener(NotificationIconEvent.CLICK, iconClickHandler, false);
			icon.trayIcon.tooltip = Constants.getString(Constants.NOTIFICATION_ICON_TOOLTIP);
			
			timer.removeEventListener(ApplicationTimerEvent.SESSION_END, sessionEndHandler, false);
			timer.removeEventListener(ApplicationTimerEvent.TICK, tickHandler, false);
			timer.stop();
			
			notificationWindow.removeEventListener(NotificationWindowEvent.POSTPONE, postponeHandler, false);
		}
		
		
		public function stop():void
		{
			icon.updateTimerState(Constants.TIMER_STATE_STOPPED);
			icon.drawIcon();
			
			menu.updateTimerState(Constants.TIMER_STATE_STOPPED);
			menu.enableItem(NotificationMenu.ITEM_TAKE_A_BREAK, false);
			menu.enableItem(NotificationMenu.ITEM_RETURN_TO_WORK, false);
			
			timer.stop();
			timerWindow.updateTimerState(Constants.TIMER_STATE_STOPPED);
			
			//_context.changeFrameRate(Constants.FRAMERATE_INACTIVE);
		}
		
		public function pause():void
		{
			icon.updateTimerState(Constants.TIMER_STATE_PAUSED);
			icon.drawIcon();
			
			menu.updateTimerState(Constants.TIMER_STATE_PAUSED);
			
			timer.pause();
			timerWindow.updateTimerState(Constants.TIMER_STATE_PAUSED);
			
			//_context.changeFrameRate(Constants.FRAMERATE_INACTIVE);
		}
		
		public function start():void
		{
			icon.updateTimerState(Constants.TIMER_STATE_RUNNING);
			icon.drawIcon();
			
			menu.updateTimerState(Constants.TIMER_STATE_RUNNING);
			menu.enableItem(NotificationMenu.ITEM_TAKE_A_BREAK, true);
			menu.enableItem(NotificationMenu.ITEM_RETURN_TO_WORK, true);
			
			timer.start();
			timerWindow.updateTimerState(Constants.TIMER_STATE_RUNNING);
			
			//_context.changeFrameRate(Constants.FRAMERATE_ACTIVE);
		}
		
		public function resume():void
		{
			icon.updateTimerState(Constants.TIMER_STATE_RUNNING);
			icon.drawIcon();
			
			menu.updateTimerState(Constants.TIMER_STATE_RUNNING);
			
			timer.resume();
			timerWindow.updateTimerState(Constants.TIMER_STATE_RUNNING);
			
			//_context.changeFrameRate(Constants.FRAMERATE_ACTIVE);
		}
		
		
		public function dispose():void
		{
			_context = null;
			_name = null;
			
			if (icon)
			{
				icon.removeEventListener(NotificationIconEvent.CLICK, iconClickHandler, false);
				icon = null;
			}
			
			menu = null;
			
			if (timer)
			{
				timer.removeEventListener(ApplicationTimerEvent.SESSION_END, sessionEndHandler, false);
				timer.removeEventListener(ApplicationTimerEvent.TICK, tickHandler, false);
				timer.reset();
				timer = null;
			}
			
			timerWindow = null;
			
			if (notificationWindow)
			{
				notificationWindow.removeEventListener(NotificationWindowEvent.POSTPONE, postponeHandler, false);
				notificationWindow = null;
			}
		}
		
		
		public function toString():String
		{
			return "[ApplicationState name=\"" + name + "\"]";
		}
		
		
		
		
		protected function iconClickHandler(event:NotificationIconEvent):void
		{
			// For implementation
		}
		
		protected function postponeHandler(event:NotificationWindowEvent):void
		{
			// For implementation
		}
		
		
		protected function tickHandler(event:ApplicationTimerEvent):void
		{
			// For implementation
		}
		
		protected function sessionEndHandler(event:ApplicationTimerEvent):void
		{
			// For implementation
		}
	}
}