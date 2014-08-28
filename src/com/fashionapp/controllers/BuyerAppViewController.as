package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoChat;
	import com.fashionapp.business.BuyerAppServiceLocator;
	import com.fashionapp.control.BuyerAppController;
	import com.fashionapp.events.IntimateForNewChatMessagesForMeEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.network.Network;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
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
		}
		
		public function creationCompleteHandler() : void
		{
			view;
			new BuyerAppServiceLocator();
			_frontController = new BuyerAppController();
			_model = BuyerAppModelLocator.getInstance();
		}
	}
}