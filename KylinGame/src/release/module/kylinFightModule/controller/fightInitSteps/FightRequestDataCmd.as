package release.module.kylinFightModule.controller.fightInitSteps
{	
	import mainModule.controller.netCmds.httpCmds.HttpCmd;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.sheetData.subwave.ISubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.subwave.ISubwaveSheetItem;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetItem;
	import mainModule.model.gameData.sheetData.wave.IWaveSheetDataModel;
	import mainModule.model.gameData.sheetData.wave.IWaveSheetItem;
	
	import release.module.kylinFightModule.model.state.FightState;

	/**
	 * 单机时根据配置表填充虚拟的战斗数据 
	 * @author Edward
	 * 
	 */	
	public class FightRequestDataCmd extends HttpCmd
	{
		[Inject]
		public var tollgateModel:ITollgateSheetDataModel;
		[Inject]
		public var waveModel:IWaveSheetDataModel;
		[Inject]
		public var subWaveModel:ISubwaveSheetDataModel;
		[Inject]
		public var fightState:FightState;
		
		public function FightRequestDataCmd()
		{
			super();
		}
		
		override protected function initRequestParam():void
		{
			super.initRequestParam();
			requestParam.bVirtual = true;
		}
			
		override protected function get virtualResponData():Array
		{
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
			
			var tollgateItem:ITollgateSheetItem = tollgateModel.getTollgateSheetById(fightObj.tollgateId);
			for each(var waveId:int in tollgateItem.arrWaves)
			{
				var waveObj:Object = {};
				waveObj.offsetStartTick = 20;
				waveObj.subWaves = [];
				var waveItem:IWaveSheetItem = waveModel.getWaveSheetById(waveId);
				for each(var subWaveId:int in waveItem.arrSubWaves)
				{
					var subObj:Object = {};
					var subwaveItem:ISubwaveSheetItem = subWaveModel.getSubwaveSheetById(subWaveId);
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
			
			return [{dynamic:dynamicData}];
		}
		
		override protected function response():void
		{
			super.response();
			fightState.state = FightState.UnInitialized;
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightLoadMapImg));
		}
	}
}