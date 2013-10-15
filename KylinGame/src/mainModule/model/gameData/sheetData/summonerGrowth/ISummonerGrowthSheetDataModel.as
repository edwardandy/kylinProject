package mainModule.model.gameData.sheetData.summonerGrowth
{
	/**
	 * 召唤物随塔或英雄等级增加的成长 
	 * @author Edward
	 * 
	 */
	public interface ISummonerGrowthSheetDataModel
	{
		/**
		 * 通过召唤者的等级获得被召唤物的成长数值项 
		 * @param lvl 召唤者的等级
		 * @return 
		 * 
		 */		
		function getSummonerGrowthByMasterLvl(lvl:int):ISummonerGrowthSheetItem;
	}
}