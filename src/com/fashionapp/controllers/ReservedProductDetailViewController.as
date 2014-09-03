package com.fashionapp.controllers
{	
	import com.fashionapp.DAO.ReservedProductDetailsDAO;
	import com.fashionapp.events.ShowReservedProductDetailsDataEvent;
	import com.fashionapp.views.ReservedProductsDetailView;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class ReservedProductDetailViewController extends BaseController
	{
		public function ReservedProductDetailViewController()
		{
			super();
		}		
		public function creationCompleteHandler():void 
		{
			
			addListeners();
		}
		
		private function addListeners():void
		{
			if(FlexGlobals.topLevelApplication.hasEventListener('ShowReservedProductDetailsDataEvent')==false){
				FlexGlobals.topLevelApplication.addEventListener('ShowReservedProductDetailsDataEvent',showReservedProductDetailsDataEventListener,false,0,true);
			}			
		}
		private function showReservedProductDetailsDataEventListener(event:ShowReservedProductDetailsDataEvent):void
		{
			(view as ReservedProductsDetailView).showProductDetails(event.reservedProductDetailsData); 
		}
		public function getReservedProductDetailViewData(productID:String):void 
		{			
			var rpld:ReservedProductDetailsDAO = new ReservedProductDetailsDAO();
			rpld.getReservedProductDetailsFromDB(productID);
		}
		
		
	}
}