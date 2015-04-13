package timmee.display
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import timmee.core.Application;
	import timmee.core.Constants;
	import timmee.events.NotificationWindowEvent;
	import timmee.ui.NotificationWindowUI;
	
	
	public class NotificationWindow extends TrayWindowBase
	{
		private var closing:Boolean;
		private var windowTween:TweenLite;
		private var windowUI:NotificationWindowUI;
		private var postponeEvent:NotificationWindowEvent;
		
		
		public function NotificationWindow(context:Application)
		{
			super(context, Constants.getString(Constants.NOTIFICATION_WINDOW_TITLE));
		}
		
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			
			postponeEvent = new NotificationWindowEvent(NotificationWindowEvent.POSTPONE, false, true);
			
			windowUI = new NotificationWindowUI();
			windowUI.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			windowUI.postponeButton.addEventListener(MouseEvent.CLICK, postponeClickHandler, false, 0, true);
			windowUI.alpha = 0;
			stage.addChild(windowUI);
			
			alwaysInFront = true;
		}
		
		
		override public function dispose():void
		{
			if (windowTween)
			{
				windowTween.kill();
				windowTween = null;
			}
			
			if (windowUI)
			{
				if (stage.contains(windowUI)) stage.removeChild(windowUI);
				windowUI.postponeButton.removeEventListener(MouseEvent.CLICK, postponeClickHandler, false);
				windowUI.closeButton.removeEventListener(MouseEvent.CLICK, closeClickHandler, false);
				windowUI.dispose();
				windowUI = null;
			}
			
			postponeEvent = null;
			
			super.dispose();
		}
		
		
		public function updateTimerState(state:String):void
		{
			if (windowUI && state)
			{
				windowUI.progress.updateState(state);
			}
		}
		
		public function updateProgress(value:Number):void
		{
			if (windowUI)
			{
				windowUI.progress.updateProgress(value);
			}
		}
		
		
		public function updateText(stringId:int, sessionIndex:int = -1):void
		{
			windowUI.textField.text = Constants.getString(stringId, sessionIndex > -1 ? [String(sessionIndex + 1)] : null);
		}
		
		
		override protected function activateHandler(event:Event):void
		{
			if (visible) return;
			if (windowTween) windowTween.kill();
			
			closing = false;
			windowUI.alpha = 0;
			windowUI.y = Constants.WINDOW_CORNER_HEIGHT >> 2;
			windowTween = TweenLite.to(windowUI, 0.4, {alpha: 1, y: 0, ease: Quint.easeOut});
			
			super.activateHandler(event);
		}
		
		
		private function closeClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (closing) return;
			closing = true;
			
			if (windowTween) windowTween.kill();
			windowTween = TweenLite.to(windowUI, 0.3, {alpha: 0, y: Constants.WINDOW_CORNER_HEIGHT >> 2, ease: Quint.easeIn, onComplete: hideWindow});
		}
		
		
		private function postponeClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			dispatchEvent(postponeEvent);
		}
		
		
		private function hideWindow():void
		{
			hide();
		}
	}
}