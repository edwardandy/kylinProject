package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.shinezone.core.interfaces.behavior.IDispose;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.IBuildingCircleMenuOwner;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class BasicBuildingCircleMenu extends BasicView
	{
		private static const TWEEN_TIME:Number = 0.1;
		
		private var _buildingCircleBGSkin:BuildingCircleBGSkin;
		
		private var _myBuildingCircleTween:TweenLite;
		private var _isShowed:Boolean = false;
		
		protected var myBuildingElement:IBuildingCircleMenuOwner;

		public function get buildingElement():BasicBuildingElement
		{
			return myBuildingElement as BasicBuildingElement;
		}
		
		public function BasicBuildingCircleMenu(buildingElement:BasicBuildingElement)
		{
			super();

			this.scaleX = 0.6;
			this.scaleY = 0.6;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.visible = false;
			this.myBuildingElement = buildingElement;
		}
		
		//API
		public function notifySceneGoldUpdate():void
		{
		}
		
		public function show():void
		{
			_isShowed = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.visible = true;
			_myBuildingCircleTween.play();
			onShow();
		}
		
		protected function onShow():void
		{
			
		}
		
		public function hide():void
		{
			_isShowed = false;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_myBuildingCircleTween.reverse();
		}
		
		public function get isShowed():Boolean
		{
			return _isShowed;
		}
		
		override protected function onInitialize():void
		{
			_buildingCircleBGSkin = new BuildingCircleBGSkin();
			_buildingCircleBGSkin.mouseEnabled = false;
			_buildingCircleBGSkin.mouseChildren = false;
			addChild(_buildingCircleBGSkin);

			_myBuildingCircleTween = TweenLite.to(this, TWEEN_TIME, 
				{
					scaleX:1, 
					scaleY:1, 
					paused:true, 
					onComplete:myBuildingCircleTweenCompleteHandler, 
					onReverseComplete:myBuildingCircleTweenReverseCompleteHandler,
					ease:Back.easeOut});
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myBuildingElement = null;
			removeChild(_buildingCircleBGSkin);
			_buildingCircleBGSkin = null;
			
			_myBuildingCircleTween.kill();
			_myBuildingCircleTween = null;
		}
		
		//event handler
		private function myBuildingCircleTweenCompleteHandler():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
		private function myBuildingCircleTweenReverseCompleteHandler():void
		{
			this.mouseChildren = true;
			this.mouseEnabled = true;
			this.visible = false;
		}
		
		//API
		public function notifyCircleOnItemPreClick(circleItem:BasicBuildingCircleItem):void
		{
			if(myBuildingElement is ISceneFocusElement && circleItem.isClickToDisfocusBuilding())
			{
				GameAGlobalManager.getInstance().gameInteractiveManager.disFocusTargetElement(ISceneFocusElement(myBuildingElement));	
			}
		}

		protected function onCircleMenuItemBuildClick(typeId:int):void
		{
			myBuildingElement.notifyCircleMenuOnBuild(typeId);
		}
		
		protected function onCircleMenuItemSellClick():void
		{
			myBuildingElement.notifyCircleMenuOnSell();
		}
		
		protected function onCircleMenuItemSkillUpClick(skillId:uint,iLvl:int):void
		{
			myBuildingElement.notifyCircleMenuOnSkillUp(skillId,iLvl);
		}
		
		public function notifyCircleMenuItemMouseOver(builderId:uint,bOver:Boolean):void
		{
			myBuildingElement.notifyCircleMenuMouseOver(builderId,bOver);
		}
	}
}