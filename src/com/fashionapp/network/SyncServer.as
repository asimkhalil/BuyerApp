package com.fashionapp.network
{
	import com.adobe.serialization.jsonv2.JSON;
	import com.fashionapp.events.APIEvent;
	import flash.display.DisplayObject;
	
	public class SyncServer
	{
		private var uploading:Boolean = false;
		private var downloading:Boolean = false;
		private static var objParent:DisplayObject;
		
		public function SyncServer()
		{
			
		}
		
		private static function updateServer(parentObj:DisplayObject,table:String):void{
			/*
			if there is network, 
			select * from table where lastUpdate > lastSync
			foreach row
			send to the server
			update table set lastSync = now where id = row.id
			end
			*/
			this.uploading = true;
			this.addEventListener(APIEvent.API_COMPLETE, uploadComplete);
			this.addEventListener(APIEvent.API_ERROR, uploadError);
			
			switch (table)
			{
				case "chat":
					//do whatever you need 	
					//Network.call_API(.....)
					//handle the data
				
			}
				
		}
		
		private static function updatedbfromserver(parentObj:DisplayObject,table:String):void{
			/*
			if there is network, 
			select top 1 lastSync from table order by lastSync asc
			
			use this lastSync to check the server data
			end
			*/
			this.downloading = true;
			this.addEventListener(APIEvent.API_COMPLETE, downloadComplete);
			this.addEventListener(APIEvent.API_ERROR, downloadError);
			
			
			switch (table)
			{
				case "chat":
					//do whatever you need 	
					//Network.call_API(.....)
					//handle the data
					
			}
		}
		
		public function uploadComplete(e:APIEvent):void 
		{
			uploading = false;
			objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, "OK"));
		}
		
		public function downloadComplete(e:APIEvent):void 
		{
			downloading = false;
			objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, "OK"));
			
		}
		
		public function uploadError(e:APIEvent):void 
		{
			uploading = false;
			objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, "FAIL"));
		}
		
		public function downloadError(e:APIEvent):void 
		{
			downloading = false;
			objParent.dispatchEvent(new APIEvent(APIEvent.API_COMPLETE, "FAIL"));	
		}
	}
	
}