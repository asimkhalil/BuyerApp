package com.fashionapp.network
{
	import air.net.URLMonitor;
	
	import com.adobe.serialization.jsonv2.JSON;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.model.LoginData;
	import com.fashionapp.util.Test;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	import spark.components.View;
	
	public class Network
	{
		private static var objParent:DisplayObject;
		private static var myURLLoader:URLLoader;
		
		
		public static var app_key:String = ''; 
		public static var session_id:String = '';
		public static var user_id:String = ''; // you can use this for update the localDB of the create user id
		
		public static var ld:LoginData = new LoginData();
		
		// Internet related.
		private static var monitor:URLMonitor; 
		[Bindable]  
		private static var isOnline: Boolean = true;

		public static function call_API(parentObj:DisplayObject,api_name:String,
										variables:URLVariables,file:String="",method:String = "post"):void{
			objParent = parentObj;
			//CursorManager.setBusyCursor();
			var myVariables:URLVariables = new URLVariables();
			myVariables = variables;
			var myURLRequest:URLRequest = new URLRequest();
			myURLLoader = new URLLoader(); 
			if(method == "get".toLocaleLowerCase()){
				myURLRequest.method = URLRequestMethod.GET;
			}
			else if(method == "post".toLocaleLowerCase()){
				myURLRequest.method = URLRequestMethod.POST;
			}
			
			
			if(api_name != "login") {
				variables.session_id = session_id;
			}
			var requestData:String = unescape(variables.toString());
			
			requestData = BasicUtil.encrypt(requestData);
			
			if(file != "" && variables != null){
				myURLRequest.url = "http://59.188.218.19/api/1-0/"+api_name+"/";				
				myURLRequest.data = new URLVariables();
				myURLRequest.data.request = requestData;				

				//myURLRequest.data.image = bytes;
			}
			else {					
				myURLRequest.url = "http://59.188.218.19/api/1-0/"+api_name+"/"+requestData;
			}
			myURLLoader.load(myURLRequest);
			myURLLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.addEventListener(Event.COMPLETE, callComplete);
		}
		/*******************************************************************/
		private static function IOErrorHanlder(event:Event):void{						
			myURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.removeEventListener(Event.COMPLETE, callComplete);
			
			objParent.dispatchEvent(new APIEvent(APIEvent.API_ERROR));			
			//Alert.show(objParent,event.target.data);
			//CursorManager.removeBusyCursor();			
		}
		/*******************************************************************/ 
		private static function SECURITY_ERRORHanlder(event:Event):void{						
			myURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.removeEventListener(Event.COMPLETE, callComplete);
			
			objParent.dispatchEvent(new APIEvent(APIEvent.API_ERROR));			
			//Alert.show(objParent,event.target.data);
			//CursorManager.removeBusyCursor();			
		}
		/*******************************************************************/ 
		private static function callComplete(event:Event):void{						
			myURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.removeEventListener(Event.COMPLETE, callComplete);
			
			if(myURLLoader.data != undefined) {
				var _data:String = BasicUtil.decrypt(myURLLoader.data);
				var jsonResult:Object = com.adobe.serialization.jsonv2.JSON.decode(_data); 
				if(jsonResult.users != undefined) {
					objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE_CONTACTS, jsonResult));
				} else if(jsonResult.chat != undefined) {
					objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE_CHATS, jsonResult));
				} else {
					objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, jsonResult));
				}
			}
			//Alert.show(objParent,com.adobe.serialization.jsonv2.JSON.decode(_data));
			//CursorManager.removeBusyCursor();
		}	
		
		/*************************  Check internet  ******************************************/
		public static function startMonitor(){
			monitor = new URLMonitor( new URLRequest('http://www.google.com/')); 
			monitor.addEventListener(StatusEvent.STATUS,announceStatus); 
			monitor.start(); 
		}
		
		public static function checkInterNetAvailability():Boolean { 
			return isOnline;			
		} 
		
		private static function announceStatus(e:StatusEvent):void { 
			if(monitor.available) { 
				isOnline = true; 
				/*
					try to upload all data back to the server
					select * from database
					foreach table
						select * from table where lastUpdate > lastSync
						foreach row
							send to the server
							update table set lastSync = now where id = row.id
						end					
					end
				*/
			} else { 
				isOnline = false; 
			}
		}
		
		/*******************************************************************/
		
	}
		
}