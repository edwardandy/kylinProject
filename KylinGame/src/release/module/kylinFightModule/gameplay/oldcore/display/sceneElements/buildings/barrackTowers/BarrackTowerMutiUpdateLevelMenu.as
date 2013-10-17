package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BarrackTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.MeetingPointCircleItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerMultiUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import framecore.structure.model.user.tower.TowerTemplateInfo;

	public class BarrackTowerMutiUpdateLevelMenu extends TowerMultiUpdateLevelMenu implements IMouseCursorSponsor
	{
		private var _meetingPointCircleItem:MeetingPointCircleItem;
		
		public function BarrackTowerMutiUpdateLevelMenu(buildingElement:BasicBuildingElement, 
														towerTemplateInfo:TowerTemplateInfo)
		{
			super(buildingElement, towerTemplateInfo);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_meetingPointCircleItem = new MeetingPointCircleItem(onCircleMenuItemMettingPoint, this);
			//_meetingPointCircleItem.x = 43;
			_meetingPointCircleItem.y = 50;
			addChild(_meetingPointCircleItem);
		}
		
		protected function onCircleMenuItemMettingPoint():void
		{
			GameAGlobalManager.getInstance()
				.gameMouseCursorManager.activeMouseCursorByName(
					GameFightMouseCursorManager.BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR, this);
			
			var currentMouseCursor:BarrackTowersMeetingPointMouseCursor = GameAGlobalManager.getInstance()
				.gameMouseCursorManager.getCurrentMouseCursor() as BarrackTowersMeetingPointMouseCursor;
			currentMouseCursor.setBarrackTowerElement(BarrackTowerElement(myBuildingElement));
			
			BarrackTowerElement(myBuildingElement).isShowTowerRange(true);
		}
		
		//IMouseCursorSponsor Interface
		public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			BarrackTowerElement(myBuildingElement).isShowTowerRange(false);
			
			BarrackTowerElement(myBuildingElement).moveAllSoldierToMeetingCenterPoint(
				GameMathUtil.convertStagePtToGame(mouseClickEvent.stageX, mouseClickEvent.stageY,GameAGlobalManager.getInstance().game));
		}
		
		public function notifyTargetMouseCursorCanceled():void
		{
			BarrackTowerElement(myBuildingElement).isShowTowerRange(false);
		}
	}
}