package timmee.display
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import timmee.core.Application;
	import timmee.core.Constants;
	import timmee.ui.AboutWindowUI;
	
	
	public class AboutWindow extends StandardWindowBase
	{
		private var windowUI:AboutWindowUI;
		private var socialLinksRequest:URLRequest;
		
		
		public function AboutWindow(context:Application)
		{
			super(context, Constants.getString(Constants.ABOUT_WINDOW_TITLE));
		}
		
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			
			windowUI = new AboutWindowUI();
			windowUI.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			windowUI.behance.addEventListener(MouseEvent.CLICK, behanceClickHandler, false, 0, true);
			windowUI.github.addEventListener(MouseEvent.CLICK, githubClickHandler, false, 0 , true);
			stage.addChild(windowUI);
			
			socialLinksRequest = new URLRequest();
		}
		
		
		override public function dispose():void
		{
			if (windowUI)
			{
				if (stage.contains(windowUI)) stage.removeChild(windowUI);
				windowUI.closeButton.removeEventListener(MouseEvent.CLICK, closeClickHandler, false);
				windowUI.behance.removeEventListener(MouseEvent.CLICK, behanceClickHandler, false);
				windowUI.github.removeEventListener(MouseEvent.CLICK, githubClickHandler, false);
				windowUI.dispose();
				windowUI = null;
			}
			
			socialLinksRequest = null;
			super.dispose();
		}
		
		
		private function closeClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			hide();
		}
		
		
		private function behanceClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			socialLinksRequest.url = Constants.BEHANCE_PROJECT_URL;
			if (socialLinksRequest.url) navigateToURL(socialLinksRequest);
		}
		
		private function githubClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			socialLinksRequest.url = Constants.GITHUB_PROJECT_URL;
			if (socialLinksRequest.url) navigateToURL(socialLinksRequest);
		}
	}
}