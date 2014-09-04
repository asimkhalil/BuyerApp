package com.fashionapp.network
{
	import air.net.URLMonitor;
	
	import com.adobe.serialization.jsonv2.JSON;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.model.LoginData;
	import com.fashionapp.util.*;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.views.LoginView;
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.DisplayObject;
	import flash.events.DataEvent;
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
	
	public class SendChatNetwork
	{
		private static var objParent:DisplayObject;
		private static var myURLLoader:CustomURLLoader;
		private static var myURLRequest:URLRequest;
		
		[Bindable]  
		private static var _waitingForResponse:Boolean = false;
		
		private static var _serviceQueue:Array = [];
		
		public static function call_API(parentObj:DisplayObject,api_name:String,variables:URLVariables,file:String="",method:String = "post"):void {
			
			if(!_waitingForResponse) 
			{
				_waitingForResponse = true;	
			}
			else 
			{
				var serviceData:Object = {};
				serviceData.parentObject = parentObj;
				serviceData.api_name = api_name;
				serviceData.variables = variables;
				serviceData.file = file;
				serviceData.method = method;
				_serviceQueue.push(serviceData);	
				return;
			}
			
			objParent = parentObj;
			CursorManager.setBusyCursor();
			var myVariables:URLVariables = new URLVariables();
			myVariables = variables;
			myURLRequest = new URLRequest();
			myURLLoader = new CustomURLLoader(); 
			if(method == "get".toLocaleLowerCase()){
				myURLRequest.method = URLRequestMethod.GET;
			}
			else if(method == "post".toLocaleLowerCase()){
				myURLRequest.method = URLRequestMethod.POST;
			}
			
			
			if(api_name != "login") {
				variables.session_id = Network.session_id;
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
			if(myURLLoader.hasEventListener(IOErrorEvent.IO_ERROR)==false) {
				myURLLoader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			}
			if(myURLLoader.hasEventListener(SecurityErrorEvent.SECURITY_ERROR)==false) {
				myURLLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			}
			if(myURLLoader.hasEventListener(Event.COMPLETE)==false) {
				myURLLoader.addEventListener(Event.COMPLETE, callComplete);
			}
		}
		/*******************************************************************/
		private static function IOErrorHanlder(event:Event):void{						
			myURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.removeEventListener(Event.COMPLETE, callComplete);
			
			objParent.dispatchEvent(new APIEvent(APIEvent.API_ERROR));			
			//Alert.show(objParent,event.target.data);
			CursorManager.removeBusyCursor();			
		}
		/*******************************************************************/ 
		private static function SECURITY_ERRORHanlder(event:Event):void{						
			myURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.removeEventListener(Event.COMPLETE, callComplete);
			
			objParent.dispatchEvent(new APIEvent(APIEvent.API_ERROR));			
			//Alert.show(objParent,event.target.data);
			CursorManager.removeBusyCursor();			
		}
		/*******************************************************************/ 
		private static function callComplete(event:Event):void {	
			CursorManager.removeBusyCursor();	
			myURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHanlder);
			myURLLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_ERRORHanlder);
			myURLLoader.removeEventListener(Event.COMPLETE, callComplete);
			
			if(myURLLoader.data != undefined) {
				var _data:String = BasicUtil.decrypt(myURLLoader.data);
				var jsonResult:Object = com.adobe.serialization.jsonv2.JSON.decode(_data); 
				if(myURLRequest.url.indexOf('contact') != -1) 
				{
					objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE_CONTACTS, jsonResult));
				} 
				else if(myURLRequest.url.indexOf('receive_chat') != -1) 
				{
					objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE_CHATS, jsonResult));
				} 
				else if(myURLRequest.url.indexOf('send_chat') != -1) 
				{
					FlexGlobals.topLevelApplication.dispatchEvent(new APIEvent(APIEvent.API_SEND_CHAT, jsonResult));
				} 
				else if(myURLRequest.url.indexOf('upload_image') != -1) 
				{
					FlexGlobals.topLevelApplication.dispatchEvent(new APIEvent(APIEvent.API_IMAGE_UPLOAD_COMPLETE, jsonResult));
				}
				else {
					objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, jsonResult));
				}
				
				_waitingForResponse = false;
				
				if(_serviceQueue.length > 0) 
				{
					var serviceData:Object = _serviceQueue.pop();
					call_API(serviceData.parentObject,serviceData.api_name,serviceData.variables,serviceData.file,serviceData.method);
				}
			}
		}			
	}
	
}