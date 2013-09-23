package mainModule.model.gameData.sheetData.soldier
{
	import mainModule.model.gameData.sheetData.BaseMoveFighterSheetItem;
	/**
	 * 士兵数值表项 
	 * @author Edward
	 * 
	 */	
	public class SoldierSheetItem extends BaseMoveFighterSheetItem
	{
		/**
		 * 复活时间
		 */
		public var rebirthTime:uint;
		/**
		 * 是否可召唤
		 */		
		public var canSummon:Boolean;
		/**
		 * 资源id 
		 */		
		public var resId:int;
		/**
		 * 名字和描述所使用的id 
		 */		
		public var descId:int;
		
		public function SoldierSheetItem()
		{
			super();
		}
	}
}