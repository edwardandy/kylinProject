package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.hero.HeroData;
	import framecore.structure.model.user.hero.HeroInfo;
	import framecore.structure.model.user.heroSkill.HeroSkillInfo;
	import framecore.structure.model.user.heroTalents.HeroTalentTemplateInfo;
	
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class HeroPreLoad extends BasicPreLoad
	{
		public function HeroPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var heroInfo:HeroInfo = HeroData.getInstance().getOwnInfoById(id) as HeroInfo;
			if(!heroInfo)
				return;
			
			preloadRes(GameObjectCategoryType.HERO+"_"+id);	
			
			parseHeroWeapon(heroInfo);
			
			parseHeroSkill(heroInfo);
			
			parseHeroTalents(heroInfo);
		}
		
		private function parseHeroWeapon(info:HeroInfo):void
		{
			if(info.heroTemplateInfo.weapon>0)
				preloadWeaponRes(info.heroTemplateInfo.weapon);
		}
		
		private function parseHeroSkill(info:HeroInfo):void
		{
			/*for each(var skillId:uint in info.heroTemplateInfo.getskillIds())
			{
				preloadSkillRes(skillId);
			}	*/
			
			if(info.passiveSkillInfos && info.passiveSkillInfos.length>0)
			{
				for each(var skill:HeroSkillInfo in info.passiveSkillInfos)
				{
					preloadSkillRes(skill.configId);
				}
			}
		}
		
		private function parseHeroTalents(info:HeroInfo):void
		{
			if(info.arrTalents && info.arrTalents.length>0)
			{
				for each(var talentId:uint in info.arrTalents)
				{
					var temp:HeroTalentTemplateInfo = TemplateDataFactory.getInstance().getHeroTalentTemplateById(talentId);
					if(temp && temp.skillId)
						preloadSkillRes(temp.skillId);
				}
			}
		}
	}
}