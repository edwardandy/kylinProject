package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.monster.MonsterTemplateInfo;
	
	public class MonsterPreLoad extends BasicPreLoad
	{
		public function MonsterPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var monsterInfo:MonsterTemplateInfo = TemplateDataFactory.getInstance().getMonsterTemplateById(id);
			if(!monsterInfo)
			{
				//throw new Error("preloadError monsterId is not exist:"+monsterId);
				return;
			}
			
			preloadRes(GameObjectCategoryType.MONSTER+"_"+(monsterInfo.resId || id));
			
			parseWeapon(monsterInfo);
			
			parseSkills(monsterInfo);
			
			parseOtherRes(monsterInfo.otherResIds);
		}
		
		private function parseWeapon(info:MonsterTemplateInfo):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseSkills(info:MonsterTemplateInfo):void
		{
			for each(var skillId:uint in info.getskillIds())
			{
				preloadSkillRes(skillId);
			}	
		}
	}
}