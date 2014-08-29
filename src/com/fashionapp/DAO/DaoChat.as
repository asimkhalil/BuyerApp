package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;

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
			if (result != null){
				Parser.parseContactList(result);
			}
			
			getAllCurrentChats();
			
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
		
		
		private function getAllCurrentChats(username:String=""):void {
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "SELECT * FROM Chat";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
			
			var result:SQLResult = stmt1.getResult();
			if (result != null){
				Parser.parseChatsList(result);
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
				Parser.parseChatMessagesForMeList(result);
			}
		}
		
		private	function openHandler(event:SQLEvent):void{
		}
		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}