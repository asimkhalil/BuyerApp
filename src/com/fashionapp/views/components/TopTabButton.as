package com.fashionapp.views.components
{
	import com.fashionapp.skins.TopTabButtonSkin;
	import com.fashionapp.utils.BasicUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
	import spark.components.Button;
	import spark.components.Image;
	import spark.components.Label;
	
	public class TopTabButton extends Button
	{
		private var _icon:Class;
		
		[SkinPart(required="true")]
		public var iconImage:Image;
		
		public function TopTabButton()
		{
			super();
			this.setStyle("skinClass",TopTabButtonSkin);
			this.setStyle("fontSize",BasicUtil.getFontSize(30));
			this.addEventListener(FlexEvent.CREATION_COMPLETE,function(event:FlexEvent):void {
				iconImage.source = _icon;
			});
		}
		
		public function set icon(cls:Class):void {
			_icon = cls;
		}
	}
}