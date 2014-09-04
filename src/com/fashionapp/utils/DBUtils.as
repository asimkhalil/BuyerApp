package com.fashionapp.utils
{
	import com.fashionapp.network.Network;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import com.fashionapp.model.BuyerAppModelLocator;

	
	public class DBUtils
	{
		private var _sqlStatement:SQLStatement;

		public function DBUtils()
		{
		}
		
		public static function getUniqueID():String {
			
			var date:Date = new Date();
			var unix:int = date.time;
			
			return Network.app_key.toString() + "-" + unix.toString();
		}
		
		public static function getLastdownloadTime(tablename:String):String
		{
			var lastDownloadTime:String = null;
			var _sql:SQLStatement = new SQLStatement();
			_sql.text = "select DateTime(lastDownload.time) LastDownloadTime from lastDownload where lastDownload.tablename = '"+tablename+"'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				if (result.data !=null){
					lastDownloadTime = result.data[0].LastDownloadTime;
				}
			}
			
			if (lastDownloadTime ==null){
				_sql.text = "insert into lastDownload (tablename, time)VALUES('"+tablename+"','2014-01-01 00:00:00')";
				_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
				_sql.execute();
				lastDownloadTime = '2014-01-01 00:00:00';
			}
			return lastDownloadTime;			
		}		
		
		public static function updateLastdownloadTime(tablename:String):Boolean
		{
			var lastdownloadTimeUpdated:Boolean = false;
			var _sql:SQLStatement = new SQLStatement();
			var lastDownloadDateTime:String = BasicUtil.convertToSQLTimeStamp(new Date());
			_sql.text = "update lastDownload set time = '"+lastDownloadDateTime+"' where lastDownload.tablename = '"+tablename+"'";
			_sql.sqlConnection = BuyerAppModelLocator.getInstance().dbConn;
			_sql.execute();
			var result:SQLResult = _sql.getResult();
			if (result != null){
				lastdownloadTimeUpdated = true;
			}
			return lastdownloadTimeUpdated;			
		}

	}
}