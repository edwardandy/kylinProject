package release.module.kylinFightModule.service.fightResPreload.preLoad
{	
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;

	public class MagicPreLoad extends BasicPreLoad
	{
		[Inject]
		public var magicModel:IMagicSkillSheetDataModel;
		
		public function MagicPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:IMagicSkillSheetItem = magicModel.getMagicSkillSheetById(id);
			if(!info)
				return;
			
			var resId:uint = info.resId;
			if(resId)			
				preloadRes(GameObjectCategoryType.MAGIC_SKILL+"_"+resId);	
			
			//解析effect内包含的资源
			parseMagicEffect(info.objEffect);
			//解析buff内包含的资源
			parseMagicBuffer(info);
			
			parseCursor(info);
			parseOtherRes(info.otherResIds);
		}
		
		private function parseCursor(info:IMagicSkillSheetItem):void
		{
			if(info.cursorId>0)
				preloadRes("cursor_"+info.cursorId);
		}
	}
}