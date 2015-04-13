package timmee.display
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import timmee.core.Application;
	
	
	public class AppWindowBase extends NativeWindow
	{
		protected var _context:Application;
		protected var _initialized:Boolean;
		
		
		public function AppWindowBase(context:Application, title:String, bounds:Rectangle, type:String = NativeWindowType.NORMAL)
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.maximizable = false;
			initOptions.minimizable = false;
			initOptions.resizable = false;
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.transparent = true;
			initOptions.type = type;
			
			super(initOptions);
			
			_context = context;
			initialize(title, bounds);
		}
		
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function get context():Application
		{
			return _context;
		}
		
		
		protected function initialize(title:String, bounds:Rectangle):void
		{
			if (_initialized) return;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.title = title;
			
			var chromeWidth:int = stage.nativeWindow.width - stage.stageWidth;
			var chromeHeight:int = stage.nativeWindow.height - stage.stageHeight;
			x = bounds.x - (chromeWidth >> 1);
			y = bounds.y - (chromeHeight >> 1);
			width = bounds.width + chromeWidth;
			height = bounds.height + chromeHeight;
			
			initializeUI();
			
			_initialized = true;
		}
		
		
		protected function initializeUI():void
		{
			// For implementation
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			_context = null;
		}
		
		
		public function hide():void
		{
			visible = false;
		}
	}
}