package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;

	public final class GameMouseCursorFactory
	{
		private static var _instance:GameMouseCursorFactory;
		
		public static function getInstance():GameMouseCursorFactory
		{
			return _instance ||= new GameMouseCursorFactory();
		}
	
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
			var magicSkillTemplateInfo:MagicSkillTemplateInfo = TemplateDataFactory.getInstance().getMagicSkillTemplateById(magicSkillTypeId);
			
			var isRangeable:Boolean = magicSkillTemplateInfo.range > 0;
			
			var currentMouseCursor:MonomerMagicMouseCursor = null;
			
			if(isRangeable)
			{
				GameAGlobalManager.getInstance()
					.gameMouseCursorManager.activeMouseCursorByName(GameFightMouseCursorManager.RANGE_MAGIC_MOUSE_CURSOR, mouseCursorSponsor);
			}
			else
			{
				GameAGlobalManager.getInstance()
					.gameMouseCursorManager.activeMouseCursorByName(GameFightMouseCursorManager.MONOMER_MAGIC_MOUSE_CURSOR, mouseCursorSponsor);
			}
			
			currentMouseCursor = GameAGlobalManager.getInstance()
				.gameMouseCursorManager.getCurrentMouseCursor() as MonomerMagicMouseCursor;
			
			if(currentMouseCursor != null)
			{
				currentMouseCursor.setMagicSkillTemplateInfo(magicSkillTemplateInfo);
			}
			
			return currentMouseCursor;
		}
	}
}