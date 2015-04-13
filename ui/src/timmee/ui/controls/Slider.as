package timmee.ui.controls
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class Slider extends Sprite
	{
		private static const THUMB_WIDTH:Number = 5;
		
		
		public var track:MovieClip;
		public var fill:MovieClip;
		public var thumb:Sprite;
		
		private var _initialized:Boolean;
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _value:Number;
		private var _tick:Number;
		
		private var changeEvent:Event;
		
		
		public function Slider()
		{
			super();
			initialize();
		}
		
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		public function set minValue(value:Number):void
		{
			if (value !== _minValue)
			{
				_minValue = value;
				constrainValue();
				updateThumbPosition();
			}
		}
		
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		public function set maxValue(value:Number):void
		{
			if (value !== _maxValue)
			{
				_maxValue = value;
				constrainValue();
				updateThumbPosition();
			}
		}

		
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}
		
		public function set value(value:Number):void
		{
			if (value !== _value)
			{
				_value = value;
				constrainValue();
				updateThumbPosition();
			}
		}
		
		
		public function get rawValue():Number
		{
			return _value;
		}
		
		
		public function get tick():Number
		{
			return _tick;
		}
		
		public function set tick(value:Number):void
		{
			_tick = value;
		}
		
		
		public function initialize():void
		{
			if (_initialized) return;
			
			fill.buttonMode = true;
			fill.mouseChildren = false;
			
			track.buttonMode = true;
			track.mouseChildren = false;
			
			thumb.buttonMode = true;
			thumb.mouseChildren = false;
			
			_minValue = 0;
			_maxValue = 1;
			_tick = 0.01;
			
			changeEvent = new Event(Event.CHANGE);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			
			_initialized = true;
		}
		
		
		public function dispose():void
		{
			_initialized = false;
			
			if (stage)
			{
				if (stage.hasEventListener(MouseEvent.MOUSE_MOVE))
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
				if (stage.hasEventListener(MouseEvent.MOUSE_UP))
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false);
			}
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false);
			changeEvent = null;
		}
		
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			updateValueFromEvent(event);
			constrainValue();
			updateThumbPosition();
			
			track.gotoAndStop("_down");
			fill.gotoAndStop("_down");
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			updateValueFromEvent(event);
			constrainValue();
			updateThumbPosition();
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false);
			
			if (event.target !== stage)
			{
				track.gotoAndStop("_over");
				fill.gotoAndStop("_over");
			}
		}
		
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			track.gotoAndStop("_over");
			fill.gotoAndStop("_over");
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			track.gotoAndStop("_up");
			fill.gotoAndStop("_up");
		}
		
		
		private function updateValueFromEvent(event:MouseEvent):void
		{
			_value = ((event.stageX - x) / (track.width - THUMB_WIDTH)) * (_maxValue - _minValue) + _minValue;
		}
		
		private function constrainValue():void
		{
			if(_maxValue > _minValue)
			{
				_value = Math.min(_value, _maxValue);
				_value = Math.max(_value, _minValue);
			}
			else
			{
				_value = Math.max(_value, _maxValue);
				_value = Math.min(_value, _minValue);
			}
		}
		
		
		private function updateThumbPosition(notify:Boolean = true):void
		{
			thumb.x = ((_value - _minValue) / (_maxValue - _minValue) * (track.width - THUMB_WIDTH)) >> 0;
			fill.width = thumb.x;
			
			if (notify) dispatchEvent(changeEvent);
		}
	}
}