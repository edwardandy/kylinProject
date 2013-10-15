package mainModule.model.gameData.sheetData.summonerGrowth
{
	/**
	 * 召唤物成长数值项 
	 * @author Edward
	 * 
	 */
	public interface ISummonerGrowthSheetItem
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