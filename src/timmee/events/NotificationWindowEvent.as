package timmee.events
{
	import flash.events.Event;
	
	
	public class NotificationWindowEvent extends Event
	{
		public static const POSTPONE:String = "postpone";
		
		
		public function NotificationWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			var event:NotificationWindowEvent = new NotificationWindowEvent(type, bubbles, cancelable);
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("NotificationWindowEvent", "type", "bubbles", "cancelable");
		}
	}
}