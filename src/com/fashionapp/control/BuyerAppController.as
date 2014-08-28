package com.fashionapp.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.fashionapp.commands.LoginCommand;
	import com.fashionapp.events.LoginEvent;
	
	public class BuyerAppController extends FrontController
	{
		public function BuyerAppController()
		{
			super();
			addCommand( LoginEvent.LOGIN, LoginCommand );
		}
	}
}