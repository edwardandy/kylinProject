package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	
	import framecore.structure.model.user.tower.TowerTemplateInfo;

	public class BasicTowerCircleMenu extends BasicBuildingCircleMenu
	{
		protected var myTowerTemplateInfo:TowerTemplateInfo;
		protected var mySellCircleItem:SellCircleItem;
		
		public function BasicTowerCircleMenu(buildingElement:BasicBuildingElement, 
											 towerTemplateInfo:TowerTemplateInfo)
		{
			super(buildingElement);

			myTowerTemplateInfo = towerTemplateInfo;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			mySellCircleItem = new SellCircleItem(onCircleMenuItemSellClick, this);
			mySellCircleItem.x = 47;
			mySellCircleItem.y = 30;
			addChild(mySellCircleItem);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			disposeCircleItem(mySellCircleItem);
			mySellCircleItem = null;
		}
		
		protected function disposeCircleItem(circleItem:BasicBuildingCircleItem):void
		{
			removeChild(circleItem);
			circleItem.dispose();
		}
	}
}