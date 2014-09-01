package com.fashionapp.events
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class IntimateToLoadReservedProductListEvent extends Event
	{
		
		public static var INTIMATE_TO_LOAD_RESERVED_PRODUCT_LIST_EVENT:String = "IntimateToLoadReservedProductListEvent";
		
		public function IntimateToLoadReservedProductListEvent(type:String,  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}