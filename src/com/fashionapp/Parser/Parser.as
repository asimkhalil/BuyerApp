package com.fashionapp.Parser
{
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.*;
	import com.fashionapp.util.Utils;
	
	import flash.data.SQLResult;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;

	public class Parser
	{
		/**
		* Parse login data
		*/
		public static function parseLoginData(results:Array):LoginData{
			var ld:LoginData = new LoginData();
			var arrLoginData:Array =  results;
			
			ld.id = arrLoginData[0].id;
			ld.groupID = arrLoginData[0].groupid;
			ld.code = arrLoginData[0].code;
			ld.userName = arrLoginData[0].username;
			ld.fullName = arrLoginData[0].fullname;
			ld.email = arrLoginData[0].email;
			ld.tel = arrLoginData[0].tel;
			ld.status = arrLoginData[0].statusID;
			BuyerAppModelLocator.getInstance().loginData = ld;
			return ld;
		}
		
		/**
		 * Parse Reserved Product List data
		 */
		public static function parseReservedProductListData(data:Array):ArrayCollection{
			var tempArrayCollection:ArrayCollection = new ArrayCollection(data)
			ReservedProductListData.getInstance().reservedProductList = tempArrayCollection;
			return tempArrayCollection;
		}
		
		
		public static function parseContactList(results:Array):void {
			var arrLoginData:Array =  results;
			
			for(var i:int=0;i < arrLoginData.length; i++) {
				var ld:LoginData = new LoginData();
				ld.id = arrLoginData[i].id;
				ld.code = arrLoginData[i].code;
				ld.userName = arrLoginData[i].username;
				ld.fullName = arrLoginData[i].fullname;
				ld.email = arrLoginData[i].email;
				ld.tel = arrLoginData[i].tel;
				ld.status = arrLoginData[i].statusID;
				ld.groupID = Number(arrLoginData[i].group_id);
				if(ld.id != BuyerAppModelLocator.getInstance().loginData.id) {
					BuyerAppModelLocator.getInstance().users.addItem(ld)
				}
				
				if(ld.groupID == 1) {
					BuyerAppModelLocator.getInstance().usersBuyer.addItem(ld);
				}
				
				if(ld.groupID == 2) {
					BuyerAppModelLocator.getInstance().usersStaff.addItem(ld);
				}
				
				if(ld.groupID == 3) {
					BuyerAppModelLocator.getInstance().usersVip.addItem(ld);
				}
			}
			
			BuyerAppModelLocator.getInstance().usersBuyer.refresh();
			
			BuyerAppModelLocator.getInstance().usersStaff.refresh();
			
			BuyerAppModelLocator.getInstance().usersVip.refresh();
			
			FlexGlobals.topLevelApplication.dispatchEvent(new Event('ContactListRecieved',true));
		}

		//update by mark
		public static function parseBrand(results:Array):void 
		{
			BuyerAppModelLocator.getInstance().brand.removeAll();
			
			for(var i:int=0; i < results.length; i++) {
				var modeldata:BrandData = new BrandData();
				
				modeldata.id = results[i].id;
				modeldata.createdBy = results[i].fullname;
				modeldata.createDate = results[i].createDate;
				modeldata.deptId = results[i].deptId;
				modeldata.lastUpdate = results[i].lastUpdate;
				modeldata.numProducts = 0
				modeldata.seasonId = int(results[i].seasonId);
				modeldata.statusId = int(results[i].status);
				modeldata.title = results[i].name;
				
				modeldata.dept = results[i].dept;
				modeldata.season = results[i].season;
			
				BuyerAppModelLocator.getInstance().brand.addItem(modeldata);
			}
			
			BuyerAppModelLocator.getInstance().brand.refresh();
			
			FlexGlobals.topLevelApplication.dispatchEvent(new FlexEvent('GET_BRAND',true));
		}		
		public static function parseProduct(results:Array):void 
		{
			BuyerAppModelLocator.getInstance().product.removeAll();
			
			for(var i:int=0; i < results.length; i++) {
				var modeldata:ProductData = new ProductData();
				
				modeldata.id = results[i].id;
				modeldata.createdBy = results[i].createdBy;
				modeldata.createDate = results[i].createDate;				
				modeldata.lastUpdate = results[i].lastUpdate;
				modeldata.statusID = int(results[i].statusID);
				
				modeldata.imageversion = int(results[i].imageversion);	
				modeldata.entityGroupID = int(results[i].entityGroupID);	
				modeldata.caption = results[i].caption;
				modeldata.remark = results[i].remark;	
				modeldata.brandID = results[i].brandID;	
				
				modeldata.field1 = results[i].field1;
				modeldata.field2 = results[i].field2;
				modeldata.field3 = results[i].field3;
				modeldata.field4 = results[i].field4;
				modeldata.field5 = results[i].field5;
				
				var destination:File = File.applicationStorageDirectory.resolvePath(Utils.image_path+"brand/"+modeldata.id+"-"+modeldata.imageversion+".jpg");
				modeldata.path = destination.nativePath;
				
				BuyerAppModelLocator.getInstance().product.addItem(modeldata);
			}
			
			BuyerAppModelLocator.getInstance().product.refresh();
			
			FlexGlobals.topLevelApplication.dispatchEvent(new FlexEvent('GET_PRODUCT',true));
		}
		//end
		
		public static function parseChatsList(results:Array):void {
			var arrChats:Array =  results;
			if(arrChats){
				for(var i:int=0;i < arrChats.length; i++){
					var chat:ChatData = new ChatData();
					chat.id = arrChats[i].id;
					chat.toUserId = arrChats[i].to_user;
					chat.type = arrChats[i].type;
					chat.content = arrChats[i].content;
					chat.statusId = arrChats[i].status_id;
					chat.createdBy = arrChats[i].create_by;
					chat.createDate = new Date();
					chat.lastUpdate = new Date();
					chat.lastSync = new Date();
					
					BuyerAppModelLocator.getInstance().chats.addItem(chat);
					if(chat.toUserId == BuyerAppModelLocator.getInstance().loginData.id){
						if(BuyerAppModelLocator.getInstance().chatCollection[chat.createdBy] == null){
							var c:ArrayCollection = new ArrayCollection();
							c.addItem(chat);
							BuyerAppModelLocator.getInstance().chatCollection[chat.createdBy] = c;
						}else{
							(BuyerAppModelLocator.getInstance().chatCollection[chat.createdBy] as ArrayCollection).addItem(chat);
						}
					}else{
						if(BuyerAppModelLocator.getInstance().chatCollection[chat.toUserId] == null){
							var ch:ArrayCollection = new ArrayCollection();
							ch.addItem(chat);
							BuyerAppModelLocator.getInstance().chatCollection[chat.toUserId] = ch;
						}else{
							(BuyerAppModelLocator.getInstance().chatCollection[chat.toUserId] as ArrayCollection).addItem(chat);
						}
					}
				}
				FlexGlobals.topLevelApplication.dispatchEvent(new Event('ChatListRecieved',true));
			}
		}
		
		private static function chatMessageAlreadyExists(id:String):Boolean {
			for each(var chat:ChatData in BuyerAppModelLocator.getInstance().chats) {
				if(chat.id == id) {
					return true;
				}
			}
			return false;
		}
		
		public static function parseChatMessagesForMeList(results:Array):void{
			var arrChats:Array =  results;
			
			//var newChatMessagesForMe:ArrayCollection = new ArrayCollection();
			if(arrChats){
				for(var i:int=0;i < arrChats.length; i++){
					var chat:ChatData = new ChatData();
					chat.id = arrChats[i].id;
					chat.toUserId = arrChats[i].to_user;
					chat.type = arrChats[i].type;
					chat.content = arrChats[i].content;
					chat.statusId = arrChats[i].status_id;
					chat.createdBy = arrChats[i].create_by;
					chat.createDate = new Date();
					chat.lastUpdate = new Date();
					chat.lastSync = new Date();
					
					var userId:String;
					if(chat.toUserId == BuyerAppModelLocator.getInstance().loginData.id){
						userId = chat.createdBy.toString();
					}else{
						userId = chat.toUserId.toString();
					}
					
					if(!chatMessageAlreadyExists(chat.id)) {
						BuyerAppModelLocator.getInstance().chats.addItem(chat);
						
						//newChatMessagesForMe.addItem(chat);
						if(BuyerAppModelLocator.getInstance().chatCollection[userId] == null){
							var ch:ArrayCollection = new ArrayCollection();
							ch.addItem(chat);
							BuyerAppModelLocator.getInstance().chatCollection[userId] = ch;
						}else{
							(BuyerAppModelLocator.getInstance().chatCollection[userId] as ArrayCollection).addItem(chat);
						}
						
					}else if(chat.type == "delete"){
						var delArray:ArrayCollection = (BuyerAppModelLocator.getInstance().chatCollection[userId] as ArrayCollection);
						for(var j:int = 0 ; j < delArray.length ; j++){
							if((delArray.getItemAt(j) as ChatData).id == chat.id){
								(delArray.getItemAt(j) as ChatData).type = chat.type;
							}
						}
					}
					
				}
				FlexGlobals.topLevelApplication.dispatchEvent(new IntimateForNewChatMessagesForMeEvent(IntimateForNewChatMessagesForMeEvent.INTIMATE_FOR_NEW_MESSAGES,true));
			}
		}
	}
}