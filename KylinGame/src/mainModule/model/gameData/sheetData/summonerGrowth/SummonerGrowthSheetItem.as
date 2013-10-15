package mainModule.model.gameData.sheetData.summonerGrowth
{
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;
	
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * 召唤物成长数值项 
	 * @author Edward
	 * 
	 */	
	public class SummonerGrowthSheetItem extends BaseDescSheetItem implements ISummonerGrowthSheetItem
	{
		public var summon_12108:uint;
		public var summon_12174:uint;
		public var summon_12175:uint;
		public var summon_12110:uint;
		public var summon_12176:uint;
		public var summon_12177:uint;
		public var summon_12118:uint;
		
		[Inject]
		public var logger:ILogger;
		
		public function SummonerGrowthSheetItem()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */		
		public function getSummonerGrowthById(summonerId:uint):uint
		{
			if(this.hasOwnProperty("summon_"+summonerId))
				return this["summon_"+summonerId];
			logger.error("summoner has not growth,id:{0}",[summonerId]);
			return 0;
		}
	}
}