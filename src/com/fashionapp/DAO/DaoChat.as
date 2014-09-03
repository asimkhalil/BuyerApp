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
	import flash.events.Event;
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
			FlexGlobals.topLevelApplication.addEventListener(APIEvent.API_SEND_CHAT,sendCompleteHandler);
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
		private var recordsToBeSync:Array;
		private var currentIndex:int = 0;
		
		public function sendChat(chat:ChatData):void{
			this.chat = chat;
			var stmt1:SQLStatement = new SQLStatement();
			var uniqueId:int = DBUtils.getUniqueID();
			
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(chat.createDate);
			chat.id = Network.app_key+"-"+ new Date().time;
			stmt1.text = "INSERT INTO Chat(id,toUserID,type, content,statusID,createBy,createDate,lastUpdate,lastSync) VALUES('"+chat.id+"',"+chat.toUserId+",'"+chat.type+"','"+chat.content+"',"+chat.statusId+","+chat.createdBy+",'"+createdDate+"','"+createdDate+"','"+createdDate+"')";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				if(Network.checkInterNetAvailability() == true) {
					recordsToBeSync = getRecordsNeededToSyncOnLiveServer('Chat');
					currentIndex = 0;
					if(recordsToBeSync){
						chat = recordsToBeSync[currentIndex] as ChatData;
						sendChatToServer(chat);
					}
				}
			}
		}
		
		private function sendChatToServer(chat:ChatData):void{
			var urlVariable:URLVariables  = new URLVariables;
			urlVariable.session_id = Network.session_id;
			urlVariable.chat_id  = chat.id;
			urlVariable.to_user = chat.toUserId;
			urlVariable.type = chat.type;
			urlVariable.content = chat.content;
			Network.call_API(null,"send_chat",urlVariable,"","get");
		}
		
		private function sendCompleteHandler(event:Event):void{
			updateLastSyncTime('Chat',chat.id);
			currentIndex++;
			if(currentIndex > recordsToBeSync.length){
				chat = recordsToBeSync[currentIndex] as ChatData;
				sendChatToServer(chat);
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
		
		public function updateLocalDBChatRow(rowId:String,data:Object):void {
			
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM Chat WHERE id="+rowId;
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
					chatdata.createDate = new Date();
					chatdata.createdBy = data.create_by;
					chatdata.lastSync = new Date();
					chatdata.statusId = data.status_id;
					chatdata.toUserId = data.to_user;
					chatdata.type = data.type;
					sendChat(chatdata);
				}
			}
		}
		
		private	function openHandler(event:SQLEvent):void{
		}
		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}