package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.events.LoginClickEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.LoginData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	import com.fashionapp.views.poups.Alert;
	
	import mx.core.FlexGlobals;

	public class DaoLogin
	{
		private var loginData:LoginData;
		private var username:String;
		private var password:String;
		private var stmt1:SQLStatement;
		
		
		public function initDB():void {
			BuyerAppModelLocator.getInstance().dataFile = File.applicationStorageDirectory.resolvePath(Utils.db_path);
			BuyerAppModelLocator.getInstance().dbConn = new SQLConnection();
			BuyerAppModelLocator.getInstance().dbConn.addEventListener(SQLEvent.OPEN, DBOpened);
			BuyerAppModelLocator.getInstance().dbConn.open(BuyerAppModelLocator.getInstance().dataFile);
		}
		
		
		public function getLoginDataFromDB(usr:String, pwd:String):void{
			
			username = usr;
			password = pwd;
			
			stmt1 = new SQLStatement();
			stmt1.text = "SELECT * FROM Users where username='"+username+"' and password='" + password + "'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, loginHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
		}
		
		private function DBOpened(event:SQLEvent):void{
			trace("asdaslkj");
		}
		private	function loginHandler(event:SQLEvent):void{
			var result:SQLResult = stmt1.getResult();
			FlexGlobals.topLevelApplication.dispatchEvent(new LoginClickEvent('LoginClickEvent',Parser.parseLoginData(result.data)));
		}
		
		
		public function getLocalSession():void{
			
			stmt1 = new SQLStatement();
			stmt1.text = "SELECT value FROM MasterKey where id='SessionKey'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, getSessionHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();	
			
		}
		
		private	function getSessionHandler(event:SQLEvent):void{
			var result:SQLResult = stmt1.getResult();
			if (result.data[0].value !=""){
				Network.session_id = result.data[0].value;
			}
		}
		
		public function writeLocalSession(value:String):void{
			
			stmt1 = new SQLStatement();
			
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(new Date());
			//Alert("update MasterKey set value ='"+value+"', lastupdate='"+createdDate+"' where id='SessionKey'");
			stmt1.text = "update MasterKey set value ='"+value+"', lastupdate='"+createdDate+"' where id='SessionKey'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.execute();	
			
		}

		public function getLocalAppKey():void{
			
			stmt1 = new SQLStatement();
			stmt1.text = "SELECT value FROM MasterKey where id='AppKey'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, getAppKeyHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();	
			
		}
		
		private	function getAppKeyHandler(event:SQLEvent):void{
			var result:SQLResult = stmt1.getResult();
			if (result != null && result.data !=null){
				if (result.data[0].value !=""){
					Network.app_key = result.data[0].value;
				}
			}
			Alert.show((FlexGlobals.topLevelApplication as DisplayObject),'getKey:'+Network.app_key); 
			FlexGlobals.topLevelApplication.dispatchEvent(new APIEvent('CheckAppKey'));
		}

		public function writeLocalAppKey(value:String):void{
			
			stmt1 = new SQLStatement();
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(new Date());
			stmt1.text = "update MasterKey set value ='"+value+"', lastUpdate='"+createdDate+"' where id='AppKey'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.execute();	
		}

		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}