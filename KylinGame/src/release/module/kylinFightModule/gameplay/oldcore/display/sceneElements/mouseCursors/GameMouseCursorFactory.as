package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;

	public final class GameMouseCursorFactory
	{
		[Inject]
		public var magicModel:IMagicSkillSheetDataModel;
		[Inject]
		public var mouseCursorMgr:GameFightMouseCursorManager;
		
		public function createGameMouseCursor(effectType:int, effectParameters:Object, mouseCursorSponsor:IMouseCursorSponsor):BasicMouseCursor
		{
			var reusltMouseCursor:BasicMouseCursor = null;
			
			switch(effectType)
			{
				case 1://法术类
					reusltMouseCursor = createMagicSkillMouseCursor(effectParameters, mouseCursorSponsor);
					break;
			}
			
			return reusltMouseCursor;
		}
		
		//{magic:id}
		private function createMagicSkillMouseCursor(effectParameters:Object, mouseCursorSponsor:IMouseCursorSponsor):BasicMouseCursor
		{
			var magicSkillTypeId:int = effectParameters.magic;
			var magicSkillTemplateInfo:IMagicSkillSheetItem = magicModel.getMagicSkillSheetById(magicSkillTypeId);
			
			var isRangeable:Boolean = magicSkillTemplateInfo.range > 0;
			
			var currentMouseCursor:MonomerMagicMouseCursor = null;
			
			if(isRangeable)
			{
				mouseCursorMgr.activeMouseCursorByName(GameFightMouseCursorManager.RANGE_MAGIC_MOUSE_CURSOR, mouseCursorSponsor);
			}
			else
			{
				mouseCursorMgr.activeMouseCursorByName(GameFightMouseCursorManager.MONOMER_MAGIC_MOUSE_CURSOR, mouseCursorSponsor);
			}
			
			currentMouseCursor = mouseCursorMgr.getCurrentMouseCursor() as MonomerMagicMouseCursor;
			
			if(currentMouseCursor != null)
			{
				currentMouseCursor.setMagicSkillTemplateInfo(magicSkillTemplateInfo);
			}
			
			return currentMouseCursor;
		}
	}
}