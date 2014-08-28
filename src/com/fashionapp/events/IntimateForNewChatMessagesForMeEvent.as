package com.fashionapp.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class IntimateForNewChatMessagesForMeEvent extends Event
	{
		public var newChatMessages:ArrayCollection = new ArrayCollection();
		
		public static var INTIMATE_FOR_NEW_MESSAGES:String = "INTIMATE_FOR_NEW_MESSAGES";
		
		public function IntimateForNewChatMessagesForMeEvent(type:String, newChatMessages:ArrayCollection, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.newChatMessages = newChatMessages;
		}
	}
}