package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import com.shinezone.core.resource.ClassLibrary;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.geom.Point;
	
	import framecore.tools.loadmgr.LoadMgr;

	public class BasicHasFlagMouseCursor extends BasicMouseCursor
	{
		public function BasicHasFlagMouseCursor()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			
			//myValideMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_move"); //new valideMouseCursorCls();
			myValideMouseCursorView = LoadMgr.instance.domainMgr.getMovieClipByDomain("cursor_move");
			
			//myErrorMouseCursorView = ClassLibrary.getInstance().getMovieClip("cursor_move2"); //new errorMouseCursorViewCls();
			myErrorMouseCursorView = LoadMgr.instance.domainMgr.getMovieClipByDomain("cursor_move2");
			
			super.onInitialize();
		}
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			super.doWhenValidMouseClick(mouseCursorReleaseValidateResult);
			var flag:BasicGroundEffect = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.GROUNDEFFECT,7,false) as BasicGroundEffect;
			if(flag)
			{
				flag.setEffectParam(0,null,null);
				var pt:PointVO = GameMathUtil.convertStagePtToGame(myCurrentValidMouseClickEvent.stageX,myCurrentValidMouseClickEvent.stageY,GameAGlobalManager.getInstance().game);
				flag.x = pt.x;
				flag.y = pt.y;
				flag.notifyLifecycleActive();
			}
		}
	}
}