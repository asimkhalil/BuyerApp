package com.tree.ext
{
	import com.adobe.serialization.jsonv2.JSON;
	import com.fashionapp.controllers.BaseController;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.StatusEvent;
	import flash.net.*;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifier;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	public class PushNotification
	{
		private var notiStyles:Vector.<String> = new Vector.<String>;
		private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions();
		private var preferredStyles:Vector.<String> = new Vector.<String>();
		private var remoteNot:RemoteNotifier = new RemoteNotifier();
		public static var APN_ID:String = "";
		
		//private var subsButton:CustomButton = new CustomButton("Subscribe");
		//private var unSubsButton:CustomButton = new CustomButton("UnSubscribe");
		//private var clearButton:CustomButton = new CustomButton("clearText");
		
		private var instance:BaseController;
		public function init(_instance:BaseController)
		{
			instance = _instance;
			
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND);			
			subscribeOptions.notificationStyles= preferredStyles;
			
			// tt.text += "\n After Preferred notificationStyles:" + subscribeOptions.notificationStyles.toString() + "\n";
			
			remoteNot.addEventListener(RemoteNotificationEvent.TOKEN,tokenHandler);
			remoteNot.addEventListener(RemoteNotificationEvent.NOTIFICATION,notificationHandler);
			remoteNot.addEventListener(StatusEvent.STATUS,statusHandler);
			
			// this.stage.addEventListener(Event.ACTIVATE,activateHandler);			
			
			NativeApplication.nativeApplication.executeInBackground = true;
			//instance.toast("going subscribe");
			if(RemoteNotifier.supportedNotificationStyles.toString() != " ")
			{	
				remoteNot.subscribe(subscribeOptions);		
				//instance.toast("finishing subscribe");
			}
			
		}
		
		public function activateHandler(e:Event):void
		{	
			if(RemoteNotifier.supportedNotificationStyles.toString() != " ") {	
				remoteNot.subscribe(subscribeOptions);				
			}
			else {
				//tt.appendText("\n Remote Notifications not supported on this Platform !");
			}
		}
		public function subsButtonHandler(e:MouseEvent):void{
			remoteNot.subscribe(subscribeOptions);
		}
		public function unSubsButtonHandler(e:MouseEvent):void{
			remoteNot.unsubscribe();
			//tt.text +="\n UNSUBSCRIBED";
		}
		
		public function clearButtonHandler(e:MouseEvent):void{
			//tt.text = " ";
		}
		
		public function notificationHandler(e:RemoteNotificationEvent):void{
			//tt.appendText("\nRemoteNotificationEvent type: " + e.type +"\nbubbles: "+ e.bubbles + "\ncancelable " +e.cancelable);
			//instance.toast("notificationHandler");
			//var jsonResult:Object = com.adobe.serialization.jsonv2.JSON.decode(e.data['aps']); 
			
//			var tt:String;
//			var ss:String = null;
//			for (var x:String in e.data[0].data) {
//				tt += "\n"+ x + ":  " + e.data[0].data[x];
//				
//				if (x == "alert"){
//					ss= e.data[0].data[x];				
//				}
//			}
//			if (ss != null){
//				instance.toast(ss);
//			}else{
				instance.toast('New Message Arrived');
			//}
		}
		
		
		private var urlreq:URLRequest;
		private var urlLoad:URLLoader = new URLLoader();
		private var urlString:String;
		public function tokenHandler(e:RemoteNotificationEvent):void
		{
			//tt.appendText("\nRemoteNotificationEvent type: "+e.type +"\nBubbles: "+ e.bubbles + "\ncancelable " +e.cancelable +"\ntokenID:\n"+ e.tokenId +"\n");
			PushNotification.APN_ID = e.tokenId;
			//instance.toast("tokenHandler: " + e.tokenId);
			
			/*
			urlString = new String("http://http://59.188.218.19/apns/admin.php?action=register&os=ios&projectID=12&devID="+e.tokenId);
			
			urlreq = new URLRequest(urlString);
			
			urlreq.authenticate = true;
			urlreq.method = URLRequestMethod.PUT;
			
			//URLRequestDefaults.setLoginCredentialsForHost("go.urbanairship.com","1ssB2iV_RL6_UBLiYMQVfg","t-kZlzXGQ6-yU8T3iHiSyQ");
			
			urlLoad.load(urlreq);
			urlLoad.addEventListener(IOErrorEvent.IO_ERROR,iohandler);
			urlLoad.addEventListener(Event.COMPLETE,compHandler);
			urlLoad.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler);
			*/
			
		}
		
		private function iohandler(e:IOErrorEvent):void
		{
			instance.toast("In IOError handler" + e.errorID +" " +e.type);
			//tt.appendText("\n In IOError handler" + e.errorID +" " +e.type);
			
		}
		private function compHandler(e:Event):void{
			instance.toast("In Complete handler,"+"status: " +e.type + "\n");
			//tt.appendText("\n In Complete handler,"+"status: " +e.type + "\n");
		}
		
		private function httpHandler(e:HTTPStatusEvent):void{
			//tt.appendText("\n in httpstatus handler,"+ "Status: " + e.status);
		}
		
		
		public function statusHandler(e:StatusEvent):void{
			instance.toast("event Level" + e.level +"event code " + e.code);
			//tt.appendText("\n statusHandler");
			//tt.appendText("\nevent Level" + e.level +"\nevent code " + e.code + "\ne.currentTarget: " + e.currentTarget.toString());
		}
	}
}