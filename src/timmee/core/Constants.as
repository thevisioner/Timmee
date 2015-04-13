package timmee.core
{
	import flash.utils.Dictionary;
	
	import timmee.desktop.NotificationMenu;
	
	
	public class Constants
	{
		public static const DEV_VERSION:Boolean = true;
		
		
		public static const WINDOW_CORNER_OFFSET:int = 20;
		public static const WINDOW_CORNER_WIDTH:int = 240;
		public static const WINDOW_CORNER_HEIGHT:int = 130;
		
		public static const WINDOW_STANDARD_WIDTH:int = 480;
		public static const WINDOW_STANDARD_HEIGHT:int = 296;
		
		public static const COLOR_PAUSED:uint = 0xF4B651;
		public static const COLOR_RUNNING:uint = 0x00A652;
		public static const COLOR_STOPPED:uint = 0x939496;
		
		public static const FRAMERATE_ACTIVE:Number = 60;
		public static const FRAMERATE_INACTIVE:Number = 1;
		
		public static const TIMER_START_DELAY:int = 1000;
		public static const WINDOW_HIDE_DELAY:int = 1000 * 10;
		public static const NOTIFICATION_DELAY:int = 1000 * 15;
		public static const TIMER_ACCURACY_STEP_DELAY:int = 100;
		public static const MILLISECONDS_IN_MINUTE:int = 1000 * 60;
		public static const TIMER_BREAK_POSTPONE_RATIO:Number = 0.2;
		public static const TIMER_WORK_POSTPONE_RATIO:Number = 0.5;
		
		public static const TIMER_COMP_POSITION:Number = 115;
		public static const TIMER_COMP_POSITION_LEFT:Number = 92;
		public static const TIMER_COMP_POSITION_RIGHT:Number = 134;
		public static const TIMER_COMP_POSITION_STRETCH:Number = 20;
		public static const TIMER_COMP_MOVEMENT_FORCE:Number = 100;
		
		public static const BUTTON_POSITION_LEFT:Number = 48;
		public static const BUTTON_POSITION_RIGHT:Number = 151;
		public static const BUTTON_POSITION_WIDE_LEFT:Number = 38;
		public static const BUTTON_POSITION_WIDE_RIGHT:Number = 161;
		
		public static const TIMER_STATE_PAUSED:String = "State.Paused";
		public static const TIMER_STATE_RUNNING:String = "State.Running";
		public static const TIMER_STATE_STOPPED:String = "State.Stopped";
		
		
		public static const UPDATE_CONFIGURATION_URL:String = "app:/Timmee-update.xml";
		public static const SETTINGS_CONFIGURATION_URL:String = "app-storage:/Timmee-settings.xml";
		
		public static const ANALYTICS_TRACKING_CODE:String = "UA-41346477-2";
		public static const ANALITYCS_TRACKING_URL:String = "http://www.google-analytics.com/collect";
		
		public static const XML_DOCTYPE:String = '<?xml version="1.0" encoding="utf-8" standalone="no" ?>';
		
		
		public static const BEHANCE_PROJECT_URL:String = "";
		public static const GITHUB_PROJECT_URL:String = "";
		
		
		// STRINGS
		private static const STRING_RESOURCE:int = 500;
		
		public static const NOTIFICATION_ICON_TOOLTIP:int = STRING_RESOURCE + 1;
		public static const NOTIFICATION_ICON_TOOLTIP_WORKING:int = STRING_RESOURCE + 2;
		public static const NOTIFICATION_ICON_TOOLTIP_RESTING:int = STRING_RESOURCE + 3;
		public static const SETTINGS_WINDOW_TITLE:int = STRING_RESOURCE + 4;
		public static const TIMER_WINDOW_TITLE:int = STRING_RESOURCE + 5;
		public static const ABOUT_WINDOW_TITLE:int = STRING_RESOURCE + 6;
		public static const SESSION_TIME_MINUTES:int = STRING_RESOURCE + 7;
		public static const NOTIFICATION_WINDOW_TITLE:int = STRING_RESOURCE + 8;
		public static const NOTIFICATION_LONG_BREAK_TEXT:int = STRING_RESOURCE + 9;
		public static const NOTIFICATION_SHORT_BREAK_TEXT:int = STRING_RESOURCE + 10;
		public static const NOTIFICATION_RETURN_TO_WORK_TEXT:int = STRING_RESOURCE + 11;
		
		public static const MINUTES_TEXT:int = STRING_RESOURCE + 12;
		public static const POMODOROS_TEXT:int = STRING_RESOURCE + 13;
		
		private static const MISSING_STRING_RESOURCE:String = "missingStringResource";
		
		
		public static function getString(key:int, params:Array = null):String
		{
			var value:String = resourceDict.hasOwnProperty(key) ? String(resourceDict[key]) : null;
			
			if (value == null)
			{
				value = String(resourceDict[MISSING_STRING_RESOURCE]);
				params = [key];
			}
			
			if (params)
			{
				value = substitute(value, params);
			}
			
			return value;
		}
		
		private static function substitute(value:String, ... rest):String
		{
			var result:String = "";
			
			if (value)
			{
				result = value;
				
				var args:Array;
				var length:int = rest.length;
				if (length == 1 && rest[0] is Array)
				{
					args = rest[0] as Array;
					length = args.length;
				}
				else
				{
					args = rest;
				}
				
				for (var i:int = 0; i < length; i++)
				{
					result = result.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
				}
			}
			
			return result;
		}
		
		
		// ERRORS
		private static const ERROR_INTERNAL:int = 1000;
		
		public static const ERROR_NOTIFICATION_ICON_NOT_INITIALIZED:int = ERROR_INTERNAL;
		public static const ERROR_NOTIFICATION_ICON_NOT_SUPPORTED:int = ERROR_INTERNAL + 1;
		
		
		// STRING RESOURCE
		private static const resourceDict:Dictionary = new Dictionary();
		{
			resourceDict[NOTIFICATION_ICON_TOOLTIP] = "Timmee - pomodoro timer";
			resourceDict[NOTIFICATION_ICON_TOOLTIP_WORKING] = "Timmee - working";
			resourceDict[NOTIFICATION_ICON_TOOLTIP_RESTING] = "Timmee - resting";
			resourceDict[NOTIFICATION_WINDOW_TITLE] = "Timmee notification";
			resourceDict[SETTINGS_WINDOW_TITLE] = "Timmee settings";
			resourceDict[TIMER_WINDOW_TITLE] = "Timmee timer";
			resourceDict[ABOUT_WINDOW_TITLE] = "About Timmee";
			
			resourceDict[MINUTES_TEXT] = "minute{0}";
			resourceDict[POMODOROS_TEXT] = "pomodoro{0}";
			
			resourceDict[NotificationMenu.ITEM_TAKE_A_BREAK] = "Take a break";
			resourceDict[NotificationMenu.ITEM_RETURN_TO_WORK] = "Return to work";
			resourceDict[NotificationMenu.ITEM_CHANGE_TIME] = "Change time";
			resourceDict[NotificationMenu.ITEM_PAUSE] = "Pause";
			resourceDict[NotificationMenu.ITEM_RESUME] = "Resume";
			resourceDict[NotificationMenu.ITEM_STOP] = "Stop";
			resourceDict[NotificationMenu.ITEM_START] = "Start";
			resourceDict[NotificationMenu.ITEM_ALWAYS_ON_TOP] = "Always on top";
			resourceDict[NotificationMenu.ITEM_SETTINGS] = "Settings";
			resourceDict[NotificationMenu.ITEM_ABOUT] = "About";
			resourceDict[NotificationMenu.ITEM_QUIT] = "Quit";
			
			resourceDict[SESSION_TIME_MINUTES] = "{0} min";
			
			resourceDict[NOTIFICATION_RETURN_TO_WORK_TEXT] = "Break over! Return to work.";
			resourceDict[NOTIFICATION_SHORT_BREAK_TEXT] = "Session {0}# has finished. Take a short break!";
			resourceDict[NOTIFICATION_LONG_BREAK_TEXT] = "Session {0}# has finished. Take a long break! You deserve it!";
			
			resourceDict[ERROR_NOTIFICATION_ICON_NOT_INITIALIZED] = "NotificationIcon must be initialized before {0} call.";
			resourceDict[ERROR_NOTIFICATION_ICON_NOT_SUPPORTED] = "Current operating system does not support notification area icon.";
			
			resourceDict[MISSING_STRING_RESOURCE] = "No string for resource {0}.";
		}
	}
}