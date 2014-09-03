package com.fashionapp.delegate
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ReservedProductListDelegate
	{
		private var _locator : ServiceLocator = ServiceLocator.getInstance();
		
		private var _service : HTTPService;
		
		private var _token : AsyncToken;
		
		public function send( url : String ) : AsyncToken
		{
			_service = _locator.getHTTPService( "ReservedProductListService" );
			_service.url = url;
			var localResponder : Responder = new Responder( success, fail );
			var token : AsyncToken = _service.send();
			token.addResponder( localResponder );
			_token = new AsyncToken( token.message );
			return _token;
		}
		
		private function success( event : ResultEvent ) : void
		{
			var result:Object = {};
			var resultEvent : ResultEvent = new ResultEvent( ResultEvent.RESULT, false, true, result, _token );
			for each ( var responder : IResponder in _token.responders )
			{
				responder.result( resultEvent );
			}
		}
		
		private function fail( event : FaultEvent ) : void
		{
			for each ( var responder : IResponder in _token.responders )
			{
				responder.fault( event );
			}
		}
	}
}