package com.fashionapp.controllers
{
	import com.fashionapp.DAO.DaoBrand;
	import com.fashionapp.model.BrandData;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	import com.fashionapp.views.BrandsView;
	import com.fashionapp.views.components.*;
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.collections.ArrayCollection;
	
	public class BrandViewController extends BaseController
	{
		private var dao:DaoBrand;
		
		public function BrandViewController()
		{
			super();
		}
		
		public function creationCompleteHandler():void 
		{
			//toast(Network.checkInterNetAvailability().toString());
			if(view is NewBrand)
			{
				view.addEventListener('backClicked',onBackClickHnd);	
				
				dao = new DaoBrand();			
			}
			else if(view is BrandsView)
			{
				if(FlexGlobals.topLevelApplication.hasEventListener("GET_BRAND")==false) {
					FlexGlobals.topLevelApplication.addEventListener("GET_BRAND",getBrandComplete,false,0,true);
				}
				
				dao = new DaoBrand();
				dao.getBrand();
				(view as BrandsView).list.dataProvider = BuyerAppModelLocator.getInstance().brand;
				
				// wait for GET_BRAND;
				/*
				var list:ArrayCollection = new ArrayCollection();
				list.addItem({title:"abc"});				
				list.addItem({title:"def"});	
				(view as BrandsView).list.dataProvider = list;
				*/
			}		
		}
		
		
		// Events
		public function getBrandComplete(e:FlexEvent) :void
		{			
			//refreshBrandList();
			(view as BrandsView).list.visible = true;
		}
		
		private function onBackClickHnd(e:FlexEvent):void
		{
			(view as NewBrand).navigator.popView();
		}
		
		public function refreshBrandList():void
		{
			return; 
			var list:ArrayCollection = new ArrayCollection();
			
			for each(var source:BrandData in BuyerAppModelLocator.getInstance().brand)
			{
				var obj:Object = new Object();				
				obj.id = source.id;
				obj.createdBy = source.createdBy;
				obj.createDate = source.createDate;
				obj.deptId = source.deptId;
				obj.lastUpdate = source.lastUpdate;
				obj.numProducts = source.numProducts;
				obj.seasonId = source.seasonId;
				obj.statusId = source.statusId;
				obj.title = source.title;				
				
				obj.dept = "";
				obj.season = "";
				var date:Array = source.createDate.split(" ");
				obj.date = source.createDate;
				
				list.addItem(obj);				
			}
			
			(view as BrandsView).list.dataProvider = list;
		}
		
		public function createBrand(brandName:String, seasonId:String, deptId:String):void
		{
			var createdDate:String = BasicUtil.convertToSQLTimeStamp(new Date());
			var brand:BrandData = new BrandData();
			brand.id = DBUtils.getUniqueID()+"";
			brand.title = brandName;
			brand.seasonId = int(seasonId);
			brand.deptId = int(deptId);
			brand.createDate = brand.lastUpdate = createdDate;
			brand.createdBy = int(Network.user_id);
			brand.statusId = 100;
			
			dao.addBrand(brand);
			(view as NewBrand).navigator.popView();	
		}
	}
}