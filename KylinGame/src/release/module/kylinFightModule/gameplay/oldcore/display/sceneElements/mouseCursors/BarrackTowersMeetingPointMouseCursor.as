package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers.BarrackTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import framecore.structure.model.constdata.TowerSoundEffectsConst;
	import framecore.tools.media.TowerMediaPlayer;

	public class BarrackTowersMeetingPointMouseCursor extends BasicHasFlagMouseCursor
	{
		private var _myCurrentBarrackTowerElement:BarrackTowerElement;
		
		public function BarrackTowersMeetingPointMouseCursor()
		{
			super();
		}
		
		public function setBarrackTowerElement(value:BarrackTowerElement):void
		{
			_myCurrentBarrackTowerElement = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_myCurrentBarrackTowerElement = null;
		}
		
		override protected function checkIsValidMouseClick(mouseClickEvent:MouseEvent):Object
		{
			var _tempPt:Point = GameMathUtil.convertStagePtToGame2(mouseClickEvent.stageX,mouseClickEvent.stageY,GameAGlobalManager.getInstance().game);
			return GameAGlobalManager.getInstance().groundScene.hisTestMapRoad(mouseClickEvent.stageX,mouseClickEvent.stageY) &&
				GameMathUtil.containsPointInEllipseSearchArea(_myCurrentBarrackTowerElement.x, _myCurrentBarrackTowerElement.y,
				_myCurrentBarrackTowerElement.attackArea, _tempPt.x, _tempPt.y);
		}	
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			GameAGlobalManager.getInstance().gameFightInfoRecorder.taskOpData.changeCampPointCount++;
			super.doWhenValidMouseClick(mouseCursorReleaseValidateResult);
			_myCurrentBarrackTowerElement.playMoveSound();
		}
	}
}