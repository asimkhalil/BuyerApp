package com.fashionapp.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.fashionapp.delegate.BuyerAppDelegate;
	import com.fashionapp.events.LoginEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.vo.LoginVO;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	public class LoginCommand implements ICommand, IResponder
	{
		private var _model : BuyerAppModelLocator = BuyerAppModelLocator.getInstance();
		
		public function execute( event : CairngormEvent ) : void
		{
			var login : LoginVO = (event as LoginEvent).login;
			if ( login )
			{
				var delegate : BuyerAppDelegate = new BuyerAppDelegate();
				var token : AsyncToken = delegate.send( "" );// log in service url
				token.addResponder( this );	
			}
		}
		
		public function result( event : Object ) : void
		{
			// populate data in model locator
			trace("login successfull!");
		}
		
		public function fault( event : Object ) : void
		{
			trace("login unsuccessfull!");
		}
	}
}