package mainModule.model.gameData.sheetData.interfaces
{
	/**
	 * 可移动的战斗单位 
	 * @author Edward
	 * 
	 */
	public interface IBaseMoveFighterSheetItem extends IBaseFighterSheetItem
	{
		/**
		 * 单位类型 1:陆地 2:空中飞行单位
		 */
		function get type():int;
		/**
		 * 移动速度
		 */
		function get moveSpd():uint;
		/**
		 *法术防御力 
		 */
		function get magicDef():int;
		/**
		 *物理防御力 
		 */
		function get physicDef():int;
		/**
		 * 血量
		 */
		function get life():uint;
	}
}