package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	import mainModule.model.gameData.sheetData.towerLevelup.ITowerLevelupSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBufferAttacher;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.BasicBuildingCircleMenu;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	public class BasicBuildingElement extends BasicBufferAttacher implements IBuildingCircleMenuOwner
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var filterMgr:GameFilterManager;
		[Inject]
		public var towerModel:ITowerSheetDataModel;
		[Inject]
		public var towerData:ITowerDynamicDataModel;
		[Inject]
		public var towerLvlModel:ITowerLevelupSheetDataModel;
		
		protected var myIsMouseOver:Boolean = false;
		
		protected var myBuildingCircleMenu:BasicBuildingCircleMenu;
		protected var myBuildBuilddingAnimation:NewBitmapMovieClip;
		
		private var _hasSettedCircleMenuePosition:Boolean = false;
		
		private var _myNextRangeShape:Shape;
		
		public function BasicBuildingElement()
		{
			super();
		}
		
		//API
		public function showBuildingMenu():void
		{
			if(myBuildingCircleMenu != null)
			{
				myBuildingCircleMenu.show();	
			}
			
			//出现的时候要检测一次     
			notifySceneGoldUpdate();
		}
		
		public function hideBuildingMenu():void
		{
			myBuildingCircleMenu.hide();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			_myNextRangeShape = new Shape();
			addChild(_myNextRangeShape);
			createBuildingCircleMenu();
		}
		
		protected function createBuildingCircleMenu():void
		{
		}
		
		protected function playBuilddingEffect():void
		{
			destoryMyBuildBuilddingAnimation();
			myBuildBuilddingAnimation = new NewBitmapMovieClip(["BuildingEffect"]);
			injector.injectInto(myBuildBuilddingAnimation);
			myBuildBuilddingAnimation.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, destoryMyBuildBuilddingAnimation);
			addChild(myBuildBuilddingAnimation);			
		}
		
		private function destoryMyBuildBuilddingAnimation():void
		{
			if(myBuildBuilddingAnimation != null)
			{
				if(contains(myBuildBuilddingAnimation))
				{
					removeChild(myBuildBuilddingAnimation);
				}
				myBuildBuilddingAnimation.dispose();
				myBuildBuilddingAnimation = null;
			}
		}
		
		override protected function onLifecycleActivate():void 
		{
			super.onLifecycleActivate();
			
			this.addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			
			this.removeEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			
			eventDispatcher.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, sceneGoldUpdateHandler);
			
			myIsInFocus = false;
			myIsMouseOver = false;
			onMouseInAndOut2FocusChanged();
			_hasSettedCircleMenuePosition = false;
		}
		
		private function notifySceneGoldUpdate():void
		{
			if(myBuildingCircleMenu != null && myBuildingCircleMenu.isShowed)
			{
				myBuildingCircleMenu.notifySceneGoldUpdate();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();

			destoryMyBuildBuilddingAnimation();
			myBuildingCircleMenu.dispose();
			myBuildingCircleMenu = null;
		}
		
		override protected function onFocusChanged():void
		{
			if(myIsInFocus)
			{
				if(myFightState.bStun)
				{
					myIsInFocus = false;
					gameInteractiveMgr.setCurrentFocusdElement(null);
					return;
				}
				if(!_hasSettedCircleMenuePosition)
				{
					_hasSettedCircleMenuePosition = true;

					var p:Point = new Point(0, -myBodySkin.height / 2);
					p = fightViewModel.towerMenuLayer.globalToLocal(localToGlobal(p));
					
					if(myBuildingCircleMenu != null)
					{
						myBuildingCircleMenu.x = p.x;
						myBuildingCircleMenu.y = p.y;	
					}
				}
				
				if(myBuildingCircleMenu != null)
				{
					showBuildingMenu();
				}
				
				eventDispatcher.addEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, sceneGoldUpdateHandler);
			}
			else
			{
				if(myBuildingCircleMenu != null)
				{
					hideBuildingMenu();
				}
				isShowNextTowerRange(false,0);
				eventDispatcher.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, sceneGoldUpdateHandler);
			}

			onMouseInAndOut2FocusChanged();
		}
		
		private function sceneGoldUpdateHandler(event:Event):void
		{
			notifySceneGoldUpdate();
		}
		
		protected function onMouseInAndOut2FocusChanged():void
		{
			if(myIsInFocus || myIsMouseOver) 
			{
				if(!hasBuffer(BufferID.RdcTowerAtkSpd))
					this.myBodySkin.filters = [filterMgr.yellowGlowFilter];
			}
			else
			{
				if(!hasBuffer(BufferID.RdcTowerAtkSpd))
					this.myBodySkin.filters = null;
			}
		}
		
		override protected function onAddToStage():void
		{
			super.onAddToStage();
			
			if(myBuildingCircleMenu != null)
			{
				if(!fightViewModel.towerMenuLayer.contains(myBuildingCircleMenu))
				{
					fightViewModel.towerMenuLayer.addChild(myBuildingCircleMenu);	
				}
			}
		}
		
		override protected function onRemoveFromStage():void
		{
			super.onRemoveFromStage();

			if(myBuildingCircleMenu != null)
			{
				if(fightViewModel.towerMenuLayer.contains(myBuildingCircleMenu))
				{
					fightViewModel.towerMenuLayer.removeChild(myBuildingCircleMenu);	
				}
			}
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			if(myBuildBuilddingAnimation != null) 
				myBuildBuilddingAnimation.render(iElapse);
		}
		
		//IBuildingCircleMenuOwner Interface
		public function notifyCircleMenuOnBuild(typeId:int):void
		{
		}
		
		public function notifyCircleMenuOnSell():void
		{
		}
		
		public function notifyCircleMenuOnSkillUp(skillId:uint,iLvl:int):void
		{
			
		}
		
		public function notifyCircleMenuMouseOver(builderId:uint,bOver:Boolean):void
		{	
			var range:int = getNextTowerRange(builderId);
			if(range<=0)
				return;
			isShowNextTowerRange(bOver,range);
		}
		
		protected function getNextTowerRange(builderId:uint):int
		{
			var temp:ITowerSheetItem = towerModel.getTowerSheetById(builderId);
			if(!temp)
				return 0;
			var lvl:int = towerData.getTowerLevelByType(temp.type);
			if(lvl>1)
			{
				return temp.atkArea + towerLvlModel.getTowerLevelupSheetByLvl(lvl).getLevelupGrowth(temp.type)[1];
			}
			else
				return temp.atkArea;
		}
		
		private function isShowNextTowerRange(isShow:Boolean,range:int):void
		{
			_myNextRangeShape.graphics.clear();
			if(isShow && !myFightState.bStun)
			{
				_myNextRangeShape.graphics.lineStyle(3, getRangeBorderColor(), 0.15);
				_myNextRangeShape.graphics.beginFill(getRangeColor(), 0.15);
				_myNextRangeShape.graphics.drawEllipse(-range, -range*GameFightConstant.Y_X_RATIO, 
					range * 2, range*GameFightConstant.Y_X_RATIO * 2);
			}
			_myNextRangeShape.graphics.endFill();
		}
		
		protected function getRangeColor():uint
		{
			return 0x7da4b6;
		}
		
		protected function getRangeBorderColor():uint
		{
			return 0x054d8a;
		}
		
		//event Handlers========================================================
		private function mouseRollOverHandler(event:MouseEvent):void
		{
			myIsMouseOver = true;
			onMouseInAndOut2FocusChanged();
		}
		
		private function mouseRollOutHandler(event:MouseEvent):void
		{
			myIsMouseOver = false;
			onMouseInAndOut2FocusChanged();
		}
	}
}