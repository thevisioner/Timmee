package timmee.core
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import timmee.core.appStates.RestingState;
	import timmee.core.appStates.WaitingState;
	import timmee.core.appStates.WorkingState;
	import timmee.desktop.NotificationIcon;
	import timmee.desktop.NotificationMenu;
	import timmee.display.AboutWindow;
	import timmee.display.NotificationWindow;
	import timmee.display.SettingsWindow;
	import timmee.display.StandardWindowBase;
	import timmee.display.TimerWindow;
	import timmee.display.TrayWindowBase;
	import timmee.events.NotificationMenuEvent;
	import timmee.system.UpdateManager;
	import timmee.system.UsageStatistics;
	
	
	public class Application extends Object
	{
		private static var instance:Application;
		
		
		private var updateManager:UpdateManager;
		private var usageStatistics:UsageStatistics;
		private var app:NativeApplication;
		private var workingState:ApplicationState;
		private var restingState:ApplicationState;
		private var waitingState:ApplicationState;
		
		
		private var _currentState:ApplicationState;
		private var _lastState:ApplicationState;
		private var _initialized:Boolean;
		private var _sessionIndex:int;
		private var _frameRate:Number;
		
		private var _icon:NotificationIcon;
		private var _menu:NotificationMenu;
		private var _timer:ApplicationTimer;
		private var _aboutWindow:AboutWindow;
		private var _timerWindow:TimerWindow;
		private var _settingsWindow:SettingsWindow;
		private var _notificationWindow:NotificationWindow;
		
		
		public function Application(singleton:ApplicationSingleton)
		{
			super();
		}
		
		
		public static function getInstance():Application
		{
			return instance ||= new Application(new ApplicationSingleton());
		}
		
		
		public function get currentState():ApplicationState
		{
			return _currentState;
		}
		
		public function get lastState():ApplicationState
		{
			return _lastState;
		}
		
		public function get timerState():String
		{
			return _timer.currentState;
		}
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function get version():String
		{
			var appXML:XML = app.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			
			var appVersion:String = appXML.ns::versionNumber[0];
			return appVersion;
		}
		
		public function get sessionIndex():int
		{
			return _sessionIndex;
		}
		
		
		public function get icon():NotificationIcon
		{
			return _icon;
		}
		
		public function get menu():NotificationMenu
		{
			return _menu;
		}
		
		public function get timer():ApplicationTimer
		{
			return _timer;
		}
		
		public function get timerWindow():TimerWindow
		{
			return _timerWindow;
		}
		
		public function get notificationWindow():NotificationWindow
		{
			return _notificationWindow;
		}
		
		
		public function get shouldTakeLongBreak():Boolean
		{
			return (_sessionIndex > 0 && (_sessionIndex % (ApplicationSettings.longBreakDelay - 1)) === 0);
		}
		
		
		public function initialize(nativeApplication:NativeApplication):void
		{
			if (_initialized) return;
			
			ApplicationSettings.load();
			
			app = nativeApplication;
			app.autoExit = false;
			
			updateManager = new UpdateManager();
			updateManager.initielize();
			
			usageStatistics = new UsageStatistics();
			usageStatistics.initielize(app);
			usageStatistics.track(UsageStatistics.ACTION_APP_LAUNCHED, Constants.DEV_VERSION ? UsageStatistics.CATEGORY_DEV_VERSION : null);
			
			_menu = new NotificationMenu();
			_menu.addEventListener(NotificationMenuEvent.ITEM_SELECT, menuItemSelectHandler, false, 0, true);
			_menu.checkItem(NotificationMenu.ITEM_ALWAYS_ON_TOP, ApplicationSettings.alwaysOnTop);
			
			_icon = new NotificationIcon();
			_icon.attachMenu(_menu);
			
			_timer = new ApplicationTimer();
			_timer.updateSessionLength(ApplicationSettings.sessionLength);
			
			_timerWindow = new TimerWindow(this);
			_timerWindow.attachMenu(_menu);
			_timerWindow.updateRemainingTime(_timer.remainingTime);
			_timerWindow.updateSessionLength(ApplicationSettings.sessionLength);
			_timerWindow.alwaysInFront = ApplicationSettings.alwaysOnTop;
			
			_notificationWindow = new NotificationWindow(this);
			
			workingState = new WorkingState(this);
			restingState = new RestingState(this);
			waitingState = new WaitingState(this);
			
			//changeFrameRate(Constants.FRAMERATE_INACTIVE);
			changeStateByName(ApplicationState.WORKING);
			activateWindow(_timerWindow);
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			if (_initialized)
			{
				workingState.dispose();
				workingState = null;
				restingState.dispose();
				restingState = null;
				waitingState.dispose();
				waitingState = null;
				
				_timer.dispose();
				_timer = null;
				
				try
				{
					_timerWindow.close();
				} catch (error:IllegalOperationError) { }
				_timerWindow.dispose();
				_timerWindow = null;
				
				try
				{
					_notificationWindow.close();
				} catch (error:IllegalOperationError) { }
				_notificationWindow.dispose();
				_notificationWindow = null;
				
				_menu.removeEventListener(NotificationMenuEvent.ITEM_SELECT, menuItemSelectHandler, false);
				_menu.dispose();
				_menu = null;
				
				_icon.dispose();
				_icon = null;
				
				_lastState = null;
				_currentState = null;
				_sessionIndex = 0;
				
				if (updateManager)
				{
					updateManager.dispose();
					updateManager = null;
				}
				
				if (usageStatistics)
				{
					usageStatistics.dispose();
					usageStatistics = null;
				}
				
				app = null;
				instance = null;
				ApplicationSettings.save();
				
				_initialized = false;
			}
		}
		
		
		public function changeStateByName(newStateName:String):Boolean
		{
			var state:ApplicationState;
			
			switch (newStateName)
			{
				case ApplicationState.WORKING:
					state = workingState;
					break;
				
				case ApplicationState.RESTING:
					state = restingState;
					break;
				
				case ApplicationState.WAITING:
					state = waitingState;
					break;
			}
			
			if (state && state !== _currentState)
			{
				changeState(state);
				return true;
			}
			
			return false;
		}
		
		private function changeState(newState:ApplicationState):void
		{
			_lastState = _currentState;
			if (_lastState) _lastState.exit();
			
			_currentState = newState;
			_currentState.enter(_lastState);
		}
		
		
		public function incrementSessionIndex(value:int):int
		{
			_sessionIndex += value;
			return _sessionIndex;
		}
		
		
		public function smartDivideSessionLength():void
		{
			// TODO: Round time to nearest minute;
			
			if (_currentState.name === ApplicationState.WORKING)
			{
				_timer.updateSessionLength(ApplicationSettings.sessionLength * Constants.TIMER_BREAK_POSTPONE_RATIO);
			}
			else if (_currentState.name === ApplicationState.RESTING)
			{
				if (shouldTakeLongBreak)
				{
					_timer.updateSessionLength(ApplicationSettings.longBreakLength * Constants.TIMER_WORK_POSTPONE_RATIO);
				}
				else
				{
					_timer.updateSessionLength(ApplicationSettings.shortBreakLength);
				}
			}
		}
		
		
		public function activateWindow(window:NativeWindow):void
		{
			window.stage.frameRate = _frameRate;
			
			window.activate();
			app.activate(window);
		}
		
		public function hideAllOpenWindows():void
		{
			var openedWindows:Array =  app.openedWindows;
			var window:NativeWindow;
			
			var n:uint = openedWindows.length;
			for (var i:uint; i < n; i ++)
			{
				window = openedWindows[i];
				
				if (window is TrayWindowBase)
				{
					TrayWindowBase(window).hide();
				}
				else if (window is StandardWindowBase)
				{
					StandardWindowBase(window).hide();
				}
			}
		}
		
		
		public function changeFrameRate(frameRate:Number):void
		{
			_frameRate = frameRate;
			
			var n:uint = app.openedWindows.length
			if (n > 0)
			{
				var window:NativeWindow;
				for (var i:uint; i < n; i++)
				{
					window = app.openedWindows[i];
					window.stage.frameRate = _frameRate;
				}
			}
		}
		
		
		private function menuItemSelectHandler(event:NotificationMenuEvent):void
		{
			if (event)
			{
				event.stopImmediatePropagation();
				
				switch (event.getTargetId())
				{
					case NotificationMenu.ITEM_TAKE_A_BREAK:
						changeStateByName(ApplicationState.RESTING);
						incrementSessionIndex(+1);
						_currentState.start();
						break;
					
					case NotificationMenu.ITEM_RETURN_TO_WORK:
						changeStateByName(ApplicationState.WORKING);
						_currentState.start();
						break;
					
					case NotificationMenu.ITEM_PAUSE:
						_currentState.pause();
						break;
					
					case NotificationMenu.ITEM_RESUME:
						_currentState.resume();
						break;
					
					case NotificationMenu.ITEM_STOP:
						_currentState.stop();
						break;
					
					case NotificationMenu.ITEM_START:
						_currentState.start();
						break;
					
					case NotificationMenu.ITEM_ALWAYS_ON_TOP:
						ApplicationSettings.alwaysOnTop = _menu.checkItem(NotificationMenu.ITEM_ALWAYS_ON_TOP, !ApplicationSettings.alwaysOnTop);
						
						_timerWindow.alwaysInFront = ApplicationSettings.alwaysOnTop;
						if (ApplicationSettings.alwaysOnTop && _currentState.name === ApplicationState.WORKING) activateWindow(_timerWindow);
						else if (ApplicationSettings.alwaysOnTop && _currentState.name === ApplicationState.RESTING) activateWindow(_notificationWindow);
						
						break;
					
					case NotificationMenu.ITEM_SETTINGS:
						hideAllOpenWindows();
						
						if (!_settingsWindow)
						{
							_settingsWindow = new SettingsWindow(this);
						}
						
						activateWindow(_settingsWindow);
						break;
					
					case NotificationMenu.ITEM_ABOUT:
						hideAllOpenWindows();
						
						if (!_aboutWindow)
						{
							_aboutWindow = new AboutWindow(this);
						}
						
						activateWindow(_aboutWindow);
						break;
					
					case NotificationMenu.ITEM_QUIT:
						usageStatistics.track(UsageStatistics.ACTION_APP_EXITED);
						app.dispatchEvent(new Event(Event.EXITING));
						break;
				}
				
				event.releaseTarget();
			}
		}
	}
}


internal final class ApplicationSingleton { }