package com.fashionapp.util
{
	
	import com.fashionapp.events.CameraEvent;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MediaEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.events.DynamicEvent;
	import mx.graphics.codec.JPEGEncoder;
	
	[Event(name="fileReady", type="events.CameraEvent")]
	public class CameraUtil extends EventDispatcher
	{
		protected var camera:CameraUI;
		protected var loader:Loader;
		public var file:File;
		
		public function CameraUtil()
		{
			if (CameraUI.isSupported)
			{
				camera = new CameraUI();
				camera.addEventListener(MediaEvent.COMPLETE, mediaEventComplete);
			}
		}
		
		public function takePicture():void
		{
			if (camera) {
				camera.launch(MediaType.IMAGE);
			}
		}
		
		protected function mediaEventComplete(event:MediaEvent):void
		{
			var mediaPromise:MediaPromise = event.data;
			if (mediaPromise.file == null)
			{
				// For iOS we need to load with a Loader first
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleted);
				loader.loadFilePromise(mediaPromise);
				
				//FlexGlobals.topLevelApplication.dispatchEvent(new Event("111111"));
			}
			else
			{
				// Android we can just dispatch the event that it's complete
				file = new File(mediaPromise.file.url);
				dispatchEvent(new CameraEvent(CameraEvent.FILE_READY, file)); 
			}
		}
		
		protected function loaderCompleted(event:Event):void
		{			
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			if (CameraRoll.supportsAddBitmapData)
			{
				var mpLoaderInfo:LoaderInfo = event.target as LoaderInfo;
				
				/// Here was the solution
				
				var bitmapDataA:BitmapData = new BitmapData(mpLoaderInfo.width, mpLoaderInfo.height);
				bitmapDataA.draw(mpLoaderInfo.content,null,null,null,null,true);  
				
				/// I had to cast the loaderInfo as BitmapData 					
				//var bitmapDataB:BitmapData = resizeimage(bitmapDataA, int(mpLoaderInfo.width / 4), int(mpLoaderInfo.height/ 4));  // function to shrink the image

				var c:CameraRoll = new CameraRoll();
				c.addBitmapData(bitmapDataA);
				
				var now:Date = new Date();
				var f:File = File.applicationStorageDirectory.resolvePath("img" + now.seconds + now.minutes + ".jpg");                                    
				var stream:FileStream = new FileStream()
				stream.open(f, FileMode.WRITE);                                         
				
				// Then had to redraw and encode as a jpeg before writing the file
				var bytes:ByteArray = new ByteArray();
				bytes = bitmapDataA.encode(new Rectangle(0,0, int(mpLoaderInfo.width / 4) , int(mpLoaderInfo.height / 4)), new JPEGEncoderOptions(80), bytes);
				
				stream.writeBytes(bytes,0,bytes.bytesAvailable);
				stream.close(); 
				
				dispatchEvent(new CameraEvent(CameraEvent.FILE_READY, f)); 
				
				/*
				var bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height);
				bitmapData.draw(loaderInfo.loader);  
				file = File.applicationStorageDirectory.resolvePath("receipt" + new Date().time + ".jpg");     
				
				var stream:FileStream = new FileStream()
				stream.open(file, FileMode.WRITE);
				var j:JPEGEncoder = new JPEGEncoder();
				var bytes:ByteArray = j.encode(bitmapData);
				
				FlexGlobals.topLevelApplication.dispatchEvent(new Event("222222"));
				return;
				
				
				stream.writeBytes(bytes,0,bytes.bytesAvailable);
				stream.close(); 
				dispatchEvent(new CameraEvent(CameraEvent.FILE_READY, file)); 
				*/
			}
		}
	}
}