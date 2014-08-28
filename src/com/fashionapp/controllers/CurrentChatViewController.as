package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.network.Network;
	import com.fashionapp.renderers.FromMessageRenderer;
	import com.fashionapp.renderers.ToMessageRenderer;
	import com.fashionapp.views.CurrentChatView;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class CurrentChatViewController extends BaseController
	{
		public function CurrentChatViewController()
		{
			super();
		}
		
		public function creationCompleteHandler():void 
		{
			addListeners();
		}
		
		private var localChatCollection:ArrayCollection = new ArrayCollection();
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
			}*/
			
			/*if(FlexGlobals.topLevelApplication.hasEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES)==false) {
				FlexGlobals.topLevelApplication.addEventListener(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES,chatMessagesForMeListRecieved,false,0,true);
			}*/
			
			FlexGlobals.topLevelApplication.addEventListener('NEW_MESSAGES_ARRIVED',chatMessagesRecieved);
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
		
		private function chatMessagesRecieved(event:Event):void{
			var currentChat:CurrentChatView = (view as CurrentChatView);
			if(BuyerAppModelLocator.getInstance().chatCollection[currentChat.chat.toUserId]){
				var c:ArrayCollection = BuyerAppModelLocator.getInstance().chatCollection[currentChat.chat.toUserId];
				if(c.length > localChatCollection.length){
					for(var i:int = localChatCollection.length ; i < c.length ; i++){
						var chatObj:ChatData = c.getItemAt(i) as ChatData;
						if(chatObj.toUserId == BuyerAppModelLocator.getInstance().loginData.id){
							var toMsg:ToMessageRenderer = new ToMessageRenderer();
							currentChat.chatBox.addElement(toMsg);
							toMsg.txtMsg.text = chatObj.content;
						}else{
							var fromMsg:FromMessageRenderer = new FromMessageRenderer();
							currentChat.chatBox.addElement(fromMsg);
							fromMsg.txtMsg.text = chatObj.content;
						}
						localChatCollection.addItem(chatObj);
					}
					//localChatCollection = c;
				}
			}
		}
		
		public function send(chat:ChatData):void{
			var dc:DaoChat = new DaoChat();
			if(Network.checkInterNetAvailability() == true){
				trace('internet available');
			}else{
				dc.sendChat(chat);
			}
			
			// for testing
			dc.sendChat(chat);
		}
		
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