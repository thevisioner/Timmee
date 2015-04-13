package timmee.desktop
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import timmee.core.ApplicationState;
	import timmee.core.Constants;
	import timmee.events.NotificationMenuEvent;
	
	
	public class NotificationMenu extends EventDispatcher
	{
		public static const ITEM_TAKE_A_BREAK:int = 0;
		public static const ITEM_RETURN_TO_WORK:int = 1;
		public static const ITEM_CHANGE_TIME:int = 2;
		public static const ITEM_PAUSE:int = 3;
		public static const ITEM_RESUME:int = 4;
		public static const ITEM_STOP:int = 5;
		public static const ITEM_START:int = 6;
		public static const ITEM_ALWAYS_ON_TOP:int = 7;
		public static const ITEM_SETTINGS:int = 8;
		public static const ITEM_ABOUT:int = 9;
		public static const ITEM_QUIT:int = 10;
		
		private static const MARKER_TIMER_CONTROLS:String = "Marker.TimerControls";
		private static const MARKER_TIMER_CONTROLS_END:String = "Marker.TimerControls.END";
		
		
		private var itemSelectEvent:NotificationMenuEvent;
		private var itemReturnToWork:NativeMenuItem;
		private var itemTakeBreak:NativeMenuItem;
		private var itemResume:NativeMenuItem;
		private var itemPause:NativeMenuItem;
		private var itemStart:NativeMenuItem;
		private var itemStop:NativeMenuItem;
		
		
		private var _nativeMenu:NativeMenu;
		private var _initialized:Boolean;
		
		
		public function NotificationMenu()
		{
			super(null);
			initialize();
		}
		
		
		public function get nativeMenu():NativeMenu
		{
			return _nativeMenu;
		}
		
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			itemSelectEvent = new NotificationMenuEvent(NotificationMenuEvent.ITEM_SELECT);
			
			_nativeMenu = new NativeMenu();
			_nativeMenu.addEventListener(Event.SELECT, menuSelectHandler, false, 0, true);
			
			var items:Array = [];
			itemTakeBreak = new NativeMenuItem(Constants.getString(ITEM_TAKE_A_BREAK));
			itemTakeBreak.name = ITEM_TAKE_A_BREAK.toString();
			
			var item:NativeMenuItem = itemTakeBreak;
			item.enabled = false;
			items[0] = item;
			
			itemReturnToWork = new NativeMenuItem(Constants.getString(ITEM_RETURN_TO_WORK));
			itemReturnToWork.name = ITEM_RETURN_TO_WORK.toString();
			
			item = new NativeMenuItem("", true);
			item.name = MARKER_TIMER_CONTROLS;
			items[1] = item;
			
			itemResume = new NativeMenuItem(Constants.getString(ITEM_RESUME));
			itemResume.name = ITEM_RESUME.toString();
			
			itemPause = new NativeMenuItem(Constants.getString(ITEM_PAUSE));
			itemPause.name = ITEM_PAUSE.toString();
			
			itemStart = new NativeMenuItem(Constants.getString(ITEM_START));
			itemStart.name = ITEM_START.toString();
			
			itemStop = new NativeMenuItem(Constants.getString(ITEM_STOP));
			itemStop.name = ITEM_STOP.toString();
			
			item = new NativeMenuItem("", true);
			item.name = MARKER_TIMER_CONTROLS_END;
			items[2] = item;
			
			item = new NativeMenuItem(Constants.getString(ITEM_ALWAYS_ON_TOP));
			item.name = ITEM_ALWAYS_ON_TOP.toString();
			items[3] = item;
			
			item = new NativeMenuItem(Constants.getString(ITEM_SETTINGS));
			item.name = ITEM_SETTINGS.toString();
			items[4] = item;
			
			item = new NativeMenuItem(Constants.getString(ITEM_ABOUT));
			item.name = ITEM_ABOUT.toString();
			items[5] = item;
			
			item = new NativeMenuItem("", true);
			items[6] = item;
			
			item = new NativeMenuItem(Constants.getString(ITEM_QUIT));
			item.name = ITEM_QUIT.toString();
			items[7] = item;
			
			_nativeMenu.items = items;
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			if (_nativeMenu)
			{
				_nativeMenu.removeEventListener(Event.SELECT, menuSelectHandler, false);
				_nativeMenu.items = [];
				_nativeMenu = null;
			}
			
			itemSelectEvent = null;
			itemReturnToWork = null;
			itemTakeBreak = null;
			itemResume = null;
			itemPause = null;
			itemStart = null;
			itemStop = null;
		}
		
		
		public function updateAppStateByName(stateName:String):void
		{
			var items:Array = _nativeMenu.items;
			
			switch (stateName)
			{
				case ApplicationState.WORKING:
					items.splice(0, 1, itemTakeBreak);
					break;
				
				case ApplicationState.RESTING:
					items.splice(0, 1, itemReturnToWork);
					break;
			}
			
			_nativeMenu.items = items;
		}
		
		
		public function updateTimerState(state:String):void
		{
			var items:Array = _nativeMenu.items;
			
			var marker:NativeMenuItem = _nativeMenu.getItemByName(MARKER_TIMER_CONTROLS);
			var markerStartIndex:int = _nativeMenu.getItemIndex(marker);
			
			marker = _nativeMenu.getItemByName(MARKER_TIMER_CONTROLS_END);
			var markerEndIndex:int = _nativeMenu.getItemIndex(marker);
			
			switch (state)
			{
				case Constants.TIMER_STATE_PAUSED:
					items.splice(markerStartIndex + 1, markerEndIndex - markerStartIndex - 1, itemResume, itemStop);
					break;
				
				case Constants.TIMER_STATE_RUNNING:
					items.splice(markerStartIndex + 1, markerEndIndex - markerStartIndex - 1, itemPause, itemStop);
					break;
				
				case Constants.TIMER_STATE_STOPPED:
					items.splice(markerStartIndex + 1, markerEndIndex - markerStartIndex - 1, itemStart);
					break;
			}
			
			_nativeMenu.items = items;
		}
		
		
		public function checkItem(id:int, checked:Boolean):Boolean
		{
			var item:NativeMenuItem = _nativeMenu.getItemByName(id.toString());
			if (item) item.checked = checked;
			return checked;
		}
		
		public function enableItem(id:int, enabled:Boolean):Boolean
		{
			var item:NativeMenuItem = _nativeMenu.getItemByName(id.toString());
			if (item) item.enabled = enabled;
			return enabled;
		}
		
		
		private function menuSelectHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			
			var target:NativeMenuItem = event.target as NativeMenuItem;
			itemSelectEvent.updateTarget(target);
			dispatchEvent(itemSelectEvent);
		}
	}
}