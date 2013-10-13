package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.soldier.SoldierTemplateInfo;
	
	public class SoilderPreLoad extends BasicPreLoad
	{
		public function SoilderPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:SoldierTemplateInfo = TemplateDataFactory.getInstance().getSoldierTemplateById(id);
			if(!info)
				return;
			
			preloadRes(GameObjectCategoryType.SOLDIER+"_"+(info.resId || id));	
			
			parseWeapon(info);
			
			parseSkill(info);
		}
		
		private function parseWeapon(info:SoldierTemplateInfo):void
		{
			if(info.weapon>0)
				preloadWeaponRes(info.weapon);
		}
		
		private function parseSkill(info:SoldierTemplateInfo):void
		{
			for each(var skillId:uint in info.getskillIds())
			{
				preloadSkillRes(skillId);
			}	
		}
	}
}