package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.model.LoginData;
	import com.fashionapp.network.Network;
	import com.fashionapp.views.ChatView;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import spark.events.TextOperationEvent;

	public class ChatViewController extends BaseController
	{
		public function ChatViewController()
		{
			super();
		}
		
		public function search_changeHandler(event:TextOperationEvent):void
		{
			BuyerAppModelLocator.getInstance().usersBuyer.filterFunction = filterChatContacts;
			BuyerAppModelLocator.getInstance().usersBuyer.refresh();
			
			BuyerAppModelLocator.getInstance().usersStaff.filterFunction = filterChatContacts;
			BuyerAppModelLocator.getInstance().usersStaff.refresh();
			
			BuyerAppModelLocator.getInstance().usersVip.filterFunction = filterChatContacts;
			BuyerAppModelLocator.getInstance().usersVip.refresh();
		}
		
		private function filterChatContacts(item:Object):Boolean 
		{
			if(String(item.fullName).toLowerCase().indexOf((view as ChatView).txt_search.text.toLowerCase()) >= 0) 
			{
				return true;
			}
			return false;
		}
		
		public function filterChatMsgs():void{
			new DaoChat().getRecordsNeededToSyncOnLiveServer('Chat');
			var chatList:ArrayCollection = new ArrayCollection();
			for each(var chats:ArrayCollection in BuyerAppModelLocator.getInstance().chatCollection){
				var chat:ChatData = chats.getItemAt(chats.length-1) as ChatData;
				if(chat.createdBy != BuyerAppModelLocator.getInstance().loginData.id){
					for each(var login:LoginData in BuyerAppModelLocator.getInstance().users){
						if(login.id == chat.createdBy){
							var obj:Object = new Object();
							obj.name = login.fullName;
							obj.message = chat.content;
							obj.type = chat.type;
							obj.time = chat.createDate;
							obj.id = chat.toUserId;
							chatList.addItem(obj);
						}
					}
				}else{
					for each(var login1:LoginData in BuyerAppModelLocator.getInstance().users){
						if(login1.id == chat.toUserId){
							var obj1:Object = new Object();
							obj1.name = login1.fullName;
							obj1.message = chat.content;
							obj1.type = chat.type;
							obj1.time = chat.createDate;
							obj1.id = chat.createdBy;
							chatList.addItem(obj1);
						}
					}
				}
			}
			
			(view as ChatView).chatList.dataProvider = chatList;
			
			(view as ChatView).chatList.visible = true;
		}
		public function creationCompleteHandler():void 
		{
			/*addListeners();*/
			/*var dc:DaoChat = new DaoChat();
			if(Network.checkInterNetAvailability() == true){
			}else{
				dc.getContactsFromDB();
			}
			// for testing
			dc.getContactsFromDB();*/
		}
		
		
		/*private function listenForNewMessage():void {
			checkNewMessageForMe();
		} */
		
		private function addListeners():void
		{
			/*if(FlexGlobals.topLevelApplication.hasEventListener('ContactListRecieved')==false) {
				FlexGlobals.topLevelApplication.addEventListener('ContactListRecieved',contactsRecieved,false,0,true);
			}
			
			if(FlexGlobals.topLevelApplication.hasEventListener('ChatListRecieved')==false) {
				FlexGlobals.topLevelApplication.addEventListener('ChatListRecieved',chatListRecieved,false,0,true);
			}
			
			if(FlexGlobals.topLevelApplication.hasEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES)==false) {
				FlexGlobals.topLevelApplication.addEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES,chatMessagesForMeListRecieved,false,0,true);
			}*/
		}
		
		/*private function chatMessagesForMeListRecieved(event:IntimateForNewChatMessagesForMeEvent):void {
			if(event.newChatMessages.length > 0) {
				//New chat messages are available		
				var newMessages:ArrayCollection = new ArrayCollection(event.newChatMessages.source);
				//intimate Views for new messages
				FlexGlobals.topLevelApplication.dispatchEvent(new Event("NEW_MESSAGES_ARRIVED",true));
			}
		}*/
		
		/*private function chatListRecieved(event:Event):void {
			setTimeout(listenForNewMessage,100000);
		}*/
		
		/*private function contactsRecieved(event:Event):void{
			BuyerAppModelLocator.getInstance().users.refresh();
		}*/
		
		/*public function send(chat:ChatData):void{
			var dc:DaoChat = new DaoChat();
			if(Network.checkInterNetAvailability() == true){
				trace('internet available');
			}else{
				dc.sendChat(chat);
			}
			
			// for testing
			dc.sendChat(chat);
		}*/
		
		/*public function checkNewMessageForMe():void {
			
			var dc:DaoChat = new DaoChat();
			
			if(Network.checkInterNetAvailability() == true){
				trace('internet available');
			}else{
				dc.getChatsForMe();
			}
		}*/
	}
}