package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers
{
	import flash.events.MouseEvent;
	
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BarrackTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.MeetingPointCircleItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerSingleUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	public class BarrackTowerSingleUpdateLevelMenu extends TowerSingleUpdateLevelMenu implements IMouseCursorSponsor
	{
		private var _meetingPointCircleItem:MeetingPointCircleItem;
		
		public function BarrackTowerSingleUpdateLevelMenu(buildingElement:BasicBuildingElement, 
														  towerTemplateInfo:ITowerSheetItem)
		{
			super(buildingElement, towerTemplateInfo);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_meetingPointCircleItem = new MeetingPointCircleItem(onCircleMenuItemMettingPointClick, this);
			injector.injectInto(_meetingPointCircleItem);
			//_meetingPointCircleItem.x = 43;
			_meetingPointCircleItem.y = 50;
			addChild(_meetingPointCircleItem);
		}
		
		protected function onCircleMenuItemMettingPointClick():void
		{
			mouseCursorMgr.activeMouseCursorByName(GameFightMouseCursorManager.BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR, this);
			
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