package timmee.ui
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	
	import timmee.core.ApplicationSettings;
	import timmee.ui.controls.ToggleSwitch;
	import timmee.ui.controls.Slider;
	import timmee.core.Constants;
	
	
	public class SettingsWindowUI extends Sprite
	{
		public var closeButton:SimpleButton;
		
		
		public var sessionLengthLabel:TextField;
		public var sessionLengthSlider:Slider;
		
		public var shortBreakLengthLabel:TextField;
		public var shortBreakLengthSlider:Slider;
		
		public var longBreakLengthLabel:TextField;
		public var longBreakLengthSlider:Slider;
		
		public var longBreakDelayLabel:TextField;
		public var longBreakDelaySlider:Slider;
		
		public var volumeLabel:TextField;
		public var volumeSlider:Slider;
		
		public var loginLabel:TextField;
		public var loginSwitch:ToggleSwitch;
		
		
		private var _initialized:Boolean;
		
		
		public function SettingsWindowUI()
		{
			super();
			initialize();
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			sessionLengthSlider.minValue = 25;
			sessionLengthSlider.maxValue = 60;
			sessionLengthSlider.value = 35;
			sessionLengthSlider.tick = 5;
			sessionLengthSlider.addEventListener(Event.CHANGE, sessionLengthSliderChangeHandler, false, 0, true);
			
			shortBreakLengthSlider.minValue = 5;
			shortBreakLengthSlider.maxValue = 30;
			shortBreakLengthSlider.value = 5;
			shortBreakLengthSlider.tick = 5;
			shortBreakLengthSlider.addEventListener(Event.CHANGE, shortBreakLengthSliderChangeHandler, false, 0, true);
			
			longBreakLengthSlider.minValue = 15;
			longBreakLengthSlider.maxValue = 60;
			longBreakLengthSlider.value = 20;
			longBreakLengthSlider.tick = 5;
			longBreakLengthSlider.addEventListener(Event.CHANGE, longBreakLengthSliderChangeHandler, false, 0, true);
			
			longBreakDelaySlider.minValue = 1;
			longBreakDelaySlider.maxValue = 9;
			longBreakDelaySlider.value = 4;
			longBreakDelaySlider.tick = 1;
			longBreakDelaySlider.addEventListener(Event.CHANGE, longBreakDelaySliderChangeHandler, false, 0, true);
			
			volumeSlider.addEventListener(Event.CHANGE, volumeSliderChangeHandler, false, 0, true);
			loginSwitch.addEventListener(Event.CHANGE, loginSwitchChangeHandler, false, 0, true);
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			sessionLengthSlider.removeEventListener(Event.CHANGE, sessionLengthSliderChangeHandler, false);
			shortBreakLengthSlider.removeEventListener(Event.CHANGE, shortBreakLengthSliderChangeHandler, false);
			longBreakLengthSlider.removeEventListener(Event.CHANGE, longBreakLengthSliderChangeHandler, false);
			longBreakDelaySlider.removeEventListener(Event.CHANGE, longBreakDelaySliderChangeHandler, false);
			volumeSlider.removeEventListener(Event.CHANGE, volumeSliderChangeHandler, false);
			loginSwitch.removeEventListener(Event.CHANGE, loginSwitchChangeHandler, false);
		}
		
		
		public function updateSettings():void
		{
			sessionLengthSlider.value = ApplicationSettings.sessionLength / Constants.MILLISECONDS_IN_MINUTE;
			shortBreakLengthSlider.value = ApplicationSettings.shortBreakLength / Constants.MILLISECONDS_IN_MINUTE;
			longBreakLengthSlider.value = ApplicationSettings.longBreakLength / Constants.MILLISECONDS_IN_MINUTE;
			longBreakDelaySlider.value = ApplicationSettings.longBreakDelay;
			volumeSlider.value = ApplicationSettings.notificationVolume;
			loginSwitch.active = ApplicationSettings.startAtLogin;
		}
		
		
		private function sessionLengthSliderChangeHandler(event:Event):void
		{
			sessionLengthLabel.text = getValueLabelString(Constants.MINUTES_TEXT, sessionLengthSlider.value);
			ApplicationSettings.sessionLength = sessionLengthSlider.value * Constants.MILLISECONDS_IN_MINUTE;
		}
		
		private function shortBreakLengthSliderChangeHandler(event:Event):void
		{
			shortBreakLengthLabel.text = getValueLabelString(Constants.MINUTES_TEXT, shortBreakLengthSlider.value);
			ApplicationSettings.shortBreakLength = shortBreakLengthSlider.value * Constants.MILLISECONDS_IN_MINUTE;
		}
		
		private function longBreakLengthSliderChangeHandler(event:Event):void
		{
			longBreakLengthLabel.text = getValueLabelString(Constants.MINUTES_TEXT, longBreakLengthSlider.value);
			ApplicationSettings.longBreakLength = longBreakLengthSlider.value * Constants.MILLISECONDS_IN_MINUTE;
		}
		
		private function longBreakDelaySliderChangeHandler(event:Event):void
		{
			longBreakDelayLabel.text = getValueLabelString(Constants.POMODOROS_TEXT, longBreakDelaySlider.value);
			ApplicationSettings.longBreakDelay = longBreakDelaySlider.value;
		}
		
		private function volumeSliderChangeHandler(event:Event):void
		{
			volumeLabel.text = Math.round(volumeSlider.value * 100).toString() + " %";
			ApplicationSettings.notificationVolume = volumeSlider.value;
		}
		
		private function loginSwitchChangeHandler(event:Event):void
		{
			var activeState:Boolean = loginSwitch.active;
			loginLabel.text = activeState ? "on" : "off";
			ApplicationSettings.startAtLogin = activeState;
		}
		
		
		private function getValueLabelString(id:int, value:Number):String
		{
			var valueString:String = value.toString().substr(-1);
			var singular:Boolean = (parseInt(valueString) === 1 && value !== 11);
			return value.toString() + " " + Constants.getString(id, [singular ? "" : "s"]);
		}
	}
}