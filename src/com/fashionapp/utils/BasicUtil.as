package com.fashionapp.utils
{
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;
	import com.fashionapp.util.Base64;

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
			dt.setTime(dt.getTime() + (dt.getTimezoneOffset() * 60000))
			
			var month = dt.getMonth()+1;
			if(month < 10) month = "0" + month;
			var day = dt.getDate();
			if(day < 10) day = "0" + day;
			var dStr = dt.fullYear + "-" + month + "-" + day ;
			var hour = dt.getHours();
			if(hour < 10) hour = "0" + hour;
			var minute = dt.getMinutes();
			if(minute < 10) minute = "0" + minute;
			var second = dt.getSeconds();
			if(second < 10) second = "0" + second;
			dStr += ' ' + hour + ':' + minute + ':' + second;
			return dStr;
		}
		
		
		private static var key:String = 'dSChAjgz36TTexeLODPYxleJndjVcOMVzsLJjSM8dLpXsTS4FCeMbhw2s2u';
		
		// encryption decryption
		/**************************************************************/
		public static function encrypt(str:String):String {
			var result:String = '';
			for (var i:int = 0; i < str.length; i++) {
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar + ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}	
			return Base64.encode(result);
		}
		public static function decrypt(str:String):String {
			
			var result:String = '';
			var str:String = Base64.decode(str);   
			for (var i:int = 0; i < str.length; i++) {
				var char:String = str.substr(i, 1);
				var keychar:String = key.substr((i % key.length) - 1, 1);
				var ordChar:int = char.charCodeAt(0);
				var ordKeychar:int = keychar.charCodeAt(0);
				var sum:int = ordChar - ordKeychar;
				char = String.fromCharCode(sum);
				result = result + char;
			}
			return result;
		}
	}
}