package com.fashionapp.utils
{
	import com.adobe.protocols.dict.events.ErrorEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Application;
	import spark.components.Image;

	
	public class DBUtils
	{
		private static var _parenDisplayObject:DisplayObject;
		private var _sqlStatement:SQLStatement;
		private static var _loader:URLLoader;
		private static var _localBigImageURL:String;
		private static var _localSmallImageURL:String;
		public function DBUtils()
		{
		}
		
		public static function getUniqueID():String {
			
			var date:Date = new Date();
			var unix:int = date.time;
			
			return Network.app_key.toString() + "-" + unix.toString();
		}
		
		public static function getLastdownloadTime(tablename:String):String
		{
			var lastDownloadTime:String = null;
			var _sql:SQLStatement = new SQLStatement();
			_sql.text = "select DateTime(lastDownload.time) LastDownloadTime from lastDownload where lastDownload.tablename = '"+tablename+"'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				if (result.data !=null){
					lastDownloadTime = result.data[0].LastDownloadTime;
				}
			}
			
			if (lastDownloadTime ==null){
				_sql.text = "insert into lastDownload (tablename, time)VALUES('"+tablename+"','2014-01-01 00:00:00')";
				_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
				_sql.execute();
				lastDownloadTime = '2014-01-01 00:00:00';
			}
			return lastDownloadTime;			
		}		
		
		public static function updateLastdownloadTime(tablename:String):Boolean
		{
			var lastdownloadTimeUpdated:Boolean = false;
			var _sql:SQLStatement = new SQLStatement();
			var lastDownloadDateTime:String = BasicUtil.convertToSQLTimeStamp(new Date());
			_sql.text = "update lastDownload set time = '"+lastDownloadDateTime+"' where lastDownload.tablename = '"+tablename+"'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				lastdownloadTimeUpdated = true;
			}
			return lastdownloadTimeUpdated;			
		}
		
		public static function getImage(entityID:String, type:String, imageSize:int):String
		{
			var imageLocation:String = "";
			var entityDetails:Object = getEntityDetailsFromDB(entityID);
			var localImageFixedPath:String = "images/"+type+"/"+entityDetails.brandID+"/"+imageSize+"/"+entityDetails.id+"-"+entityDetails.imageversion+".jpg";
			var localImagePath:String = File.applicationStorageDirectory.resolvePath(localImageFixedPath).nativePath;
			var imageFile:File = new File(localImagePath);
			if (imageFile.exists)
			{
				imageLocation = imageFile.nativePath;
			}
			else
			{
				var bigImageDirectory:String =  File.applicationStorageDirectory.resolvePath("images/"+type+"/"+entityDetails.brandID+"/"+800+"/").nativePath;
				
				var smallImageDirectory:String =  File.applicationStorageDirectory.resolvePath("images/"+type+"/"+entityDetails.brandID+"/"+200+"/").nativePath;
				var imageFileName:String = entityDetails.id+"-"+entityDetails.imageversion+".jpg";
				
				_localBigImageURL = bigImageDirectory+"/"+imageFileName;
				_localSmallImageURL = smallImageDirectory+"/"+imageFileName;
				
				//var fixedPathForServer:String = "http://59.188.218.19/images/"+type+"/"+entityDetails.brandID+"/"+800+"/"+entityDetails.id+"-"+entityDetails.imageversion+".jpg";
				var fixedPathForServer:String = "http://www.thebiblescholar.com/android_awesome.jpg";
				var loaclImageFile:File = new File(localImagePath);
				imageLocation = loaclImageFile.nativePath;				
				imageLoaderInit(fixedPathForServer);
			}
			return imageLocation;
		}
		private static function imageLoaderInit(imgURL:String):void {
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, onLoad);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_loader.load(new URLRequest(imgURL));
		}
		private static function onLoad(event:Event):void {
			saveBigImage(event.currentTarget.data,_localBigImageURL);
			createSmallImage(event.currentTarget.data,_localSmallImageURL);
		}
		private static function createSmallImage(bytes:ByteArray, imgPath:String):void
		{
			var loader:Loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {				
				var content:* = loader.content;				
				var scaleFactor:Number = 200/content.width;				
				var scaledWidth:int = scaleFactor*content.width;				
				var scaledHeight:int = scaleFactor*content.height;				
				var bitmapData:BitmapData = new BitmapData(scaledWidth,scaledHeight,true,0x00000000);				
				bitmapData.draw(content, new Matrix(), null, null, null, true);				
				var file:File = File.applicationStorageDirectory.resolvePath(imgPath);	
				if (file.exists)
					file.deleteFile(); //delete it if exists
				var fileStream:FileStream = new FileStream();				
				fileStream.open(file, FileMode.WRITE);				
				fileStream.writeBytes(bytes);				
				fileStream.close();				
			});
			loader.loadBytes(bytes);			
		} 
		private static function onError(event:ErrorEvent):void {
		} 
		private static function saveBigImage(data:ByteArray,imgPath:String):void {
			var file:File = File.applicationStorageDirectory.resolvePath(imgPath);
			if (file.exists)
				file.deleteFile(); //delete it if exists
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(data, 0, data.length);
			fileStream.close();
		}
		private static function getEntityDetailsFromDB(entityID:String):Object
		{
			var entityDetails:Object = new Object();
			var _sql:SQLStatement = new SQLStatement();
			_sql.text = "select entity.id, entity.brandID, entity.imageversion from entity where entity.id = '"+entityID+"'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				if (result.data !=null){
					entityDetails = result.data[0];
				}
			}
			return entityDetails;
		}

	}
}

