package com.fashionapp.utils
{
	import com.fashionapp.network.Network;
	
	public class DBUtils
	{
		public function DBUtils()
		{
		}
		
		public static function getUniqueID():String {
			
			var date:Date = new Date();
			var unix:int = date.time;
			
			return Network.app_key.toString() + "-" + unix.toString();
		}
	}
}