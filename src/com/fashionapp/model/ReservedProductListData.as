package com.fashionapp.model
{
	import com.adobe.cairngorm.model.IModelLocator;
	
	import mx.collections.ArrayCollection;

	public class ReservedProductListData implements IModelLocator
	{
		private static var _instance : ReservedProductListData;
		
		public static function getInstance() : ReservedProductListData
		{
			if ( _instance == null )
			{
				_instance = new ReservedProductListData();
			}
			return _instance;
		}
		
		private var _reservedProductList:ArrayCollection;
		public function get reservedProductList():ArrayCollection {
			return _reservedProductList;
		}
		public function set reservedProductList(value:ArrayCollection):void
		{
			_reservedProductList = value;
		}
		
	}
}