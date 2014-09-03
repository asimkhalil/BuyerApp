package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.ShowReservedProductDetailsDataEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.util.Utils;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	import mx.core.FlexGlobals;
	
	public class ReservedProductDetailsDAO
	{
		
		private var dbConn:SQLConnection;
		private	var dataFile:File  = new File();
		private var _productID:String;
		private var _sqlStatement:SQLStatement;
		
		public function getReservedProductDetailsFromDB(productID:String):void{	
			_productID = productID;
			BuyerAppModelLocator.getInstance().dataFile = File.applicationStorageDirectory.resolvePath(Utils.db_path);
			BuyerAppModelLocator.getInstance().dbConn = new SQLConnection();
			BuyerAppModelLocator.getInstance().dbConn.addEventListener(SQLEvent.OPEN, DBOpened);
			BuyerAppModelLocator.getInstance().dbConn.open(BuyerAppModelLocator.getInstance().dataFile);
			
		}
		private function DBOpened(event:SQLEvent):void{
			if (event.type == "open"){
				_sqlStatement = new SQLStatement();
				_sqlStatement.text = "select reserveEntity.id, reserveEntity.createBy, reserveEntity.qty, reserveEntity.color, reserveEntity.size, brand.name brandName, brandDepartment.name deptName,entity.caption productTitle, entity.caption productCaption from reserveEntity,entity,brand,brandDepartment where reserveEntity.entityID = entity.id and brand.id = entity.brandID and brand.departID = brandDepartment.id and reserveEntity.entityID = '"+_productID+"'";
				_sqlStatement.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
				_sqlStatement.addEventListener(SQLEvent.RESULT, openHandlerSelectDB);
				_sqlStatement.addEventListener(SQLErrorEvent.ERROR, errorHandlerSelectDB);
				_sqlStatement.execute();					
			}
		}
		private	function openHandlerSelectDB(event:SQLEvent):void{
			var result:SQLResult = _sqlStatement.getResult();
			if (result != null){
				FlexGlobals.topLevelApplication.dispatchEvent(new ShowReservedProductDetailsDataEvent('ShowReservedProductDetailsDataEvent',result.data));
			}
		}
		private	function errorHandlerSelectDB(event:SQLErrorEvent):void{
		}
	}
}