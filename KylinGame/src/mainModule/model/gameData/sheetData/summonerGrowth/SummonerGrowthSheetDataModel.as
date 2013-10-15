package mainModule.model.gameData.sheetData.summonerGrowth
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 召唤物随塔或英雄等级增加的成长 
	 * @author Edward
	 * 
	 */	
	public class SummonerGrowthSheetDataModel extends BaseSheetDataModel implements ISummonerGrowthSheetDataModel
	{
		public function SummonerGrowthSheetDataModel()
		{
			super();
			sheetName = "summonerGrowthSheetData";
			sheetClass = SummonerGrowthSheetItem;
		}
		/**
		 * @inheritDoc
		 */		
		public function getSummonerGrowthByMasterLvl(lvl:int):ISummonerGrowthSheetItem
		{
			return genSheetElement(lvl) as ISummonerGrowthSheetItem;
		}
	}
}