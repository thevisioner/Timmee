package timmee.ui
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	
	public class AboutWindowUI extends Sprite
	{
		public var closeButton:SimpleButton;
		
		public var behance:SimpleButton;
		public var github:SimpleButton;
		public var versionNumber:TextField;
		
		private var _initialized:Boolean;
		
		
		public function AboutWindowUI()
		{
			super();
			initialize();
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			versionNumber.embedFonts = true;
			versionNumber.mouseEnabled = false;
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
		}
	}
}