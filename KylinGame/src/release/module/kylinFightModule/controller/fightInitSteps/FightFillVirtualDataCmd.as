package release.module.kylinFightModule.controller.fightInitSteps
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.dynamicData.interfaces.IDynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.sheetData.subwave.ISubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.wave.IWaveSheetDataModel;
	import mainModule.model.gameData.sheetData.subwave.SubwaveSheetItem;
	import mainModule.model.gameData.sheetData.tollgate.TollgateSheetItem;
	import mainModule.model.gameData.sheetData.wave.WaveSheetItem;

	/**
	 * 单机时根据配置表填充虚拟的战斗数据 
	 * @author Edward
	 * 
	 */	
	public class FightFillVirtualDataCmd extends KylinCommand
	{
		[Inject]
		public var dynamicDataMgr:IDynamicDataDictionaryModel;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var tollgateSheet:ITollgateSheetDataModel;
		[Inject]
		public var waveSheet:IWaveSheetDataModel;
		[Inject]
		public var subWaveSheet:ISubwaveSheetDataModel;
		
		public function FightFillVirtualDataCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			var dynamicData:Object = {};
			var fightObj:Object = {};
			dynamicData[DynamicDataNameConst.FightData] = fightObj;
			
			fightObj.tollgateId = "100110111";
			fightObj.fightId = "1111111";
			fightObj.dropItems = [];
			fightObj.dropItems[131124] = "10";
			fightObj.dropItems[131125] = "15";
			fightObj.initGoods = "100000";
			fightObj.monLifeScale = "1.5";
			fightObj.monAtkScale = "2.5";
			fightObj.newMonsterIds = ["141001","141008"];
			fightObj.newItems = ["131124","131125"];
			fightObj.waveInfo = [];
			
			var tollgateItem:TollgateSheetItem = tollgateSheet.getTollgateSheetById(fightObj.tollgateId);
			for each(var waveId:int in tollgateItem.arrWaves)
			{
				var waveObj:Object = {};
				waveObj.offsetStartTick = 20;
				waveObj.subWaves = [];
				var waveItem:WaveSheetItem = waveSheet.getWaveSheetById(waveId);
				for each(var subWaveId:int in waveItem.arrSubWaves)
				{
					var subObj:Object = {};
					var subwaveItem:SubwaveSheetItem = subWaveSheet.getSubwaveSheetById(subWaveId);
					subObj.startTime = subwaveItem.startTime;
					subObj.interval = subwaveItem.interval;
					subObj.times = subwaveItem.times;
					subObj.monsterCount = subwaveItem.monsterCount;
					subObj.monsterTypeId = subwaveItem.monsterTypeId;
					subObj.roadIndex = subwaveItem.roadIndex;
					subObj.bRandomLine = (0 == subwaveItem.roadType);
					waveObj.subWaves.push(subObj);
				}
				
				fightObj.waveInfo.push(waveObj);
			}
				
			dynamicDataMgr.updateModels(dynamicData);
			
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightLoadMapImg));
		}
	}
}