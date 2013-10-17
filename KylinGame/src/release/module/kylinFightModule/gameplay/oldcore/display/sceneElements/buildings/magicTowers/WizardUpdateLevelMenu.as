package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers
{
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.WizardTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.MeetingPointCircleItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerSingleUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerSkillUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.events.MouseEvent;
	
	import framecore.structure.model.user.tower.TowerTemplateInfo;
	
	public class WizardUpdateLevelMenu extends TowerSkillUpdateLevelMenu implements IMouseCursorSponsor
	{
		private var _meetingPointCircleItem:MeetingPointCircleItem;
		
		public function WizardUpdateLevelMenu(buildingElement:BasicBuildingElement, towerTemplateInfo:TowerTemplateInfo)
		{
			super(buildingElement, towerTemplateInfo);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_meetingPointCircleItem = new MeetingPointCircleItem(onCircleMenuItemMettingPointClick, this);
			//_meetingPointCircleItem.x = 43;
			_meetingPointCircleItem.y = 50;
			addChild(_meetingPointCircleItem);
		}
		
		override protected function onLifecycleActive():void
		{
			super.onLifecycleActive();
			_meetingPointCircleItem.setIsEnable(false);
		}
		
		protected function onCircleMenuItemMettingPointClick():void
		{
			GameAGlobalManager.getInstance()
				.gameMouseCursorManager.activeMouseCursorByName(GameFightMouseCursorManager.WIZARD_TOWERS_MEETING_POINT_MOUSE_CURSOR, this);
			
			var currentMouseCursor:WizardTowersMeetingPointMouseCursor = GameAGlobalManager.getInstance()
				.gameMouseCursorManager.getCurrentMouseCursor() as WizardTowersMeetingPointMouseCursor;
			currentMouseCursor.setWizardTowerElement(WizardTowerElement(myBuildingElement));
			
			WizardTowerElement(myBuildingElement).isShowTowerRange(true);
		}
		
		public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			WizardTowerElement(myBuildingElement).isShowTowerRange(false);
			
			WizardTowerElement(myBuildingElement).moveAllSoldierToMeetingCenterPoint(
				GameMathUtil.convertStagePtToGame(mouseClickEvent.stageX, mouseClickEvent.stageY,GameAGlobalManager.getInstance().game));
		}
		
		public function notifyTargetMouseCursorCanceled():void
		{
			WizardTowerElement(myBuildingElement).isShowTowerRange(false);
		}
		
		override protected function onCircleMenuItemSkillUpClick(skillId:uint,iLvl:int):void
		{
			super.onCircleMenuItemSkillUpClick(skillId,iLvl);
			if(SkillID.SummonIce == skillId || SkillID.SummonEarth == skillId)
			{
				_meetingPointCircleItem.setIsEnable(true);
			}
		}
	}
}