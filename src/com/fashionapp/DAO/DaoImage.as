package com.fashionapp.DAO
{
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.network.Network;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;

	public class DaoImage
	{
		public static var IMAGE_TYPE_PHOTO:String = "PHOTO";
		
		public static var IMAGE_TYPE_ENTITY:String = "ENTITY";
		
		private var _photoId:String = "";
		
		public function uploadImageToServer(imageBytes:ByteArray,image:String,uniqueId:String):void 
		{
			_photoId = uniqueId;
			
			var params:URLVariables = new URLVariables();
			
			params.type = IMAGE_TYPE_PHOTO;
			
			params.id = uniqueId;
			
			params.image = imageBytes;
			
			FlexGlobals.topLevelApplication.addEventListener(APIEvent.API_IMAGE_UPLOAD_COMPLETE,onImageUploadComplete);
			
			Network.call_API(FlexGlobals.topLevelApplication as DisplayObject,"upload_image",params,"");
		}
		
		private function onImageUploadComplete(event:APIEvent):void 
		{
			trace("image uploaded... "+event.data.status);
			
			updateLocalDB(_photoId);
		}
		
		private function updateLocalDB(photoId:String):void 
		{
			var stmt1:SQLStatement = new SQLStatement();
			
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(new Date());
			
			var uniqueId:String = photoId;
			
			var remark:String = IMAGE_TYPE_PHOTO;
			
			var statusId:Number = 100;
			
			var createdBy:Number = BuyerAppModelLocator.getInstance().loginData.id;
			
			stmt1.text = "INSERT INTO photo(id,remark,statusID,createdBy,createdDate,lastUpdate) VALUES('"+uniqueId+"','"+remark+"',"+statusId+","+createdBy+",'"+createdDate+"','"+createdDate+"')";
			
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			
			if (result != null) 
			{
				//Image entry made in local db
				
				if(Network.checkInterNetAvailability() == true) 
				{
					updateServer();
				}
				
			}
		}
		
		private function updateServer():void 
		{
		}
		
		private function downloadDataFromServer():void 
		{
		}
		
		private	function openHandler(event:SQLEvent):void
		{
		}
		
		private	function errorHandler(event:SQLErrorEvent):void
		{
		}
	}
}