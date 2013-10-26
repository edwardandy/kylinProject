package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.ILifecycleObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;

	public class TowerSkillUpdateLevelMenu extends BasicTowerCircleMenu implements ILifecycleObject
	{
		protected var myUpdateCircleItem0:TowerSkillUpCircleItem;
		protected var myUpdateCircleItem1:TowerSkillUpCircleItem;
		
		public function TowerSkillUpdateLevelMenu(buildingElement:BasicBuildingElement, 
												  towerTemplateInfo:ITowerSheetItem)
		{
			super(buildingElement, towerTemplateInfo);
		}
		
		override public function notifySceneGoldUpdate():void
		{
			myUpdateCircleItem0.notifySceneGoldUpdate();
			myUpdateCircleItem1.notifySceneGoldUpdate();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			//var info:TowerInfo = TowerData.getInstance().getTowerInfoByTowerId(myTowerTemplateInfo.configId);
			var arrIds:Array = [];//info.skillIds.concat();
			for each(var id:uint in myTowerTemplateInfo.skillIds)
			{
				if(6 == id.toString().length)
					arrIds.push(id);
			}
			arrIds.sort(Array.NUMERIC | Array.DESCENDING);
			myUpdateCircleItem0 = new TowerSkillUpCircleItem(arrIds.length>0?uint(arrIds[0]):0,myTowerTemplateInfo.configId, onCircleMenuItemSkillUpClick, this);
			injector.injectInto(myUpdateCircleItem0);
			myUpdateCircleItem0.x = -38;
			myUpdateCircleItem0.y = -50+15;
			addChild(myUpdateCircleItem0);
			
			myUpdateCircleItem1 = new TowerSkillUpCircleItem(arrIds.length>1?uint(arrIds[1]):0,myTowerTemplateInfo.configId, onCircleMenuItemSkillUpClick, this);
			injector.injectInto(myUpdateCircleItem1);
			myUpdateCircleItem1.x = 38;
			myUpdateCircleItem1.y = -50+15;
			addChild(myUpdateCircleItem1);
		}
		
		override protected function onShow():void
		{
			super.onShow();
			myUpdateCircleItem0.Show();
			myUpdateCircleItem1.Show();
		}
		
		//激活
		public function notifyLifecycleActive():void
		{
			onLifecycleActive();
			myUpdateCircleItem0.notifyLifecycleActive();
			myUpdateCircleItem1.notifyLifecycleActive();
		}
		
		protected function onLifecycleActive():void
		{
			var arrIds:Array = [];//info.skillIds.concat();
			for each(var id:uint in myTowerTemplateInfo.skillIds)
			{
				if(6 == id.toString().length)
					arrIds.push(id);
			}
			arrIds.sort(Array.NUMERIC | Array.DESCENDING);
			myUpdateCircleItem0.setSkillId(arrIds.length>0?uint(arrIds[0]):0);
			myUpdateCircleItem1.setSkillId(arrIds.length>1?uint(arrIds[1]):0);
		}
		
		//冻结
		public function notifyLifecycleFreeze():void
		{
			myUpdateCircleItem0.notifyLifecycleFreeze();
			myUpdateCircleItem1.notifyLifecycleFreeze();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			disposeCircleItem(myUpdateCircleItem0);
			myUpdateCircleItem0 = null;
			
			disposeCircleItem(myUpdateCircleItem1);
			myUpdateCircleItem1 = null;
		}
	}
}