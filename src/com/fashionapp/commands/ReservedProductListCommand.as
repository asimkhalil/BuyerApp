package com.fashionapp.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.fashionapp.delegate.BuyerAppDelegate;
	import com.fashionapp.delegate.ReservedProductListDelegate;
	import com.fashionapp.events.LoginEvent;
	import com.fashionapp.model.BuyerAppModelLocator;
	import com.fashionapp.views.poups.Alert;
	import com.fashionapp.vo.LoginVO;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	
	public class ReservedProductListCommand implements ICommand, IResponder
	{
		private var _model : BuyerAppModelLocator = BuyerAppModelLocator.getInstance();
		
		public function execute( event : CairngormEvent ) : void
		{			
				var delegate : ReservedProductListDelegate = new ReservedProductListDelegate();
				
				
				var token : AsyncToken = delegate.send( "" );
				token.addResponder( this );				
		}
		
		public function result( event : Object ) : void
		{
			// populate data in model locator
			trace("Populate List  successfull!");
		}
		
		public function fault( event : Object ) : void
		{
			trace("Populate List unsuccessfull!");
		}
	}
}