package com.fashionapp.model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.model.IModelLocator;
	import com.fashionapp.vo.LoginVO;
	
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class BuyerAppModelLocator implements IModelLocator
	{
		private static var _instance : BuyerAppModelLocator;
		
		public static function getInstance() : BuyerAppModelLocator
		{
			if ( _instance == null )
			{
				_instance = new BuyerAppModelLocator();
			}
			return _instance;
		}
		
		[Bindable]
		public var loginData:LoginData;
		
		[Bindable]
		public var users:ArrayCollection = new ArrayCollection();
		
		//update by mark
		[Bindable]
		public var brand:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var product:ArrayCollection = new ArrayCollection();
		//end
		
		[Bindable]
		public var usersBuyer:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var usersStaff:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var usersVip:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var chats:ArrayCollection = new ArrayCollection();
		
		public var chatCollection:Array = new Array();
		
		[Bindable]
		public var chatMessagesForMe:ArrayCollection = new ArrayCollection();
		
		
		public var chat:ChatData;
		public var recordsToBeSync:Array;
		public var currentIndex:int = 0;
		
		public var dbConn:SQLConnection;
		public var dataFile:File  = new File();
		
		public function FlexcasterModelLocator()
		{
			if ( _instance != null )
			{
				throw new CairngormError(
					CairngormMessageCodes.SINGLETON_EXCEPTION, "BuyerAppModelLocator" );
			}
			_instance = this;
		}
	}
}