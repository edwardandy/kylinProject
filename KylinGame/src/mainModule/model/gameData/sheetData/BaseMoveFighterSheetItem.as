package mainModule.model.gameData.sheetData
{
	/**
	 * 可移动的战斗单位 
	 * @author Edward
	 * 
	 */	
	public class BaseMoveFighterSheetItem extends BaseFighterSheetItem
	{
		/**
		 * 血量
		 */
		public var life:uint;
		/**
		 *物理防御力 
		 */
		public var physicDef:int;
		/**
		 *法术防御力 
		 */
		public var magicDef:int;
		/**
		 * 移动速度
		 */
		public var moveSpd:uint;
		/**
		 * 单位类型 1:陆地 2:空中飞行单位
		 */		
		public var type:int;
		
		public function BaseMoveFighterSheetItem()
		{
			super();
		}
	}
}