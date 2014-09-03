package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.controllers.ReservedProductDetailViewController;
	import com.fashionapp.events.IntimateToLoadReservedProductListEvent;
	import com.fashionapp.events.ReservedProductListDataEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ReservedProductListData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	import com.fashionapp.views.ReservedProductsDetailView;
	import com.fashionapp.views.ReservedProductsView;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.net.URLVariables;
	
	import mx.core.FlexGlobals;
	
	import spark.components.View;
	
	public class ReservedProductListDAO
	{
		private var reservedProductListData:ReservedProductListData;
		private var dbConn:SQLConnection;
		private	var dataFile:File  = new File();
		private var _sqlStatement:SQLStatement;
		
		public function getReservedProductListFromDB():void{
			BuyerAppModelLocator.getInstance().dataFile = File.applicationStorageDirectory.resolvePath(Utils.db_path);
			BuyerAppModelLocator.getInstance().dbConn = new SQLConnection();
			BuyerAppModelLocator.getInstance().dbConn.addEventListener(SQLEvent.OPEN, DBOpened);
			BuyerAppModelLocator.getInstance().dbConn.open(BuyerAppModelLocator.getInstance().dataFile);
		}
		private function DBOpened(event:SQLEvent):void{
			if (event.type == "open"){
				_sqlStatement = new SQLStatement();
				_sqlStatement.text = "select count(*) Total_Reserved_Quantity, reserveEntity.entityID, reserveEntity.qty, reserveEntity.color, reserveEntity.size, brand.name brandName, brandDepartment.name deptName,entity.caption productTitle, entity.caption productCaption from reserveEntity,entity,brand,brandDepartment where reserveEntity.entityID = entity.id and brand.id = entity.brandID and brand.departID = brandDepartment.id group by reserveEntity.entityID";
				_sqlStatement.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
				_sqlStatement.addEventListener(SQLEvent.RESULT, openHandlerSelectDB);
				_sqlStatement.addEventListener(SQLErrorEvent.ERROR, errorHandlerSelectDB);
				_sqlStatement.execute();					
			}
		}
		private	function openHandlerSelectDB(event:SQLEvent):void{
			var result:SQLResult = _sqlStatement.getResult();
			if (result != null){
				FlexGlobals.topLevelApplication.dispatchEvent(new ReservedProductListDataEvent('ReservedProductListDataEvent',Parser.parseReservedProductListData(result.data)));
			}
		}
		private	function errorHandlerSelectDB(event:SQLErrorEvent):void{
		}	
		private var _reserverProductListdataFromServer:Array;
		public function insertTheseValuesIntoDB(data:Array):void
		{
			if(data != null)
			{
				_reserverProductListdataFromServer = data;
				BuyerAppModelLocator.getInstance().dataFile = File.applicationStorageDirectory.resolvePath(Utils.db_path);
				BuyerAppModelLocator.getInstance().dbConn = new SQLConnection();
				BuyerAppModelLocator.getInstance().dbConn.addEventListener(SQLEvent.OPEN, DBOpenedFordataInsert);
				BuyerAppModelLocator.getInstance().dbConn.open(BuyerAppModelLocator.getInstance().dataFile);
			}			
		}
		private function DBOpenedFordataInsert(event:SQLEvent):void{
			if (event.type == "open" && _reserverProductListdataFromServer.length>0){
				for(var i:int=0; i<_reserverProductListdataFromServer.length; i++)
				{
					var tempObj:Object = _reserverProductListdataFromServer[i];					
					var uniqueId:String = DBUtils.getUniqueID();
					_sqlStatement = new SQLStatement();
					var rowstatus:Boolean = checkRowExists(tempObj.reserved_product_id);
					if(rowstatus)
					{
						_sqlStatement.text = "UPDATE reserveEntity set entityID = '"+tempObj.product_id+"' , qty ='"+tempObj.qty+"' , color ='"+tempObj.color+"' , size ='"+tempObj.size+"' , VIPID ='"+tempObj.vip_id+"' , VIPphone ='"+tempObj.vip_phone+"' , VIPname ='"+tempObj.vip_name+"' , shopID ='"+tempObj.shop_id+"' , statusID ='"+tempObj.status_id+"' , createBy='"+tempObj.create_by+"' , createDate='"+tempObj.create_date+"' , lastUpdate='"+tempObj.last_update+"'";
					}
					else
					{
						_sqlStatement.text = "INSERT INTO reserveEntity (id,entityID,qty,color,size,VIPID,VIPphone,VIPname,shopID,statusID,createBy,createDate,lastUpdate) VALUES('"+tempObj.reserved_product_id+"','"+tempObj.product_id+"','"+tempObj.qty+"','"+tempObj.color+"','"+tempObj.size+"','"+tempObj.vip_id+"','"+tempObj.vip_phone+"','"+tempObj.vip_name+"','"+tempObj.shop_id+"','"+tempObj.status_id+"','"+tempObj.create_by+"','"+tempObj.create_date+"','"+tempObj.last_update+"')";
					}
					_sqlStatement.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
					_sqlStatement.addEventListener(SQLEvent.RESULT, openHandlerToInsert);
					_sqlStatement.addEventListener(SQLErrorEvent.ERROR, errorHandlerToInsert);
					_sqlStatement.execute();						
				}
				var statusUpdates:Boolean = updateLastdownloadTime();
				if(statusUpdates)
				{
					FlexGlobals.topLevelApplication.dispatchEvent(new IntimateToLoadReservedProductListEvent(IntimateToLoadReservedProductListEvent.INTIMATE_TO_LOAD_RESERVED_PRODUCT_LIST_EVENT));
				}
			}
		}
		private	function openHandlerToInsert(event:SQLEvent):void{
			var result:SQLResult = _sqlStatement.getResult();
			if (result != null){				
			}
		}
		private	function errorHandlerToInsert(event:SQLErrorEvent):void{
		}			
		private function checkRowExists(rowID:String):Boolean
		{
			var rowExists:Boolean = false;
			var _sql:SQLStatement = new SQLStatement();
			_sql.text = "select reserveEntity.id from reserveEntity where reserveEntity.id ='"+rowID+"'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.addEventListener(SQLEvent.RESULT, openHandlerToCheckRowExists);
			_sql.addEventListener(SQLErrorEvent.ERROR, errorHandlerToCheckRowExists);
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null && result.data != null){
				rowExists = true;
			}
			return rowExists;			
		}
		private	function openHandlerToCheckRowExists(event:SQLEvent):void{			
		}
		private	function errorHandlerToCheckRowExists(event:SQLErrorEvent):void{
		}	
		
		private function updateLastdownloadTime():Boolean
		{
			var lastdownloadTimeUpdated:Boolean = false;
			var _sql:SQLStatement = new SQLStatement();
			var lastDownloadDateTime:String = BasicUtil.convertToSQLTimeStamp(new Date());
			_sql.text = "update lastDownload set time = '"+lastDownloadDateTime+"' where lastDownload.tablename = 'ReserveEntity'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.addEventListener(SQLEvent.RESULT, openHandlerToUpdateLastDownloadTime);
			_sql.addEventListener(SQLErrorEvent.ERROR, errorHandlerToUpdateLastDownloadTime);
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				lastdownloadTimeUpdated = true;
			}
			return lastdownloadTimeUpdated;			
		}
		private	function openHandlerToUpdateLastDownloadTime(event:SQLEvent):void{			
		}
		private	function errorHandlerToUpdateLastDownloadTime(event:SQLErrorEvent):void{
		}
		
		public function getLastdownloadTime():String
		{
			var lastDownloadTime:String = null;
			var _sql:SQLStatement = new SQLStatement();
			_sql.text = "select DateTime(lastDownload.time) LastDownloadTime from lastDownload where lastDownload.tablename = 'ReserveEntity'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.addEventListener(SQLEvent.RESULT, openHandlerToGetLastDownloadTime);
			_sql.addEventListener(SQLErrorEvent.ERROR, errorHandlerToGetLastDownloadTime);
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				var tempDataObj:Object = result.data[0];
				lastDownloadTime = tempDataObj.LastDownloadTime;	
			}
			return lastDownloadTime;			
		}
		private	function openHandlerToGetLastDownloadTime(event:SQLEvent):void{			
		}
		private	function errorHandlerToGetLastDownloadTime(event:SQLErrorEvent):void{
		}
		
	}
}