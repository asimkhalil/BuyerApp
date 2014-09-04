package com.fashionapp.controllers
{
	import flash.display.DisplayObject;
	import com.fashionapp.network.Network;
	import com.fashionapp.views.poups.Alert;
	import com.tree.ext.*;
	
	//import com.tree.ane.Message.MessageQueue;
	//import com.tree.ane.Event.LogEvent;;
	
	public class BaseController
	{
		public var view:DisplayObject;
			
		public function BaseController()
		{
			
		}
		
		//private var _controller:MessageQueue;
		public function toast(message:String) : void
		{
//			try
//			{		
//				_controller = MessageQueue.instance;
//				if (!_controller.hasEventListener(LogEvent.ADDED))
//					_controller.addEventListener(LogEvent.ADDED, getLog);
//				
//				_controller.push(message);
//			}
//			catch(e:Error)
//			{
				Alert.show(view, message );
			//}
		}
		//private function getLog(e:LogEvent) : void
		//{
			// nothing to response
		//}

	}
}