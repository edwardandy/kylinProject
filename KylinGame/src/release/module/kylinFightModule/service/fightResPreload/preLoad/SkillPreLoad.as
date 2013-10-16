package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;
	import mainModule.model.gameData.sheetData.skill.heroSkill.IHeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.monsterSkill.IMonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.towerSkill.ITowerSkillSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class SkillPreLoad extends BasicPreLoad
	{
		[Inject]
		public var heroSkillModel:IHeroSkillSheetDataModel;
		[Inject]
		public var monsterSkillModel:IMonsterSkillSheetDataModel;
		[Inject]
		public var towerSkillModel:ITowerSkillSheetDataModel;
		
		public function SkillPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{	
			var item:IBaseOwnerSkillSheetItem = heroSkillModel.getHeroSkillSheetById(id);
			item ||= monsterSkillModel.getMonsterSkillSheetById(id);
			item ||= towerSkillModel.getTowerSkillSheetById(id);
			
			if(!item)
				return;
			
			if(SkillID.ColdStorm == item.configId)
				preloadRes(GameObjectCategoryType.SPECIAL+"_"+item.configId);
			else if(item.resId>0)
				preloadRes(GameObjectCategoryType.SPECIAL+"_"+item.resId);
			
			parseMagicEffect(item.objEffect);
			parseMagicBuffer(item);
			parseWeapon(item);
			parseOtherRes(item.otherResIds);
		}
		
		private function parseWeapon(info:IBaseOwnerSkillSheetItem):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
	}
}