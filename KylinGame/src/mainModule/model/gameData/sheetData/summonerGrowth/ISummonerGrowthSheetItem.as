package mainModule.model.gameData.sheetData.summonerGrowth
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;

	/**
	 * 召唤物成长数值项 
	 * @author Edward
	 * 
	 */
	public interface ISummonerGrowthSheetItem extends IBaseSheetItem
	{
		/**
		 * 通过被召唤物的id获得其hp成长 
		 * @param summonerId
		 * @return 
		 * 
		 */		
		function getSummonerGrowthById(summonerId:uint):uint;
	}
}