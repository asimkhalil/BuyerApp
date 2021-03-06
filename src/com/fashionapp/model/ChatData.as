package com.fashionapp.model
{
	[Bindable]
	public class ChatData
	{
		public var id:String;
		public var toUserId:Number;
		public var type:String;
		public var content:String;
		public var statusId:Number;
		public var createdBy:Number;
		public var createDate:Date;
		public var lastUpdate:Date;
		public var lastSync:Date;
		//by jack
		public var toUserName:String;
	}
}