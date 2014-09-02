package com.fashionapp.controllers
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.DAO.DaoLogin;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.events.LoginClickEvent;
	import com.fashionapp.model.*;
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
		
	public class HomeViewController extends BaseController
	{
		
		public function HomeViewController()
		{
			super();
			
		}
		
		public function creationCompleteHandler():void 
		{
			toast('userID:'+BuyerAppModelLocator.getInstance().loginData.id);
			
			//upload all my data lastupdate > lastSync
			//upload Chat
			//upload Brand
			//upload Entity
			//upload uploadfile
			//upload photo
			
			//download all data from server
			//download chat
			//download Brand
			//download BrandDepartment
			//download BrandSeason
			//download Entity
			//download EntityGroup
			//download EntityDetails
			//download MasterKey
			//download reserveEntity
			//download shop
			//download status
			//download reserveStatus
			//download visitStatus
			//download staffCustomer
			//download UserGroup
			//download users
			//donwload photo
			//donwload DownloadFile
			
			
			var dc:DaoChat = new DaoChat();
			if(Network.checkInterNetAvailability() == true){
				//dc.getContactsFromDB();
			}else{
				//dc.getContactsFromDB();
			}
		}
		
	}
}