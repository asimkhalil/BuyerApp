package com.fashionapp.util
{
	import com.fashionapp.model.LoginData;

	public class Test
	{
		public static function getDummyLoginData():LoginData
		{
			var obj:LoginData=new LoginData();
			obj.code="12345";
			obj.email = "m.usmanashraf@yahoo.com";
			obj.fullName = "usman ashraf";
			obj.id = 212;
			obj.status= "successful";
			obj.userName = "usmanashraf";				
			return obj;
		}
	}
}