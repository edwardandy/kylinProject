package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import com.shinezone.core.resource.ClassLibrary;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices.MagicMouseCursorReleaseLogic;
	
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;
	import framecore.tools.loadmgr.LoadMgr;

	public class MonomerMagicMouseCursor extends BasicMouseCursor
	{
		protected var magicSkillTemplateInfo:MagicSkillTemplateInfo;
		
		public function MonomerMagicMouseCursor()
		{
			super();
		}
		
		override protected function onInitialize():void
		{	
			//myErrorMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_move2");
			myErrorMouseCursorView = LoadMgr.instance.domainMgr.getMovieClipByDomain("cursor_move2");
			
			super.onInitialize();
		}
		
		//API
		public function setMagicSkillTemplateInfo(value:MagicSkillTemplateInfo):void
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
				myValideMouseCursorView = LoadMgr.instance.domainMgr.getMovieClipByDomain("cursor_"+magicSkillTemplateInfo.cursorId);
			
			if(myValideMouseCursorView != null)
			{
				addChild(myValideMouseCursorView);
			}
		}
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			MagicMouseCursorReleaseLogic.getInstance()
				.excute(mouseCursorReleaseValidateResult, myCurrentValidMouseClickEvent, magicSkillTemplateInfo);
		}
		
		override public function dispose():void
		{
			super.dispose();

			magicSkillTemplateInfo = null;
		}
	}
}