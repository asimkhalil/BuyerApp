package com.fashionapp.Parser
{
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.model.LoginData;
	
	import flash.data.SQLResult;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class Parser
	{
		/**
		* Parse login data
		*/
		public static function parseLoginData(results:SQLResult):LoginData{
			var ld:LoginData = new LoginData();
			var arrLoginData:Array =  results.data;
			
			ld.id = arrLoginData[0].groupID;
			ld.code = arrLoginData[0].code;
			ld.userName = arrLoginData[0].username;
			ld.fullName = arrLoginData[0].fullname;
			ld.email = arrLoginData[0].email;
			ld.tel = arrLoginData[0].tel;
			ld.status = arrLoginData[0].statusID;
			BuyerAppModelLocator.getInstance().loginData = ld;
			return ld;
		}
		
		
		public static function parseContactList(results:SQLResult):void{
			var arrLoginData:Array =  results.data;
			
			for(var i:int=0;i < arrLoginData.length; i++){
				var ld:LoginData = new LoginData();
				ld.id = arrLoginData[i].id;
				ld.code = arrLoginData[i].code;
				ld.userName = arrLoginData[i].username;
				ld.fullName = arrLoginData[i].fullname;
				ld.email = arrLoginData[i].email;
				ld.tel = arrLoginData[i].tel;
				ld.status = arrLoginData[i].statusID;
				if(ld.id != BuyerAppModelLocator.getInstance().loginData.id){
					BuyerAppModelLocator.getInstance().users.addItem(ld)
				}
			}
			FlexGlobals.topLevelApplication.dispatchEvent(new Event('ContactListRecieved',true));
		}
		
		
		public static function parseChatsList(results:SQLResult):void {
			var arrChats:Array =  results.data;
			
			for(var i:int=0;i < arrChats.length; i++){
				var chat:ChatData = new ChatData();
				chat.id = arrChats[i].id;
				chat.toUserId = arrChats[i].toUserID;
				chat.type = arrChats[i].type;
				chat.content = arrChats[i].content;
				chat.statusId = arrChats[i].statusID;
				chat.createdBy = arrChats[i].createdBy;
				chat.createDate = arrChats[i].createDate;
				chat.lastUpdate = arrChats[i].lastUpdate;
				chat.lastSync = arrChats[i].lastSync;
				
				BuyerAppModelLocator.getInstance().chats.addItem(chat);
			}
			FlexGlobals.topLevelApplication.dispatchEvent(new Event('ChatListRecieved',true));
		}
		
		private static function chatMessageAlreadyExists(id:String):Boolean {
			for each(var chat:ChatData in BuyerAppModelLocator.getInstance().chatMessagesForMe) {
				if(chat.id == id) {
					return true;
				}
			}
			return false;
		}
		
		public static function parseChatMessagesForMeList(results:SQLResult):void{
			var arrChats:Array =  results.data;
			
			var newChatMessagesForMe:ArrayCollection = new ArrayCollection();
			
			for(var i:int=0;i < arrChats.length; i++){
				var chat:ChatData = new ChatData();
				chat.id = arrChats[i].id;
				chat.toUserId = arrChats[i].toUserID;
				chat.type = arrChats[i].type;
				chat.content = arrChats[i].content;
				chat.statusId = arrChats[i].statusID;
				chat.createdBy = arrChats[i].createdBy;
				chat.createDate = arrChats[i].createDate;
				chat.lastUpdate = arrChats[i].lastUpdate;
				chat.lastSync = arrChats[i].lastSync;
				
				if(!chatMessageAlreadyExists(chat.id)) {
					BuyerAppModelLocator.getInstance().chatMessagesForMe.addItem(chat);
					newChatMessagesForMe.addItem(chat);
				}
			}
			FlexGlobals.topLevelApplication.dispatchEvent(new IntimateForNewChatMessagesForMeEvent(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES,newChatMessagesForMe,true));
		}
	}
}