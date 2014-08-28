package com.fashionapp.model
{
	[Bindable]
	public class LoginData
	{
		private var _id:int = 0;
		private var _userName:String = "";
		private var _fullName:String = "";
		private var _tel:String = "";
		private var _email:String = "";
		private var _code:String = "";
		private var _status:String = "";

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			_status = value;
		}

		public function get code():String
		{
			return _code;
		}

		public function set code(value:String):void
		{
			_code = value;
		}

		public function get email():String
		{
			return _email;
		}

		public function set email(value:String):void
		{
			_email = value;
		}

		public function get tel():String
		{
			return _tel;
		}

		public function set tel(value:String):void
		{
			_tel = value;
		}

		public function get fullName():String
		{
			return _fullName;
		}

		public function set fullName(value:String):void
		{
			_fullName = value;
		}

		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

	}
}