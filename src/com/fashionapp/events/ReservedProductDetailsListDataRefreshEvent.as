package com.fashionapp.events
{
	import flash.events.Event;
	
	public class ReservedProductDetailsListDataRefreshEvent extends Event{
		
		public var data:String = null;		
		
		// Event Name
		public static var RESERVED_PRODUCT_DETAILS_LIST_DATA_REFRESH_EVENT:String = "ReservedProductDetailsListDataRefreshEvent";
		
		public function ReservedProductDetailsListDataRefreshEvent(type:String, _data:String = "") {
			// constructor code
			data = _data;
			super(type);
		}
	}
	
}
