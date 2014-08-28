package com.fashionapp.util
{
	public class CoplStringUtil
	{
		public function CoplStringUtil()
		{
		}
		//♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥
		/**
		 * This method is used to replace null values with given string.
		 * @param str:String contain the String that contain null values
		 * @param replaceWith:String contain the String from which null value has been replaced
		 * @return String value that contain no more null values
		 * @author Kamran Aslam
		 **/
		public static function nvl(str:String,replaceWith:String):String
		{
			if(str==null)
			{
				str='';
			}
			var finalString:String='';
			var myPattern:RegExp = /null/gi; 
			finalString=str.replace(myPattern, replaceWith);
			return finalString;
		}
		//♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥
	}
}