package events 
{
	import events.UMIBEventManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Psycho
	 */
	public class UMIBEventManager extends Object
	{
		protected static var eDispatcher:EventDispatcher;
		static private var _eventList:Vector.<String>;
        static private var _functionList:Vector.<Function>;
        static private var _useCaptureList:Vector.<Boolean>;
		
		static public function addEventListener(event_type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (!eDispatcher) eDispatcher = new EventDispatcher();
            if (!_eventList) _eventList = new Vector.<String>;
            if (!_functionList) _functionList = new Vector.<Function>;
            if (!_useCaptureList) _useCaptureList = new Vector.<Boolean>;
			
            _eventList.push(event_type);
            _functionList.push(listener);
            _useCaptureList.push(useCapture);
			
			eDispatcher.addEventListener(event_type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Removes a listener from the EventDispatcher object.
		 * @param	event_type The type of event.
		 * @param	listener The listener object to remove.
		 * @param	useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases.
		 */
		static public function removeEventListener(event_type:String, listener:Function, useCapture:Boolean=false):void
		{
			if (eDispatcher == null) return;
			eDispatcher.removeEventListener(event_type, listener, useCapture);
		}
		
		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type 
		 * of event.
		 * @param	type The type of event.
		 * @return A value of true if a listener of the specified type is registered; false otherwise.
		 */
		static public function hasEventListener(type:String):Boolean
		{
			return eDispatcher.hasEventListener(type);
		}
		
		/**
		 * Dispatches an event into the event flow.
		 * @param	event The Event object that is dispatched into the event flow.
		 */
		static public function dispatchEvent(event:Event):void
		{
			if (eDispatcher == null) eDispatcher = new EventDispatcher();
			eDispatcher.dispatchEvent(event);
		}
		
		public function hasEvent(event_type:String, listener:Function) : Boolean
        {
            for (var i:int = 0; i < _eventList.length; i++)
            {
                if (event_type == _eventList[i])
                {
					if (listener == _functionList[i])
					{
						return true;
					}
				}
            }
            return false;
        }
		
		static public function removeAllEvents() : void
        {
            while (_eventList.length > 0)
            {
                
                removeEventListener(_eventList[0], _functionList[0], _useCaptureList[0]);
                _eventList.splice(0, 1);
                _functionList.splice(0, 1);
                _useCaptureList.splice(0, 1);
            }
        }
	}

}