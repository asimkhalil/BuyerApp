package com.fashionapp.network
{
	import air.net.URLMonitor;
	
	import com.fashionapp.model.LoginData;
	import com.fashionapp.util.Test;
	import com.fashionapp.util.Utils;
	import com.fashionapp.views.LoginView;
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.managers.CursorManager;
	
	public class Network
	{
		private static var objParent:DisplayObject;
		
		// Internet related.
		private static var monitor:URLMonitor; 
		[Bindable]  
		private static var isOnline: Boolean = false;
		private  var conn:SQLConnection;
		private var insertLogin:SQLStatement;
		
		public static function call_API(parentObj:DisplayObject,url:String,
										variables:URLVariables,method:String = "post"):void{
			objParent  = parentObj;
			CursorManager.setBusyCursor();
			var myVariables:URLVariables = new URLVariables();
			myVariables = variables;
			var myURLRequest:URLRequest = new URLRequest();
			var myURLLoader:URLLoader = new URLLoader(); 
			if(method == "get".toLocaleLowerCase()){
				myURLRequest.method = URLRequestMethod.GET;
			}else if(method == "post".toLocaleLowerCase()){
				myURLRequest.method = URLRequestMethod.POST;
			} 
			myURLRequest.url = url;
			if(variables != null){
				myURLRequest.data = variables;
			}
			myURLLoader.load(myURLRequest);
			myURLLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.addEventListener(Event.COMPLETE, loginComplete);
		}
		/*******************************************************************/
		private static function IOErrorHanlder(event:Event):void{
			Alert.show(objParent,event.target.data);
			CursorManager.removeBusyCursor();
		}
		/*******************************************************************/ 
		private static function SECURITY_ERRORHanlder(event:Event):void{
			Alert.show(objParent,event.target.data);
			CursorManager.removeBusyCursor();
		}
		/*******************************************************************/ 
		private static function loginComplete(event:Event):void{
			Alert.show(objParent,event.target.data);
			//updateDataBase(Test.getDummyLoginData());
			/*if(event.target.data == 'Image upload sucessfull'){
				navigateToURL(new URLRequest('http://smarttees.biz/printing?get_cart_url=1'), "_self");
			}*/
			CursorManager.removeBusyCursor();
		}
		
		/*private function updateDataBase(ld:LoginData):void{
		{
			var appStorage:File = File.applicationStorageDirectory;
			var dbFile:File = Utils.db_path;
			conn = new SQLConnection();
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.openAsync(dbFile);
		}
		private function openHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLEvent.BEGIN, beginHandler);
			conn.begin();
		}
		private function beginHandler(event:SQLEvent):void
		{
			//stmt.text = "INSERT OR IGNORE INTO tbl_breed (breed_id,breed_breed)"+" VALUES ('1','test')";
			
			conn.removeEventListener(SQLEvent.BEGIN, beginHandler);
			insertLogin = new SQLStatement();
			insertLogin.sqlConnection = conn;
			//insertLogin.text = "INSERT INTO Users (id, username, fullname,password,tel,email,groupID,code,statusID,lastLogin,lastUpdate,lastSync) " + 'VALUES ('+ld.id+','+ld.userName+','+ld.fullName+','"sdf"','+ld.tel','+ld.email','',')";
			insertLogin.addEventListener(SQLEvent.RESULT, insertLoginHandler);
			insertLogin.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			insertLogin.execute();
		}
		
		// Called after the employee record is inserted
		private function insertLoginHandler(event:SQLEvent):void
		{
			insertLogin.removeEventListener(SQLEvent.RESULT, insertLoginHandler);
			insertLogin.removeEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			var result:SQLResult = insertLogin.getResult();
			var employeeId:Number = result.lastInsertRowID;
		}
		
		private function errorHandler(event:SQLErrorEvent):void
		{
			if (conn.inTransaction)
			{
				conn.addEventListener(SQLEvent.ROLLBACK, rollbackHandler);
				conn.rollback();
			}
		}
		private function rollbackHandler(event:SQLEvent):void
		{
			conn.removeEventListener(SQLEvent.ROLLBACK, rollbackHandler);
		}*/
		
		
		/*************************  Check internet  ******************************************/
		public static function checkInterNetAvailability(url:String='http://www.google.com'):Boolean { 
			monitor = new URLMonitor( new URLRequest(url)); 
			monitor.addEventListener(StatusEvent.STATUS,announceStatus); 
			monitor.start(); 
			return isOnline;
		} 
		private static function announceStatus(e:StatusEvent):void { 
			trace("Status change. Current status: " + monitor.available); 
			if(monitor.available) { 
				isOnline = true; 
			} else { 
				isOnline = false; 
			} 
		}
		/*******************************************************************/
	}
		
}