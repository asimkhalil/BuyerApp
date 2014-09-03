package com.fashionapp.events
{
	import flash.events.Event;
	
	public class APIEvent extends Event{
		
		public var data:Object = null;		
		
		// Event Name
		public static var API_COMPLETE:String = "API_COMPLETE";
		public static var API_COMPLETE_CONTACTS:String = "API_COMPLETE_CONTACTS";
		public static var API_COMPLETE_CHATS:String = "API_COMPLETE_CHATS";
		public static var API_SEND_CHAT:String = "API_SEND_CHAT";
		public static var API_ERROR:String = "API_ERROR";
		
		public function APIEvent(type:String, _data:Object = "") {
			// constructor code
			data = _data;
			super(type);
		}
	}
	
}
