package com.fashionapp.model
{
	[Bindable]
	public class EntityData
	{
		public var id:Number;
		public var caption:String;
		public var price:Number;
		public var remark:String;
		public var brandID:String;
		public var entityGroupID:Number;
		public var field1:String;
		public var field2:String;
		public var field3:String;
		public var field4:String;
		public var field5:String;
		public var statusId:Number;
		public var createBy:Number;
		public var createDate:Date;
		public var lastUpdate:Date;
		public var lastSync:Date;
		
		public var _entityDataList:Array;
		
		public function get EntityDataList():Array
		{
			_entityDataList
		}
		public function set EntityDataList(data:Array):void
		{
			_entityDataList = data;
		}
	}
}