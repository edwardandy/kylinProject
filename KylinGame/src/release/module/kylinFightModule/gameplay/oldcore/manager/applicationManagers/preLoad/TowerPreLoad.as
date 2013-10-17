package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.tollLimit.TollLimitTemplateInfo;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.structure.model.user.tollgate.TollgateInfo;
	import framecore.structure.model.user.tower.TowerData;
	import framecore.structure.model.user.tower.TowerInfo;
	import framecore.structure.model.user.tower.TowerTemplateInfo;
	
	public class TowerPreLoad extends BasicPreLoad
	{
		public function TowerPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{	
			var towerInfo:TowerInfo = TowerData.getInstance().getTowerInfoByTowerId(id);	
			if(!towerInfo)
				return;
			
			var tempInfo:TowerTemplateInfo = towerInfo.towerTemplateInfo;
			
			if(checkIsValide(id))
				return;
			
			preloadRes(GameObjectCategoryType.TOWER+"_"+id);
			
			parseSoilder(tempInfo);
			
			parseWeapon(tempInfo);
			
			parseSkills(towerInfo);
			
			parseNextTower(tempInfo);
			
			parseOtherRes(tempInfo.otherResIds);
		}
		
		private function parseSoilder(info:TowerTemplateInfo):void
		{
			if(info.soldierId>0)
				preloadSoilderRes(info.soldierId);
		}
		
		private function parseWeapon(info:TowerTemplateInfo):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseSkills(info:TowerInfo):void
		{
			var arrIds:Array = info.skillIds;
			for each(var skillId:uint in arrIds)
			{
				preloadSkillRes(skillId);
			}
		}
		
		private function parseNextTower(info:TowerTemplateInfo):void
		{
			var arrIds:Array = info.nextTowerId.split(":");
			for each(var id:uint in arrIds)
			{
				checkCurLoadRes(id);
			}
		}
		
		private function checkIsValide(id:uint):Boolean
		{
			var tollLimitTypeId:uint = 	TollgateInfo(TollgateData.getInstance()
				.getOwnInfoById(TollgateData.currentLevelId))
				.tollgateTemplateInfo.tollLimitId;
			
			var tollLimit:TollLimitTemplateInfo = TemplateDataFactory.getInstance().getTollLimitTemplateById(tollLimitTypeId);
			var towerInfo:TowerTemplateInfo = TemplateDataFactory.getInstance().getTowerTemplateById(id);
			
			var result:Boolean = tollLimit.towerForbid.indexOf(towerInfo.type.toString()) == -1 ||
				towerInfo.level > tollLimit.towerLevel - 1 ||
				!TowerData.getInstance().getTowerisLockByTypeId(id);
			
			return result;
		}
	}
}