package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;

	public class TowerSingleUpdateLevelMenu extends BasicTowerCircleMenu
	{
		protected var myUpdateCircleItem:BuildingCircleItem;
		
		public function TowerSingleUpdateLevelMenu(buildingElement:BasicBuildingElement, 
												  towerTemplateInfo:ITowerSheetItem)
		{
			super(buildingElement, towerTemplateInfo);
		}
		
		override public function notifySceneGoldUpdate():void
		{
			myUpdateCircleItem.notifySceneGoldUpdate();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myUpdateCircleItem = new BuildingCircleItem(int(myTowerTemplateInfo.nextTowerIds[0]), onCircleMenuItemBuildClick, this, true);
			injector.injectInto(myUpdateCircleItem);
			myUpdateCircleItem.y = -50;
			addChild(myUpdateCircleItem);
		}
		
		override protected function onShow():void
		{
			super.onShow();
			myUpdateCircleItem.Show();
		}
		
		override protected function onCircleMenuItemBuildClick(typeId:int):void
		{
			super.onCircleMenuItemBuildClick(typeId);
			//GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_UPGRADE_TOWER, typeId );
			//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_TOWER_UPGRADE_MENU,{"param":[myTowerTemplateInfo.nextTowerId],"target":this});
		}
		
		override public function dispose():void
		{
			super.dispose();
			disposeCircleItem(myUpdateCircleItem);
			myUpdateCircleItem = null;
		}
	}
}