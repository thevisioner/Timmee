package timmee.events
{
	import flash.events.Event;
	
	
	public class NotificationIconEvent extends Event
	{
		public static const CLICK:String = "click";
		public static const CHANGED:String = "changed";
		
		
		public function NotificationIconEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			var event:NotificationIconEvent = new NotificationIconEvent(type, bubbles, cancelable);
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("NotificationIconEvent", "type", "bubbles", "cancelable");
		}
	}
}