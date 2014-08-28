package com.fashionapp.utils
{
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;

	[Bindable]
	public class BasicUtil
	{
		public function BasicUtil()
		{
		}
		
		public static function getFontSize(fontSize:int):int {
			var screenWidth:int = FlexGlobals.topLevelApplication.width;
			var factor:Number = screenWidth/640;
			fontSize = factor*fontSize;
			return fontSize;
		}
		
		public static function getComponentHeight(height:int):int {
			var screenWidth:int = FlexGlobals.topLevelApplication.width;
			var factor:Number = screenWidth/640;
			height = factor*height;
			return height;
		}
		
		public static function getComponentPadding(padding:int):int {
			var screenWidth:int = FlexGlobals.topLevelApplication.width;
			var factor:Number = screenWidth/640;
			padding = factor*padding;
			return padding;
		}	
		
		public static function convertToSQLTimeStamp(dt:Date):String {
			var month = dt.getMonth()+1;
			if(month < 10) month = "0" + month;
			var day = dt.getDate();
			if(day < 10) day = "0" + day;
			var dStr = dt.getFullYear() + "-" + month + "-" + day;
			var hour = dt.getHours();
			if(hour < 10) hour = "0" + hour;
			var minute = dt.getMinutes();
			if(minute < 10) minute = "0" + minute;
			var second = dt.getSeconds();
			if(second < 10) second = "0" + second;
			dStr += ' ' + hour + ':' + minute + ':' + second
			return dStr;
		}
	}
}