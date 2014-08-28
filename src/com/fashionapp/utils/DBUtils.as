package com.fashionapp.utils
{
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