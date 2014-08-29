package com.fashionapp.network
{
	import air.net.URLMonitor;
	
	import com.fashionapp.event.APIEvent;
	import com.fashionapp.util.Base64;
	
	import com.fashionapp.model.LoginData;
	import com.fashionapp.util.Test;
	import com.fashionapp.util.Utils;
	import com.fashionapp.views.LoginView;
	import com.fashionapp.views.poups.Alert;
	
	import flash.utils.ByteArray;
	
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
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	public class Network
	{
		private static var objParent:DisplayObject;
		private static var myURLLoader:URLLoader;
		private static var key:String = 'dSChAjgz36TTexeLODPYxleJndjVcOMVzsLJjSM8dLpXsTS4FCeMbhw2s2u';
		
		private static var app_key:String = 'Oo6CxOL'; 
		private static var session_id:String = 'OoDulhq';
		private static var user_id:String = '8'; // you can use this for update the localDB of the create user id

		// Internet related.
		private static var monitor:URLMonitor; 
		[Bindable]  
		private static var isOnline: Boolean = false;

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
			
			requestData = Network.encrypt(requestData);
			
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
			
			objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, Network.decrypt(myURLLoader.data)));			
			//Alert.show(objParent,event.target.data);
			//CursorManager.removeBusyCursor();
		}
		
		private static function updateServer(table:String):void{
			/*
			if there is network, 
				select * from table where lastUpdate > lastSync
				foreach row
					send to the server
					update table set lastSync = now where id = row.id
				end
			*/
		}
		
		// encryption decryption
		/**************************************************************/
		private static function encrypt(str:String):String {
            var result:String = '';
            for (var i:int = 0; i < str.length; i++) {
                var char:String = str.substr(i, 1);
                var keychar:String = key.substr((i % key.length) - 1, 1);
                var ordChar:int = char.charCodeAt(0);
                var ordKeychar:int = keychar.charCodeAt(0);
                var sum:int = ordChar + ordKeychar;
                char = String.fromCharCode(sum);
                result = result + char;
            }	
            return Base64.encode(result);
        }
   		private static function decrypt(str:String):String {
            var result:String = '';
            var str:String = Base64.decode(str);   
            for (var i:int = 0; i < str.length; i++) {
                var char:String = str.substr(i, 1);
                var keychar:String = key.substr((i % key.length) - 1, 1);
                var ordChar:int = char.charCodeAt(0);
                var ordKeychar:int = keychar.charCodeAt(0);
                var sum:int = ordChar - ordKeychar;
                char = String.fromCharCode(sum);
                result = result + char;
            }
            return result;
        }
		/*************************  Check internet  ******************************************/
		
		public static function checkInterNetAvailability(url:String='http://59.188.218.19/'):Boolean { 
			monitor = new URLMonitor( new URLRequest(url)); 
			monitor.addEventListener(StatusEvent.STATUS,announceStatus); 
			monitor.start(); 
			return isOnline;
		} 
		private static function announceStatus(e:StatusEvent):void { 
			trace("Status change. Current status: " + monitor.available); 
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