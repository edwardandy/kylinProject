package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings
{
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.constant.identify.SoundID;
	import release.module.kylinFightModule.gameplay.oldcore.display.SimpleProgressBar;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 塔基，能完成对已经开发塔的建造逻辑。 
	 * @author Administrator
	 * 
	 */	
	public final class ToftElement extends BasicBuildingElement
	{
		[Inject]
		public var sceneModel:ISceneDataModel;
		
		protected var myMeetingCenterPoint:PointVO = new PointVO(-50, 40);//本地
		
		protected var myTowerBuilderBar:SimpleProgressBar;
		
		private var _myBuildingTimrHandle:int = -1;
		
		private var _currentReadyToBuildTowerTypeId:int = -1;
		private var _currentBuilddingTowerElement:BasicTowerElement;
		
		public function ToftElement()
		{
			super();
		}
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			super.onPostConstruct();
			this.myElemeCategory = GameObjectCategoryType.TOFT;
			this.myObjectTypeId = sceneModel.sceneType;
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
			injector.injectInto(myBuildingCircleMenu);
			
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
				playSound(SoundID.Click_Toft);
				//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_TOWER_BASE,{"param":[],"target":this});
				//NewbieGuideManager.getInstance().startCondition(NewbieConst.CONDITION_START_CLICK_TOWER_BASE,{"param":[],"target":myBuildingCircleMenu});
			}
			super.onFocusChanged();
		}
		
		private function checkTypeChange():void
		{
			var sceneType:int = sceneModel.sceneType;
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
			timeTaskMgr.destoryTimeTask(_myBuildingTimrHandle);
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
				_currentBuilddingTowerElement = objPoolMgr.createSceneElementObject(GameObjectCategoryType.TOWER
					, _currentReadyToBuildTowerTypeId) as BasicTowerElement;
				
				_currentBuilddingTowerElement.x = this.x;
				_currentBuilddingTowerElement.y = this.y;
				_currentBuilddingTowerElement.buildingToft = this;
				
				playSound(getSoundId(SoundFields.Upgrade,0,towerModel.getTowerSheetById(_currentReadyToBuildTowerTypeId).objSound));
				
				sceneElementsModel.addSceneElemet(_currentBuilddingTowerElement);
				
				_myBuildingTimrHandle = timeTaskMgr.createTimeTask(GameFightConstant.TIME_UINT, 
					buiddingProgressHandler, null, 
					GameFightConstant.BUILDING_TOWER_DURATION / GameFightConstant.TIME_UINT,
					buiddingCompleteHandler);
			}
		}

		private function buiddingProgressHandler():void
		{
			myTowerBuilderBar.currentValue = timeTaskMgr.getTaskTimeTaskProgress(_myBuildingTimrHandle) * 100;
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
				//this.filters = [GameFilterManager.getInstance().colorNessMatrixFilter,new Glowimport release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
			}
		}
	}
}
import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.BasicBuildingCircleMenu;
import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.BuildingCircleItem;

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
		injector.injectInto(_buildingCircleItem0);
		_buildingCircleItem0.y = -50;
		addChild(_buildingCircleItem0);
		
		_buildingCircleItem1 = new BuildingCircleItem(113013, onCircleMenuItemBuildClick, this);
		injector.injectInto(_buildingCircleItem1);
		_buildingCircleItem1.x = -50;
		addChild(_buildingCircleItem1);
		
		_buildingCircleItem2 = new BuildingCircleItem(112007, onCircleMenuItemBuildClick, this);
		injector.injectInto(_buildingCircleItem2);
		_buildingCircleItem2.x = 50;
		addChild(_buildingCircleItem2);
		
		_buildingCircleItem3 = new BuildingCircleItem(111001, onCircleMenuItemBuildClick, this);
		injector.injectInto(_buildingCircleItem3);
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
		//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_BUILD_MENU,{"target":this});
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