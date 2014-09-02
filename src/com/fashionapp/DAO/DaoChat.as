package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.net.URLVariables;
	
	import mx.charts.chartClasses.NumericAxis;
	import mx.core.FlexGlobals;

	public class DaoChat
	{
		public function DaoChat()
		{
		}
		
		public function getContactsFromDB():void{
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM Users";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null) {
				Parser.parseContactList(result.data);
			}
		}
		
		private var chat:ChatData;
		public function sendChat(chat:ChatData):void{
			this.chat = chat;
			var stmt1:SQLStatement = new SQLStatement();
			var uniqueId:int = DBUtils.getUniqueID();
			
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(chat.createDate);
			
			stmt1.text = "INSERT INTO Chat(id,toUserID,type, content,statusID,createBy,createDate,lastUpdate) VALUES("+uniqueId+","+chat.toUserId+",'"+chat.type+"','"+chat.content+"',"+chat.statusId+","+chat.createdBy+",'"+createdDate+"','"+createdDate+"')";
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
			var uniqueId:int = DBUtils.getUniqueID();
			
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
				Parser.parseChatsList(result.data);
			}
		}
		
		public function getChatsForMe():void {
			var stmt1:SQLStatement = new SQLStatement();
			var myUserId:Number = BuyerAppModelLocator.getInstance().loginData.id;
			stmt1.text = "SELECT * FROM Chat";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				Parser.parseChatMessagesForMeList(result);
			}
		}
		
		
		public function updateServer():void {
			var recordsToSyncOnLiveServer:Array = getRecordsNeededToSyncOnLiveServer("Chat");
			
			var rowCount:int = 0;
			
			/*function syncRowWithServer():void {
				var urlVariables:URLVariables = new URLVariables();
				urlVariables.session_id;
				urlVariables.chat_id;
				urlVariables.to_user;
				urlVariables.session_id;
				Network.call_API(FlexGlobals.topLevelApplication as DisplayObject,'send_chat')
			}*/
		}
		
		public function getRecordsNeededToSyncOnLiveServer(table:String):Array {
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM "+table+" WHERE lastSync IS NULL";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				return result.data;
			}
			return [];
		}
		
		
		private function updateLastSyncTime(table:String,rowId:Number):void {
			var stmt1:SQLStatement = new SQLStatement();
			var uniqueId:int = DBUtils.getUniqueID();
			
			var now:String = BasicUtil.convertToSQLTimeStamp(new Date());
			
			stmt1.text = "update Chat set lastSync='"+now+"' where id=" + rowId;
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				trace(result);
			}
		}
		
		private	function openHandler(event:SQLEvent):void{
		}
		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}