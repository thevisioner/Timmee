package timmee.ui.controls
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class ToggleSwitch extends Sprite
	{
		public var offSwitch:SimpleButton;
		public var onSwitch:SimpleButton;
		
		private var _initialized:Boolean;
		private var _active:Boolean;
		
		private var changeEvent:Event;
		
		
		public function ToggleSwitch()
		{
			super();
			initialize();
		}
		
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			if (value !== _active)
			{
				_active = value;
				updateDisplayList();
			}
		}
		
		
		public function toggle():void
		{
			_active = !_active;
			updateDisplayList();
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			changeEvent = new Event(Event.CHANGE);
			addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			changeEvent = null;
			removeEventListener(MouseEvent.CLICK, mouseClickHandler, false);
		}
		
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			toggle();
		}
		
		
		private function updateDisplayList(notify:Boolean = true):void
		{
			offSwitch.visible = !_active;
			onSwitch.visible = _active;
			
			if (notify) dispatchEvent(changeEvent);
		}
	}
}