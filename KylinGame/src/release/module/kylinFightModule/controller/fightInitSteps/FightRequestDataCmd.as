package release.module.kylinFightModule.controller.fightInitSteps
{	
	import mainModule.controller.netCmds.httpCmds.HttpCmd;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	import mainModule.model.gameData.sheetData.subwave.ISubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.subwave.ISubwaveSheetItem;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetItem;
	import mainModule.model.gameData.sheetData.wave.IWaveSheetDataModel;
	import mainModule.model.gameData.sheetData.wave.IWaveSheetItem;
	import mainModule.service.netServices.httpServices.HttpRequestDataFormat;
	
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
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
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		[Inject]
		public var monsterWaveModel:IMonsterWaveModel;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		
		public function FightRequestDataCmd()
		{
			super();
		}
		
		override protected function initRequestParam():void
		{
			super.initRequestParam();
			requestParam.vecData.push(new HttpRequestDataFormat("fight","request",[]));
			requestParam.bVirtual = true;
			requestParam.bNeedRespon = true;
		}
			
		override protected function get virtualResponData():Array
		{
			var dynamicData:Object = {};
			//战斗动态数据
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
			
			//携带的英雄
			heroData.arrHeroIdsInFight.push(180001,180002,180003);
			var heroObj:Object = {};
			dynamicData[DynamicDataNameConst.HeroData] = heroObj;
			heroObj.dynamicItems = {180001:{id:180001,level:1},180002:{id:180002,level:1},180003:{id:180003,level:1}};
			//拥有的魔法
			var magicObj:Object = {};
			dynamicData[DynamicDataNameConst.MagicSkillData] = magicObj;
			magicObj.dynamicItems = {210101:{id:210101,level:1},210401:{id:210401,level:1},210701:{id:210701,level:1}};
			//拥有的塔
			var towerObj:Object = {};
			dynamicData[DynamicDataNameConst.TowerData] = towerObj;
			towerObj.dynamicItems = {111001:{id:111001,level:1},112007:{id:112007,level:1},113013:{id:113013,level:1},114019:{id:114019,level:1}};
			towerObj.towerLevels = {1:1,2:1,3:1,4:1};
			
			return [{dynamic:dynamicData}];
		}
		
		override protected function response():void
		{
			super.response();
			fightState.state = FightState.UnInitialized;
			monsterWaveModel.updateData(fightData.waveInfo);
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightLoadMapImg));
		}
	}
}