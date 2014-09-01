package com.fashionapp.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class ReservedProductListEvent extends CairngormEvent
	{
		public static const RESERVED_PRODUCT_LIST : String = "RESERVEDPRODUCTLISTEVENT";
		
		public function ReservedProductListEvent( type : String, message : String = "" )
		{
			super( type );
		}
		
		override public function clone() : Event
		{
			return new ReservedProductListEvent( type );
		}
	}
}