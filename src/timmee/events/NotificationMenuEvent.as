package timmee.events
{
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	
	public class NotificationMenuEvent extends Event
	{
		public static const ITEM_SELECT:String = "itemSelect";
		
		private var _target:NativeMenuItem;
		
		
		public function NotificationMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		public function getTargetId():int
		{
			return int(_target.name);
		}
		
		
		public function updateTarget(menuItem:NativeMenuItem):void
		{
			_target = menuItem;
		}
		
		public function releaseTarget():void
		{
			_target = null;
		}
		
		
		override public function clone():Event
		{
			var event:NotificationMenuEvent = new NotificationMenuEvent(type, bubbles, cancelable);
			event.updateTarget(_target);
			
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("NotificationMenuEvent", "type", "bubbles", "cancelable");
		}
	}
}