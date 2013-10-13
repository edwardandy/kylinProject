package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.weapon.WeaponTemplateInfo;
	
	public class WeaponPreLoad extends BasicPreLoad
	{
		public function WeaponPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:WeaponTemplateInfo = TemplateDataFactory.getInstance().getWeaponTemplateById(id);
			if(!info)
				return;
			var resId:uint = info.resId || id;
			preloadRes(GameObjectCategoryType.BULLET+"_"+resId);
	
			parseSpecialEffect(info);
			parseOtherRes(info.otherResIds);
		}
		
		private function parseSpecialEffect(info:WeaponTemplateInfo):void
		{
			if(info.specialEffect>0)
				preloadRes(GameObjectCategoryType.SPECIAL+"_"+info.specialEffect);
		}
	}
}