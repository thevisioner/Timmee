package timmee.desktop
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.ScreenMouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import timmee.core.Constants;
	import timmee.events.NotificationIconEvent;
	import timmee.ui.NotificationIconUI;
	
	
	public class NotificationIcon extends EventDispatcher
	{
		private static const ICON_SIZE_16:int = 16;
		private static const ICON_SIZE_32:int = 32;
		private static const ICON_SIZE_48:int = 48;
		private static const ICON_SIZE_128:int = 128;
		private static const ICON_SIZE_512:int = 512;
		
		
		private var _initialized:Boolean;
		private var _trayIcon:SystemTrayIcon;
		
		private var dirty:Boolean;
		private var iconAssetMatrix:Matrix;
		private var iconAssetRectangle:Rectangle;
		private var iconAssetBitmapData:BitmapData;
		private var iconUI:NotificationIconUI;
		
		private var clickEvent:NotificationIconEvent;
		private var changedEvent:NotificationIconEvent;
		
		
		public function NotificationIcon()
		{
			super(null);
			initialize();
		}
		
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		
		public function get trayIcon():SystemTrayIcon
		{
			return _trayIcon;
		}
		
		
		private function initialize():void
		{
			if (_initialized) return;
			
			if (NativeApplication.supportsSystemTrayIcon)
			{
				clickEvent = new NotificationIconEvent(NotificationIconEvent.CLICK);
				changedEvent = new NotificationIconEvent(NotificationIconEvent.CHANGED);
				
				_trayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				_trayIcon.tooltip = Constants.getString(Constants.NOTIFICATION_ICON_TOOLTIP);
				_trayIcon.addEventListener(ScreenMouseEvent.CLICK, iconClickHandler, false, 0, true);
				
				iconAssetBitmapData = new BitmapData(ICON_SIZE_16, ICON_SIZE_16, true, 0x00000000);
				iconUI = new NotificationIconUI();
				
				_initialized = true;
			}
			else
			{
				var errorId:int = Constants.ERROR_NOTIFICATION_ICON_NOT_SUPPORTED;
				throw new IllegalOperationError(Constants.getString(errorId), errorId);
			}
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			if (_trayIcon)
			{
				if (_trayIcon.hasEventListener(ScreenMouseEvent.CLICK))
					_trayIcon.removeEventListener(ScreenMouseEvent.CLICK, iconClickHandler, false);
				
				_trayIcon.bitmaps = [];
				_trayIcon = null;
			}
			
			if (iconUI)
			{
				iconUI.dispose();
				iconUI = null;
			}
			
			if (iconAssetBitmapData)
			{
				iconAssetBitmapData.dispose();
				iconAssetBitmapData = null;
			}
			
			if (iconAssetRectangle)
			{
				iconAssetRectangle = null;
			}
			
			if (iconAssetMatrix)
			{
				iconAssetMatrix = null;
			}
			
			dirty = false;
			clickEvent = null;
			changedEvent = null;
		}
		
		
		public function attachMenu(notificationMenu:NotificationMenu):void
		{
			if (_trayIcon)
			{
				_trayIcon.menu = notificationMenu.nativeMenu;
			}
			else
			{
				throw new IllegalOperationError(Constants.getString(Constants.ERROR_NOTIFICATION_ICON_NOT_INITIALIZED, ["attachMenu"]));
			}
		}
		
		
		public function updateTimerState(state:String):void
		{
			if (iconUI && state)
			{
				var changed:Boolean = iconUI.setProgressState(state);
				if (changed) dirty = true;
			}
		}
		
		public function updateProgress(value:Number):void
		{
			if (iconUI)
			{
				var changed:Boolean = iconUI.gotoFrameWithProgress(value);
				if (changed) dirty = true;
			}
		}
		
		
		public function drawIcon():void
		{
			if (dirty)
			{
				drawIconBitmapData(iconAssetBitmapData, iconUI, ICON_SIZE_16, true);
				_trayIcon.bitmaps = [iconAssetBitmapData];
				
				if (hasEventListener(NotificationIconEvent.CHANGED))
				{
					dispatchEvent(changedEvent);
				}
			}
		}
		
		
		private function iconClickHandler(event:ScreenMouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (hasEventListener(NotificationIconEvent.CLICK))
			{
				dispatchEvent(clickEvent);
			}
		}
		
		
		private function drawIconBitmapData(bitmapData:BitmapData, icon:NotificationIconUI, size:int, clear:Boolean = false):void
		{
			if (clear)
			{
				if (!iconAssetRectangle)
				{
					iconAssetRectangle = new Rectangle(0, 0, size, size);
				}
				
				bitmapData.fillRect(iconAssetRectangle, 0x00000000);
			}
			
			if (!iconAssetMatrix)
			{
				var s:Number = size / icon.width;
				
				iconAssetMatrix = new Matrix();
				iconAssetMatrix.scale(s, s);
			}
			
			bitmapData.drawWithQuality(icon, iconAssetMatrix, null, null, null, true, StageQuality.HIGH_16X16);
		}
	}
}