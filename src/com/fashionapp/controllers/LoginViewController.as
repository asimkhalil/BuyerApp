package com.fashionapp.controllers
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.DAO.DaoLogin;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.events.LoginClickEvent;
	import com.fashionapp.events.LoginEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.LoginData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.views.HomeView;
	import com.fashionapp.views.LoginView;
	import com.fashionapp.views.MainMenuView;
	import com.fashionapp.views.poups.Alert;
	import com.fashionapp.vo.LoginVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	

	public class LoginViewController extends BaseController
	{
		public var usernameValidator:Validator;
		public var passwordValidator:Validator;
		
		public function LoginViewController()
		{
			super();
		}
		
		public function creationCompleteHandler():void 
		{
			usernameValidator = new Validator();
			passwordValidator = new Validator();
			
			usernameValidator.source =  (view as LoginView).txt_username;
			passwordValidator.source =  (view as LoginView).txt_password;
			
			usernameValidator.property = "text";
			passwordValidator.property = "text";
			
			usernameValidator.required = true;
			passwordValidator.required = true;
			
			addListeners();	
		}
		
		private function startTimerForRecievingChats():void{
			var t:Timer = new Timer(5000);
			t.addEventListener(TimerEvent.TIMER,chatCheckHandler);
			t.start();
		}
		
		private function chatCheckHandler(event:TimerEvent):void{
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
			
			if(FlexGlobals.topLevelApplication.hasEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES)==false) {
				FlexGlobals.topLevelApplication.addEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES,chatMessagesForMeListRecieved,false,0,true);
			}
		}
		
		private function listenForNewMessage():void {
			checkNewMessageForMe();
		} 
		
		private function chatListRecieved(event:Event):void {
			startTimerForRecievingChats();
		}
		
		private function contactsRecieved(event:Event):void {
			BuyerAppModelLocator.getInstance().users.refresh();
		}
		
		private function chatMessagesForMeListRecieved(event:IntimateForNewChatMessagesForMeEvent):void {
			/*if(event.newChatMessages.length > 0) {
				//New chat messages are available		
				var newMessages:ArrayCollection = new ArrayCollection(event.newChatMessages.source);
				//intimate Views for new messages
				FlexGlobals.topLevelApplication.dispatchEvent(new Event("NEW_MESSAGES_ARRIVED",true));
			}*/
			FlexGlobals.topLevelApplication.dispatchEvent(new Event("NEW_MESSAGES_ARRIVED",true));
		}
		
		public function checkNewMessageForMe():void {
			
			var dc:DaoChat = new DaoChat();
			
			if(Network.checkInterNetAvailability() == true){
				trace('internet available');
			}else{
				dc.getChatsForMe();
			}
			//dc.getChatsForMe();
		}
		
		private function loginClickEventListener(event:LoginClickEvent):void
		{
			var ld:LoginData = new LoginData();
			ld = event.loginDataObject;
			if(ld.userName == (view as LoginView).txt_username.text){
				(view as LoginView).navigator.pushView(MainMenuView);
				var dc:DaoChat = new DaoChat();
				if(Network.checkInterNetAvailability() == true){
				}else{
					dc.getContactsFromDB();
				}
			}else{
				Alert.show(view as LoginView,"Please give correct username !");
			}
		}
		
		public function doLogin(username:String,password:String):void 
		{
			var dl:DaoLogin = new DaoLogin();
			//var file:File = File.applicationStorageDirectory;
			if(Network.checkInterNetAvailability() == true){
				var urlVariable:URLVariables  = new URLVariables;
				urlVariable.username = (view as LoginView).txt_username.text;
				urlVariable.password = (view as LoginView).txt_password.text;
				urlVariable.type = "buyer";
				Network.call_API(view as LoginView,"http://smarttees.biz/build/products.php",urlVariable,"post");
			}else{
				dl.getLoginDataFromDB((view as LoginView).txt_username.text);
			}
		}
		
	}
}