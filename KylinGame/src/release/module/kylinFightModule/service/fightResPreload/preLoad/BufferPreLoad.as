package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.sheetData.buff.IBuffSheetDataModel;
	import mainModule.model.gameData.sheetData.buff.IBuffSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class BufferPreLoad extends BasicPreLoad
	{
		[Inject]
		public var buffModel:IBuffSheetDataModel;
		
		public function BufferPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:IBuffSheetItem = buffModel.getBuffSheetById(id);;
			if(!info)
				return;
			var resId:int = info.resId;
			if(0 == resId)
				resId = id;
			if(resId>0)
				preloadRes(GameObjectCategoryType.ORGANISM_SKILL_BUFFER+"_"+resId);
			
			parseOtherRes(info.otherResIds);
		}
		
		private function parseBuffMode(info:IBuffSheetItem):void
		{
			
		}
	}
}