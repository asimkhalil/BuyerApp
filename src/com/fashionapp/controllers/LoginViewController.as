package com.fashionapp.controllers
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.adobe.serialization.jsonv2.JSON;
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.DAO.DaoLogin;
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.events.LoginClickEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.model.LoginData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.*;
	import com.fashionapp.views.HomeView;
	import com.fashionapp.views.LoginView;
	import com.fashionapp.views.MainMenuView;
	import com.fashionapp.views.poups.Alert;
	import com.fashionapp.vo.LoginVO;
	import com.tree.ext.PushNotification;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
		
	public class LoginViewController extends BaseController
	{
		public var usernameValidator:Validator;
		public var passwordValidator:Validator;
		
		private var dl:DaoLogin = new DaoLogin();
		
		private var chat:ChatData;
		private var recordsToBeSync:Array;
		private var currentIndex:int = 0;
		
		public function LoginViewController()
		{
			super();
			//setupDB();
			
		}
		
		private function setupDB():void
		{
			// check if db exists
			var source:File = File.applicationDirectory.resolvePath(Utils.db_path);
			source.addEventListener(Event.COMPLETE,copyDone);
			var destination:File = File.applicationStorageDirectory.resolvePath(Utils.db_path);
			if (! destination.exists)
			{
				source.copyTo(File.applicationStorageDirectory.resolvePath(Utils.db_path), true);
			}
		}
		public function copyDone(e:Event):void{
			toast("copyDone");
		}
		
		public function creationCompleteHandler():void 
		{
			setupDB();
			//toast(Network.checkInterNetAvailability().toString());
			
			usernameValidator = new Validator();
			passwordValidator = new Validator();
			
			usernameValidator.source =  (view as LoginView).txt_username;
			passwordValidator.source =  (view as LoginView).txt_password;
		
			usernameValidator.property = "text";
			passwordValidator.property = "text";
			
			usernameValidator.required = true;
			passwordValidator.required = true;
			
			addListeners();
			
			var dl:DaoLogin = new DaoLogin();
			dl.initDB();
			var destination:File = File.applicationStorageDirectory.resolvePath(Utils.db_path);
		}
		
		private function startTimerForRecievingChats():void {
			listenForNewMessage();
		}
		
		private function addListeners():void
		{
			if(FlexGlobals.topLevelApplication.hasEventListener('LoginClickEvent')==false){
				FlexGlobals.topLevelApplication.addEventListener('LoginClickEvent',loginClickEventListener,false,0,true);
			}
			
			if(FlexGlobals.topLevelApplication.hasEventListener('ContactListRecieved')==false) {
				FlexGlobals.topLevelApplication.addEventListener('ContactListRecieved',contactsRecieved,false,0,true);
			}
			
			if(FlexGlobals.topLevelApplication.hasEventListener('ChatListRecieved')==false) {
				FlexGlobals.topLevelApplication.addEventListener('ChatListRecieved',chatListRecieved,false,0,true);
			}
			
			//add by JACK--------------------
			if(FlexGlobals.topLevelApplication.hasEventListener('CheckAppKey')==false) {
				FlexGlobals.topLevelApplication.addEventListener('CheckAppKey',CheckAppKeyRecieved,false,0,true);
			}
			//--------------------------------
			
			if(FlexGlobals.topLevelApplication.hasEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES)==false) {
				FlexGlobals.topLevelApplication.addEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES,chatMessagesForMeListRecieved,false,0,true);
			}
			
			if(FlexGlobals.topLevelApplication.hasEventListener("RetrieveChatMessages")==false) {
				FlexGlobals.topLevelApplication.addEventListener("RetrieveChatMessages",checkNewMessageForMe,false,0,true);
			}
		}
		
		private function listenForNewMessage():void {
			checkNewMessageForMe();
		} 
		
		private function chatListRecieved(event:Event):void {
			/*startTimerForRecievingChats();*/
		}
		
		private function contactsRecieved(event:Event):void {
			BuyerAppModelLocator.getInstance().users.refresh();
			startTimerForRecievingChats();
		}
		
		private function chatMessagesForMeListRecieved(event:IntimateForNewChatMessagesForMeEvent):void {
			FlexGlobals.topLevelApplication.dispatchEvent(new Event("NEW_MESSAGES_ARRIVED",true));
		}
		
		public function checkNewMessageForMe(event:Event = null):void {
			
			var dc:DaoChat = new DaoChat();
			
			if(Network.checkInterNetAvailability() == true){
				var urlVariable:URLVariables  = new URLVariables;
				urlVariable.last_update = DBUtils.getLastdownloadTime('Chat');
				
				
				if(view.hasEventListener(APIEvent.API_COMPLETE_CHATS)==false) {
					view.addEventListener(APIEvent.API_COMPLETE_CHATS, onChatMessagesComplete);
				}
				
				function onChatMessagesComplete(event:APIEvent):void {
					var results:Array = event.data.chat;
					if(results && results.length > 0) {
						Parser.parseChatMessagesForMeList(results);
						for(var i :int = 0 ; i < results.length ; i++){
							var daoChat:DaoChat = new DaoChat();
							daoChat.updateLocalDBChatRow(results[i].id,results[i]);
						}
						DBUtils.updateLastdownloadTime('Chat');
						setTimeout(checkNewMessageForMe,30000);
					}
				}
				 
				Network.call_API(view as LoginView,"receive_chat",urlVariable,"","get");
				
			}else{
				dc.getChatsForMe();
			}
			dc.getChatsForMe();
		}
		
		private function loginClickEventListener(event:LoginClickEvent):void
		{
			var ld:LoginData = new LoginData();
			ld = event.loginDataObject;
			if(ld.userName == (view as LoginView).txt_username.text){
				(view as LoginView).navigator.pushView(HomeView);
				var dc:DaoChat = new DaoChat();
				if(Network.checkInterNetAvailability() == true){
				}else{
					dc.getContactsFromDB();
				}
			}else{
				toast("Invalid Username or Password!");
			}
		}
		
		public function doLogin(username:String,password:String):void 
		{
			var dl:DaoLogin = new DaoLogin();
			var checkNetwork:Boolean = true;
			//var file:File = File.applicationStorageDirectory;
			if(Network.checkInterNetAvailability() == true){
				var urlVariable:URLVariables  = new URLVariables;
				urlVariable.username = (view as LoginView).txt_username.text;
				urlVariable.password = (view as LoginView).txt_password.text;
				urlVariable.apns_id = PushNotification.APN_ID;
				urlVariable.type = "buyer";
				
				view.addEventListener(APIEvent.API_COMPLETE, onLoginComplete);
				view.addEventListener(APIEvent.API_ERROR, onLoginFail);
				Network.call_API((view as LoginView),"login",urlVariable,"","get");
				//Network.call_API(view as LoginView,"http://smarttees.biz/build/products.php",urlVariable,"post");
			}
			else{
				dl.getLoginDataFromDB((view as LoginView).txt_username.text,(view as LoginView).txt_password.text);
			}
		}
		
		public function localLogin(e:APIEvent):void
		{
			dl.getLoginDataFromDB((view as LoginView).txt_username.text,(view as LoginView).txt_password.text);
		}
		
		public function onLoginFail(e:APIEvent =null):void
		{
			toast("Invalid Username or Password!");
		}
		
		public function onLoginComplete(e:APIEvent):void 
		{
			var status:String = e.data.status;	
			toast(status);
			if(status == "OK") {
				Network.session_id =e.data.session_id;
				Network.user_id = e.data.id;
				Parser.parseLoginData([e.data]);
				dl.writeLocalSession(e.data.session_id);
				dl.getLocalAppKey();
				
				//delete by jack -------------
				//FlexGlobals.topLevelApplication.navigator.pushView(HomeView);
				// -------------------------
				var dc:DaoChat = new DaoChat();
				if(Network.checkInterNetAvailability() == true) {
					var urlVariable:URLVariables  = new URLVariables;
					
					urlVariable.last_update = "2014-01-01 00:00:00";
					
					if(view.hasEventListener(APIEvent.API_COMPLETE_CONTACTS)==false) 
					{
						view.addEventListener(APIEvent.API_COMPLETE_CONTACTS,onContactsRecievedHandler);
					}
					
					function onContactsRecievedHandler(event:APIEvent):void {
						if(event.data.users != undefined) {
							var results:Array = event.data.users;
							Parser.parseContactList(results);
						}
					}
					toast('getcontact');
					
					Network.call_API(view as LoginView,"contact",urlVariable,"","get");
				}else{
					dc.getContactsFromDB();
				}
				//(view as LoginView).navigator.pushView(HomeView);
			}else{
				
				toast("Invalid Username or Password!");
			}
		}
		
		public function CheckAppKeyRecieved(e:APIEvent):void{

			if (Network.app_key == '' || Network.app_key == null){
				Network.app_key = Network.session_id;
				dl.writeLocalAppKey(Network.session_id);
			}
			FlexGlobals.topLevelApplication.navigator.pushView(HomeView);
		}
	}
}