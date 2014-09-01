package com.fashionapp.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ImageSelectedEvent extends Event
	{
		public static var IMAGE_SELECTED:String = "IMAGE_SELECTED";
		
		public var imagebytes:ByteArray;
		
		public function ImageSelectedEvent(type:String, imagebytes:ByteArray, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.imagebytes = imagebytes;
		}
	}
}