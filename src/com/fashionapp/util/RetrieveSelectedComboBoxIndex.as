package com.fashionapp.util
{
	import mx.utils.ObjectUtil;
	
	import spark.components.ComboBox;

	[Bindable]
	public class RetrieveSelectedComboBoxIndex
	{
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
		/**
		 * This method is used when select a specific value from combo 
		 * @author Usman Ashraf
		 * @param cmb:ComboBox in which you want to search a value
		 * @param selectedItemData:String the data you want to search
		 * @return int the index of combo
		 */
		public function retrieveSelCombIndex(selectedItemData:String, cmb:ComboBox):int
		{
			try
			{
				for(var i:int = 0; i < cmb.dataProvider.length; i++)
				{
					if( cmb.dataProvider[i].data == selectedItemData)
					{
						return i;
					}
				}
			}catch(e:Error){trace('--->Error in RetrieveSelectedComboBoxIndex retrieveSelCombIndex() : '+ObjectUtil.toString(e));}		
			return 0;
		}
		//☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺☺
	}
}