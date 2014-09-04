package com.fashionapp.skins
{
	import mx.events.FlexEvent;
	
	import spark.skins.mobile.TextInputSkin;
	
	public class CustomTextInputSkin extends TextInputSkin
	{
		public function CustomTextInputSkin()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void 
		{
			this.border.visible = false;
			this.borderClass = null;
		}
	}
}