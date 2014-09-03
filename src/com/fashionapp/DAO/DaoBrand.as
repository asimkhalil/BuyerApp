package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.model.BrandData;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	import com.fashionapp.views.components.NewBrand;
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.net.URLVariables;
	
	import mx.events.FlexEvent;
	import mx.core.FlexGlobals;
	
	public class DaoBrand
	{
		public function DaoBrand()
		{
		}
		
		var stmt1:SQLStatement;
		
		public function addBrand(brand:BrandData):void
		{			
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "INSERT INTO Brand(id,name,seasonID,departID,statusID,createBy,createDate,lastUpdate) " +
							"VALUES('"+brand.id+"','"+brand.title+"','"+brand.seasonId+"','"+brand.deptId+"','"+brand.statusId+"','"+brand.createdBy+"','"+brand.createDate+"','"+brand.lastUpdate+"')";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();			
			
			BuyerAppModelLocator.getInstance().brand.addItem(brand);			
			BuyerAppModelLocator.getInstance().brand.refresh();
		}
		public function getBrand():void
		{			
			stmt1 = new SQLStatement();
			stmt1.text = "SELECT b.*, d.[name] as [dept], s.[name] as [season] " +
						"FROM [Brand] b " +
						"INNER JOIN [BrandDepartment] d ON d.[id] = b.[departID] " +
						"INNER JOIN [BrandSeason] s ON s.[id] = b.[seasonId] ";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, getBrandHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
		}
		private	function getBrandHandler(event:SQLEvent):void{
			var result:SQLResult = stmt1.getResult();
			FlexGlobals.topLevelApplication.dispatchEvent(new FlexEvent('GET_BRAND',Parser.parseBrand(result.data)));
		}		
		
		public function getContactsFromDB():SQLResult{
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM Users";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			return result;
		}
		
		private var chat:ChatData;
		public function sendChat(chat:ChatData):void{
			this.chat = chat;
			var stmt1:SQLStatement = new SQLStatement();
			var uniqueId:String = DBUtils.getUniqueID();
			
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(chat.createDate);
			
			stmt1.text = "INSERT INTO Chat(id,toUserID,type, content,statusID,createBy,createDate,lastUpdate) VALUES('"+uniqueId+"',"+chat.toUserId+",'"+chat.type+"','"+chat.content+"',"+chat.statusId+","+chat.createdBy+",'"+createdDate+"','"+createdDate+"')";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				trace(result);
			}
		}
		
		public function deleteChat(chat:ChatData):void{
			this.chat = chat;
			var stmt1:SQLStatement = new SQLStatement();
			var uniqueId:String = DBUtils.getUniqueID();
			
			stmt1.text = "update Chat set type = 'delete' where id = " + chat.id.toString();
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				trace(result);
			}
		}
		
		
		public function getAllCurrentChats(username:String=""):void {
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM Chat";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				//Parser.parseChatsList(result.data);
			}
		}
		
		public function getChatsForMe():void {
			var stmt1:SQLStatement = new SQLStatement();
			var myUserId:Number = BuyerAppModelLocator.getInstance().loginData.id;
			stmt1.text = "SELECT * FROM Chat";// WHERE toUserID="+BuyerAppModelLocator.getInstance().loginData.id;
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				Parser.parseChatMessagesForMeList(result.data);
			}
		}
		
		private	function openHandler(event:SQLEvent):void{
		}
		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}