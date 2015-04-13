package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import timmee.core.Application;
	
	
	public final class Timmee extends Sprite
	{
		private var application:Application;
		
		
		public function Timmee()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false);
			
			initialize();
		}
		
		
		private function initialize():void
		{
			tabChildren = false;
			tabEnabled = false;
			focusRect = null;
			
			var app:NativeApplication = NativeApplication.nativeApplication;
			app.addEventListener(Event.EXITING, exitingHandler, false, 0, false);
			
			application = Application.getInstance();
			application.initialize(app);
		}
		
		
		private function exitingHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			
			application.dispose();
			application = null;
			
			var app:NativeApplication = event.target as NativeApplication;
			app.removeEventListener(Event.EXITING, exitingHandler, false);
			app.exit();
		}
	}
}