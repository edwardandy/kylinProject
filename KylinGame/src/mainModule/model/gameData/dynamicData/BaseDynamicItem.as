package mainModule.model.gameData.dynamicData
{
	import kylin.echo.edward.utilities.datastructures.FillObjectUtil;
	
	/**
	 * 动态数据基础项，比如每个英雄的动态数据，每个法术的动态数据 
	 * @author Edward
	 * 
	 */	
	public class BaseDynamicItem
	{
		private var _id:uint;
		
		public function BaseDynamicItem()
		{
		}
		
		/**
		 * 数据项的唯一id 
		 */
		public function get id():uint
		{
			return _id;
		}

		/**
		 * @private
		 */
		public function set id(value:uint):void
		{
			_id = value;
		}

		/**
		 * 填充更新自身数据 
		 * @param value
		 * 
		 */		
		public function beFilled(value:Object):void
		{
			FillObjectUtil.fillObj(this,value);
		}
	}
}