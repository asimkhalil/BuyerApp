package com.fashionapp.model
{
	public class BrandData
	{
		public function BrandData()
		{
		}
		private var _title:String="";
		private var _seasonId:int=0;
		private var _deptId:int=0;
		private var _numProducts:int=0;
		private var _creatDate:Date=new Date();
		private var _lastUpdate:Date=new Date();
		
		public function get lastUpdate():Date
		{
			return _lastUpdate;
		}

		public function set lastUpdate(value:Date):void
		{
			_lastUpdate = value;
		}

		public function get creatDate():Date
		{
			return _creatDate;
		}

		public function set creatDate(value:Date):void
		{
			_creatDate = value;
		}

		public function get numProducts():int
		{
			return _numProducts;
		}

		public function set numProducts(value:int):void
		{
			_numProducts = value;
		}

		public function get deptId():int
		{
			return _deptId;
		}

		public function set deptId(value:int):void
		{
			_deptId = value;
		}

		public function get seasonId():int
		{
			return _seasonId;
		}

		public function set seasonId(value:int):void
		{
			_seasonId = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

	}
}