package com.fashionapp.util
{
	import com.fashionapp.model.LoginData;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	import mx.utils.ObjectUtil;
	
	import spark.components.ViewNavigator;

	public class Utils
	{
		public static var FORGOT_EMAIL:String;
		public static var db_path:String = "D:/drivers/fashionDB.s3db";
	}
}