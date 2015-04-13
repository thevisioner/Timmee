package timmee.display
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quint;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import timmee.core.Application;
	import timmee.core.ApplicationState;
	import timmee.core.Constants;
	import timmee.desktop.NotificationMenu;
	import timmee.ui.TimerWindowUI;
	
	
	public class TimerWindow extends TrayWindowBase
	{
		private var windowUI:TimerWindowUI;
		
		private var windowTween:TweenLite;
		private var timeCompTween:TweenLite;
		private var stopButtonTween:TweenLite;
		private var pauseButtonTween:TweenLite;
		private var startButtonTween:TweenLite;
		private var closeButtonTween:TweenLite;
		
		private var closing:Boolean;
		private var timeMouseDown:Boolean;
		private var predictedTimerState:String;
		private var timeMouseDownPosition:Number;
		
		private var notificationMenu:NotificationMenu;
		
		
		public function TimerWindow(context:Application)
		{
			super(context, Constants.getString(Constants.TIMER_WINDOW_TITLE));
		}
		
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			
			windowUI = new TimerWindowUI();
			windowUI.bellIcon.visible = false;
			windowUI.time.addEventListener(MouseEvent.MOUSE_DOWN, timeMouseDownHandler, false, 0, true);
			windowUI.menuButton.addEventListener(MouseEvent.CLICK, menuClickHandler, false, 0, true);
			
			windowUI.closeButton.alpha = 0;
			windowUI.closeButton.addEventListener(MouseEvent.CLICK, closeClickHandler, false, 0, true);
			windowUI.closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler, false, 0, true);
			windowUI.closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler, false, 0, true);
			
			windowUI.pauseButton.visible = false;
			windowUI.startButton.visible = false;
			windowUI.stopButton.visible = false;
			
			windowUI.alpha = 0;
			stage.addChild(windowUI);
		}
		
		
		override public function dispose():void
		{
			if (stage.hasEventListener(MouseEvent.MOUSE_UP))
				stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false);
			
			stage.removeEventListener(MouseEvent.RIGHT_CLICK, menuClickHandler, false);
			
			if (windowTween)
			{
				windowTween.kill();
				windowTween = null;
			}
			
			if (timeCompTween)
			{
				timeCompTween.kill();
				timeCompTween = null;
			}
			
			if (stopButtonTween)
			{
				stopButtonTween.kill();
				stopButtonTween = null;
			}
			
			if (startButtonTween)
			{
				startButtonTween.kill();
				startButtonTween = null;
			}
			
			if (pauseButtonTween)
			{
				pauseButtonTween.kill();
				pauseButtonTween = null;
			}
			
			if (windowUI)
			{
				if (stage.contains(windowUI)) stage.removeChild(windowUI);
				
				windowUI.closeButton.removeEventListener(MouseEvent.CLICK, closeClickHandler, false);
				windowUI.closeButton.removeEventListener(MouseEvent.MOUSE_OUT, closeOutHandler, false);
				windowUI.closeButton.removeEventListener(MouseEvent.MOUSE_OVER, closeOverHandler, false);
				
				windowUI.menuButton.removeEventListener(MouseEvent.CLICK, menuClickHandler, false);
				windowUI.time.removeEventListener(MouseEvent.MOUSE_DOWN, timeMouseDownHandler, false);
				windowUI.dispose();
				windowUI = null;
			}
			
			predictedTimerState = null;
			notificationMenu = null;
			
			super.dispose();
		}
		
		
		public function attachMenu(notificationMenu:NotificationMenu):void
		{
			this.notificationMenu = notificationMenu;
			stage.addEventListener(MouseEvent.RIGHT_CLICK, menuClickHandler, false, 0, true);
		}
		
		
		public function updateRemainingTime(value:int):void
		{
			windowUI.timeRemaining.text = formatTime(value);
		}
		
		public function updateSessionLength(value:int):void
		{
			windowUI.sessionLength.text = formatSessionTime(value);
			windowUI.session.x = -(windowUI.session.width >> 1);
			
			var minutesString:String = formatTimeString(value, false, true);
			if (minutesString.length < 2)
			{
				windowUI.stopButton.x = Constants.BUTTON_POSITION_LEFT;
				windowUI.startButton.x = Constants.BUTTON_POSITION_RIGHT;
				windowUI.pauseButton.x = Constants.BUTTON_POSITION_RIGHT;
			} else {
				windowUI.stopButton.x = Constants.BUTTON_POSITION_WIDE_LEFT;
				windowUI.startButton.x = Constants.BUTTON_POSITION_WIDE_RIGHT;
				windowUI.pauseButton.x = Constants.BUTTON_POSITION_WIDE_RIGHT;
			}
		}
		
		
		public function updateAppStateByName(stateName:String):void
		{
			switch (stateName)
			{
				case ApplicationState.WORKING:
					windowUI.briefcaseIcon.visible = true;
					windowUI.bellIcon.visible = false;
					break;
				
				case ApplicationState.RESTING:
					windowUI.bellIcon.visible = true;
					windowUI.briefcaseIcon.visible = false;
					break;
			}
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
		
		
		private function timeMouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (timeCompTween) timeCompTween.kill();
			if (stopButtonTween) stopButtonTween.kill();
			if (startButtonTween) startButtonTween.kill();
			if (pauseButtonTween) pauseButtonTween.kill();
			
			if (context.timerState === Constants.TIMER_STATE_STOPPED ||
				context.timerState === Constants.TIMER_STATE_PAUSED)
			{
				windowUI.startButton.alpha = 0;
				windowUI.startButton.visible = true;
			}
			else if (context.timerState === Constants.TIMER_STATE_RUNNING)
			{
				windowUI.pauseButton.alpha = 0;
				windowUI.pauseButton.visible = true;
			}
			
			windowUI.stopButton.alpha = 0;
			windowUI.stopButton.visible = true;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false, 0, true);
			timeMouseDownPosition = event.stageX;
			timeMouseDown = true;
		}
		
		override protected function mouseMoveHandler(event:MouseEvent):void
		{
			if (timeMouseDown)
			{
				var dx:Number = timeMouseDownPosition - event.stageX;
				
				if (dx < 0 && context.timerState === Constants.TIMER_STATE_STOPPED)
				{
					predictedTimerState = null;
					return;
				}
				
				var progress:Number = dx / Constants.TIMER_COMP_MOVEMENT_FORCE;
				var newPosition:Number = Constants.TIMER_COMP_POSITION - Constants.TIMER_COMP_POSITION_STRETCH * progress;
				if (newPosition > Constants.TIMER_COMP_POSITION_RIGHT) newPosition = Constants.TIMER_COMP_POSITION_RIGHT;
				if (newPosition < Constants.TIMER_COMP_POSITION_LEFT) newPosition = Constants.TIMER_COMP_POSITION_LEFT;
				
				updateButtonAnimationProgress(progress);
				windowUI.time.x = newPosition >> 0;
				
			}
			
			super.mouseMoveHandler(event);
		}
		
		private function stageMouseUpHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			timeMouseDown = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler, false);
			
			if (timeCompTween) timeCompTween.kill();
			timeCompTween = TweenLite.to(windowUI.time, 0.5, {x: Constants.TIMER_COMP_POSITION, ease: Quint.easeInOut});
			
			if (windowUI.startButton.visible)
			{
				if (startButtonTween) startButtonTween.kill();
				startButtonTween = TweenLite.to(windowUI.startButton, 0.35, {alpha: 0, ease: Quint.easeInOut, onComplete: setButtonVisible, onCompleteParams: [windowUI.startButton, false]});
			}
			else if (windowUI.pauseButton.visible)
			{
				if (pauseButtonTween) pauseButtonTween.kill();
				pauseButtonTween = TweenLite.to(windowUI.pauseButton, 0.35, {alpha: 0, ease: Quint.easeInOut, onComplete: setButtonVisible, onCompleteParams: [windowUI.pauseButton, false]});
			}
			if (windowUI.stopButton.visible)
			{
				if (stopButtonTween) stopButtonTween.kill();
				stopButtonTween = TweenLite.to(windowUI.stopButton, 0.35, {alpha: 0, ease: Quint.easeInOut, onComplete: setButtonVisible, onCompleteParams: [windowUI.stopButton, false]});
			}
			
			if (predictedTimerState === Constants.TIMER_STATE_STOPPED)
			{
				context.currentState.stop();
			}
			else if (predictedTimerState === Constants.TIMER_STATE_PAUSED)
			{
				context.currentState.pause();
			}
			else if (predictedTimerState === Constants.TIMER_STATE_RUNNING)
			{
				if (context.timerState === Constants.TIMER_STATE_PAUSED)
				{
					context.currentState.resume();
				}
				else
				{
					context.currentState.start();
				}
			}
		}
		
		
		private function updateButtonAnimationProgress(animationProgress:Number):void
		{
			if (animationProgress >= 0)
			{
				if (context.timerState === Constants.TIMER_STATE_STOPPED ||
					context.timerState === Constants.TIMER_STATE_PAUSED)
				{
					windowUI.startButton.alpha = Math.min(animationProgress, 1);
					predictedTimerState = animationProgress > 1 ? Constants.TIMER_STATE_RUNNING : null;
				}
				else if (context.timerState === Constants.TIMER_STATE_RUNNING)
				{
					windowUI.pauseButton.alpha = Math.min(animationProgress, 1);
					predictedTimerState = animationProgress > 1 ? Constants.TIMER_STATE_PAUSED : null;
				}
			}
			else
			{
				windowUI.stopButton.alpha = Math.max(-animationProgress, -1);
				predictedTimerState = animationProgress < -1 ? Constants.TIMER_STATE_STOPPED : null;
			}
		}
		
		private function setButtonVisible(button:SimpleButton, visible:Boolean):void
		{
			button.visible = visible;
		}
		
		
		private function formatSessionTime(time:int):String
		{
			return Constants.getString(Constants.SESSION_TIME_MINUTES, [formatTimeString(time, false, true)]);
		}
		
		private function formatTime(time:int):String
		{
			return formatTimeString(time, false, true) + ":" + formatTimeString(time, true, false);
		}
		
		
		private function formatTimeString(time:int, twoDigits:Boolean = false, minutes:Boolean = false):String
		{
			var timeString:String;
			
			if (minutes)
			{
				var min:int = time / Constants.MILLISECONDS_IN_MINUTE;
				timeString = min.toString();
			}
			else
			{
				var sec:int = (time % Constants.MILLISECONDS_IN_MINUTE) / 1000;
				timeString = sec.toString();
			}
			
			if (twoDigits && timeString.length < 2)
			{
				timeString = "0" + timeString;
			}
			
			return timeString;
		}
		
		
		private function closeClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (closing) return;
			closing = true;
			
			if (windowTween) windowTween.kill();
			windowTween = TweenLite.to(windowUI, 0.3, {alpha: 0, y: Constants.WINDOW_CORNER_HEIGHT >> 2, ease: Quint.easeIn, onComplete: hideWindow});
		}
		
		private function closeOutHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (closeButtonTween) closeButtonTween.kill();
			closeButtonTween = TweenLite.to(windowUI.closeButton, 1, {alpha: 0, ease: Quint.easeOut});
		}
		
		private function closeOverHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			
			if (closeButtonTween) closeButtonTween.kill();
			closeButtonTween = TweenLite.to(windowUI.closeButton, 0.5, {alpha: 1, ease: Quint.easeOut});
		}
		
		
		private function menuClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			notificationMenu.nativeMenu.display(stage, event.stageX, event.stageY);
		}
		
		
		private function hideWindow():void
		{
			hide();
		}
	}
}