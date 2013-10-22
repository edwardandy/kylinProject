package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicItem;
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.constant.TowerType;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.IOrganismSkiller;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerMultiUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerSingleUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus.TowerSkillUpdateLevelMenu;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;

	public class BasicTowerElement extends BasicBuildingElement implements IOrganismSkiller, ISkillOwner
	{	
		[Inject]
		public var sceneModel:ISceneDataModel;
		
		protected var myTowerInfo:ITowerDynamicItem;
		protected var myTowerTemplateInfo:ITowerSheetItem;
		
		protected var myBuilddingToft:ToftElement;
		private var _myRangeShape:Shape;
		
		
		//塔当前总价值
		private var _myTowerCostGold:uint = 0;
		private var _clickTime:int = 0;
		private var _needClickBuff:uint = 0;
		
		public function get myTowerCostGold():int
		{
			return _myTowerCostGold;
		}
		
		public function set buildingToft(toft:ToftElement):void
		{
			myBuilddingToft = toft;
		}
		
		public function BasicTowerElement(typeId:int)
		{
			super();
			myCampType = FightElementCampType.FRIENDLY_CAMP;
			this.myElemeCategory = GameObjectCategoryType.TOWER;
			this.myObjectTypeId = typeId;
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_MIDDLE;
			this.mouseEnabled = false;//after building
			myFocusTipEnable = true;
			myTowerTemplateInfo = towerModel.getTowerSheetById(typeId);
			myTowerInfo = towerData.getTowerDataById(typeId);
		}
		
		override public function get hurtPositionHeight():Number
		{
			return this.height;
		}
		
		override protected function onFocusChanged():void
		{
			super.onFocusChanged();	
			onFocusShowTowerRange(myIsInFocus);
			if(myIsInFocus)
			{
				//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_TOWER,{"param":[myObjectTypeId],"target":this});
				//NewbieGuideManager.getInstance().startCondition(NewbieConst.CONDITION_START_CLICK_TOWER,{"param":[myObjectTypeId],"target":myBuildingCircleMenu});
			}
		}
		
		protected function onFocusShowTowerRange(bShow:Boolean):void
		{
			isShowTowerRange(bShow);			
		}
		
		override public function get focusTips():String
		{
			return myTowerTemplateInfo.getName() ;//+ myTowerTemplateInfo.getDesc();
		}
		
		public final function getBuilddingToft():ToftElement
		{
			return myBuilddingToft;
		}

		public function buildedByToft(t:ToftElement):void
		{
			myBuilddingToft = t;
			completeBuilding();
		}
		
		public function buildedByTower(t:BasicTowerElement, additionalCostGold:uint):void
		{
			myBuilddingToft = t.getBuilddingToft();
			this.x = myBuilddingToft.x;
			this.y = myBuilddingToft.y;
			
			_myTowerCostGold += additionalCostGold;
			
			completeBuilding();
		}

		private function completeBuilding():void
		{
			changeToTargetBehaviorState(TowerBehaviorState.IDEL);
			playBuilddingEffect();
			playSound(getSoundId(SoundFields.Builded));
			//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_BUILD_TOWER,{"param":[myObjectTypeId],"target":this});
			//NewbieGuideManager.getInstance().startCondition(NewbieConst.CONDITION_START_BUILD_TOWER,{"param":[myObjectTypeId],"target":this});
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_myRangeShape = new Shape();
			addChild(_myRangeShape);
			addChild(_mySkillBufferBottomLayer);
			addChild(_mySkillBufferEffecstLayer);
		}
		
		override protected function createBuildingCircleMenu():void
		{
			if(myTowerTemplateInfo.level < 2)
			{
				myBuildingCircleMenu = new TowerSingleUpdateLevelMenu(this, myTowerTemplateInfo);
			}
			else if(myTowerTemplateInfo.level == 2)//这里会有多个
			{
				myBuildingCircleMenu = new TowerMultiUpdateLevelMenu(this, myTowerTemplateInfo);
			}
			else if(myTowerTemplateInfo.level == 3)
			{
				myBuildingCircleMenu = new TowerSkillUpdateLevelMenu(this, myTowerTemplateInfo);
			}
			
			if(myBuildingCircleMenu != null)
			{
				injector.injectInto(myBuildingCircleMenu);
				addChild(myBuildingCircleMenu);
			}
		}
		
		public function isShowTowerRange(isShow:Boolean):void
		{
			_myRangeShape.graphics.clear();
			if(isShow && !myFightState.bStun)
			{
				_myRangeShape.graphics.lineStyle(3, getRangeBorderColor(), 0.15);
				_myRangeShape.graphics.beginFill(getRangeColor(), 0.15);
				_myRangeShape.graphics.drawEllipse(-myFightState.atkArea, -myFightState.atkArea*GameFightConstant.Y_X_RATIO, 
					myFightState.atkArea * 2, myFightState.atkArea*GameFightConstant.Y_X_RATIO * 2);
			}
			_myRangeShape.graphics.endFill();
		}

		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myAttackCDTimer.resetCDTime();
			//重置塔的价值
			_myTowerCostGold = myTowerTemplateInfo.buyGold;
			
			if(myTowerTemplateInfo.level == 0)
			{
				changeToTargetBehaviorState(TowerBehaviorState.UN_BUILDED);
			}
			
			if(myTowerTemplateInfo.level == 3)
			{
				(myBuildingCircleMenu as TowerSkillUpdateLevelMenu).notifyLifecycleActive();
			}
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_clickTime = 0;
			_needClickBuff = 0;
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClickTower);
			if(myTowerTemplateInfo.level == 3)
			{
				(myBuildingCircleMenu as TowerSkillUpdateLevelMenu).notifyLifecycleFreeze();
			}
			
			stopClickEff();
		}
		
		override public function notifyCircleMenuOnBuild(typeId:int):void
		{
			var targetTowerElement:BasicTowerElement = objPoolMgr.createSceneElementObject(
				GameObjectCategoryType.TOWER, typeId) as BasicTowerElement;

			targetTowerElement.buildedByTower(this, _myTowerCostGold);
			
			this.destorySelf();
		}
		
		override public function notifyCircleMenuOnSell():void
		{
			if(myBuilddingToft != null)
			{
				myBuilddingToft.notifyBuildedInTowerOnSell();
				this.destorySelf();
				
				sceneModel.updateSceneGold(uint(_myTowerCostGold / 2));
			}
		}
		
		override public function notifyCircleMenuOnSkillUp(skillId:uint,iLvl:int):void
		{
			updateSkill(skillId,iLvl);	
		}

		override protected function onBufferAttached(buffId:uint):void
		{
			switch(buffId)
			{
				case BufferID.FreezeTower:
				case BufferID.NetTower:
				case BufferID.BurnTower:
				case BufferID.StickTower:
					_needClickBuff = buffId;
					addEventListener(MouseEvent.CLICK,onClickTower);
					playClickEff();
					break;
				case BufferID.RdcTowerAtkSpd:
					setBodyFilter([filterMgr.colorBlueMatrixFilter]);
					break;
			}
			super.onBufferAttached(buffId);
		}
		
		override protected function onBufferDettached(buffId:uint):void
		{
			switch(buffId)
			{
				case BufferID.FreezeTower:
				case BufferID.NetTower:
				case BufferID.BurnTower:
				case BufferID.StickTower:
					_needClickBuff = 0;
					_clickTime = 0;
					if(hasEventListener(MouseEvent.CLICK))
						removeEventListener(MouseEvent.CLICK,onClickTower);
					stopClickEff();
					break;
				case BufferID.RdcTowerAtkSpd:
					setBodyFilter(null);
					break;
			}
			super.onBufferDettached(buffId);
		}
		
		
		
		private function onClickTower(e:MouseEvent):void
		{
			_clickTime++;
			if(_clickTime>=3 && _needClickBuff>0)
				notifyDettachBuffer(_needClickBuff,false);
		}

		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case TowerBehaviorState.IDEL:
					if(myFightState.bStun)
						break;
					if(checkCanUseSkill())
						break;
					onRenderWhenIdelState();
					break;
				case TowerBehaviorState.ATTACKING:
					onRenderWhenAttacking();
				case TowerBehaviorState.USE_SKILL:
					onRenderWhenUseSkill();
					break;
			}

			super.render(iElapse);
		}
		
		//兵营自己不会攻击
		protected function onRenderWhenIdelState():void
		{
			//myAttackCDTimer.tick();

			if(myAttackCDTimer.getIsCDEnd(myFightState.extraCdTime))
			{
				if(mySearchedEnemy == null)
				{
					mySearchedEnemy = sceneElementsService.searchOrganismElementEnemy(this.x, this.y, myFightState.atkArea, 
							FightElementCampType.ENEMY_CAMP,
							necessarySearchConditionFilter);
					
					if(mySearchedEnemy != null)
					{
						changeToTargetBehaviorState(TowerBehaviorState.ATTACKING);
					}
					else
					{
						onNotSearchedEnemy();
					}
				}
			}
		}
		
		protected function onNotSearchedEnemy():void
		{
			if(myFightState.weaknessAtkState.bHasState)
			{
				if(myFightState.weaknessAtkState.lastTarget)
				{
					myFightState.weaknessAtkState.lastTarget.notifyDettachBuffer(BufferID.WeaknessShoot);
					myFightState.weaknessAtkState.lastTarget = null;
				}
				myFightState.weaknessAtkState.atkTimes = 0;
			}
		}
		
		protected function onRenderWhenAttacking():void
		{
			
		}
		
		override protected function onBehaviorStateChanged():void
		{
			this.mouseEnabled = currentBehaviorState != TowerBehaviorState.UN_BUILDED;
			if(currentBehaviorState != TowerBehaviorState.ATTACKING) mySearchedEnemy = null;
			
			switch(currentBehaviorState)
			{
				case TowerBehaviorState.UN_BUILDED:
					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.BUILDDING);
					break;
				
				case TowerBehaviorState.ATTACKING:
					onBehaviorChangeToAttacking();
					break;
				case TowerBehaviorState.USE_SKILL:
					onBehaviorChangeToUseSkill();
					break;
			}
		}
		
		protected function onBehaviorChangeToAttacking():void
		{
			myAttackCDTimer.resetCDTime();
			fireToTargetEnemy();
			playAttackSound();
		}
		
		protected function playAttackSound():void
		{
			playSound(getSoundId(SoundFields.Attack));
		}
		
		override public function dispose():void
		{
			super.dispose();

			myBuilddingToft = null;
			myTowerInfo = null;
		}
		
		protected function necessarySearchConditionFilter(taget:BasicOrganismElement):Boolean
		{
			return false;
		}
		
		protected function onFireAnimationTimeHandler():void
		{
		}
		
		protected function onFireAnimationEndHandler():void
		{
			changeToTargetBehaviorState(TowerBehaviorState.IDEL);
		}
		
		override protected function getBaseFightInfo():IBaseFighterSheetItem
		{
			return myTowerTemplateInfo;
		}
		//技能相关
		override protected function getCanUseSkills():void
		{
			/*mySkillIds = [];
			for each(var id:uint in myTowerInfo.skillIds)
			{
				mySkillIds.push(id);
			}*/
		}
		
		override protected function processPassiveSkills():void
		{
			
		}
		
		override protected function initFightState():void
		{		
			myFightState.baseAtkArea = myTowerTemplateInfo.atkArea;
			myFightState.range = myTowerTemplateInfo.atkRange;
			myFightState.minAtk = myTowerTemplateInfo.minAtk;
			myFightState.maxAtk = myTowerTemplateInfo.maxAtk;
			myFightState.cdTime = myTowerTemplateInfo.atkInterval/*(1 - EndlessBattleMgr.instance.addAtkSpdPct*0.01)*/;
			myFightState.weapon = myTowerTemplateInfo.weapon;
			myFightState.atkType = myTowerTemplateInfo.atkType;
			var lvl:int = towerData.getTowerLevelByType(myTowerTemplateInfo.type);
			
			if(TowerType.Barrack != myTowerTemplateInfo.type)
			{
				var addAtk:Number = 1;
				if(lvl>1)
				{
					var arrGrowth:Array = towerLvlModel.getTowerLevelupSheetByLvl(lvl).getLevelupGrowth(myTowerTemplateInfo.type)
					myFightState.baseAtkArea += arrGrowth[1];
					addAtk += arrGrowth[0]*0.01;
				}
				//addAtk += GlobalTemp.spiritTowerAttackAddition*0.01;
				
				var addAtk2:Number = 1/*+EndlessBattleMgr.instance.addAtkPct*0.01*/;
				myFightState.minAtk *= addAtk * addAtk2;
				myFightState.maxAtk *= addAtk * addAtk2;
			}
			
		}
		
		public function get towerType():int
		{
			return myTowerTemplateInfo?myTowerTemplateInfo.type:0;
		}
		
		public function addEndlessBuff(atkPct:Number,atkSpdPct:int):void
		{
			if(0 != atkPct)
			{
				/*var lvAtk:int = 0;
				var lv:TowerLevelVo = TowerData.getInstance().getTowerLevelVoByTowerType(myTowerTemplateInfo.type);
				if(lv)
					lvAtk = TowerData.getInstance().getTowerAtkByTypeAndLevel(myTowerTemplateInfo.type,lv.level);
				var addAkt:Number = 1+EndlessBattleMgr.instance.addAtkPct*0.01;
				myFightState.minAtk = myTowerTemplateInfo.baseAtk*(1 + (lvAtk+GlobalTemp.spiritTowerAttackAddition) * 0.01) * addAkt;
				myFightState.maxAtk = myTowerTemplateInfo.maxAtk*(1 + (lvAtk+GlobalTemp.spiritTowerAttackAddition) * 0.01) * addAkt;*/
			}
			
			if(0 != atkSpdPct)
			{
				//myAttackCDTimer.setDurationTime(myAttackCDTimer.duration - (myTowerTemplateInfo.cdTime * atkSpdPct*0.01));
			}
		}
		
		override protected function onSkillDisappearAnimEnd():void
		{
			changeToTargetBehaviorState(TowerBehaviorState.IDEL);
		}
		
		override protected function onFarAttackTarget(target:ISkillTarget):void
		{
			var dmg:int = getDmgBeforeHurtTarget(false,target as BasicOrganismElement);
			target.hurtSelf(dmg,atkType,this);
			areaAttack(target,dmg,myFightState.range);
			if(target.isAlive)
				checkSpecialSkillBeforeAttack(target);
		}
		
		override protected function searchCanAreaAtkTargets(e:BasicOrganismElement):Boolean
		{
			return necessarySearchConditionFilter(e);
		}
		
		override public function stunSlef(bEnable:Boolean,owner:ISkillOwner):Boolean
		{
			if(bEnable)
				++myFightState.iStun;
			else
				--myFightState.iStun;
			return true;
		}
		
		override public function get type():int
		{
			return FocusTargetType.ATTACK_TOWER_TYPE;
		}
		
		override public function get targetName():String
		{
			return myTowerTemplateInfo.getName();
		}
		
		override public function get curLevel():int
		{
			return towerData.getTowerLevelByType(myTowerTemplateInfo.type);
		}
		
		override protected function cancleUseSkillState():void
		{
			changeToTargetBehaviorState(TowerBehaviorState.IDEL);
		}
		
		override protected function isNotUseSkillState():Boolean
		{
			return TowerBehaviorState.USE_SKILL != currentBehaviorState;
		}
		
		override protected function getDefaultSoundObj():Object
		{
			return myTowerTemplateInfo?myTowerTemplateInfo.objSound:null;
		}
	}
}