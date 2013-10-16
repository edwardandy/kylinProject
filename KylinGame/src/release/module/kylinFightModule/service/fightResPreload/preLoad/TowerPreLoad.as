package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicItem;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	import mainModule.service.gameDataServices.helpServices.ITollgateService;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class TowerPreLoad extends BasicPreLoad
	{
		[Inject]
		public var towerData:ITowerDynamicDataModel;
		[Inject]
		public var towerModel:ITowerSheetDataModel;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var tollgateService:ITollgateService;
		
		public function TowerPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{	
			
			var info:ITowerDynamicItem = towerData.getTowerDataById(id);	
			if(!info)
				return;			
			if(!tollgateService.canTowerBuildInTollgate(fightData.tollgateId,id))
				return;
			
			var item:ITowerSheetItem = towerModel.getTowerSheetById(id);
			
			preloadRes(GameObjectCategoryType.TOWER+"_"+id);
			
			parseSoilder(item);
			
			parseWeapon(item);
			
			parseSkills(info);
			
			parseNextTower(item);
			
			parseOtherRes(item.otherResIds);
		}
		
		private function parseSoilder(info:ITowerSheetItem):void
		{
			if(info.soldierId>0)
				preloadSoilderRes(info.soldierId);
		}
		
		private function parseWeapon(info:ITowerSheetItem):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseSkills(info:ITowerDynamicItem):void
		{
			var arrIds:Array = info.arrSkills;
			for each(var skillId:uint in arrIds)
			{
				preloadSkillRes(skillId);
			}
		}
		
		private function parseNextTower(info:ITowerSheetItem):void
		{
			var arrIds:Array = info.nextTowerIds;
			for each(var id:uint in arrIds)
			{
				checkCurLoadRes(id);
			}
		}
	}
}