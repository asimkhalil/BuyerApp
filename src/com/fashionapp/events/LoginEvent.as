package com.fashionapp.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.fashionapp.vo.LoginVO;
	import flash.events.Event;
	
	public class LoginEvent extends CairngormEvent
	{
		public static const LOGIN : String = "login";
		
		public var login:LoginVO;
		
		public function LoginEvent( type : String, login:LoginVO, message : String = "" )
		{
			super( type );
			this.login = login;
		}
		
		override public function clone() : Event
		{
			return new LoginEvent( type, login );
		}
	}
}