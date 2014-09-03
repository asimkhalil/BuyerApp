package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.events.ImageSelectedEvent;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.network.Network;
	import com.fashionapp.renderers.FromMessageRenderer;
	import com.fashionapp.renderers.ToMessageRenderer;
	import com.fashionapp.util.Base64;
	import com.fashionapp.views.CurrentChatView;
	
	import flash.net.URLVariables;
	
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
			
			FlexGlobals.topLevelApplication.addEventListener(ImageSelectedEvent.IMAGE_SELECTED,onImageSelected);
		}
		
		private function onImageSelected(event:ImageSelectedEvent):void {
			event.imagebytes;
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
		
		private function chatMessagesRecieved(event:Event):void {
			var currentChat:CurrentChatView = (view as CurrentChatView);
			if(BuyerAppModelLocator.getInstance().chatCollection[currentChat.chat.toUserId]){
				var c:ArrayCollection = BuyerAppModelLocator.getInstance().chatCollection[currentChat.chat.toUserId];
				if(c.length > localChatCollection.length){
					for(var i:int = localChatCollection.length ; i < c.length ; i++){
						var chatObj:ChatData = c.getItemAt(i) as ChatData;
						if(chatObj.type == "text" || chatObj.type == "image") {
							if(chatObj.toUserId == BuyerAppModelLocator.getInstance().loginData.id){
								var toMsg:ToMessageRenderer = new ToMessageRenderer();
								currentChat.chatBox.addElement(toMsg);
								toMsg.txtMsg.text = chatObj.content;
								if(chatObj.type == "image") {
									toMsg.image_photo.source = Base64.decodeToByteArray(chatObj.content);
								}
								toMsg.chat  = chatObj;
								toMsg.name = chatObj.id;
							}else{
								var fromMsg:FromMessageRenderer = new FromMessageRenderer();
								currentChat.chatBox.addElement(fromMsg);
								fromMsg.txtMsg.text = chatObj.content;
								if(chatObj.type == "image") {
									fromMsg.image_photo.source = Base64.decodeToByteArray(chatObj.content);
								}
								fromMsg.chat = chatObj;
								fromMsg.name = chatObj.id;
							}
						}
						localChatCollection.addItem(chatObj);
					}
					//localChatCollection = c;
				}
				for(var j:int = 0; j < c.length ; j++){
					var ch:ChatData = c.getItemAt(j) as ChatData
					if(ch.type == "delete"){
						try{
							for(var d:int = 0 ; d < currentChat.chatBox.numElements ; d++){
								if(currentChat.chatBox.getElementAt(d) is ToMessageRenderer){
									if((currentChat.chatBox.getElementAt(d) as ToMessageRenderer).name == ch.id){
										currentChat.chatBox.removeElementAt(d);
										d--;
									}
								}else if(currentChat.chatBox.getElementAt(d) is FromMessageRenderer){
									if((currentChat.chatBox.getElementAt(d) as FromMessageRenderer).name == ch.id){
										currentChat.chatBox.removeElementAt(d);
										d--;
									}
								}
							}
						}catch(e:Error){
						
						}
					}
				}
			}
		}
		
		public function send(chat:ChatData):void{
			var dc:DaoChat = new DaoChat();
			if(Network.checkInterNetAvailability() == true) {
				trace('internet available');
				dc.sendChat(chat);
			}else{
				dc.sendChat(chat);
			}
			
			// for testing
			//dc.sendChat(chat);
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