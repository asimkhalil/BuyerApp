package com.fashionapp.DAO
{
	import com.fashionapp.Parser.Parser;
	import com.fashionapp.events.APIEvent;
	import com.fashionapp.model.*;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.model.ChatData;
	import com.fashionapp.network.Network;
	import com.fashionapp.util.Utils;
	import com.fashionapp.utils.BasicUtil;
	import com.fashionapp.utils.DBUtils;
	import com.fashionapp.views.components.NewBrand;
	import com.fashionapp.views.poups.Alert;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.net.URLVariables;
	
	import mx.events.FlexEvent;
	import mx.core.FlexGlobals;
	
	public class DaoProduct
	{
		public function DaoProduct()
		{
		}
		
		var stmt1:SQLStatement;		
		public function addProduct(product:ProductData):void
		{			
			var stmt1:SQLStatement = new SQLStatement();
			stmt1.text = "INSERT INTO Entity(id, imageversion,brandID, statusID, createBy,createDate, lastUpdate) " +
							"VALUES('"+product.id+"','"+product.imageversion+"','"+product.brandID+"','"+product.statusID+"','"+product.createdBy+"','"+product.createDate+"','"+product.lastUpdate+"')";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, openHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();			
			
			BuyerAppModelLocator.getInstance().product.addItem(product);			
			BuyerAppModelLocator.getInstance().product.refresh();
		}
		public function getBrandProduct(brandID:String):void
		{
			stmt1 = new SQLStatement();
			stmt1.text = "SELECT x.*" +
						"FROM [Entity] x " +
						"WHERE x.brandID = '" + brandID+"'";
			stmt1.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			stmt1.addEventListener(SQLEvent.RESULT, getBrandHandler);
			stmt1.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			stmt1.execute();
		}
		private	function getBrandHandler(event:SQLEvent):void{
			var result:SQLResult = stmt1.getResult();
			Parser.parseProduct(result.data);
			//FlexGlobals.topLevelApplication.dispatchEvent(new FlexEvent('GET_PRODUCT',Parser.parseProduct(result.data)));
		}		
		
		private	function openHandler(event:SQLEvent):void{
		}
		private	function errorHandler(event:SQLErrorEvent):void{
		}
	}
}