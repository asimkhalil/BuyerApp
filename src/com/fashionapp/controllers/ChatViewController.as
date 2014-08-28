package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.network.Network;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class ChatViewController extends BaseController
	{
		public function ChatViewController()
		{
			super();
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