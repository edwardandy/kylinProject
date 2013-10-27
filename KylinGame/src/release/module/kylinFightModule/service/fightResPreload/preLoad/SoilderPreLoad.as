package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.sheetData.soldier.ISoldierSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class SoilderPreLoad extends BasicPreLoad
	{
		public function SoilderPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:ISoldierSheetItem = soldierModel.getSoldierSheetById(id);
			if(!info)
				return;
			
			preloadRes(GameObjectCategoryType.SOLDIER+"_"+(info.resId || id));	
			
			parseWeapon(info);
			
			parseSkill(info);
		}
		
		private function parseWeapon(info:ISoldierSheetItem):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseSkill(info:ISoldierSheetItem):void
		{
			for each(var skillId:uint in info.skillIds)
			{
				preloadSkillRes(skillId);
			}	
		}
	}
}