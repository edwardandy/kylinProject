package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers.WizardTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WizardTowersMeetingPointMouseCursor extends BasicHasFlagMouseCursor
	{
		private var _myCurrentWizardTowerElement:WizardTowerElement;
		
		public function WizardTowersMeetingPointMouseCursor()
		{
			super();
		}
		
		public function setWizardTowerElement(value:WizardTowerElement):void
		{
			_myCurrentWizardTowerElement = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			_myCurrentWizardTowerElement = null;
		}
		
		override protected function checkIsValidMouseClick(mouseClickEvent:MouseEvent):Object
		{
			var pt:Point = GameMathUtil.convertStagePtToGame2(mouseClickEvent.stageX,mouseClickEvent.stageY,GameAGlobalManager.getInstance().game);
			return GameAGlobalManager.getInstance().groundScene.hisTestMapRoad(mouseClickEvent.stageX,mouseClickEvent.stageY) &&
				GameMathUtil.containsPointInEllipseSearchArea(_myCurrentWizardTowerElement.x, _myCurrentWizardTowerElement.y,
					_myCurrentWizardTowerElement.attackArea, pt.x, pt.y);
		}
	}
}