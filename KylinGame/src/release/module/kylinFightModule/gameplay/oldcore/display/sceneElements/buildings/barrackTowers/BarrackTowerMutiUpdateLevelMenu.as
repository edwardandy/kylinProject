package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers
{
	import flash.events.MouseEvent;
	
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BarrackTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.MeetingPointCircleItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerMultiUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	public class BarrackTowerMutiUpdateLevelMenu extends TowerMultiUpdateLevelMenu implements IMouseCursorSponsor
	{
		private var _meetingPointCircleItem:MeetingPointCircleItem;
		
		public function BarrackTowerMutiUpdateLevelMenu(buildingElement:BasicBuildingElement, 
														towerTemplateInfo:ITowerSheetItem)
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
			mouseCursorMgr.activeMouseCursorByName(
					GameFightMouseCursorManager.BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR, this);
			
			var currentMouseCursor:BarrackTowersMeetingPointMouseCursor = mouseCursorMgr
				.getCurrentMouseCursor() as BarrackTowersMeetingPointMouseCursor;
			currentMouseCursor.setBarrackTowerElement(BarrackTowerElement(myBuildingElement));
			
			BarrackTowerElement(myBuildingElement).isShowTowerRange(true);
		}
		
		//IMouseCursorSponsor Interface
		public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			BarrackTowerElement(myBuildingElement).isShowTowerRange(false);
			
			BarrackTowerElement(myBuildingElement).moveAllSoldierToMeetingCenterPoint(
				GameMathUtil.convertStagePtToGame(mouseClickEvent.stageX, mouseClickEvent.stageY,fightViewModel.groundLayer));
		}
		
		public function notifyTargetMouseCursorCanceled():void
		{
			BarrackTowerElement(myBuildingElement).isShowTowerRange(false);
		}
	}
}