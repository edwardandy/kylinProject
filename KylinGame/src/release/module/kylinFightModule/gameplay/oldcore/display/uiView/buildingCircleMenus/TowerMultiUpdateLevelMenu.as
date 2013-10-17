package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	
	import framecore.structure.model.user.tower.TowerTemplateInfo;

	public class TowerMultiUpdateLevelMenu extends BasicTowerCircleMenu
	{
		protected var myUpdateCircleItem0:BuildingCircleItem;
		protected var myUpdateCircleItem1:BuildingCircleItem;
		protected var myUpdateCircleItem2:BuildingCircleItem;
		
		private var _nextTowerIds:Array = [];//id
		
		public function TowerMultiUpdateLevelMenu(buildingElement:BasicBuildingElement, 
												  towerTemplateInfo:TowerTemplateInfo)
		{
			super(buildingElement, towerTemplateInfo);
			
			_nextTowerIds = towerTemplateInfo.nextTowerId.split(":");
		}
		
		override public function notifySceneGoldUpdate():void
		{
			myUpdateCircleItem0.notifySceneGoldUpdate();
			myUpdateCircleItem1.notifySceneGoldUpdate();
			myUpdateCircleItem2.notifySceneGoldUpdate();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myUpdateCircleItem0 = new BuildingCircleItem(int(_nextTowerIds[0]), onCircleMenuItemBuildClick, this);
			myUpdateCircleItem0.x = -50;
			myUpdateCircleItem0.y = -50;
			addChild(myUpdateCircleItem0);
			
			myUpdateCircleItem1 = new BuildingCircleItem(int(_nextTowerIds[1]), onCircleMenuItemBuildClick, this);
			myUpdateCircleItem1.y = -50;
			addChild(myUpdateCircleItem1);

			myUpdateCircleItem2 = new BuildingCircleItem(int(_nextTowerIds[2]), onCircleMenuItemBuildClick, this);
			myUpdateCircleItem2.x = 50;
			myUpdateCircleItem2.y = -50;
			addChild(myUpdateCircleItem2);
		}
		
		override protected function onShow():void
		{
			super.onShow();
			myUpdateCircleItem0.Show();
			myUpdateCircleItem1.Show();
			myUpdateCircleItem2.Show();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			disposeCircleItem(myUpdateCircleItem0);
			disposeCircleItem(myUpdateCircleItem1);
			disposeCircleItem(myUpdateCircleItem2);
			myUpdateCircleItem0 = null;
			myUpdateCircleItem1 = null;
			myUpdateCircleItem2 = null;
		}
	}
}