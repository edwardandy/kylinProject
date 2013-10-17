package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.SimpleProgressBar;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneInteractiveElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.BasicBuildingCircleMenu;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightDataInfoManager;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.constdata.TowerSoundEffectsConst;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	import framecore.tools.media.TowerMediaPlayer;

	/**
	 * 塔基，能完成对已经开发塔的建造逻辑。 
	 * @author Administrator
	 * 
	 */	
	public final class ToftElement extends BasicBuildingElement
	{
		protected var myMeetingCenterPoint:PointVO = new PointVO(-50, 40);//本地
		
		protected var myTowerBuilderBar:SimpleProgressBar;
		
		private var _myBuildingTimrHandle:int = -1;
		
		private var _currentReadyToBuildTowerTypeId:int = -1;
		private var _currentBuilddingTowerElement:BasicTowerElement;
		
		public function ToftElement()
		{
			super();

			this.myElemeCategory = GameObjectCategoryType.TOFT;
			this.myObjectTypeId = GameAGlobalManager.getInstance().gameDataInfoManager.sceneType;
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
		}
		
		public function get meetingCenterPoint():PointVO
		{
			return myMeetingCenterPoint.clone();
		}

		public function setMeetingCenterPoint(value:PointVO):void
		{
			if(value == null) throw new Error("ToftElement::setMeetingCenterPoint value can not be null");
			
			myMeetingCenterPoint.x = value.x;
			myMeetingCenterPoint.y = value.y;
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myBuildingCircleMenu = new ToftElementCircleMenu(this);
			
			myTowerBuilderBar = new SimpleProgressBar(0, 100, 
				GameFightConstant.PROGRESS_BAR_COLOR_YELLOW, GameFightConstant.PROGRESS_BAR_COLOR_BROWN);
			myTowerBuilderBar.visible = false;
			myTowerBuilderBar.y = -30;
			addChild(myTowerBuilderBar);
		}
		
		override protected function onLifecycleActivate():void
		{
			checkTypeChange();
			
			super.onLifecycleActivate();
			
			this.mouseEnabled = true;
			_currentReadyToBuildTowerTypeId = -1;
		}
		
		override protected function onFocusChanged():void
		{
			if(myIsInFocus)
			{
				TowerMediaPlayer.getInstance().playEffect( TowerSoundEffectsConst.CLICK_TOFT );
				NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_TOWER_BASE,{"param":[],"target":this});
				NewbieGuideManager.getInstance().startCondition(NewbieConst.CONDITION_START_CLICK_TOWER_BASE,{"param":[],"target":myBuildingCircleMenu});
			}
			super.onFocusChanged();
		}
		
		private function checkTypeChange():void
		{
			var sceneType:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneType;
			if(sceneType == myObjectTypeId)
				return;
			myObjectTypeId = sceneType;
			
			if(myBodySkin != null)
			{
				removeChild(myBodySkin);
				myBodySkin.dispose();
				myBodySkin = null;
			}
			createBodySkin();
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();

			myTowerBuilderBar.visible = false;
			TimeTaskManager.getInstance().destoryTimeTask(_myBuildingTimrHandle);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myMeetingCenterPoint = null;
			removeChild(myTowerBuilderBar);
			myTowerBuilderBar = null;
		}
		
		override public function notifyCircleMenuOnBuild(typeId:int):void
		{
			if(_myBuildingTimrHandle != -1) return;

			_currentReadyToBuildTowerTypeId = typeId;

			this.mouseEnabled = false;
			myTowerBuilderBar.visible = true;
			
			if(_currentReadyToBuildTowerTypeId != -1)
			{
				_currentBuilddingTowerElement = ObjectPoolManager.getInstance()
					.createSceneElementObject(GameObjectCategoryType.TOWER, _currentReadyToBuildTowerTypeId) as BasicTowerElement;
				
				_currentBuilddingTowerElement.x = this.x;
				_currentBuilddingTowerElement.y = this.y;
				_currentBuilddingTowerElement.buildingToft = this;
				TowerMediaPlayer.getInstance().playEffect( TowerSoundEffectsConst.START_BUILD );
				GameAGlobalManager.getInstance().groundScene.addSceneElemet(_currentBuilddingTowerElement);
				
				_myBuildingTimrHandle = TimeTaskManager.getInstance().createTimeTask(GameFightConstant.TIME_UINT, 
					buiddingProgressHandler, null, 
					GameFightConstant.BUILDING_TOWER_DURATION / GameFightConstant.TIME_UINT,
					buiddingCompleteHandler);
			}
		}

		private function buiddingProgressHandler():void
		{
			myTowerBuilderBar.currentValue = TimeTaskManager.getInstance().getTaskTimeTaskProgress(_myBuildingTimrHandle) * 100;
		}

		private function buiddingCompleteHandler():void
		{
			myTowerBuilderBar.visible = false;
			_myBuildingTimrHandle = -1;

			if(_currentBuilddingTowerElement != null)
			{
				_currentBuilddingTowerElement.buildedByToft(this);
				_currentBuilddingTowerElement = null;
			}
		}
		
		override protected function getCanUseSkills():void
		{
			
		}
		
		override protected function processPassiveSkills():void
		{
			
		}
		
		override protected function genSKillUseUnits():void
		{
			
		}
		
		public function notifyBuildedInTowerOnSell():void
		{
			this.mouseEnabled = true;
			this.playBuilddingEffect();
		}
		
		private var _enable:Boolean = true;
		public function set enable(b:Boolean):void
		{
			if(b == _enable)
				return;
			_enable = b;
			if(_enable)
			{
				this.mouseEnabled = true;
				myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
				//this.filters = null;
			}
			else
			{
				this.mouseEnabled = false;
				myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.DISABLE);
				//this.filters = [GameFilterManager.getInstance().colorNessMatrixFilter,new GlowFilter(0xf70a15 , 0.5 , 6 , 6 , 6)];
			}
		}
	}
}

import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.BasicBuildingCircleMenu;
import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.BuildingCircleItem;
import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;

import framecore.structure.model.constdata.NewbieConst;
import framecore.structure.views.newguidPanel.NewbieGuideManager;

class ToftElementCircleMenu extends BasicBuildingCircleMenu
{
	//矮人石炮 114019 
	private var _buildingCircleItem0:BuildingCircleItem;
	//见习法师塔 113013 
	private var _buildingCircleItem1:BuildingCircleItem;
	//箭手之塔 112007
	private var _buildingCircleItem2:BuildingCircleItem;
	//新兵兵营 111001
	private var _buildingCircleItem3:BuildingCircleItem;
	
	public function ToftElementCircleMenu(buildingElement:BasicBuildingElement)
	{
		super(buildingElement);
	}
	
	override public function notifySceneGoldUpdate():void
	{
		_buildingCircleItem0.notifySceneGoldUpdate();
		_buildingCircleItem1.notifySceneGoldUpdate();
		_buildingCircleItem2.notifySceneGoldUpdate();
		_buildingCircleItem3.notifySceneGoldUpdate();
	}

	override protected function onInitialize():void
	{
		super.onInitialize();
		
		_buildingCircleItem0 = new BuildingCircleItem(114019, onCircleMenuItemBuildClick, this);
		_buildingCircleItem0.y = -50;
		addChild(_buildingCircleItem0);
		
		_buildingCircleItem1 = new BuildingCircleItem(113013, onCircleMenuItemBuildClick, this);
		_buildingCircleItem1.x = -50;
		addChild(_buildingCircleItem1);
		
		_buildingCircleItem2 = new BuildingCircleItem(112007, onCircleMenuItemBuildClick, this);
		_buildingCircleItem2.x = 50;
		addChild(_buildingCircleItem2);
		
		_buildingCircleItem3 = new BuildingCircleItem(111001, onCircleMenuItemBuildClick, this);
		_buildingCircleItem3.y = 50;
		addChild(_buildingCircleItem3);
	}
	
	override protected function onShow():void
	{
		super.onShow();
		_buildingCircleItem0.Show();
		_buildingCircleItem1.Show();
		_buildingCircleItem2.Show();
		_buildingCircleItem3.Show();
	}
	
	override protected function onCircleMenuItemBuildClick(typeId:int):void
	{
		super.onCircleMenuItemBuildClick(typeId);
		NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_BUILD_MENU,{"target":this});
	}
	
	override public function dispose():void
	{
		super.dispose();
		
		removeChild(_buildingCircleItem0);
		_buildingCircleItem0.dispose();
		_buildingCircleItem0 = null;
		
		removeChild(_buildingCircleItem1);
		_buildingCircleItem1.dispose();
		_buildingCircleItem1 = null;
		
		removeChild(_buildingCircleItem2);
		_buildingCircleItem2.dispose();
		_buildingCircleItem2 = null;
		
		removeChild(_buildingCircleItem3);
		_buildingCircleItem3.dispose();
		_buildingCircleItem3 = null;
	}
}