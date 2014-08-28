package com.fashionapp.util
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	public class LookupUtil
	{
		public function LookupUtil()
		{
		}
		//♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥
		/**
		 * This static method used to convert service providers array to lookup array 
		 * @author Usman Ashraf
		 * @param serviceProviders:ArrayCollection containing service providers array
		 * @return ArrayCollection containing lookup service providers array
		 */
		public static function convertServiceProvider(serviceProviders:ArrayCollection):ArrayCollection
		{
			try
			{
				var lookupArray:ArrayCollection=new ArrayCollection();
				var lookup:LookupUtil;
				for(var x:int=0;x<serviceProviders.length;x++)
				{
					lookup=new LookupUtil();
					//lookup.data=serviceProviders.getItemAt(x).serviceProviderID;
					
					lookupArray.addItem(lookup); 
				}
			}catch(e:Error){trace('--->Error in LookupUtil convertServiceProvider() : '+ObjectUtil.toString(e));}	
			return lookupArray;
		}
	}
}