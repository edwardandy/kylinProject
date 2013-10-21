package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices.MagicMouseCursorReleaseLogic;

	public class MonomerMagicMouseCursor extends BasicMouseCursor
	{
		[Inject]
		public var magicCursorLogic:MagicMouseCursorReleaseLogic;
		
		protected var magicSkillTemplateInfo:IMagicSkillSheetItem;
		
		public function MonomerMagicMouseCursor()
		{
			super();
		}
		
		override protected function onInitialize():void
		{	loadService
			//myErrorMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_move2");
			myErrorMouseCursorView = loadService.domainMgr.getMovieClipByDomain("cursor_move2");
			
			super.onInitialize();
		}
		
		//API
		public function setMagicSkillTemplateInfo(value:IMagicSkillSheetItem):void
		{
			if(value == magicSkillTemplateInfo)
				return;
			magicSkillTemplateInfo = value;
			
			if(magicSkillTemplateInfo != null)
			{
				myMouseCursorReleaseValidatorType = magicSkillTemplateInfo.releaseWay;
				createValidCursor();
			}
		}
		
		private function createValidCursor():void
		{
			if(!magicSkillTemplateInfo)
				return;
			
			if(myValideMouseCursorView != null && contains(myValideMouseCursorView))
			{
				removeChild(myValideMouseCursorView);
			}

				//myValideMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_"+magicSkillTemplateInfo.cursorId);//new valideMouseCursorCls();
				myValideMouseCursorView = loadService.domainMgr.getMovieClipByDomain("cursor_"+magicSkillTemplateInfo.cursorId);
			
			if(myValideMouseCursorView != null)
			{
				addChild(myValideMouseCursorView);
			}
		}
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			magicCursorLogic.excute(mouseCursorReleaseValidateResult, myCurrentValidMouseClickEvent, magicSkillTemplateInfo);
		}
		
		override public function dispose():void
		{
			super.dispose();

			magicSkillTemplateInfo = null;
		}
	}
}