package mainModule.model.gameData.sheetData.groundEff
{
	/**
	 * 地表特效动态项 
	 * @author Edward
	 * 
	 */
	public interface IGroundEffSheetItem
	{
		/**
		 * 影响范围
		 */
		function get range():int;
		/**
		 * 是否对空 0：只对地  1：对地对空 2:只对空
		 */
		function get canAirFight():int;
		/**
		 * 格式字段数组
		 */
		function get modeFields():Array;
	}
}