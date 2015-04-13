package timmee.ui
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import timmee.ui.controls.Progress;
	
	
	public class TimerWindowUI extends Sprite
	{
		public var time:Sprite;
		public var progress:Progress;
		
		public var closeButton:Sprite;
		public var menuButton:SimpleButton;
		public var stopButton:SimpleButton;
		public var pauseButton:SimpleButton;
		public var startButton:SimpleButton;
		
		// children
		public var timeRemaining:TextField;
		public var sessionLength:TextField;
		public var briefcaseIcon:Sprite;
		public var bellIcon:Sprite;
		public var session:Sprite;
		
		private var _initialized:Boolean;
		
		
		public function TimerWindowUI()
		{
			super();
			initialize();
		}
		
		
		public function initialize():void
		{
			time.mouseChildren = false;
			closeButton.buttonMode = true;
			closeButton.mouseChildren = false;
			
			session = time.getChildByName("session") as Sprite;
			session.mouseChildren = false;
			session.mouseEnabled = false;
			
			bellIcon = session.getChildByName("bellIcon") as Sprite;
			briefcaseIcon = session.getChildByName("briefcaseIcon") as Sprite;
			sessionLength = session.getChildByName("sessionLength") as TextField;
			sessionLength.autoSize = TextFieldAutoSize.LEFT;
			timeRemaining = time.getChildByName("timeRemaining") as TextField;
			
			progress.initialize();
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			session = null;
			bellIcon = null;
			briefcaseIcon = null;
			sessionLength = null;
			timeRemaining = null;
			
			progress.dispose();
		}
	}
}