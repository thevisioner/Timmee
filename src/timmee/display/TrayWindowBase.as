package timmee.display
{
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import timmee.core.Application;
	import timmee.core.Constants;
	
	
	public class TrayWindowBase extends AppWindowBase
	{
		private var hideTimer:Timer;
		private var mouseInside:Boolean;
		
		public function TrayWindowBase(context:Application, title:String)
		{
			var windowWidth:int = Constants.WINDOW_CORNER_WIDTH + Constants.WINDOW_CORNER_OFFSET;
			var windowHeight:int = Constants.WINDOW_CORNER_HEIGHT + Constants.WINDOW_CORNER_OFFSET;
			
			var screenBounds:Rectangle = Screen.mainScreen.visibleBounds;
			var bounds:Rectangle = new Rectangle(
				screenBounds.width + screenBounds.x - windowWidth,
				screenBounds.height + screenBounds.y - windowHeight,
				windowWidth,
				windowHeight
			);
			
			super(context, title, bounds, NativeWindowType.LIGHTWEIGHT);
		}
		
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			
			addEventListener(Event.CLOSING, closingHandler, false, 0, true);
			addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			
			hideTimer = new Timer(Constants.WINDOW_HIDE_DELAY);
			hideTimer.addEventListener(TimerEvent.TIMER, hideTimerHandler, false, 0, true);
		}
		
		
		override public function dispose():void
		{
			removeEventListener(Event.CLOSING, closingHandler, false);
			removeEventListener(Event.ACTIVATE, activateHandler, false);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
			
			if (hideTimer)
			{
				hideTimer.removeEventListener(TimerEvent.TIMER, hideTimerHandler, false);
				if (hideTimer.running) hideTimer.stop();
				hideTimer = null;
			}
			
			super.dispose();
		}
		
		
		override public function hide():void
		{
			if (hideTimer && hideTimer.running)
			{
				hideTimer.reset();
			}
			
			mouseInside = false;
			super.hide();
		}
		
		
		protected function mouseLeaveHandler(event:Event):void
		{
			mouseInside = false;
			hideTimer.start();
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			if (mouseInside) return;
			
			mouseInside = true;
			hideTimer.reset();
		}
		
		
		protected function activateHandler(event:Event):void
		{
			hideTimer.start();
		}
		
		protected function closingHandler(event:Event):void
		{
			if (hideTimer)
			{
				hideTimer.stop();
			}
		}
		
		
		private function hideTimerHandler(event:TimerEvent):void
		{
			event.stopImmediatePropagation();
			hide();
		}
	}
}