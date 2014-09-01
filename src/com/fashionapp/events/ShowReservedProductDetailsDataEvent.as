package com.fashionapp.events
{
	/* @author Keshaw Kumar Singh
	* Date 27-08-2014.
	*/
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ShowReservedProductDetailsDataEvent extends  Event
	{
		public var reservedProductDetailsData:Array;
		public function ShowReservedProductDetailsDataEvent(type:String, data:Array):void{
			super(type,true);
			this.reservedProductDetailsData = data;
		}
		override public function clone():Event
		{
			return new ShowReservedProductDetailsDataEvent(type,this.reservedProductDetailsData);
		}
	}
}

