package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class MonsterPreLoad extends BasicPreLoad
	{
		public function MonsterPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var monsterInfo:IMonsterSheetItem = monsterModel.getMonsterSheetById(id);
			if(!monsterInfo)
				return;
			
			preloadRes(GameObjectCategoryType.MONSTER+"_"+(monsterInfo.resId || id));
			
			parseWeapon(monsterInfo);
			
			parseSkills(monsterInfo);
			
			parseOtherRes(monsterInfo.otherResIds);
		}
		
		private function parseWeapon(info:IMonsterSheetItem):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseSkills(info:IMonsterSheetItem):void
		{
			for each(var skillId:uint in info.skillIds)
			{
				preloadSkillRes(skillId);
			}	
		}
	}
}