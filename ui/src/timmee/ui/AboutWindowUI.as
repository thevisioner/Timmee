package timmee.ui
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	
	
	public class AboutWindowUI extends Sprite
	{
		public var closeButton:SimpleButton;
		
		public var behance:SimpleButton;
		public var github:SimpleButton;
		
		private var _initialized:Boolean;
		
		
		public function AboutWindowUI()
		{
			super();
			initialize();
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
		}
	}
}