package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public class BasicHasFlagMouseCursor extends BasicMouseCursor
	{
		public function BasicHasFlagMouseCursor()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			
			//myValideMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_move"); //new valideMouseCursorCls();
			myValideMouseCursorView = loadService.domainMgr.getMovieClipByDomain("cursor_move");
			
			//myErrorMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_move2"); //new errorMouseCursorViewCls();
			myErrorMouseCursorView = loadService.domainMgr.domainMgr.getMovieClipByDomain("cursor_move2");
			
			super.onInitialize();
		}
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			super.doWhenValidMouseClick(mouseCursorReleaseValidateResult);
			var flag:BasicGroundEffect = objPoolMgr.createSceneElementObject(GameObjectCategoryType.GROUNDEFFECT,7,false) as BasicGroundEffect;
			if(flag)
			{
				flag.setEffectParam(0,null,null);
				var pt:PointVO = GameMathUtil.convertStagePtToGame(myCurrentValidMouseClickEvent.stageX,myCurrentValidMouseClickEvent.stageY,fightViewModel.groundLayer);
				flag.x = pt.x;
				flag.y = pt.y;
				flag.notifyLifecycleActive();
			}
		}
	}
}