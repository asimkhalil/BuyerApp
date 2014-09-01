package com.fashionapp.events
{
	import flash.events.Event;
	
	public class APIEvent extends Event{
		
		public var data:Object = null;		
		
		// Event Name
		public static var API_COMPLETE:String = "API_COMPLETE";
		public static var API_ERROR:String = "API_ERROR";
		
		public function APIEvent(type:String, _data:Object = "") {
			// constructor code
			data = _data;
			super(type);
		}
	}
	
}
