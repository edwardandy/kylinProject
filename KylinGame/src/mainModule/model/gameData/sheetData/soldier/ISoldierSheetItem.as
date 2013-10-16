package mainModule.model.gameData.sheetData.soldier
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseMoveFighterSheetItem;
	/**
	 * 士兵数值表项 
	 * @author Edward
	 * 
	 */
	public interface ISoldierSheetItem extends IBaseMoveFighterSheetItem
	{
		/**
		 * 名字和描述所使用的id 
		 */
		function get descId():int;
		/**
		 * 资源id 
		 */
		function get resId():int;
		/**
		 * 是否可召唤
		 */
		function get canSummon():Boolean;
		/**
		 * 复活时间
		 */
		function get rebirthTime():uint;
	}
}