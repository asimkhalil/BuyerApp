package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.business.BuyerAppServiceLocator;
	import com.fashionapp.control.BuyerAppController;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.views.poups.Alert;
	import com.fashionapp.network.Network;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.tree.ext.PushNotification;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	public class BuyerAppViewController extends BaseController
	{
		private var _frontController : BuyerAppController;
		[Bindable]
		private var _model : BuyerAppModelLocator;
		
		public function BuyerAppViewController()
		{
			super();
			Network.startMonitor();
		}
		
		public function creationCompleteHandler() : void
		{
			view;
			new BuyerAppServiceLocator();
			_frontController = new BuyerAppController();
			_model = BuyerAppModelLocator.getInstance();
			
			init();
		}
		
		private var apn:PushNotification;
		public function init()
		{
			apn = new PushNotification();
			apn.init(this);
			
			toast("init apn()");
		}
	}
}