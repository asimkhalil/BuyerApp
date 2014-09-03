package com.fashionapp.controllers
{
	import assets.images.CustomViewWithBackButtonAndSubTitleNormalSkin;
	
	import com.fashionapp.DAO.*;
	import com.fashionapp.events.CameraEvent;
	import com.fashionapp.events.ImageSelectedEvent;
	import com.fashionapp.model.*;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.CameraUtil;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	import com.fashionapp.views.*;
	import com.fashionapp.views.components.*;
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	public class ProductViewController extends BaseController
	{
		private var dao:DaoProduct;
		private var cameraUtil:CameraUtil;
		
		public function ProductViewController() 
		{
			super();
		}
		
		public function creationCompleteHandler():void 
		{
			
			//toast(Network.checkInterNetAvailability().toString());
			if(view is TakeNewPhotoView)
			{
				//view.addEventListener('backClicked',onBackClickHnd);
				//dao = new DaoBrand();
				cameraUtil = new CameraUtil();
				cameraUtil.addEventListener(CameraEvent.FILE_READY,fileReadyHandler);				
			}
			else if(view is BrandProductsView)
			{			
				((view as BrandProductsView).skin as CustomViewWithBackButtonAndSubTitleNormalSkin).subTitle.text = "FALL 2000 | WOMEN";
				(view as BrandProductsView).title = "ALEXENDER MCQUEEN";				
				
				if(FlexGlobals.topLevelApplication.hasEventListener("GET_PRODUCT")==false) {
					FlexGlobals.topLevelApplication.addEventListener("GET_PRODUCT",getProductComplete,false,0,true);
				}
				dao = new DaoProduct();
				dao.getBrandProduct("1");
				(view as BrandProductsView).list_product.dataProvider = BuyerAppModelLocator.getInstance().product;
				
				//if(FlexGlobals.topLevelApplication.hasEventListener("GET_BRAND")==false) {
				//	FlexGlobals.topLevelApplication.addEventListener("GET_BRAND",getBrandComplete,false,0,true);
				//}
				
				//dao = new DaoBrand();
				//dao.getBrand();
				//(view as BrandsView).list.dataProvider = BuyerAppModelLocator.getInstance().brand;
				
				// wait for GET_BRAND;
			}		
		}
		
		// Events		
		private function fileReadyHandler(event:CameraEvent):void {
			
			//FlexGlobals.topLevelApplication.dispatchEvent(new ImageSelectedEvent(ImageSelectedEvent.IMAGE_SELECTED,event.file.data));

			var createdDate:String = BasicUtil.convertToSQLTimeStamp(new Date());
			var productID:String = DBUtils.getUniqueID()+"";
			
			var product:ProductData = new ProductData();
			product.id = productID;
			product.imageversion = 1; 
			product.brandID = "1";
			
			product.statusID = 100;
			product.createDate = product.lastUpdate = createdDate;
			product.createdBy = int(Network.user_id);
			
			var imageFile:File = event.file;
			var destination:File = File.applicationStorageDirectory.resolvePath(Utils.image_path+"brand/"+product.id+"-"+product.imageversion+".jpg");
			
			try  
			{
				imageFile.moveTo(destination, true);
			}
			catch (error:Error)
			{
				trace("Error:" + error.message);
			}
			dao.addProduct(product);
			
			(view as TakeNewPhotoView).navigator.popView();
		}
		
		// Function 
		public function takePhoto()
		{
			cameraUtil.takePicture();			
		}
		
		public function getProductComplete(e:Event)
		{
			(view as BrandProductsView).list_product.visible = true;
			//toast("getProductComplete " + (view as BrandProductsView).list_product.dataProvider.length);
			for each(var source:ProductData in BuyerAppModelLocator.getInstance().product)
			{ 
				toast("ID :" + source.path.substr(50,100));
			}
		}
	}
}