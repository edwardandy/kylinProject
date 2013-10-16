package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.sheetData.weapon.IWeaponSheetDataModel;
	import mainModule.model.gameData.sheetData.weapon.IWeaponSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class WeaponPreLoad extends BasicPreLoad
	{
		[Inject]
		public var weaponModel:IWeaponSheetDataModel;
		
		public function WeaponPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:IWeaponSheetItem = weaponModel.getWeaponSheetById(id);
			if(!info)
				return;
			var resId:uint = info.resId || id;
			preloadRes(GameObjectCategoryType.BULLET+"_"+resId);
	
			parseSpecialEffect(info);
			parseOtherRes(info.otherResIds);
		}
		
		private function parseSpecialEffect(info:IWeaponSheetItem):void
		{
			if(info.specialEffect>0)
				preloadRes(GameObjectCategoryType.SPECIAL+"_"+info.specialEffect);
		}
	}
}