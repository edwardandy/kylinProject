package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicItem;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicItem;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class HeroPreLoad extends BasicPreLoad
	{
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		[Inject]
		public var heroModel:IHeroSheetDataModel;
		[Inject]
		public var heroSkillData:IHeroSkillDynamicDataModel;
		
		public function HeroPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var heroInfo:IHeroDynamicItem = heroData.getHeroDataById(id);
			var heroSheet:IHeroSheetItem = heroModel.getHeroSheetById(id);
			if(!heroInfo || !heroSheet)
				return;
			
			preloadRes(GameObjectCategoryType.HERO+"_"+id);	
			
			parseHeroWeapon(heroSheet);
			
			parseHeroSkill(id);
			
			//parseHeroTalents(heroInfo);
		}
		
		private function parseHeroWeapon(info:IHeroSheetItem):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseHeroSkill(id:uint):void
		{
			for each(var skill:IHeroSkillDynamicItem in heroSkillData.getHeroAllSkillData(id))
			{
				preloadSkillRes(skill.skillId);
			}
		}
		
		/*private function parseHeroTalents(info:HeroInfo):void
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
		}*/
	}
}