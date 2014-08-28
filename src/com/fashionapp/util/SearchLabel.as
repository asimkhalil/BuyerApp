package com.fashionapp.util
{
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	public class SearchLabel
	{
		public function SearchLabel()
		{
		}
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
		/**
		 * This static method used to search data from an array and return its label 
		 * @author Usman Ashraf
		 * @param data:String data that you want to search
		 * @param array:ArrayCollection is an array in which data is search
		 * @return String Label of specific data
		 */
		public static function getLabel(data:String,array:ArrayCollection):String
		{
			try
			{
				if(data==null)
				{
					return '';
				}
		        for(var i:int=0;i<array.length;i++)
		        {
			         if(array[i].data==data)
			         {
		    	      	return array[i].label;
		        	 }
		        }
			}catch(e:Error){trace('--->Error in SearchLabel getLabel() : '+ObjectUtil.toString(e));}	
	        return data;
		}
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
		/**
		 * This method used to search label from an array and return its data 
		 * @author Usman Ashraf
		 * @param label:String label that you want to search
		 * @param array:ArrayCollection is an array in which data is search
		 * @return String Data of specific label
		 */
		public function getData(label:String,arrayCollect:ArrayCollection):String
		{
			try
			{
		        for(var i:int=0;i<arrayCollect.length;i++)
		        {
			         if(arrayCollect[i].label==label)
			         {
		    	      	return arrayCollect[i].data;
		        	 }
		        }
			}catch(e:Error){trace('--->Error in SearchLabel getData() : '+ObjectUtil.toString(e));}		
	        return label;
		}
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
		/**
		 * This static method used to search data from an array and return its label2 
		 * @author Usman Ashraf
		 * @param data:String data that you want to search
		 * @param array:ArrayCollection is an array in which data is search
		 * @return String Label2 of specific data
		 */
		public function getLabel2(data:String,arrayCollect:ArrayCollection):String
		{
			try
			{
				for(var i:int=0;i<arrayCollect.length;i++)
				{
					if(arrayCollect[i].data==data)
					{
						return arrayCollect[i].label2;
					}
				}
			}catch(e:Error){trace('--->Error in SearchLabel getLabel2() : '+ObjectUtil.toString(e));}			
			return "";
		}
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
		/**
		 * This static method used to search data from an array and return its label1 
		 * @author Usman Ashraf
		 * @param data:String data that you want to search
		 * @param array:ArrayCollection is an array in which data is search
		 * @return String Label1 of specific data
		 */
		public function getLabel1(data:String,arrayCollect:ArrayCollection):String
		{
			try
			{
				for(var i:int=0;i<arrayCollect.length;i++)
				{
					if(arrayCollect[i].label2==data)//LoginName Comparison 
					{
						return arrayCollect[i].label1;//ServiceProviderType [00050/00060]
					}
				}
			}catch(e:Error){trace('--->Error in SearchLabel getLabel1() : '+ObjectUtil.toString(e));}			
			return "";
		}
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
	}
}
