package timmee.events
{
	import flash.events.Event;
	
	
	public class ApplicationTimerEvent extends Event
	{
		public static const TICK:String = "tick";
		public static const SESSION_END:String = "sessionEnd";
		
		
		public function ApplicationTimerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			var event:ApplicationTimerEvent = new ApplicationTimerEvent(type, bubbles, cancelable);
			return event;
		}
		
		override public function toString():String
		{
			return formatToString("ApplicationTimerEvent", "type", "bubbles", "cancelable");
		}
	}
}