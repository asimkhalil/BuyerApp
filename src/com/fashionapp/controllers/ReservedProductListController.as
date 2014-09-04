package com.fashionapp.controllers
{
	import com.fashionapp.DAO.ReservedProductListDAO;
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.events.IntimateToLoadReservedProductListEvent;
	import com.fashionapp.events.ReservedProductListDataEvent;
	import com.fashionapp.model.ReservedProductListData;
	import com.fashionapp.network.Network;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.*;
	import com.fashionapp.views.ReservedProductsView;
	
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	

	public class ReservedProductListController extends BaseController
	{
		private var rpld:ReservedProductListDAO = new ReservedProductListDAO();
		public function ReservedProductListController()
		{
			super();
		}		
		public function creationCompleteHandler():void 
		{
			addListeners();			
		}
		private function addListeners():void
		{
			if(FlexGlobals.topLevelApplication.hasEventListener('ReservedProductListDataEvent')==false){
				FlexGlobals.topLevelApplication.addEventListener('ReservedProductListDataEvent',reservedProductListDataEventListener,false,0,true);
			}
			if(FlexGlobals.topLevelApplication.hasEventListener(IntimateToLoadReservedProductListEvent.INTIMATE_TO_LOAD_RESERVED_PRODUCT_LIST_EVENT)==false){
				FlexGlobals.topLevelApplication.addEventListener(IntimateToLoadReservedProductListEvent.INTIMATE_TO_LOAD_RESERVED_PRODUCT_LIST_EVENT,toLoadReservedProductListDataEventListener,false,0,true);
			}
			(view as ReservedProductsView).addEventListener(APIEvent.API_COMPLETE,getReservedProductDataFromServer);
			checkReservedProductListUpdate();
		}
		
		/**
		 * Update Server
		 * 
		 * */
		public function updateserver():void
		{
			
		}
		/**
		 *  Get Data From Server
		 * 
		 * */
		public function  getDataFromServer():Boolean
		{
			var status:Boolean = false;
			if(Network.checkInterNetAvailability() == true){
				var urlVariable:URLVariables  = new URLVariables;
				urlVariable.type = "buyer";
				urlVariable.last_update = DBUtils.getLastdownloadTime("ReserveEntity");
				Network.call_API(view as ReservedProductsView ,"reserved_product",urlVariable);
				status = true;
			}
			return status;
		}		
		
		private function reservedProductListDataEventListener(event:ReservedProductListDataEvent):void
		{
			var tempReservedProductListData:ArrayCollection =  ReservedProductListData.getInstance().reservedProductList; 
			(view as ReservedProductsView).menuList.dataProvider = event.reservedProductListData; 
		}
		private function toLoadReservedProductListDataEventListener(event:IntimateToLoadReservedProductListEvent):void
		{
			getReservedProductList();
		}
		private function getReservedProductDataFromServer(event:APIEvent):void
		{
			var tempReservedProductListData:Object = event.data;
			var tempDataList:Array = tempReservedProductListData.reserved_product;
			rpld.insertTheseValuesIntoDB(tempDataList);
		}
		
		public function checkReservedProductListUpdate():void
		{
			if(Network.checkInterNetAvailability() == true){
				getDataFromServer();
			}else{
				getReservedProductList();
			}
		}
		public function getReservedProductList():void 
		{			
			rpld.getReservedProductListFromDB();
		}
	}
}