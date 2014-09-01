package com.tree.ext
{
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
	
	import com.fashionapp.controllers.BaseController;
	public class PushNotification
	{
		private var notiStyles:Vector.<String> = new Vector.<String>;;
		private var tt:TextField = new TextField();
		private var tf:TextFormat = new TextFormat();
		private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions();
		private var preferredStyles:Vector.<String> = new Vector.<String>();
		private var remoteNot:RemoteNotifier = new RemoteNotifier();
		
		//private var subsButton:CustomButton = new CustomButton("Subscribe");
		//private var unSubsButton:CustomButton = new CustomButton("UnSubscribe");
		//private var clearButton:CustomButton = new CustomButton("clearText");
		
		private var urlreq:URLRequest;
		private var urlLoad:URLLoader = new URLLoader();
		private var urlString:String;
		
		private var instance:BaseController;
		public function init(_instance:BaseController)
		{
			instance = _instance;
			//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			/*
			tf.size = 20;
			tf.bold = true;			
			
			tt.x=0;
			tt.y =150;
			tt.height = stage.stageHeight;
			tt.width = stage.stageWidth;
			tt.border = true;
			tt.defaultTextFormat = tf;
			
			addChild(tt);
			
			subsButton.x = 150;
			subsButton.y=10;
			subsButton.addEventListener(MouseEvent.CLICK,subsButtonHandler);
			stage.addChild(subsButton);
			
			unSubsButton.x = 300;
			unSubsButton.y=10;
			unSubsButton.addEventListener(MouseEvent.CLICK,unSubsButtonHandler);
			stage.addChild(unSubsButton);
			
			clearButton.x = 450;
			clearButton.y=10;
			clearButton.addEventListener(MouseEvent.CLICK,clearButtonHandler);
			stage.addChild(clearButton);
			
			
			tt.text += "\n SupportedNotification Styles: " + RemoteNotifier.supportedNotificationStyles.toString() + "\n";
			
			tt.text += "\n Before Preferred notificationStyles: " + subscribeOptions.notificationStyles.toString() + "\n";
			*/
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND );			
			subscribeOptions.notificationStyles= preferredStyles;
			
			// tt.text += "\n After Preferred notificationStyles:" + subscribeOptions.notificationStyles.toString() + "\n";
			
			
			remoteNot.addEventListener(RemoteNotificationEvent.TOKEN,tokenHandler);
			remoteNot.addEventListener(RemoteNotificationEvent.NOTIFICATION,notificationHandler);
			remoteNot.addEventListener(StatusEvent.STATUS,statusHandler);
			
			// this.stage.addEventListener(Event.ACTIVATE,activateHandler);
			
			
			NativeApplication.nativeApplication.executeInBackground = true;
			instance.toast("going subscribe");
			if(RemoteNotifier.supportedNotificationStyles.toString() != " ")
			{	
				remoteNot.subscribe(subscribeOptions);		
				instance.toast("finishing subscribe");
			}
			
		}
		
		public function activateHandler(e:Event):void
		{
			
			if(RemoteNotifier.supportedNotificationStyles.toString() != " ")
			{	
				remoteNot.subscribe(subscribeOptions);
				
			}
			else{
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
			instance.toast("notificationHandler");
			for (var x:String in e.data) {
				//tt.text += "\n"+ x + ":  " + e.data[x];
			}
			
		}
		
		public function tokenHandler(e:RemoteNotificationEvent):void
		{
			//tt.appendText("\nRemoteNotificationEvent type: "+e.type +"\nBubbles: "+ e.bubbles + "\ncancelable " +e.cancelable +"\ntokenID:\n"+ e.tokenId +"\n");
			instance.toast("tokenHandler");
			//urlString = new String("https://go.urbanairship.com/api/device_tokens/" + e.tokenId);
			urlString = new String("http://www.infinmedia.net/apps_push_notification/register.php?action=register&os=ios&projectID=11&devID="+e.tokenId);
			
			urlreq = new URLRequest(urlString);
			
			urlreq.authenticate = true;
			urlreq.method = URLRequestMethod.PUT;
			
			//URLRequestDefaults.setLoginCredentialsForHost("go.urbanairship.com","1ssB2iV_RL6_UBLiYMQVfg","t-kZlzXGQ6-yU8T3iHiSyQ");
			
			urlLoad.load(urlreq);
			urlLoad.addEventListener(IOErrorEvent.IO_ERROR,iohandler);
			urlLoad.addEventListener(Event.COMPLETE,compHandler);
			urlLoad.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler);
			
		}
		
		private function iohandler(e:IOErrorEvent):void
		{
			//tt.appendText("\n In IOError handler" + e.errorID +" " +e.type);
			
		}
		private function compHandler(e:Event):void{
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