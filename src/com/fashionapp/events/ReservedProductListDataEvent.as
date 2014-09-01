package com.fashionapp.events
{
	/* @author Keshaw Kumar Singh
	* Date 27-08-2014.
	*/
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class ReservedProductListDataEvent extends  Event
	{
		public var reservedProductListData:ArrayCollection;
		public function ReservedProductListDataEvent(type:String, data:ArrayCollection):void{
			super(type,true);
			this.reservedProductListData = data;
		}
		override public function clone():Event
		{
			return new ReservedProductListDataEvent(type,this.reservedProductListData);
		}
	}
}

