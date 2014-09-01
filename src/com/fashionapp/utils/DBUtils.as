package com.fashionapp.utils
{
	import com.fashionapp.network.Network;
	
	public class DBUtils
	{
		public function DBUtils()
		{
		}
		
		public static function getUniqueID():int {
			var date:Date = new Date();
			return date.time;
		}
	}
}