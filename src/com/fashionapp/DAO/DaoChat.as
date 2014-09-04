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
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.net.URLVariables;
	
	import mx.charts.chartClasses.NumericAxis;
	import mx.core.FlexGlobals;

	import com.fashionapp.controllers.BaseController;
	
	public class DaoChat
	{
		/*private var chat:ChatData;
		private var recordsToBeSync:Array;
		private var currentIndex:int = 0;*/
		
		private var instance:BaseController;
		
		public function DaoChat()
		{
			if(FlexGlobals.topLevelApplication.hasEventListener(APIEvent.API_SEND_CHAT)==false) {
				FlexGlobals.topLevelApplication.addEventListener(APIEvent.API_SEND_CHAT,sendCompleteHandler);
			}
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
		
		public function sendChat(chat:ChatData):void {
			// step 1: make chat row new entry in data base with last sync untouch
			BuyerAppModelLocator.getInstance().chat = chat;
			var stmt1:SQLStatement = new SQLStatement();
			
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(chat.createDate);
			chat.id = DBUtils.getUniqueID();
			
			stmt1.text = "INSERT INTO Chat(id,toUserID,type, content,statusID,createBy,createDate,lastUpdate) VALUES('"+chat.id+"',"+chat.toUserId+",'"+chat.type+"','"+chat.content+"',"+chat.statusId+","+chat.createdBy+",'"+createdDate+"','"+createdDate+"')";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null) {
				if(Network.checkInterNetAvailability() == true) {
					//Step 2: get all records from local data base which are required to be sent on live server have no sync.
					BuyerAppModelLocator.getInstance().recordsToBeSync = getRecordsNeededToSyncOnLiveServer('Chat');
					BuyerAppModelLocator.getInstance().currentIndex = 0;
					if(BuyerAppModelLocator.getInstance().recordsToBeSync){
						BuyerAppModelLocator.getInstance().chat = toChatData(BuyerAppModelLocator.getInstance().recordsToBeSync[BuyerAppModelLocator.getInstance().currentIndex]);
						//step 3: send all record to live server one by one
						sendChatToServer(BuyerAppModelLocator.getInstance().chat);
					}
				}
			}
		}
		
		private function toChatData(obj:Object):ChatData {
			var chat:ChatData = new ChatData();
			chat.content = obj.content;
			chat.createDate = obj.createDate;
			chat.createdBy = obj.createdBy;
			chat.id = obj.id;
			chat.lastSync = obj.lastSync;
			chat.lastUpdate = obj.lastUpdate;
			chat.statusId = obj.statusID;
			chat.toUserId = obj.toUserID;
			chat.type = obj.type;
			return chat;
		}
		
		private function sendChatToServer(chat:ChatData):void{
			var param:URLVariables  = new URLVariables;
			param.to_user = chat.toUserId;
			param.chat_id =  chat.id;
			param.type = 'TEXT';
			param.content = chat.content;
			param.session_id = Network.session_id;
			Network.call_API(FlexGlobals.topLevelApplication as DisplayObject,"send_chat",param);
		}
		
		private function sendCompleteHandler(event:Event):void{
			if(BuyerAppModelLocator.getInstance().chat) {
				//Update last synched time in local db for the record you just synched on live server
				updateLastSyncTime('Chat',BuyerAppModelLocator.getInstance().chat.id);
			}
			BuyerAppModelLocator.getInstance().currentIndex++;
			if(BuyerAppModelLocator.getInstance().currentIndex < BuyerAppModelLocator.getInstance().recordsToBeSync.length){
				BuyerAppModelLocator.getInstance().chat = toChatData(BuyerAppModelLocator.getInstance().recordsToBeSync[BuyerAppModelLocator.getInstance().currentIndex]);
				sendChatToServer(BuyerAppModelLocator.getInstance().chat);
			}
			else 
			{
				FlexGlobals.topLevelApplication.dispatchEvent(new Event("RetrieveChatMessages",true));
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
				//				Parser.parseChatMessagesForMeList(result);
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
		
		/*public function sendMessage(msgID:String,touser:String, message:String):void
		{
			var param:URLVariables  = new URLVariables;
			param.to_user = touser;
			param.chat_id =  msgID;
			param.type = 'TEXT';
			param.content = message;
			
			param.session_id = Network.session_id;
			Network.call_API(FlexGlobals.topLevelApplication as DisplayObject,"send_chat",param);
		}*/
		
		public function deleteChat(chat:ChatData):void{
			BuyerAppModelLocator.getInstance().chat = chat;
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
		
		
		/*public function getAllCurrentChats(username:String=""):void {
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
		}*/
		
		
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
		
		
		private function updateLastSyncTime(table:String,rowId:String):void {
			var stmt1:SQLStatement = new SQLStatement();
			/*var uniqueId:int = DBUtils.getUniqueID();*/
			
			var now:String = BasicUtil.convertToSQLTimeStamp(new Date());
			
			stmt1.text = "update Chat set lastSync='"+now+"' where id='" + rowId+"'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				trace(result);
			}
		}
		
		public function updateLocalDBChatRow(rowId:String,data:Object):void {
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM Chat WHERE id='"+rowId+"'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				if(result.data && result.data.length > 0) {
					//Update
				} else {
					
					//add new record
					var chatdata:ChatData = new ChatData();
					chatdata.id = data.id;
					chatdata.content = data.content;
					chatdata.createDate = data.create_date;
					chatdata.createdBy = data.create_by;
					chatdata.lastSync = new Date();
					chatdata.statusId = data.status_id;
					chatdata.toUserId = data.to_user;
					chatdata.type = data.type;
					
					var stmt1:SQLStatement = new SQLStatement();
					/*var uniqueId:int = DBUtils.getUniqueID();*/
					
					var createdDate:String = BasicUtil.convertToSQLTimeStamp(new Date());
					if(!chatdata.id && chatdata.id == "") {
						chatdata.id = Network.app_key+"-"+ new Date().time;
					}
					
					stmt1.text = "INSERT INTO Chat(id,toUserID,type, content,statusID,createBy,createDate,lastUpdate,lastSync) VALUES('"+chatdata.id+"',"+chatdata.toUserId+",'"+chatdata.type+"','"+chatdata.content+"',"+chatdata.statusId+","+chatdata.createdBy+",'"+createdDate+"','"+createdDate+"','"+createdDate+"')";
					stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
					stmt1.addEventListener(SQLEvent.RESULT, openHandler);
					stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
					stmt1.execute();
				}
			}
		}
		
		private	function openHandler(event:SQLEvent):void{
		}
		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}