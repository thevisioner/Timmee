package timmee.display
{
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import timmee.core.Application;
	import timmee.core.Constants;
	
	
	public class StandardWindowBase extends AppWindowBase
	{
		public function StandardWindowBase(context:Application, title:String)
		{
			var screenBounds:Rectangle = Screen.mainScreen.visibleBounds;
			
			var bounds:Rectangle = new Rectangle(
				(screenBounds.width - Constants.WINDOW_STANDARD_WIDTH) >> 1,
				(screenBounds.height - Constants.WINDOW_STANDARD_HEIGHT) >> 1,
				Constants.WINDOW_STANDARD_WIDTH,
				Constants.WINDOW_STANDARD_HEIGHT
			);
			
			super(context, title, bounds);
		}
		
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			centerWindow();
			
			addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, windowMoveHandler, false, 0, true);
		}
		
		
		override public function dispose():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, windowMoveHandler, false);
			removeEventListener(Event.ACTIVATE, activateHandler, false);
			super.dispose();
		}
		
		
		public function centerWindow():void
		{
			var screenBounds:Rectangle = Screen.mainScreen.visibleBounds;
			var chromeWidth:int = stage.nativeWindow.width - stage.stageWidth;
			var chromeHeight:int = stage.nativeWindow.height - stage.stageHeight;
			x = ((screenBounds.width - Constants.WINDOW_STANDARD_WIDTH) >> 1) - (chromeWidth >> 1);
			y = ((screenBounds.height - Constants.WINDOW_STANDARD_HEIGHT) >> 1) - (chromeHeight >> 1);
		}
		
		
		private function activateHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			centerWindow();
		}
		
		private function windowMoveHandler(event:MouseEvent):void
		{
			if (event.stageY <= 30) startMove();
		}
	}
}