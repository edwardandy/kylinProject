package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import com.shinezone.towerDefense.fight.manager.applicationManagers.GamePreloadResMgr;
	import framecore.tools.GameStringUtil;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.base.BaseSkillInfo;
	
	public class SkillPreLoad extends BasicPreLoad
	{
		public function SkillPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var bHero:Boolean = false;
			var info:BaseSkillInfo = TemplateDataFactory.getInstance().getSkillTemplateById(id);
			if(!info)
			{
				info = TemplateDataFactory.getInstance().getHeroSkillTemplateById(id);
				bHero = true;
			}
			if(!info/*|| SkillType.INITIATIVE != info.type*/)
				return;
			
			if(info.configId == SkillID.ColdStorm)
				preloadRes(GameObjectCategoryType.SPECIAL+"_"+info.configId);
			else if(info.resId>0)
				preloadRes(GameObjectCategoryType.SPECIAL+"_"+info.resId);
			
			parseMagicEffect(GameStringUtil.deserializeString(info.effect));
			parseMagicBuffer(info);
			parseWeapon(info);
			parseOtherRes(info.otherResIds);
		}
		
		private function parseWeapon(info:BaseSkillInfo):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
	}
}