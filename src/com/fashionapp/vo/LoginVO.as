package com.fashionapp.vo
{
	import com.adobe.cairngorm.vo.IValueObject;

	public class LoginVO implements IValueObject
	{
		private var _username:String = "";
		
		private var _password:String = "";
		
		public function LoginVO(username:String,password:String)
		{
			_username = username;
			_password = password;
		}
		
		public function get username():String {
			return _username;
		}
		
		public function get password():String {
			return _password;
		}
	}
}