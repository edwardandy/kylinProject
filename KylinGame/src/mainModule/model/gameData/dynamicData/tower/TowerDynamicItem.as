package mainModule.model.gameData.dynamicData.tower
{
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;

	/**
	 * 防御塔动态项 
	 * @author Edward
	 * 
	 */	
	public class TowerDynamicItem extends BaseDynamicItem implements ITowerDynamicItem
	{
		private var _arrSkills:Array = [];
		
		public function set skills(str:String):void
		{
			_arrSkills = [];
			if(!str)
				return;
			_arrSkills = KylinStringUtil.splitStringArrayToIntArray(str);
		}
		/**
		 * @inheritDoc
		 */		
		public function get arrSkills():Array
		{
			return _arrSkills;
		}
		
		public function TowerDynamicItem()
		{
			super();
		}
	}
}