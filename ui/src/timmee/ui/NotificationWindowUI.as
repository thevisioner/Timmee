package timmee.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	
	import timmee.ui.controls.Progress;
	
	
	public class NotificationWindowUI extends Sprite
	{
		public var progress:Progress;
		public var textField:TextField;
		public var closeButton:SimpleButton;
		public var postponeButton:SimpleButton;
		
		private var _initialized:Boolean;
		
		
		public function NotificationWindowUI()
		{
			super();
			initialize();
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			textField.mouseEnabled = false;
			progress.initialize();
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			progress.dispose();
			progress = null
		}
	}
}