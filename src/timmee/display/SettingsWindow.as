package timmee.display
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import timmee.core.Application;
	import timmee.core.Constants;
	import timmee.ui.SettingsWindowUI;
	
	
	public class SettingsWindow extends StandardWindowBase
	{
		private var windowUI:SettingsWindowUI;
		
		
		public function SettingsWindow(context:Application)
		{
			super(context, Constants.getString(Constants.SETTINGS_WINDOW_TITLE));
		}
		
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			
			windowUI = new SettingsWindowUI();
			windowUI.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			stage.addChild(windowUI);
			
			addEventListener(Event.ACTIVATE, activateHandler, false, 0, true);
		}
		
		
		override public function dispose():void
		{
			removeEventListener(Event.ACTIVATE, activateHandler, false);
			
			if (windowUI)
			{
				if (stage.contains(windowUI)) stage.removeChild(windowUI);
				windowUI.closeButton.removeEventListener(MouseEvent.CLICK, closeClickHandler, false);
				windowUI.dispose();
				windowUI = null;
			}
			
			super.dispose();
		}
		
		
		private function activateHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			windowUI.updateSettings();
		}
		
		
		private function closeClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			hide();
		}
	}
}