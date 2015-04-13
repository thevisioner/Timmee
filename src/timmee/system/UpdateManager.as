package timmee.system
{
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import timmee.core.Constants;
	
	
	public final class UpdateManager extends EventDispatcher
	{
		private var initialized:Boolean;
		private var appUpdater:ApplicationUpdaterUI;
		
		
		public function UpdateManager()
		{
			super(null);
		}
		
		
		public function initielize():void
		{
			if (Capabilities.isDebugger || initialized) return;
			
			appUpdater = new ApplicationUpdaterUI();
			appUpdater.configurationFile = new File(Constants.UPDATE_CONFIGURATION_URL);
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, updaterInitializedHandler, false, 0, true);
			appUpdater.addEventListener(ErrorEvent.ERROR, updaterErrorHandler, false, 0, true);
			appUpdater.initialize();
			
			initialized = true;
		}
		
		
		public function dispose():void
		{
			initialized = false;
			
			if (appUpdater)
			{
				appUpdater.cancelUpdate();
				appUpdater.removeEventListener(UpdateEvent.INITIALIZED, updaterInitializedHandler, false);
				appUpdater.removeEventListener(ErrorEvent.ERROR, updaterErrorHandler, false);
				appUpdater = null;
			}
		}
		
		
		private function updaterInitializedHandler(event:UpdateEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		private function updaterErrorHandler(event:ErrorEvent):void
		{
			event.stopImmediatePropagation();
		}
	}
}