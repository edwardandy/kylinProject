package mainModule.model.gameData.sheetData
{
	/**
	 * 数值表项的基本表示类 
	 * @author Edward
	 * 
	 */	
	public class BaseSheetItem
	{
		private var _configId:uint;
		
		public function BaseSheetItem()
		{
		}

		/**
		 * 唯一标识id 
		 */
		public function get configId():uint
		{
			return _configId;
		}

		/**
		 * @private
		 */
		public function set configId(value:uint):void
		{
			_configId = value;
		}

	}
}