package com.fashionapp.events
{
	/* @author M.USMAN ASHRAF
	* Date 15-01-2013.
	*/
	import com.fashionapp.model.LoginData;	
	import flash.events.Event;
	
	public class LoginClickEvent extends  Event
	{
		public var loginDataObject:LoginData;
		public function LoginClickEvent(type:String,ld:LoginData):void{
			super(type,true);
			this.loginDataObject =ld;
		}
		override public function clone():Event
		{
			return new LoginClickEvent(type,loginDataObject);
		}
	}
}

