package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mainModule.model.gameData.sheetData.groundEff.IGroundEffSheetDataModel;
	import mainModule.model.gameData.sheetData.groundEff.IGroundEffSheetItem;
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	import mainModule.model.gameData.sheetData.interfaces.IBaseMoveFighterSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.FightUnitType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.OrganismBodySizeType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.constant.TowerType;
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.SimpleProgressBar;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBufferAttacher;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.cannonTowers.LongXiTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.SpecialBufferRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.dieEffect.BasicDieEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SummonByOrganisms;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SupportSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.GameFightMoveLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.MoveState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveLogic;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightSuccessAndFailedDetector;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	/**
	 * 此类为场景战斗对象的核心类，实现了两方阵营大部分的战斗状态逻辑 
	 * @author Administrator
	 * 
	 */	
	public class BasicOrganismElement extends BasicBufferAttacher implements ISkillOwner, IMoveUnit
	{
		[Inject]
		public var moveLogicMgr:GameFightMoveLogicMgr;
		[Inject]
		public var sceneModel:ISceneDataModel;
		[Inject]
		public var successAndFailedDetector:GameFightSuccessAndFailedDetector;
		[Inject]
		public var groundEffModel:IGroundEffSheetDataModel
		[Inject]
		public var filterMgr:GameFilterManager;
		//单位模板信息
		protected var myMoveFighterInfo:IBaseMoveFighterSheetItem;		
		
		//单位尺寸
		private var _myBodySizeType:int = -1;
		private var _myBodySize:uint = 0;
		
		private var _myBodyWidth:uint = 0;
		private var _myBodyHeight:uint = 0;
		//是否远程攻击
		//private var _myIsFarAttackable:Boolean = false;
		
		//下面3个特效的父层		
		private var _mySpecialEffectAnimationsLayer:Sprite = null;
		//友方加血特效
		private var _benefitBloodEffectAnimation1:NewBitmapMovieClip;
		//怪物加血特效
		private var _benefitBloodEffectAnimation2:NewBitmapMovieClip;
		//伤血特效
		private var _hurtBloodEffectAnimation:NewBitmapMovieClip;
		
		//复活特效
		private var _rebirthAnim:NewBitmapMovieClip;
		protected var _bNeedRebirthAnim:Boolean = false;
		//复活方式，0为默认，1为士兵原地复活
		protected var _iRebirthType:int = 0;
		
		//血槽
		private var _myBloodBar:SimpleProgressBar = null;
		private var _myFocusShape:Shape;
		
		//移动导航点
		protected var myAppointPoint:PointVO = new PointVO();
		//死亡方式
		protected var _myCurrentDieType:int = OrganismDieType.NORMAL_DIE;
		
		//延迟伤害，被龙卷风吹回退后的效果
		private var _isDelayHurtFlag:Boolean = false;
		private var _delayHurtBloodValue:uint = 0;//在怪物出现后给予造成的伤害
		private var _delayHurtAttackType:int = -1;
		private var _delayIsMonomerHurt:Boolean = false;
		//出现效果，被风吹回或被传送
		private var _isAutoAppearFlag:Boolean = false;
		private var _isNeedPlayAppearAnim:Boolean = false;
		private var _AppearDisappearAnim:NewBitmapMovieClip;
		
		//尸体停留时间
		private var _dieBodyStayCDTimer:SimpleCDTimer;
		private var _dieStepType:int = -1;
		//外界控制移动
		protected var _isRecieverdersMoveMode:Boolean = false;
		
		//移动状态
		protected var myMoveState:MoveState;
		protected var myMoveLogic:IMoveLogic;
		
		public function BasicOrganismElement(typeId:int)
		{
			super();
			this.myObjectTypeId = typeId;
			myMoveState = new MoveState(this);
			myMoveLogic = moveLogicMgr.getMoveLogicByCategoryAndId(myElemeCategory,myObjectTypeId);
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_MIDDLE;
			this.buttonMode = true;	
			myFocusTipEnable = true;
		}
		
		/***********************************************************************************
		 * ***************************  生命周期  **********************************************
		 * *************************************************************/	
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_myBodySizeType = myMoveFighterInfo.size;
			
			_myBodySize = _myBodySizeType == OrganismBodySizeType.SIZE_BIG ?
				GameFightConstant.BIG_ORGANISMELEMENT_BODY_SIZE :
				(_myBodySizeType == OrganismBodySizeType.SIZE_NORMAL ? 
					GameFightConstant.NORMAL_ORGANISMELEMENT_BODY_SIZE : 
					GameFightConstant.SMALL_ORGANISMELEMENT_BODY_SIZE);
			
			_myBodyWidth = myBodySkin.iFirstFrameWidth;//.getFrameInfo(1).bitmapData.width;
			_myBodyHeight = myBodySkin.iFirstFrameHeight;//.getFrameInfo(1).bitmapData.height;
			
			myFireLocalPoint.x = myBodyWidth>>1;
			myFireLocalPoint.y = /*fightState.isFlyUnit ? -(_myBodyHeight/2 + GameFightConstant.FLY_UNIT_OFF_HEIGTH):*/-(myBodyHeight>>1);
			
			myIdelAnimationCDTimer = new SimpleCDTimer(0);	
			_dieBodyStayCDTimer = new SimpleCDTimer(GameFightConstant.NORMAL_DIE_BODY_STAY_TIME);
			
			_mySpecialEffectAnimationsLayer = new Sprite();
			_mySpecialEffectAnimationsLayer.mouseEnabled = false;
			_mySpecialEffectAnimationsLayer.mouseEnabled = false;
			addChild(_mySpecialEffectAnimationsLayer);
			
			_benefitBloodEffectAnimation1 = new NewBitmapMovieClip(["BenefitBloodEffect_1"]);
			injector.injectInto(_benefitBloodEffectAnimation1);
			_benefitBloodEffectAnimation2 = new NewBitmapMovieClip(["BenefitBloodEffect_2"]);
			injector.injectInto(_benefitBloodEffectAnimation2);
			_hurtBloodEffectAnimation = new NewBitmapMovieClip(["HurtBloodEffect"]);
			injector.injectInto(_hurtBloodEffectAnimation);
			_benefitBloodEffectAnimation1.visible = _benefitBloodEffectAnimation2.visible = _hurtBloodEffectAnimation.visible = false;
			
			_hurtBloodEffectAnimation.y = myFireLocalPoint.y;
			_mySpecialEffectAnimationsLayer.addChild(_benefitBloodEffectAnimation1);
			_mySpecialEffectAnimationsLayer.addChild(_benefitBloodEffectAnimation2);
			_mySpecialEffectAnimationsLayer.addChild(_hurtBloodEffectAnimation);
			
			
			var bloodBarWidth:int = _myBodySizeType == OrganismBodySizeType.SIZE_BIG ? 41 :
				(_myBodySizeType == OrganismBodySizeType.SIZE_MIDDLE ? 28 : 20);
			myFightState.curLife = myFightState.maxlife;
			_myBloodBar = new SimpleProgressBar(myFightState.curLife, myFightState.maxlife, 
				GameFightConstant.BLOOD_BAR_COLOR_GREEN,
				GameFightConstant.BLOOD_BAR_COLOR_RED,
				bloodBarWidth,2,true,GameFightConstant.BLOOD_BAR_COLOR_BORDER);
			
			_myBloodBar.y = -bodyHeight;
			addChild(_myBloodBar);
			
			_myFocusShape = new Shape();
			addChildAt(_myFocusShape, 0);	
		}
		
		override protected function createBodySkin():void
		{
			var dieBloodDisappearAnimationDatas:Vector.<BitmapFrameInfo>;
			if(fightUnitType == FightUnitType.LAND)//空中单位死亡后没有血迹
			{
				//dieBloodDisappearAnimationDatas = ObjectPoolManager.getInstance().getBitmapFrameInfos("Common_Death_Effect_1", myScaleRatioType);
				myBodySkin = new NewBitmapMovieClip([bodySkinResourceURL,"Common_Death_Effect_1"], [myScaleRatioType,myScaleRatioType]);
			}
			else
			{
				myBodySkin = new NewBitmapMovieClip([bodySkinResourceURL], [myScaleRatioType]);
			}
			injector.injectInto(myBodySkin);
			addChild(myBodySkin);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
		}
		
		override protected function initStateWhenActive():void
		{
			//要放在前面，因为父类操作中会处理增加移动速度的被动技能
			myMoveState.unit = this;
			myMoveState.mySpeed = GameMathUtil.secondSpeedToFrameMoveSpeed( myMoveFighterInfo.moveSpd);
			
			super.initStateWhenActive();
			
			myMoveLogic.initMoveUnitByState(myMoveState);
			_lastWalkPt.x = x;
			_lastWalkPt.y = y;
			if(0 == myFightState.baseAtkArea) 
				myFightState.baseAtkArea = GameFightConstant.NEAR_ATTACK_RANGE;
			if(myFightState.searchArea<=0)
				myFightState.searchArea = GameFightConstant.SEARCH_ENEMY_RANGE;
			myFightState.isFlyUnit = myMoveFighterInfo.type == 2;
			myResurrectionCDTimer = new SimpleCDTimer(myFightState.rebirthTime);
			
			resetBooldBar();
			
			_myBloodBar.visible = true;
			_isAutoAppearFlag = false;
			_isRecieverdersMoveMode = false;
			_myCurrentDieType = OrganismDieType.NORMAL_DIE;
			myIdelAnimationCDTimer.setDurationTime(uint(GameMathUtil.randomFromValues([3000, 4000, 5000])));
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_dieStepType = -1;
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean = false):void
		{
			super.clearStateWhenFreeze(bDie);
			
			

			clearDelayHurt();
			
			/*if(currentSearchedEnemy != null)
			{
			currentSearchedEnemy.notifyBeUnBlockedByEnemy(this);
			}
			
			setSearchedEnemy(null);*/
			resetSearchState();
			
			if(_benefitBloodEffectAnimation1.visible)
			{
				_benefitBloodEffectAnimation1.visible = false;
				_benefitBloodEffectAnimation1.gotoAndStop2(1);
			}
			
			if(_benefitBloodEffectAnimation2.visible)
			{
				_benefitBloodEffectAnimation2.visible = false;
				_benefitBloodEffectAnimation2.gotoAndStop2(1);
			}
			
			if(_hurtBloodEffectAnimation.visible)
			{
				_hurtBloodEffectAnimation.visible = false;
				_hurtBloodEffectAnimation.gotoAndStop2(1);
			}
			
			if(_rebirthAnim && _mySpecialEffectAnimationsLayer.contains(_rebirthAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_rebirthAnim);
			if(_rebirthAnim)
				_rebirthAnim.visible = false;
			
			if(_AppearDisappearAnim && _mySpecialEffectAnimationsLayer.contains(_AppearDisappearAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_AppearDisappearAnim);
			if(_AppearDisappearAnim)
				_AppearDisappearAnim.visible = false;
			//怪物死亡后有可能复活，所以不能把路径信息清除
			myMoveLogic.pauseWalk(myMoveState);
			if(!bDie)
			{
				myMoveLogic.stopWalk(myMoveState);
				myMoveState.clear();
			}
			
			clearAllEffTowers();
			clearAllEffSoldiers();
			_groundEffTemp = null;
			
			showSlefSheep(false);
			
			clearSkillChantState();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myAppointPoint = null;
			
			removeChild(_myBloodBar);
			_myBloodBar = null;
			
			removeChild(_myFocusShape);
			_myFocusShape = null;
			
			_mySpecialEffectAnimationsLayer.removeChild(_benefitBloodEffectAnimation1);
			_benefitBloodEffectAnimation1.dispose();
			_benefitBloodEffectAnimation1 = null;
			
			_mySpecialEffectAnimationsLayer.removeChild(_benefitBloodEffectAnimation2);
			_benefitBloodEffectAnimation2.dispose();
			_benefitBloodEffectAnimation2 = null;
			
			_mySpecialEffectAnimationsLayer.removeChild(_hurtBloodEffectAnimation);
			_hurtBloodEffectAnimation.dispose();
			_hurtBloodEffectAnimation = null;
			
			if(_rebirthAnim && _mySpecialEffectAnimationsLayer.contains(_rebirthAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_rebirthAnim);
			if(_rebirthAnim)
				_rebirthAnim.dispose();
			_rebirthAnim = null;
			
			if(_AppearDisappearAnim && _mySpecialEffectAnimationsLayer.contains(_AppearDisappearAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_AppearDisappearAnim);
			if(_AppearDisappearAnim)
				_AppearDisappearAnim.dispose();
			_AppearDisappearAnim = null;
			
			removeChild(_mySpecialEffectAnimationsLayer);
			_mySpecialEffectAnimationsLayer = null;
			
			myMoveState.dispose();
			myMoveState = null;
			myMoveLogic = null;
		}
		
		/**
		 * 获得所有拥有的技能
		 */
		override protected function getCanUseSkills():void
		{
			mySkillIds = myMoveFighterInfo.skillIds.concat();
			
		}
		
		override protected function initFightState():void
		{
			myFightState.baseAtkArea = myMoveFighterInfo.atkArea;
			myFightState.searchArea = myMoveFighterInfo.searchArea;
			myFightState.range = myMoveFighterInfo.atkRange;
			myFightState.cdTime = myMoveFighterInfo.atkInterval;
			myFightState.magicDefense = myMoveFighterInfo.magicDef;
			myFightState.maxAtk = myMoveFighterInfo.maxAtk;
			myFightState.maxlife = myMoveFighterInfo.life;
			myFightState.minAtk = myMoveFighterInfo.minAtk;
			myFightState.physicDefense = myMoveFighterInfo.physicDef;
			myFightState.atkType = myMoveFighterInfo.atkType;
			myFightState.weapon = myMoveFighterInfo.weapon;
		}
		
		protected function resetBooldBar():void
		{
			myFightState.curLife = myFightState.maxlife;
			_myBloodBar.maxValue = myFightState.getRealMaxLife();
			_myBloodBar.currentValue = myFightState.curLife;
		}
		
		/****************************************************************
		 * *************************** 基本属性   **************************
		 * **************************************************************/
		
		public function get bodySize():uint
		{
			return _myBodySize;
		}
		
		//是否可远程攻击
		public final function get isFarAttackable():Boolean
		{
			return myFightState.atkArea > GameFightConstant.NEAR_ATTACK_RANGE;
		}
		
		//获取伤害高度
		override public function get hurtPositionHeight():Number
		{
			return bodyHeight / 2 /*myFightState.isFlyUnit ?
				bodyHeight / 2 + GameFightConstant.FLY_UNIT_OFF_HEIGTH :
				bodyHeight / 2;*/
		}
		
		protected function get myBodyHeight():int
		{
			return (myBodySkin && myBodySkin.height>0)?myBodySkin.height:(_myBodyHeight*myBodySkin.scaleY);
		}
		
		protected function get myBodyWidth():int
		{
			return (myBodySkin && myBodySkin.width>0)?myBodySkin.width:(_myBodyWidth*myBodySkin.scaleX);
		}
		
		//身体高度
		public final function get bodyHeight():Number
		{
			return myFightState.isFlyUnit ?
				myBodyHeight + GameFightConstant.FLY_UNIT_OFF_HEIGTH :
				myBodyHeight;
		}
		
		//身体宽度
		public final function get bodyWidth():uint
		{
			return myBodyWidth;
		}
		
		override public function get isAlive():Boolean
		{
			return parent != null &&//在现实列表
				myFightState.curLife > 0 && 
				isActivedOrganismBehaviorState();
		}
		
		private function isActivedOrganismBehaviorState():Boolean
		{
			return currentBehaviorState < OrganismBehaviorState.RESURRECTION;
		}

		//是否可以被所单个所有， 如果这里是范围攻击的话这里是会搜到的
		public final function getIsSearchable():Boolean
		{
			return !_isRecieverdersMoveMode && !myFightState.bInvisible;
		}
		
		override protected function getBaseFightInfo():IBaseFighterSheetItem
		{
			return myMoveFighterInfo;
		}
		
		override public function get fightUnitType():int
		{
			return myMoveFighterInfo.type;
		}
		
		protected function set bloodBarY(iY:int):void
		{
			_myBloodBar.y = iY;
		}

		/****************************************************************
		 * *************************** 战斗逻辑方法   **************************
		 * **************************************************************/
		/*override public function notifyHurtTagetOnkill(beHurtTarget:BasicOrganismElement, finalHurtValue:uint):void
		{
			notifyTriggerSkillAndBuff(TriggerConditionType.KILL_TARGET_OR_ATTACKED_BY_TOWER);
			notifyTriggerSkillAndBuff(TriggerConditionType.KILL_TARGET);
			if(myCampType == FightElementCampType.FRIENDLY_CAMP && !myFightState.betrayState.bBetrayed 
				&& beHurtTarget.campType == FightElementCampType.ENEMY_CAMP && !beHurtTarget.fightState.betrayState.bBetrayed)
			{
				if(beHurtTarget is BasicMonsterElement)
				{
					onkillEnemyCampTypeMonster(BasicMonsterElement(beHurtTarget));
				}
			}
		}*/
		
		override public function notifyHurtTagetOnkill(beHurtTarget:BasicOrganismElement, finalHurtValue:uint):void
		{
			
		}
		
		protected function onkillEnemyCampTypeMonster(monster:BasicMonsterElement):void
		{

		}
		
		//hurt==================================================================
		public function hurtBlood(value:uint,
										attackType:int = FightAttackType.PHYSICAL_ATTACK_TYPE,
								   		isMonomerHurt:Boolean = true,//是否为单体伤害
								   		byTarget:ISkillOwner = null, 
										isDirectDethMode:Boolean = false,
								   		hurtedDeathType:int = OrganismDieType.NORMAL_DIE,
										scaleValue:Number = 1,beKillAll:Boolean = false,bNormalAttack:Boolean = false/*是否普通攻击*/):void
		{
			if(!isAlive) 
				return;
			if(myFightState.bInvincible && !beKillAll)
				return;
			
			if(beKillAll)
				isDirectDethMode = true;

			if(isDirectDethMode)
			{
				myFightState.curLife = 0;
			}
			else
			{
				notifyTriggerSkillAndBuff(TriggerConditionType.BEFORE_UNDER_ATTACK);
				//格挡或闪避
				if(myFightState.bBlock && FightAttackType.PHYSICAL_ATTACK_TYPE == attackType)
				{
					onBlockAttack();
					return;
				}
				
				var hurtValue:uint = caculateResultHurtValue(value, attackType,byTarget,bNormalAttack);
				
				if(hurtValue == 0)
				{
					createSceneTipEffect(SceneTipEffect.SCENE_TIPE_MISS, this.x, this.y - bodyHeight);	
					return;
				}
				//民兵的不屈
				if(myFightState.rdcDmgByLifeDownState.bHasState && myFightState.getCurLifePct() < myFightState.rdcDmgByLifeDownState.iLifeLimitPct)
				{
					hurtValue -= hurtValue * myFightState.rdcDmgByLifeDownState.iDmgRdcPct/100;
				}
				//反伤
				if(myFightState.iReboundDmgPct>0 && byTarget && !byTarget.isBoss)
				{
					var reboundDmg:int = hurtValue * myFightState.iReboundDmgPct/100;
					byTarget.hurtSelf(reboundDmg,attackType,this);
				}
				
				if(byTarget && myFightState.iDmgFromCategoryPct > 0 && (0 == myFightState.iRdcDmgFromCategory || (myFightState.iRdcDmgFromCategory>0  
					&& (myFightState.iRdcDmgFromCategory & byTarget.subjectCategory)>0)))
				{
					hurtValue -= hurtValue * myFightState.iDmgFromCategoryPct/100;
				}
				
				if(byTarget && myFightState.iFireMoreDmgPct>0)
				{
					if(byTarget is LongXiTowerElement)
					{
						if(!hasBuffer(BufferID.Burning))
						{
							var param:Object = {};
							param[BufferFields.BUFF] = BufferID.Burning;
							param[BufferFields.DURATION] = 1000;
							param[SkillResultTyps.SPECIAL_PROCESS] = 1;
							notifyAttachBuffer(BufferID.Burning,param,byTarget);
						}
						hurtValue += hurtValue * myFightState.iFireMoreDmgPct/100;
					}
				}
				
				if(myFightState.curLife <= hurtValue)
					notifyTriggerSkillAndBuff(TriggerConditionType.BEFORE_DIE);
				
				if(myFightState.safeLaunchState.hasSafeLaunch)
				{
					onSafeLaunch(myFightState.safeLaunchState.atkArea,myFightState.safeLaunchState.dmg,myFightState.safeLaunchState.stunTime,
						myFightState.safeLaunchState.fallAtkArea,myFightState.safeLaunchState.fallDmg);
					myFightState.safeLaunchState.dispose();
					return;
				}
				
				if(byTarget is BasicTowerElement)
					notifyTriggerSkillAndBuff(TriggerConditionType.KILL_TARGET_OR_ATTACKED_BY_TOWER);
				
				if(myFightState.iIceShield>0)
				{
					if(myFightState.iIceShield>hurtValue)
					{
						myFightState.iIceShield -= hurtValue;
						return;
					}
					else
					{
						hurtValue -= myFightState.iIceShield;
						myFightState.iIceShield = 0;
						RemoveIceShield();
					}
				}
				
				if(myFightState.iDmgUnderAtkPct != 0)
				{
					hurtValue += hurtValue*myFightState.iDmgUnderAtkPct/100;
				}
				
				if(hurtValue>0 && scaleValue != 1)
				{
					hurtValue *= scaleValue;
					if(hurtValue<1)
						hurtValue = 1;
				}
				
				if(hurtValue >= myFightState.curLife) 
					hurtValue = myFightState.curLife;
								
				myFightState.addLife(-hurtValue);
				_myBloodBar.currentValue = myFightState.curLife;
				
				if(hurtValue>0 && byTarget)
					onHurtedEff(hurtValue,byTarget);
				
				if(myFightState.curLife>0 && hurtValue>0)
					notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_UNDER_ATTACK);
			}
			
			var isEmptyBlood:Boolean = myFightState.curLife == 0;
			
			if(isEmptyBlood)
			{
				_myCurrentDieType = hurtedDeathType;
				
				if(OrganismDieType.NORMAL_DIE == _myCurrentDieType && hasBuffer(BufferID.Freeze))
				{
					_myCurrentDieType = OrganismDieType.FREEZE_DIE;
				}
				
				if(isHero || isBoss)
					_myCurrentDieType = OrganismDieType.NORMAL_DIE;
				
				if(myCampType == FightElementCampType.ENEMY_CAMP && (this is BasicMonsterElement))
				{
					
					sceneModel.updateSceneGold((this as BasicMonsterElement).monsterTemplateInfo.rewardGoods);
					if(!byTarget || GameObjectCategoryType.HERO != byTarget.elemeCategory)
						GameAGlobalManager.getInstance().game.gameFightMainUIView.playAddGoodsAnim(0,-bodyHeight,(this as BasicMonsterElement).monsterTemplateInfo.rewardGoods,this,false,0xecda3e);
				}
				
				if(byTarget != null && byTarget.isAlive) 
					byTarget.notifyHurtTagetOnkill(this, hurtValue);	

				dispatchLeaveOffScreenSearchRangeEvent();
				changeToTargetBehaviorState(OrganismBehaviorState.DYING);
			}
			else
			{
				if(attackType == FightAttackType.PHYSICAL_ATTACK_TYPE && isMonomerHurt)//单体 物理伤害需要掉血动画
				{
					playHurtBloodEffect();
				}
			}
		}
		
		protected function onHurtedEff(hurtValue:int,owner:ISkillOwner):void
		{
			
		}
		
		//isEffectType2 是指的是 圣光加血，默认是自然加血
		public final function benefitBlood(value:uint, isPlayEffect:Boolean = true, isEffectType2:Boolean = false):void
		{
			if(!isAlive) return;
			
			var benefitValue:uint = value;
			if(benefitValue >= myFightState.maxlife - myFightState.curLife) benefitValue = myFightState.maxlife - myFightState.curLife;
			
			if(benefitValue == 0) return;
			
			if(isPlayEffect)
			{
				playBenefitBloodEffect(isEffectType2);
			}

			myFightState.addLife(benefitValue);
			_myBloodBar.currentValue = myFightState.curLife;
		}
		
		public final function benefitBlood2(maxBloodPercent:Number, isPlayEffect:Boolean = true, isEffectType2:Boolean = false):void
		{
			benefitBlood(myFightState.maxlife * maxBloodPercent, isPlayEffect, isEffectType2);
		}
		
		/**
		 * 播放加血特效
		 */
		private function playBenefitBloodEffect(isEffectType2:Boolean):void
		{
			if(isEffectType2)
			{
				_benefitBloodEffectAnimation2.visible = true;
				_benefitBloodEffectAnimation2.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, benefitBloodEffectAnimationEndHandler);
				
				_benefitBloodEffectAnimation1.visible = false;
				_benefitBloodEffectAnimation1.gotoAndStop2(1);
			}
			else
			{
				_benefitBloodEffectAnimation1.visible = true;
				
				_benefitBloodEffectAnimation2.visible = false;
				_benefitBloodEffectAnimation2.gotoAndStop2(1);
				
				_benefitBloodEffectAnimation1.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, benefitBloodEffectAnimationEndHandler);
			}
		}
		
		private function benefitBloodEffectAnimationEndHandler():void
		{
			_benefitBloodEffectAnimation1.visible = false;
			_benefitBloodEffectAnimation2.visible = false;
		}
		
		private function playHurtBloodEffect():void
		{
			_hurtBloodEffectAnimation.visible = true;
			_hurtBloodEffectAnimation.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, hurtBloodEffectAnimationEndHandler);
		}
		
		private function hurtBloodEffectAnimationEndHandler():void
		{
			if(_hurtBloodEffectAnimation)
				_hurtBloodEffectAnimation.visible = false;
		}
		
		protected function caculateResultHurtValue(value:int, attackType:int,byTarget:ISkillOwner,bNormalAttack:Boolean):uint
		{
			if(myFightState.bInvincible) 
				return 0;
			if(myFightState.bSheep ||(bNormalAttack && byTarget && byTarget.fightState.bIgnoreNormalDef))
				return value;
			
			if(attackType == FightAttackType.MAGIC_ATTACK_TYPE)
			{
				value = Math.round(value * (100 - myFightState.totalMagicDefense) * 0.01);
			}
			else if(attackType == FightAttackType.PHYSICAL_ATTACK_TYPE)
			{
				value = Math.round(value * (100 - myFightState.totalPhysicDefense) * 0.01);
			}
			
			return value<0 ? 0 : value;
		}
		
		//被敌人发现并锁定
		public function notifyBeBlockedByEnemy(target:BasicOrganismElement):void
		{
			if(myCampType != FightElementCampType.ENEMY_CAMP || target.isSameCampType(this) || myFightState.bSheep || myFightState.isFlyUnit) 
				return;

			//只有在这两种情况下才会被锁定
			if(currentBehaviorState == OrganismBehaviorState.ENEMY_ESCAPING || currentBehaviorState == OrganismBehaviorState.IDLE)
			{
				if(mySearchedEnemy == null)
				{
					setSearchedEnemy(target);
					changeToTargetBehaviorState(OrganismBehaviorState.BE_FINED_AND_LOCKED_BY_ENEMY);
				}
			}
			else if(currentBehaviorState == OrganismBehaviorState.FAR_FIHGTTING)
			{
				setSearchedEnemy(target);
				changeToTargetBehaviorState(OrganismBehaviorState.BE_FINED_AND_LOCKED_BY_ENEMY);
			}
			else if(currentBehaviorState == OrganismBehaviorState.USE_SKILL)
			{
				if(mySearchedEnemy == null)
				{
					setSearchedEnemy(target);
				}
			}
			else if(currentBehaviorState == OrganismBehaviorState.MOVING_TO_ENEMY_NEAR_BY)
			{
				if(mySearchedEnemy && !mySearchedEnemy.isTargetEnemy(this))
				{
					setSearchedEnemy(target);
					changeToTargetBehaviorState(OrganismBehaviorState.BE_FINED_AND_LOCKED_BY_ENEMY);
				}
			}
		}

		//通知该对象可以战斗了
		public final function notifyNearFighttingWithCurrentEnemy(target:BasicOrganismElement):void
		{
			if(myCampType != FightElementCampType.ENEMY_CAMP ||
				target.isSameCampType(this) ||
				myFightState.isFlyUnit ||
				currentBehaviorState != OrganismBehaviorState.BE_FINED_AND_LOCKED_BY_ENEMY) 
				return;

			if(mySearchedEnemy == target)
			{
				changeToTargetBehaviorState(OrganismBehaviorState.NEAR_FIHGTTING);
			}
		}
		
		/****************************************************************
		 * *************************** 渲染逻辑   **************************
		 * **************************************************************/
		override public function render(iElapse:int):void
		{
			/*if(mySearchedEnemy && (!mySearchedEnemy.getIsAlive() || !mySearchedEnemy.getIsSearchable()))
				setSearchedEnemy(null);*/
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.IDLE:
					if(myFightState.bStun || myFightState.bSheep)
						break;
					if(checkCanUseSkill())
						break;
					onRenderWhenIdelState();
					break;
				
				case OrganismBehaviorState.RESURRECTION:
					onRenderWhenResurrectionState();
					break;
				
				case OrganismBehaviorState.NEAR_FIHGTTING:
					onRenderWhenNearFighttingState();
					break;
				
				case OrganismBehaviorState.FAR_FIHGTTING:
					onRenderWhenFarFighttingState();
					break;
				
				case OrganismBehaviorState.ENEMY_ESCAPING:
					if(myFightState.bStun || myFightState.bSheep)
						break;
					if(checkCanUseSkill())
						break;
					onRenderWhenEnemyEscapState();
					break;
				
				case OrganismBehaviorState.DYING:
					onRenderWhenDying();
					break;
				
				case OrganismBehaviorState.USE_SKILL:
					onRenderWhenUseSkill();
					break;
				
				case OrganismBehaviorState.MOVE_TO_APPOINTED_POINT:
					onRenderWhenMoveToAppointPoint();
					break;
			}
			
			if(isFreezedState())
				return;
			
			if(_hurtBloodEffectAnimation && _hurtBloodEffectAnimation.visible) 
				_hurtBloodEffectAnimation.render(iElapse);
			if(_benefitBloodEffectAnimation1 && _benefitBloodEffectAnimation1.visible) 
				_benefitBloodEffectAnimation1.render(iElapse);
			if(_benefitBloodEffectAnimation2 && _benefitBloodEffectAnimation2.visible) 
				_benefitBloodEffectAnimation2.render(iElapse);
			if(_rebirthAnim && _rebirthAnim.visible)
				_rebirthAnim.render(iElapse);
			if(_AppearDisappearAnim && _AppearDisappearAnim.visible)
				_AppearDisappearAnim.render(iElapse);
			
			//是活动状态且行为锁定，是不会渲染的, 所以行为锁定的情况下是可以消失和死亡的等非活动的动画的
			/*if(isActivedOrganismBehaviorState())
			{
				return;
			}*/
			
			/*if(myFightState.bStun && myMoveState.myIsWalking)
				return;*/
			
			if(myFightState && myMoveLogic && myMoveState && !myFightState.bStun)
				myMoveLogic.update(myMoveState);
			
			//if(myFightState&& !myFightState.bStun)
			super.render(iElapse);
		}
		/**
		 * 待机
		 */
		protected function onRenderWhenIdelState():void
		{
			if(myCampType == FightElementCampType.FRIENDLY_CAMP && myIdelAnimationCDTimer.getIsCDEnd())
			{
				myIdelAnimationCDTimer.resetCDTime();
				myBodySkin.scaleX *= -1;
			}
			
			searchEnemyCampWhenIdel();	
		}
		/**
		 * 复活
		 */
		protected function onRenderWhenResurrectionState():void
		{
			if((_rebirthAnim && _rebirthAnim.visible) || myBodySkin.isPlaying)
				return;
			//myResurrectionCDTimer.tick();
			
			if(myResurrectionCDTimer.getIsCDEnd())
			{
				//myResurrectionCDTimer.resetCDTime();
				
				if(_bNeedRebirthAnim)
					playRebornEff();
				else 
					onRebornEffEnd();	
			}
		}
		
		private function playRebornEff():void
		{
			if(!_rebirthAnim)
			{
				//var vecFrames:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos("Reborn", myScaleRatioType);
				//if(vecFrames)
				{
					_rebirthAnim = new NewBitmapMovieClip(["Reborn"], [myScaleRatioType]);
					injector.injectInto(_rebirthAnim);
				}
			}
			_mySpecialEffectAnimationsLayer.addChild(_rebirthAnim);
			_rebirthAnim.visible = true;
			_rebirthAnim.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				onRebornEffEnd) 
		}
		
		private function onRebornEffEnd():void
		{
			if(_rebirthAnim && _mySpecialEffectAnimationsLayer.contains(_rebirthAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_rebirthAnim);
			if(_rebirthAnim)
				_rebirthAnim.visible = false;
			
			if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.REBORN+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
			{
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.REBORN+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.REBORN+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onResurrection);
			}
			else
				onResurrection();
		}
		
		private function onResurrection():void
		{
			//重置血条
			resetBooldBar();
			_myBloodBar.visible = true;
			//先站立
			enforceRecoverToStandState();
			_myBloodBar.visible = true;
			
			onResurrectionComplete();
		}
		
		protected function onResurrectionComplete():void
		{
			//showBufferLayer(true);
			initStateWhenActive();
			_iRebirthType = 0;
			onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
		}

		/**
		 * 近战
		 */
		protected function onRenderWhenNearFighttingState():void
		{
			if(myFightState.bStun)
			{
				if(!myBodySkin.isPlaying) 
				{
					setSearchedEnemy(null);
					changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
				}
				return;
			}
			
			/*if(myBodySkin.isPlaying) 
				return;*/
			if(fightState.provokeTarget)
			{
				var gaojian:int = 0;
			}
			
			var searchedEnemy:BasicOrganismElement = getCanSearchedEnemy();
			//searchedEnemy.notifyBeBlockedByEnemy(this);
			setSearchedEnemy(searchedEnemy);
			if(!currentSearchedEnemy)
			{
				onDoDefaultBehavior();
				return;
			}
			var distanceType:int = caculateTargetEnemyDistanceType(mySearchedEnemy);			
			if(-1 == distanceType)
			{
				onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
				return;
			}
			else if(1 == distanceType)
			{
				changeToTargetBehaviorState(OrganismBehaviorState.FAR_FIHGTTING);
				return;
			}
			else if(2 == distanceType)
			{
				if(FightElementCampType.FRIENDLY_CAMP == myCampType || myFightState.betrayState.bBetrayed)
				{
					if(!currentSearchedEnemy.fightState.isFlyUnit)
					{
						currentSearchedEnemy.notifyBeBlockedByEnemy(this);
						moveToCurrentFindedEnemyNearby();
					}
					else if(isFarAttackable)
						changeToTargetBehaviorState(OrganismBehaviorState.FAR_FIHGTTING);
				}
				else
					onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
				return;
			}			
			else if(!currentSearchedEnemy.hasTargetEnemy())
			{
				currentSearchedEnemy.notifyBeBlockedByEnemy(this);
				currentSearchedEnemy.notifyNearFighttingWithCurrentEnemy(this);
			}
			
			if(myAttackCDTimer.getIsCDEnd(myFightState.extraCdTime))
			{
				if(myBodySkin.isPlaying) 
					return;
				if(checkCanUseSkill())
					return;
				myAttackCDTimer.resetCDTime();
				fireToTargetEnemy();
			}
		}
		/**
		 * 远战
		 */
		protected function onRenderWhenFarFighttingState():void
		{
			/*if(myBodySkin.isPlaying) 
				return;*/
			
			if(myFightState.bStun || !mySearchedEnemy || mySearchedEnemy.fightState.bInvincible)
			{
				setSearchedEnemy(null);
				onDoDefaultBehavior();
				return;
			}
			
			var searchedEnemy:BasicOrganismElement = getCanSearchedEnemy();
			setSearchedEnemy(searchedEnemy);
			if(!currentSearchedEnemy)
			{
				onDoDefaultBehavior();
				return;
			}
			var distanceType:int = caculateTargetEnemyDistanceType(mySearchedEnemy);
			
			if(-1 == distanceType)
			{
				onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
				return;
			}
			else if(!currentSearchedEnemy.fightState.isFlyUnit)
			{
				if(FightElementCampType.FRIENDLY_CAMP == myCampType)
				{
					if(2 == distanceType)
					{
						currentSearchedEnemy.notifyBeBlockedByEnemy(this);
						moveToCurrentFindedEnemyNearby();
						return;
					}
					else if(0 == distanceType)
					{
						currentSearchedEnemy.notifyBeBlockedByEnemy(this);
						currentSearchedEnemy.notifyNearFighttingWithCurrentEnemy(this);
						changeToTargetBehaviorState(OrganismBehaviorState.NEAR_FIHGTTING);
						return;
					}
				}
				else if(0 == distanceType)
				{
					changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
					return;
				}
			}	
			
			//myAttackCDTimer.tick();
			if(myAttackCDTimer.getIsCDEnd(myFightState.extraCdTime))
			{
				if(myBodySkin.isPlaying) 
					return;
				if(checkCanUseSkill())
					return;
				myAttackCDTimer.resetCDTime();
				fireToTargetEnemy();
			}
		}
		/**
		 * 怪物逃跑
		 */
		protected function onRenderWhenEnemyEscapState():void
		{
			if(myCampType == FightElementCampType.ENEMY_CAMP && isFarAttackable)
			{
				/*var searchedEnemy:BasicOrganismElement = GameAGlobalManager
					.getInstance()
					.groundSceneHelper
					.searchOrganismElementEnemy(searchCenterX,searchCenterY, myFightState.atkArea, 
						oppositeCampType);*/
				var searchedEnemy:BasicOrganismElement = getCanSearchedEnemy();
				
				if(searchedEnemy != null)
				{
					setSearchedEnemy(searchedEnemy);
					changeToTargetBehaviorState(OrganismBehaviorState.FAR_FIHGTTING);
				}
			}
		}
		/**
		 * 移动到导航点
		 */
		protected function onRenderWhenMoveToAppointPoint():void
		{
			
		}
		/**
		 * 死亡
		 */
		protected function onRenderWhenDying():void
		{
			if(_dieStepType == OrganismDieStepType.BODY_STAY)
			{
				//_dieBodyStayCDTimer.tick();
				if(_dieBodyStayCDTimer.getIsCDEnd())
				{
					onDiedAnimationEndHandlerStep2();
				}
			}
		}
		
		/****************************************************************
		 * *************************** 状态机切换   **************************
		 * **************************************************************/
		override protected function canChangeBehaviorState(behaviorState:int):Boolean
		{
			if(myFightState.bStun && (OrganismBehaviorState.NEAR_FIHGTTING == behaviorState 
				|| OrganismBehaviorState.FAR_FIHGTTING == behaviorState
				|| OrganismBehaviorState.MOVE_TO_APPOINTED_POINT == behaviorState))
				return false;
			
			return true;
		}

		//inner event handler
		override protected function onBehaviorStateChanged():void
		{		
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.DYING:			
					if(myFightState.bSheep)
					{
						myFightState.bSheep = false;
						showSlefSheep(false);
					}
					notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_DIE_BEFORE_REBIRTH);
					onBehaviorChangeToDying();
					break;
				
				case OrganismBehaviorState.BE_FINED_AND_LOCKED_BY_ENEMY:
					onBehaviorChangeToBeLocked();
					break;
				case OrganismBehaviorState.NEAR_FIHGTTING:
					if(!isAlive)
						var gaojian:int = 0;
					notifyTriggerSkillAndBuff(TriggerConditionType.BEFORE_ATTACK);
					onBehaviorChangeToNearFight();
					break;
				case OrganismBehaviorState.FAR_FIHGTTING:
					notifyTriggerSkillAndBuff(TriggerConditionType.BEFORE_ATTACK);
					onBehaviorChangeToFarFight();
					break;
				case OrganismBehaviorState.RESURRECTION:
					onBehaviorChangeToResurrect();
					break;		
				case OrganismBehaviorState.IDLE:
					onBehaviorChangeToIdle();
					break;		
				case OrganismBehaviorState.DISAPPEAR:
					onBehaviorChangeToDisappear();
					break;				
				case OrganismBehaviorState.APPEAR:
					onBehaviorChangeToAppear();
					break;
				case OrganismBehaviorState.USE_SKILL:
					onBehaviorChangeToUseSkill();
					break;
			}
		}
		/**
		 * 使用技能
		 */
		override protected function onBehaviorChangeToUseSkill():void
		{
			myMoveLogic.pauseWalk(myMoveState);
			super.onBehaviorChangeToUseSkill();
		}
		
		override protected function onSkillDisappearAnimEnd():void
		{
			super.onSkillDisappearAnimEnd();
			onDoDefaultBehavior();
			/*if(GameObjectCategoryType.MONSTER != myElemeCategory && isAlive)
			{
				searchEnemyCampWhenIdel();
				if(!mySearchedEnemy)
					changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}*/
		}
		/**
		 * 死亡
		 */
		protected function onBehaviorChangeToDying():void
		{
			if(-1 != _dieStepType)
				return;
			
			myMoveLogic.pauseWalk(myMoveState);//暂停移动
			clearStateWhenFreeze(true);
			//showBufferLayer(false);
			
			_dieStepType = OrganismDieStepType.BODY_DIE;
			if(_myCurrentDieType == OrganismDieType.NORMAL_DIE)
			{
				var dieAnimationFrameKey:String = getDyingAnimationFrameKeyByDieType(_myCurrentDieType);
				myBodySkin.gotoAndPlay2(dieAnimationFrameKey + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					dieAnimationFrameKey + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
					onDiedAnimationEndHandlerStep1);
				playSound(getSoundId(SoundFields.Dead));
			}
			else if(_myCurrentDieType == OrganismDieType.NONE_DIE)
			{
				onDiedAnimationEndHandlerStep1();
				playSound(getSoundId(SoundFields.Dead));
			}
			else if(_myCurrentDieType > OrganismDieType.NONE_DIE)
			{
				this.myBodySkin.visible = false;
				var dieEff:BasicDieEffect = objPoolMgr.
					createSceneElementObject(GameObjectCategoryType.DIEEFFECT,_myCurrentDieType,false) as BasicDieEffect;
				dieEff.setDieEffectParam(onDiedAnimationEndHandlerStep1);
				dieEff.x = x;
				dieEff.y = y;
				dieEff.notifyLifecycleActive();
				playSound(SoundFields.DieType+_myCurrentDieType);
			}
		}
		
		protected function getDyingAnimationFrameKeyByDieType(dieType:int):String
		{
			return GameMovieClipFrameNameType.NORMAL_DIE;
		}
		
		//死亡的第一步，身体倒地， 或直接死亡动画结束
		protected function onDiedAnimationEndHandlerStep1():void
		{
			if(isFreezedState())
				return;
			
			_myBloodBar.visible = false;
			
			if(_myCurrentDieType == OrganismDieType.NONE_DIE)
			{
				notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_DIE);
				//非正常死亡是没有尸体的，直接死亡
				destorySelf();	
				if(campType == FightElementCampType.ENEMY_CAMP)
				{
					//胜利失败检测
					successAndFailedDetector.onEnemyCampUintDied(this as BasicMonsterElement);
				}
				
				
			}
			else
			{
				if(checkCanResurrect())
					return;
				
				//进入尸体停留状态
				if(OrganismDieType.NORMAL_DIE == _myCurrentDieType)
				{
					onBodyStay();
				}
				else
				{
					onDiedAnimationEndHandlerStep2();
				}
			}
		}
		
		protected function onBodyStay():void
		{
			_dieStepType = OrganismDieStepType.BODY_STAY;
			_dieBodyStayCDTimer.resetCDTime();
		}
		
		protected function checkCanResurrect():Boolean
		{
			if(myFightState.bCanRebirth)
			{	
				changeToTargetBehaviorState(OrganismBehaviorState.RESURRECTION);	
				immediatelyResurrection();
				myFightState.bCanRebirth = false;
				return true;
			}
			
			if(/*_myCurrentDieType == OrganismDieType.NORMAL_DIE &&*/ checkHasAbilityToResurrection())
			{
				changeToTargetBehaviorState(OrganismBehaviorState.RESURRECTION);					
				return true;
			}
			
			return false;
		}
		
		//尸体停留3s结束
		protected function onDiedAnimationEndHandlerStep2():void
		{
			if(_myCurrentDieType == OrganismDieType.NORMAL_DIE)
			{
				_dieStepType = OrganismDieStepType.BODY_BLOOD_DISPPEAR;
				
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DIE_BLOOD_DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.DIE_BLOOD_DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
					onDiedAnimationEndHandlerStep3);
			}
			else//非正常死亡是没有尸体的，直接死亡
			{
				notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_DIE);
				destorySelf();	
				if(campType == FightElementCampType.ENEMY_CAMP)
				{
					//胜利失败检测
					successAndFailedDetector.onEnemyCampUintDied(this as BasicMonsterElement);
				}
				
				
			}
	
		}
		
		protected function onDiedAnimationEndHandlerStep3():void
		{
			notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_DIE);
			destorySelf();
			if(campType == FightElementCampType.ENEMY_CAMP)
			{
				//胜利失败检测
				successAndFailedDetector.onEnemyCampUintDied(this as BasicMonsterElement);
			}
			
			
		}
		
		protected function checkHasAbilityToResurrection():Boolean
		{
			return myFightState.rebirthTime > 0;
		}
		/**
		 * 被锁定
		 */
		protected function onBehaviorChangeToBeLocked():void
		{
			myMoveLogic.pauseWalk(myMoveState);
		}
		
		protected function onBehaviorChangeToNearFight():void
		{
			//setAngle(GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, currentSearchedEnemy.x, currentSearchedEnemy.y), true);
			myBodySkin.gotoAndStop2(getNearAttackTypeStr()+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
			currentSearchedEnemy.notifyNearFighttingWithCurrentEnemy(this);
		}
		
		protected function onBehaviorChangeToFarFight():void
		{
			if(myFightState.bStun)
				var gaojian:int = 0;
			myAttackCDTimer.clearCDTime();
			myMoveLogic.pauseWalk(myMoveState);
			//setAngle(GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, currentSearchedEnemy.x, currentSearchedEnemy.y), true);
			myBodySkin.gotoAndStop2(getFarAttackTypeStr()+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
		}
		/**
		 * 复活状态
		 */
		protected function onBehaviorChangeToResurrect():void
		{
			_dieStepType = -1;
			_myCurrentDieType = OrganismDieType.NORMAL_DIE;
			myResurrectionCDTimer.resetCDTime();
		}
		
		//立即复活
		public function immediatelyResurrection():void
		{
			if(currentBehaviorState != OrganismBehaviorState.RESURRECTION) return;
			
			myResurrectionCDTimer.clearCDTime();
			onRenderWhenResurrectionState();
		}
		
		public function forceToResurrection(rebirthType:int = 0):void
		{
			_iRebirthType = rebirthType;
			changeToTargetBehaviorState(OrganismBehaviorState.RESURRECTION);
			immediatelyResurrection();
		}
		/**
		 * 待机状态
		 */
		protected function onBehaviorChangeToIdle():void
		{
			enforceRecoverToStandState();
			if(myCampType != FightElementCampType.ENEMY_CAMP)
			{
				myIdelAnimationCDTimer.resetCDTime();
			}
		}
		/**
		 * 消失状态
		 */
		protected function onBehaviorChangeToDisappear():void
		{
			myMoveLogic.pauseWalk(myMoveState);
			dispatchLeaveOffScreenSearchRangeEvent();
			
			if(_isNeedPlayAppearAnim)
			{
				playAppearEff();
			}
			else
			{
				this.visible = false;
				if(_isAutoAppearFlag)
				{
					_isAutoAppearFlag = false;
					enforceAppear(myAppointPoint);
				}
			}
		}
		
		//强制消失，只有活动状态才会消失
		public final function enforceDisappear(appearPosition:PointVO = null, isAutoAppear:Boolean = false, bPlayAnim:Boolean = false):void
		{
			if(isActivedOrganismBehaviorState())
			{
				if(appearPosition != null)
				{
					myAppointPoint.x = appearPosition.x;
					myAppointPoint.y = appearPosition.y;
				}
				
				_isAutoAppearFlag = isAutoAppear;
				_isNeedPlayAppearAnim = bPlayAnim;
				changeToTargetBehaviorState(OrganismBehaviorState.DISAPPEAR);	
			}
		}
		
		/**
		 * 出现状态
		 */
		protected function onBehaviorChangeToAppear():void
		{
			this.visible = true;
			onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
		}
		
		//只有消失状态才会出现
		public final function enforceAppear(appearPosition:PointVO = null, isNeedHurt:Boolean = false,
											delatHurtValue:uint = 0,
											attackType:int = FightAttackType.PHYSICAL_ATTACK_TYPE,
											isMonomerHurt:Boolean = true):void
		{
			if(currentBehaviorState == OrganismBehaviorState.DISAPPEAR)
			{
				if(appearPosition != null)
				{
					myAppointPoint.x = appearPosition.x;
					myAppointPoint.y = appearPosition.y;
				}
				
				this.x = myAppointPoint.x;
				this.y = myAppointPoint.y;
				flagDelayHurt(delatHurtValue, attackType, isMonomerHurt);
				
				if(_isNeedPlayAppearAnim)
				{
					this.visible = true;
					playAppearEff(true);
				}
				else
				{
					changeToTargetBehaviorState(OrganismBehaviorState.APPEAR);
					onEnforceAppear();
				}
			}
		}
		
		protected function onEnforceAppear():void
		{
			doDelayHurt();
		}
		
		private function flagDelayHurt(value:uint,
									   attackType:int = FightAttackType.PHYSICAL_ATTACK_TYPE,
									   isMonomerHurt:Boolean = true):void
		{
			_isDelayHurtFlag = true;
			_delayHurtBloodValue = value;
			_delayHurtAttackType = attackType;
			_delayIsMonomerHurt = isMonomerHurt;
		}
		
		private function doDelayHurt():void
		{
			if(_isDelayHurtFlag)
			{
				if(_delayHurtBloodValue>0)
					hurtBlood(_delayHurtBloodValue, _delayHurtAttackType, _delayIsMonomerHurt);
				clearDelayHurt();
			}
		}
		
		private function clearDelayHurt():void
		{
			_isDelayHurtFlag = false;
			
			_delayHurtBloodValue = 0;
			_delayHurtAttackType = -1;
			_delayIsMonomerHurt = false;
		}
		
		/**
		 * 出现和消失的动画
		 */
		private function playAppearEff(bAppear:Boolean = false):void
		{
			if(!_AppearDisappearAnim)
			{
				//var vecFrames:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(GameObjectCategoryType.SPECIAL+"_152050", myScaleRatioType);
				//if(vecFrames)
				{
					_AppearDisappearAnim = new NewBitmapMovieClip([GameObjectCategoryType.SPECIAL+"_152050"], [myScaleRatioType]);
					injector.injectInto(_AppearDisappearAnim);
				}
			}
			_mySpecialEffectAnimationsLayer.addChild(_AppearDisappearAnim);
			_AppearDisappearAnim.visible = true;
			var strAction:String = bAppear?GameMovieClipFrameNameType.APPEAR:GameMovieClipFrameNameType.DISAPPEAR;
			_AppearDisappearAnim.gotoAndPlay2(strAction + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				strAction + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				bAppear?onAppearEffEnd:onDisappearEffEnd);
		}
		
		private function onAppearEffEnd():void
		{
			if(_AppearDisappearAnim && _mySpecialEffectAnimationsLayer.contains(_AppearDisappearAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_AppearDisappearAnim);
			if(_AppearDisappearAnim)
				_AppearDisappearAnim.visible = false;
			
			changeToTargetBehaviorState(OrganismBehaviorState.APPEAR);
			onEnforceAppear();
		}
		
		private function onDisappearEffEnd():void
		{
			if(_AppearDisappearAnim && _mySpecialEffectAnimationsLayer.contains(_AppearDisappearAnim))
				_mySpecialEffectAnimationsLayer.removeChild(_AppearDisappearAnim);
			if(_AppearDisappearAnim)
				_AppearDisappearAnim.visible = false;
			this.visible = false;
			if(_isAutoAppearFlag)
			{
				_isAutoAppearFlag = false;
				enforceAppear(myAppointPoint);
			}
		}		
	
		/****************************************************************
		 * *************************** 战斗目标相关   **************************
		 * **************************************************************/
		//这里要判断远程近程的攻击方式
		private function searchEnemyCampWhenIdel():void
		{				
			var searchedEnemy:BasicOrganismElement = getCanSearchedEnemy();
			setSearchedEnemy(searchedEnemy);
			
			if(searchedEnemy != null)
			{	
				var distanceType:int = caculateTargetEnemyDistanceType(currentSearchedEnemy);
				
				if(isFarAttackable)
				{
					if(!currentSearchedEnemy.fightState.isFlyUnit)
					{				
						if(distanceType == 0)
						{
							currentSearchedEnemy.notifyBeBlockedByEnemy(this);
							currentSearchedEnemy.notifyNearFighttingWithCurrentEnemy(this);
							changeToTargetBehaviorState(OrganismBehaviorState.NEAR_FIHGTTING);
						}
						else if(distanceType == 2)
						{
							moveToCurrentFindedEnemyNearby();
						}
						else if(distanceType == 1)
						{
							changeToTargetBehaviorState(OrganismBehaviorState.FAR_FIHGTTING);
						}
					}
					else
					{
						changeToTargetBehaviorState(OrganismBehaviorState.FAR_FIHGTTING);
					}
				}
				else if(!currentSearchedEnemy.fightState.isFlyUnit)
				{
					if(distanceType == 0)
					{
						currentSearchedEnemy.notifyBeBlockedByEnemy(this);
						currentSearchedEnemy.notifyNearFighttingWithCurrentEnemy(this);
						changeToTargetBehaviorState(OrganismBehaviorState.NEAR_FIHGTTING);
					}
					else
						moveToCurrentFindedEnemyNearby();
				}
			}
		}
		
		private function getCanSearchedEnemy():BasicOrganismElement
		{
			var searchedEnemy:BasicOrganismElement;
			var tempEnemy:BasicOrganismElement;
			
			if(myFightState.provokeTarget && myFightState.provokeTarget.isAlive && !myFightState.provokeTarget.fightState.bInvisible /*&& mySearchedEnemy != myFightState.provokeTarget*/)
			{
				if(!myFightState.provokeTarget.isTargetEnemy(this))
					dispatchLeaveOffScreenSearchRangeEvent();
				searchedEnemy = myFightState.provokeTarget;
			}
			else if(mySearchedEnemy && mySearchedEnemy.isAlive && !mySearchedEnemy.fightState.bInvisible)
			{
				if(mySearchedEnemy.isTargetEnemy(this) || !mySearchedEnemy.hasTargetEnemy())
					searchedEnemy = mySearchedEnemy;
				else
				{
					if(FightElementCampType.FRIENDLY_CAMP == myCampType)
					{
						tempEnemy = sceneElementsService
							.searchOrganismElementEnemy(searchCenterX, searchCenterY, myFightState.searchArea, 
								oppositeCampType, searchCanInterceptOtherEnemy);
					}
					if(tempEnemy)
						searchedEnemy = tempEnemy;
					else
					{
						if(isFarAttackable)
						{
							tempEnemy = sceneElementsService
								.searchOrganismElementEnemy(searchCenterX, searchCenterY, myFightState.atkArea, 
									oppositeCampType, searchAttackMySelfEnemy);
							if(tempEnemy)
								searchedEnemy = tempEnemy;
							else
							{
								var distanceType:int = caculateTargetEnemyDistanceType(currentSearchedEnemy);
								if(!fightState.betrayState.bBetrayed && (1 != distanceType && 2 != distanceType))
								{
									if(FightElementCampType.ENEMY_CAMP == myCampType)
										searchedEnemy = null;
									else
										searchedEnemy = mySearchedEnemy;
								}
								else
									searchedEnemy = mySearchedEnemy;
							}
						}
						else
							searchedEnemy = mySearchedEnemy;
					}
				}
			}
			else if(FightElementCampType.FRIENDLY_CAMP == myCampType || fightState.betrayState.bBetrayed)
			{
				searchedEnemy = sceneElementsService
					.searchOrganismElementEnemy(searchCenterX, searchCenterY,myFightState.searchArea, 
						oppositeCampType, searchCanInterceptEscapeEnemy);
				if(!searchedEnemy)
				{
					searchedEnemy = sceneElementsService
						.searchOrganismElementEnemy(searchCenterX, searchCenterY,myFightState.searchArea, 
							oppositeCampType, searchCanInterceptEnemy);
					if(!searchedEnemy && isFarAttackable)
					{
						searchedEnemy = sceneElementsService
							.searchOrganismElementEnemy(searchCenterX, searchCenterY,myFightState.atkArea, 
								oppositeCampType, searchFarAttackFlyUintSearchConditionFilter);
					}
				}
			}
			else if(isFarAttackable)
			{
				searchedEnemy = sceneElementsService
					.searchOrganismElementEnemy(searchCenterX, searchCenterY,myFightState.atkArea, oppositeCampType, searchCanBeFarAttackedFriendly);
			}
			
			return searchedEnemy;
		}
		
		protected function get searchCenterX():Number
		{
			return this.x;
		}
		
		protected function get searchCenterY():Number
		{
			return this.y;
		}
		//搜索除了当前目标外可以拦截的目标
		protected function searchCanInterceptOtherEnemy(element:BasicOrganismElement):Boolean
		{
			if(mySearchedEnemy == element)
				return false;
			return searchCanInterceptEscapeEnemy(element);
		}
		
		protected function searchCanInterceptEscapeEnemy(element:BasicOrganismElement):Boolean
		{				
			if(element.hasTargetEnemy())
				return false;
			return searchCanInterceptEnemy(element);
		}
		
		protected function searchCanInterceptEnemy(element:BasicOrganismElement):Boolean
		{
			if(element.fightState.bInvincible || element.fightState.isFlyUnit || element.fightState.bSheep || element.fightState.bMaxSnowball)
				return false;
			return true;
		}
		
		protected function searchAttackMySelfEnemy(element:BasicOrganismElement):Boolean
		{
			if(!element.isTargetEnemy(this))
				return false;
			return searchFarAttackFlyUintSearchConditionFilter(element);
		}
		
		protected function searchCanBeFarAttackedFriendly(element:BasicOrganismElement):Boolean
		{
			if(element.fightState.bInvincible)
				return false;
			
			var distanceType:int = caculateTargetEnemyDistanceType(element);
			if(0 == distanceType || -1 == distanceType)
				return false;
			
			return true;
		}
		
		//search filter
		protected function searchFarAttackFlyUintSearchConditionFilter(element:BasicOrganismElement):Boolean
		{
			if(element.fightState.bInvincible)
				return false;
			if(isFarAttackable) 
				return true;
			if(!element.fightState.isFlyUnit && !element.fightState.bSheep)
				return true;
			return false;
		}
		
		protected function searchNewNoTargetEnemyConditionFilter(element:BasicOrganismElement):Boolean
		{
			return	!element.hasTargetEnemy() && searchFarAttackFlyUintSearchConditionFilter(element);
		}
		
		//searchedEnemy
		protected final function get currentSearchedEnemy():BasicOrganismElement
		{
			return mySearchedEnemy;
		}
		
		protected final function setSearchedEnemy(value:BasicOrganismElement):void
		{
			if(mySearchedEnemy == value) 
				return;
			
			if(null == value && mySearchedEnemy == myFightState.provokeTarget)
				myFightState.provokeTarget = null;

			if(mySearchedEnemy != null)
			{
				mySearchedEnemy.removeEventListener(SceneElementEvent.LEAVE_OFF_SCREEN_SEARCH_RANGE, 
					currentSearchEnemyLeaveOffScreenSearchRangeHandler);
			}

			mySearchedEnemy = value;
			
			if(mySearchedEnemy != null)
			{
				mySearchedEnemy.addEventListener(SceneElementEvent.LEAVE_OFF_SCREEN_SEARCH_RANGE, 
					currentSearchEnemyLeaveOffScreenSearchRangeHandler);
			}
		}
		
		//target TargetEnemy========================================================
		public final function isTargetEnemy(enemy:BasicOrganismElement):Boolean
		{
			return hasTargetEnemy() && mySearchedEnemy == enemy;
		}
		
		public final function hasTargetEnemy():Boolean
		{
			return mySearchedEnemy != null;
		}
		
		public final function isSameCampType(target:ISkillOwner):Boolean
		{
			return myCampType == target.campType;
		}
		
		//event handle
		private function currentSearchEnemyLeaveOffScreenSearchRangeHandler(event:SceneElementEvent):void
		{
			onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
		}
		
		protected final function dispatchLeaveOffScreenSearchRangeEvent():void
		{
			this.dispatchEvent(new SceneElementEvent(SceneElementEvent.LEAVE_OFF_SCREEN_SEARCH_RANGE));
		}
		
		protected function resetSearchState():void
		{
			dispatchLeaveOffScreenSearchRangeEvent();
			setSearchedEnemy(null);
		}	
		
		/**
		 * 默认状态转换
		 */
		public final function enforceTerminateCurrentBehaviorAndThenDoDefaultBehavior():void
		{
			//通知侦听对象，自己离开
			dispatchLeaveOffScreenSearchRangeEvent();
			onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
		}
		
		protected function onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior():void
		{
			setSearchedEnemy(null);
			if(OrganismBehaviorState.USE_SKILL != currentBehaviorState)
				onDoDefaultBehavior();
		}
		
		protected function onDoDefaultBehavior():void
		{
			if(!isAlive && OrganismBehaviorState.SOLDIER_STAY_AT_HOME != currentBehaviorState)
			{
				if(0 == myFightState.curLife && isActivedOrganismBehaviorState())
					changeToTargetBehaviorState(OrganismBehaviorState.DYING);
				return;
			}
			//所有友方单位，包括被魅惑的
			if((myCampType == FightElementCampType.FRIENDLY_CAMP && !myFightState.betrayState.bBetrayed) 
				|| (myCampType == FightElementCampType.ENEMY_CAMP && myFightState.betrayState.bBetrayed))
			{
				//没有目标敌人，则回导航点
				if(null == mySearchedEnemy)
				{
					var enemy:BasicOrganismElement = getCanSearchedEnemy();
					if(enemy)
						changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
					else
						backToCurrentAppointPoint();
				}
				else//有敌人则变为空闲状态，进行后续状态的切换
					changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}
			else if(myFightState.betrayState.bBetrayed)
			{
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}
			else if(null == mySearchedEnemy) /*if(!(OrganismBehaviorState.NEAR_FIHGTTING == currentBehaviorState && myBodySkin.isPlaying))*/
			{
				changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
			}
			else
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
		}

		/****************************************************************
		 * *************************** 近战远战相关   **************************
		 * **************************************************************/
		override protected function fireToTargetEnemy():void
		{
			setAngle(GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, currentSearchedEnemy.x, currentSearchedEnemy.y), true);
			
			if(currentBehaviorState == OrganismBehaviorState.NEAR_FIHGTTING)
			{
				myBodySkin.gotoAndPlay2(getNearAttackTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					getNearAttackTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, null,
					getNearFirePointTypeStr(), onFireAnimationTimeHandler);
			}
			else
			{
				myBodySkin.gotoAndPlay2(getFarAttackTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					getFarAttackTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, null,
					getFarFirePointTypeStr(), onFireAnimationTimeHandler);
			}
		}
		
		protected function onFireAnimationTimeHandler():void
		{
			//这里防止动画的延时播放会导致这里的bug
			if(mySearchedEnemy == null || !isAlive) 
				return;
			
			if(currentBehaviorState == OrganismBehaviorState.NEAR_FIHGTTING)
			{
				var dmg:int = getDmgBeforeHurtTarget(true,mySearchedEnemy);
				checkAtkToLife(dmg);
				areaAttack(mySearchedEnemy,dmg,myFightState.range);
				if(mySearchedEnemy == null) 
					return;
				mySearchedEnemy.hurtBlood(dmg, FightAttackType.PHYSICAL_ATTACK_TYPE, true, this,false,OrganismDieType.NORMAL_DIE,1,false,true);			
				if(myFightState.iMultyAtk>1 && mySearchedEnemy)
				{
					for(var i:int=0;i<myFightState.iMultyAtk-1;++i)
					{
						mySearchedEnemy.hurtBlood(dmg, FightAttackType.PHYSICAL_ATTACK_TYPE, true, this,false,OrganismDieType.NORMAL_DIE,1,false,true);
						if(!mySearchedEnemy)
							break;
					}
					myFightState.iMultyAtk = 0;
				}
				if(mySearchedEnemy && mySearchedEnemy.isAlive)
					checkSpecialSkillBeforeAttack(mySearchedEnemy);
				playNearAttackSound();
			}
			else if(currentBehaviorState == OrganismBehaviorState.FAR_FIHGTTING)
			{
				fireBullet(getGlobalFirePoint());
				playFarAttackSound();
			}
			
		}
		
		protected function playNearAttackSound():void
		{
			playSound(getSoundId(SoundFields.NearAttack));
		}
		
		protected function playFarAttackSound():void
		{
			playSound(getSoundId(SoundFields.FarAttack));
		}
		
		protected function fireBullet(ptFire:PointVO):void
		{
			//伤害在onFarAttackTarget中计算
			var bulletEffect:BasicBulletEffect = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.BULLET, 
					myFightState.weapon, false) as BasicBulletEffect;
			bulletEffect.fire(mySearchedEnemy, this, 
				ptFire,
				0, 100);
			
			bulletEffect.notifyLifecycleActive();
		}
		
		override protected function onFarAttackTarget(target:ISkillTarget):void
		{
			var dmg:int = getDmgBeforeHurtTarget(false,target as BasicOrganismElement);
			checkAtkToLife(dmg);
			target.hurtSelf(dmg,atkType,this);
			areaAttack(target,dmg,myFightState.range);
			if(target.isAlive)
				checkSpecialSkillBeforeAttack(target);
		}
		
		override protected function searchCanAreaAtkTargets(e:BasicOrganismElement):Boolean
		{
			return searchFarAttackFlyUintSearchConditionFilter(e);
		}
		
		/****************************************************************
		 * *************************** 伤害计算逻辑   **************************
		 * **************************************************************/
		override protected function getDmgBeforeHurtTarget(bNear:Boolean = true,target:BasicOrganismElement = null):int
		{
			//用于加成攻击的基数
			var baseDmg:int = getRandomDamageValue();
			var realDmg:int = baseDmg;
			realDmg += checkHugeDmg(baseDmg,bNear);
			realDmg += checkWeaknessAtk(baseDmg,target);
			realDmg += checkBodyDmg(baseDmg);
			realDmg += checkFlyDmg(baseDmg);
			realDmg += checkEquipCritDmg(baseDmg);
			return realDmg;
		}
		/**
		 * 装备暴击属性 
		 * @param dmg
		 * @return 
		 * 
		 */		
		protected function checkEquipCritDmg(dmg:int):int
		{
			if(myFightState.equipCritValuePct>0 && Math.random()*100<myFightState.equipCritValuePct)
			{
				return dmg;
			}
			return 0;
		}
		
		protected function checkHugeDmg(dmg:int,bNear:Boolean = true):int
		{
			var addDmg:int = 0;
			if(myFightState.hugeDmgState.bHasBuff && myFightState.hugeDmgState.successOdds())
			{
				if(bNear)
					addDmg = dmg*myFightState.hugeDmgState.nearPct/100 - dmg;	
				else
					addDmg = dmg*myFightState.hugeDmgState.farPct/100 - dmg;	
				myFightState.hugeDmgState.bShooted = true;
			}
			else
				myFightState.hugeDmgState.bShooted = false;
			return addDmg;
		}
		
		protected function checkFlyDmg(dmg:int):int
		{
			if(myFightState.iDmgFlyPct>0 && mySearchedEnemy.fightState.isFlyUnit)
			{
				return dmg * myFightState.iDmgFlyPct/100;
			}
			return 0;
		}
		
		protected function checkBodyDmg(dmg:int):int
		{
			var addDmg:int = 0;
			if(myFightState && myFightState.dmgPctBySizeState.bHasState && mySearchedEnemy)
			{
				switch(mySearchedEnemy.bodySize)
				{
					case OrganismBodySizeType.SIZE_NORMAL:
						addDmg = dmg * myFightState.dmgPctBySizeState.iPctSmall/100;
						break;
					case OrganismBodySizeType.SIZE_MIDDLE:
						addDmg = dmg * myFightState.dmgPctBySizeState.iPctNormal/100;
						break;
					case OrganismBodySizeType.SIZE_BIG:
						addDmg = dmg * myFightState.dmgPctBySizeState.iPctBig/100;
						break;
				}
			}
			return addDmg;
		}
		
		protected function checkAtkToLife(dmg:int):void
		{
			if((myFightState.iAtkToLifePct>0 || myFightState.equipBloodValuePct) && dmg>0)
			{
				var life:int = dmg*(myFightState.iAtkToLifePct+myFightState.equipBloodValuePct)/100;
				if(myFightState.addLife(life))
				{
					var res:SpecialBufferRes = objPoolMgr.createSceneElementObject(
						GameObjectCategoryType.ORGANISM_SKILL_BUFFER,BufferID.Vampire,false) as SpecialBufferRes;
					res.initializeByParameters(this);
					res.notifyLifecycleActive();
				}
			}
			
		}
		
		/**
		 * 焦点相关
		 */
		override protected function onFocusChanged():void
		{
			_myFocusShape.graphics.clear();
			if(myIsInFocus)
			{
				var color:uint = campType == FightElementCampType.ENEMY_CAMP ? 
					GameFightConstant.ENEMY_CAMP_FOCUS_COLOR : 
					GameFightConstant.FRIENDLY_CAMP_FOCUS_COLOR;
				
				_myFocusShape.graphics.lineStyle(1, color);
				var partBodySize:Number = bodyWidth / 3;
				_myFocusShape.graphics.drawEllipse(-partBodySize, -partBodySize * GameFightConstant.Y_X_RATIO, 
					partBodySize * 2, partBodySize * GameFightConstant.Y_X_RATIO * 2);
			}
			_myFocusShape.graphics.endFill();
		}
		
		override public function get focusTips():String
		{
			return myMoveFighterInfo.getName() ;//+ myMoveFighterInfo.getDesc();
		}
		
		/****************************************************************
		 * *************************** 距离坐标相关计算   **************************
		 * **************************************************************/
		/**
		 * -1为在范围外， 1 在远程范围内， 0表示近战范围,2表示在拦截范围内
		 */
		protected function caculateTargetEnemyDistanceType(targetEnemy:BasicOrganismElement):int
		{
			var distance:Number = GameMathUtil.distance(this.x,this.y/GameFightConstant.Y_X_RATIO, targetEnemy.x, targetEnemy.y/GameFightConstant.Y_X_RATIO);
			if(distance <= GameFightConstant.NEAR_ATTACK_RANGE + 5) //5个像素的误差范围
				return 0;
			
			if(isFarAttackable)
			{
				if(distance > myFightState.atkArea) 
					return -1;
				else if(distance <= myFightState.atkArea && distance > myFightState.searchArea)
					return 1;
				else if(distance <= myFightState.searchArea && distance > GameFightConstant.NEAR_ATTACK_RANGE)
					return 2;
			}
			else
			{
				if(distance > myFightState.searchArea)
					return -1;
				else if(distance <= myFightState.searchArea && distance > GameFightConstant.NEAR_ATTACK_RANGE)
					return 2;
			}
			return -1;
		}
		
		public final function getAttackablePositionByTargetEnemy(targetEnemy:BasicOrganismElement,ptExpect:PointVO = null):PointVO
		{
			var range:Number = (bodyWidth + targetEnemy.bodyWidth) * 0.5;
			if(range>GameFightConstant.NEAR_ATTACK_RANGE)
				range = GameFightConstant.NEAR_ATTACK_RANGE;
			var ix:Number;
			var iy:Number;
			if(ptExpect)
			{
				ix = ptExpect.x;
				iy = ptExpect.y;
			}
			else
			{
				ix = this.x;
				iy = this.y;
			}
			return GameMathUtil.caculateTargetPointOnOnEllipse(ix, iy, range, targetEnemy.x, targetEnemy.y);
		}
		
		public function get appointPoint():PointVO
		{
			return myAppointPoint;
		}

		/****************************************************************
		 * *************************** 移动相关逻辑   **************************
		 * **************************************************************/
		public function notifyMoveStateChange(horDir:int,verDir:int,bForceStop:Boolean):void
		{
			if(0 != horDir || 0 != verDir)
			{
				var scaleX:int = ((-1 == horDir) ? -1 : 1);
				if(myBodySkin.scaleX * scaleX <0)	
				{
					myBodySkin.scaleX *= -1;
				}
			}
			
			if(!myMoveState.myIsWalking && !bForceStop)
				return;
			
			var strStart:String = getWalkTypeStr();
			if(myMoveState.myIsWalking)
			{
				if(0 == horDir)
				{
					if(-1 == verDir)
						strStart = getUpWalkTypeStr();
					else if(1 == verDir)
						strStart = getDownWalkTypeStr();
				}	
			}
			
			var strEnd:String = strStart + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END;
			strStart += GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START;
			if(bForceStop)
			{
				strStart = getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START;
				strEnd = getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END;
				if(isHero)
				{
					myBodySkin.gotoAndStop2(strStart);
				}
				else if(myBodySkin.hasFrameName(strStart))
				{
					myBodySkin.gotoAndPlay2(strStart,strEnd);
				}
				else if(myBodySkin.hasFrameName(getIdleTypeStr()))
				{
					myBodySkin.gotoAndStop2(getIdleTypeStr());
				}
				else
					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.NEAR_ATTACK+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
			}
			else
				myBodySkin.gotoAndPlay2(strStart,strEnd);
		}
		
		public function notifyTeleportMove():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.SPELL_SUFFIX +"2_"+GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.SPELL_SUFFIX +"2_"+GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
				onTeleportEnd,GameMovieClipFrameNameType.SPELL_SUFFIX +"2_"+GameMovieClipFrameNameType.FIRE_POINT,onTeleportFire);
		}
		
		private function onTeleportFire():void
		{
			var targetPathPoint:PointVO = myMoveState.currentPathPoints[myMoveState.currentPathStepIndex];
			this.x = targetPathPoint.x;
			this.y = targetPathPoint.y;
		}
		
		private function onTeleportEnd():void
		{
			myMoveLogic.stopWalk(myMoveState);
			onArrivedEndPoint();
		}
		
		public function notifyArrivedEndPoint():void
		{
			onArrivedEndPoint();
		}	
		
		protected function onArrivedEndPoint():void
		{
			if(_isRecieverdersMoveMode) _isRecieverdersMoveMode = false;
			
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.MOVING_TO_ENEMY_NEAR_BY:
					restoreMoveState();
					changeToTargetBehaviorState(OrganismBehaviorState.NEAR_FIHGTTING);
					break;
				
				case OrganismBehaviorState.MOVE_TO_APPOINTED_POINT:
					changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
					break;
			}
		}
		
		public function notifyMoving(oldX:Number,oldY:Number):void
		{
			checkAddTowerAtk();
			checkAddSoldierState();
			checkWalkEff();
		}
		
		public function getRollbackPositionVOByDistance(distance:Number):Array
		{
			return myMoveLogic.getRollbackPositionVOByDistance(myMoveState,distance);
		}
		
		public function getPredictionPositionVOByTime(time:uint):PointVO
		{
			return myMoveLogic.getPredictionPositionVOByTime(myMoveState,time);
		}
		
		public function getCurrentActualSpeed():Number
		{
			var nowSpeed:Number = myMoveState.myIsWalking ? myMoveState.mySpeed : 0;
			return nowSpeed * (1 + myMoveState.mySpeedPct);
		}
		
		//保持站立姿势
		public function enforceRecoverToStandState():void
		{
			myMoveLogic.enforceRecoverToStandState(myMoveState);
		}
		
		public function updateWalkPathStepIndex(pathStepIndex:int):void
		{
			myMoveLogic.updateWalkPathStepIndex(myMoveState,pathStepIndex);
		}
		
		public function setAngle(value:Number, isApplyImmediately:Boolean = false):void
		{
			myMoveLogic.setAngle(myMoveState,value,isApplyImmediately);
		}
		
		//外界命令控制的移动1
		public final function moveToAppointPoint(appointPoint:PointVO):void
		{
			if(myCampType == FightElementCampType.FRIENDLY_CAMP && !myFightState.bStun)
			{
				_isRecieverdersMoveMode = true;
				
				myAppointPoint.x = appointPoint.x;
				myAppointPoint.y = appointPoint.y;
				
				/*if(currentSearchedEnemy != null)
				{
					currentSearchedEnemy.notifyBeUnBlockedByEnemy(this);
				}*/
				resetSearchState();
				
				backToCurrentAppointPoint();	
			}
		}
		
		//外界命令控制的移动2
		public function moveToAppointPointByPath(pathPoints:Vector.<PointVO>):void
		{
			if(myCampType == FightElementCampType.FRIENDLY_CAMP && !myFightState.bStun)
			{
				_isRecieverdersMoveMode = true;
				
				myAppointPoint.x = pathPoints[pathPoints.length - 1].x;
				myAppointPoint.y = pathPoints[pathPoints.length - 1].y;
				
				/*if(currentSearchedEnemy != null)
				{
					currentSearchedEnemy.notifyBeUnBlockedByEnemy(this);
				}*/
				resetSearchState();
				
				myMoveLogic.moveToByPath(myMoveState,pathPoints);
				
				changeToTargetBehaviorState(OrganismBehaviorState.MOVE_TO_APPOINTED_POINT);	
			}
		}
		
		protected final function backToCurrentAppointPoint():void
		{
			myMoveLogic.moveToByPath(myMoveState,Vector.<PointVO>([myAppointPoint]));
			changeToTargetBehaviorState(OrganismBehaviorState.MOVE_TO_APPOINTED_POINT);
		}
		
		//currentSearchedEnemy.notifyBeBlockedByEnemy(this);bug在此函数之前也会调用该代码  ,eg. line 965
		protected function moveToCurrentFindedEnemyNearby():void
		{
			if(this is BasicMonsterElement)
			{
				var gaojian:int = 0;
			}
			currentSearchedEnemy.notifyBeBlockedByEnemy(this);
			storeMoveState();
			myMoveLogic.moveToByPath(myMoveState,Vector.<PointVO>([currentSearchedEnemy.getAttackablePositionByTargetEnemy(this)]));
			changeToTargetBehaviorState(OrganismBehaviorState.MOVING_TO_ENEMY_NEAR_BY);
		}
		
		protected function storeMoveState():void
		{
			
		}
		
		protected function restoreMoveState():void
		{
			
		}
		
		/****************************************************************
		 * *************************** 移动时状态检查逻辑   **************************
		 * **************************************************************/	
		private var _lastWalkPt:PointVO = new PointVO;
		private var _groundEffTemp:IGroundEffSheetItem;
		private function checkWalkEff():void
		{
			if(0 == myFightState.groundEffcetState.effId)
				return;
			
			var distance:int = GameMathUtil.distance(x,y/GameFightConstant.Y_X_RATIO,_lastWalkPt.x,_lastWalkPt.y/GameFightConstant.Y_X_RATIO);
			if(!_groundEffTemp)
				_groundEffTemp = groundEffModel.getGroundEffSheetById(myFightState.groundEffcetState.effId);
			if(distance<_groundEffTemp.range)
				return;
			
			var temp:IGroundEffSheetItem = groundEffModel.getGroundEffSheetById(myFightState.groundEffcetState.effId);
			if(!temp)
				return;
			var vecGroundEff:Vector.<BasicGroundEffect> = sceneElementsService.searchGroundEffsBySearchArea(x,y,temp.range,1,onSearchGroundEffCondition);
			if(vecGroundEff && vecGroundEff.length>0)
				return;
			_lastWalkPt.x = x;
			_lastWalkPt.y = y;
			
			var eff:BasicGroundEffect = objPoolMgr.createSceneElementObject(
				GameObjectCategoryType.GROUNDEFFECT,myFightState.groundEffcetState.effId,false) as BasicGroundEffect;
			if(!eff)
				return;
			eff.x = x;
			eff.y = y;
			eff.setEffectParam(myFightState.groundEffcetState.duration,myFightState.groundEffcetState.arrParam,this);
			eff.notifyLifecycleActive();
		}
		
		private function onSearchGroundEffCondition(e:BasicGroundEffect):Boolean
		{
			return e.objectTypeId == myFightState.groundEffcetState.effId;
		}
		
		private function searchNotBarrackTower(e:BasicTowerElement):Boolean
		{
			return TowerType.Barrack != e.towerType;
		}
		
		private var _vecEffTowers:Vector.<BasicTowerElement> = new Vector.<BasicTowerElement>;
		private function checkAddTowerAtk():void
		{
			if(myFightState.addTowerAtk.bHasState)
			{
				var vecTower:Vector.<BasicTowerElement> = sceneElementsService.
					searchTowersBySearchArea(this.x,this.y,myFightState.addTowerAtk.iArea*(1+myFightState.extraAddTowerAtk.extraAddTowerAtkAreaPct*0.01),0,searchNotBarrackTower);
				if(!vecTower || 0 == vecTower.length)
				{
					clearAllEffTowers();
					return;
				}
				var tower:BasicTowerElement;
				for each(tower in _vecEffTowers)
				{
					if(vecTower.indexOf(tower) == -1)
					{
						tower.addAtkPct(-myFightState.addTowerAtk.iAtkPct*(1+myFightState.extraAddTowerAtk.extraAddTowerAtkValuePct*0.01),this);
						tower.fightState.addedAtkCnt--;
						if(tower.fightState.addedAtkCnt<=0)
							tower.notifyDettachBuffer(BufferID.AddTowerAtk);
					}
				}
				if(vecTower && vecTower.length>0)
				{
					for each(tower in vecTower)
					{
						if(_vecEffTowers.indexOf(tower) != -1)
							continue;
						tower.addAtkPct(myFightState.addTowerAtk.iAtkPct*(1+myFightState.extraAddTowerAtk.extraAddTowerAtkValuePct*0.01),this);
						var param:Object = {};
						param[BufferFields.BUFF] = BufferID.AddTowerAtk;
						param[BufferFields.DURATION] = 0;
						param[SkillResultTyps.SPECIAL_PROCESS] = 1;
						tower.notifyAttachBuffer(BufferID.AddTowerAtk,param,this);
						tower.fightState.addedAtkCnt++;
					}
				}
				_vecEffTowers = vecTower;
			}
		}
		
		private function clearAllEffTowers():void
		{
			for each(var tower:BasicTowerElement in _vecEffTowers)
			{
				tower.addAtkPct(-myFightState.addTowerAtk.iAtkPct*(1+myFightState.extraAddTowerAtk.extraAddTowerAtkValuePct*0.01),this);
				tower.fightState.addedAtkCnt--;
				if(tower.fightState.addedAtkCnt<=0)
					tower.notifyDettachBuffer(BufferID.AddTowerAtk);
			}
			_vecEffTowers.length = 0;
		}
		
		private var _vecEffSoldier:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>;
		private function checkAddSoldierState():void
		{
			if(myFightState.addSoldierState.bHasState)
			{
				var vecSoldier:Vector.<BasicOrganismElement> = sceneElementsService.
					searchOrganismElementsBySearchArea(this.x,this.y,myFightState.addSoldierState.iAtkArea,myCampType,searchSoldierFilter);
				if(!vecSoldier || 0 == vecSoldier.length)
				{
					clearAllEffSoldiers();
					return;
				}
				var soldier:BasicOrganismElement;
				for each(soldier in _vecEffSoldier)
				{
					if(vecSoldier.indexOf(soldier) == -1)
					{
						soldier.addAtkPct(-myFightState.addSoldierState.iAtkPct,this);
						soldier.addPhysicDef(-myFightState.addSoldierState.iDef,this);
						soldier.addMagicDef(-myFightState.addSoldierState.iDef,this);
						soldier.fightState.addedAtkCnt--;
						if(soldier.fightState.addedAtkCnt<=0)
							soldier.notifyDettachBuffer(BufferID.AddSoilderAtkDef);
					}
				}
				if(vecSoldier && vecSoldier.length>0)
				{
					for each(soldier in vecSoldier)
					{
						if(_vecEffSoldier.indexOf(soldier) != -1)
							continue;
						soldier.addAtkPct(myFightState.addSoldierState.iAtkPct,this);
						soldier.addPhysicDef(myFightState.addSoldierState.iDef,this);
						soldier.addMagicDef(myFightState.addSoldierState.iDef,this);
						var param:Object = {};
						param[BufferFields.BUFF] = BufferID.AddSoilderAtkDef;
						param[BufferFields.DURATION] = 0;
						param[SkillResultTyps.SPECIAL_PROCESS] = 1;
						soldier.notifyAttachBuffer(BufferID.AddSoilderAtkDef,param,this);
						soldier.fightState.addedAtkCnt++;
					}
				}
				_vecEffSoldier = vecSoldier;
			}
		}
		
		private function searchSoldierFilter(e:BasicOrganismElement):Boolean
		{
			return e!=this;
		}
		
		private function clearAllEffSoldiers():void
		{
			for each(var soldier:BasicOrganismElement in _vecEffSoldier)
			{
				if(!soldier.isAlive)
					continue;
				soldier.addAtkPct(-myFightState.addSoldierState.iAtkPct,this);
				soldier.addPhysicDef(-myFightState.addSoldierState.iDef,this);
				soldier.addMagicDef(-myFightState.addSoldierState.iDef,this);
				soldier.fightState.addedAtkCnt--;
				if(soldier.fightState.addedAtkCnt<=0)
					soldier.notifyDettachBuffer(BufferID.AddSoilderAtkDef);
			}
			_vecEffSoldier.length = 0;
		}
		
		/****************************************************************
		 * *************************** 技能相关   **************************
		 * **************************************************************/
		override protected function checkCanUseSkill():Boolean
		{
			if(!isAlive)
				return false;
			return super.checkCanUseSkill();
		}
		
		protected function onBlockAttack():void
		{
			if(myFightState.iBlockAtkPct>0)
			{
				var dmg:int = getRandomDamageValue()*myFightState.iBlockAtkPct;
				areaAttack(this,dmg,GameFightConstant.NEAR_SKILL_AREA);
			}
			myFightState.bBlock = false;
			createSceneTipEffect(SceneTipEffect.SCENE_TIPE_MISS, this.x, this.y - bodyHeight);
			notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_BLOCK);
		}
		
		override public function notifyTriggerSkillAndBuff(condition:int):void
		{
			super.notifyTriggerSkillAndBuff(condition);
			if(condition == TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED && _myBloodBar )
			{
				_myBloodBar.maxValue = myFightState.getRealMaxLife();
				_myBloodBar.currentValue = myFightState.curLife;
			}
		}
		
		override protected function adjustUseSkillAngle():void
		{
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			var target:ISkillTarget = state.mainTarget;
			if(!target)
				target = state.vecTargets[0];
			if(!target || target == this)
				return;
			setAngle(GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, target.x, target.y), true);
		}
		
		/****************************************************************
		 * *************************** ISkillOwner接口实现   **************************
		 * **************************************************************/
		
		override public function hurtSelf(value:int,atkType:int,owner:ISkillOwner,dieType:int = OrganismDieType.NORMAL_DIE,scaleValue:Number = 1,bNormalAttack:Boolean = true):Boolean
		{
			this.hurtBlood(value,atkType,true,owner,false,dieType,scaleValue,false,bNormalAttack);
			return true;
		}
		
		override public function dmgAddition(pct:int,owner:ISkillOwner,dieType:int = 0):Boolean
		{
			var atk:uint = GameMathUtil.randomUintBetween(owner.minAtk,owner.maxAtk);
			this.hurtBlood(atk*pct/100.0,owner.atkType,true,owner,false,dieType);
			return true;
		}
		
		
		override public function rebirthNow(owner:ISkillOwner):Boolean
		{
			//immediatelyResurrection();
			//changeToTargetBehaviorState(OrganismBehaviorState.RESURRECTION);
			myFightState.bCanRebirth = true;
			return true;
		}
		
		override public function addPassiveMoveSpeedPct(value:int,owner:ISkillOwner):Boolean
		{
			myMoveState.mySpeed = myMoveState.mySpeed*(100+value)/100.0;
			return true;
		}
		
		override public function addPassiveMoveSpeed(value:int,owner:ISkillOwner):Boolean
		{
			myMoveState.mySpeed += GameMathUtil.secondSpeedToFrameMoveSpeed(value);
			return true;
		}
		
		override public function changeMoveSpeed(iPct:int,owner:ISkillOwner,bBuffEnd:Boolean = false):Boolean
		{
			if(myFightState.bImmuneRdcMoveSpd && ((iPct<0 && !bBuffEnd)||(iPct>0 && bBuffEnd)))
				return false;
			/*if(Math.abs(iPct)<=Math.abs(myMoveState.mySpeedPct*100))
				return false;*/

			myMoveState.mySpeedPct += iPct/100.0;

			return true;
		}
		
		override public function atkRoundUnits(area:int,atk:int,camp:int,owner:ISkillOwner,dieType:int = 0):Boolean
		{
			var vecTargets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x,this.y,area,camp);
			for each(var target:BasicOrganismElement in vecTargets)
			{
				target.hurtBlood(atk,myFightState.atkType,false,this,false,dieType);
			}
			return true;
		}
		
		override public function suddenDeath(owner:ISkillOwner,dieType:int = 0):Boolean
		{
			if(isBoss || fightState.bInvincible)
				return false;
			this.hurtBlood(100,FightAttackType.PHYSICAL_ATTACK_TYPE,true,owner,true,dieType);
			return true;
		}
		
		override public function stunSlef(bEnable:Boolean,owner:ISkillOwner):Boolean
		{
			if(bEnable)
				++myFightState.iStun;
			else
				--myFightState.iStun;
			if(myFightState.iStun<0)
				throw new Error("myFightState.iStun cannot less than 0.");
			
			if(0 == myFightState.iStun)
			{
				//myFightState.bStun = bEnable;
				onDoDefaultBehavior();
				return true;
			}
			if(!isAlive)
				return false;
			//myFightState.bStun = bEnable;
			changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			return true;
		}
		
		override public function changeToSheep(bChange:Boolean,owner:ISkillOwner):Boolean
		{
			if(bChange == myFightState.bSheep || myCampType == owner.campType || !isAlive)
				return false;
			myFightState.bSheep = bChange;
			showSlefSheep(bChange);
			myMoveLogic.initMoveUnitByState(myMoveState,false);

			if(GameObjectCategoryType.MONSTER == myElemeCategory)
			{
				changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
			}
			else
			{
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}
			return true;
		}
		
		protected function showSlefSheep(bShow:Boolean):void
		{
			var idx:int = 0;
			if(bShow)
			{
				var res:String = fightState.isFlyUnit?"FlySheep":"Sheep";
				//var vecFrames:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(res, myScaleRatioType);
				//if(vecFrames)
				{
					idx = getChildIndex(myBodySkin);
					myOldBodySkin = myBodySkin;
					removeChild(myBodySkin);
					myBodySkin = new NewBitmapMovieClip([res], [myScaleRatioType]);
					injector.injectInto(myBodySkin);
					addChildAt(myBodySkin,idx);
					if(GameObjectCategoryType.MONSTER == myElemeCategory)
					{
						myBodySkin.gotoAndPlay2(getWalkTypeStr()+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
							getWalkTypeStr()+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					}
					else
					{
						myBodySkin.gotoAndStop2(getWalkTypeStr()+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
					}
				}
			}
			else if(myBodySkin && myOldBodySkin)
			{
				idx = getChildIndex(myBodySkin);
				removeChild(myBodySkin);
				myBodySkin.dispose();
				myBodySkin = myOldBodySkin;
				if(myBodySkin)
					addChildAt(myBodySkin,idx);
				myOldBodySkin = null;
			}
		}
		
		override public function addLife(value:int,owner:ISkillOwner,hasAnim:Boolean = true):Boolean
		{
			if(!isAlive || isFreezedState())
				return false;
			var result:Boolean = myFightState.addLife(value);
			if(hasAnim && value>0 && result)
				playBenefitBloodEffect((FightElementCampType.FRIENDLY_CAMP == myCampType && !myFightState.betrayState.bBetrayed)
				|| (FightElementCampType.ENEMY_CAMP == myCampType && myFightState.betrayState.bBetrayed) );
			return result;
		}
		
		override public function explodeAfterDie(dmg:int,range:int,owner:ISkillOwner,dieType:int):Boolean
		{
			var vecTargets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x,this.y,range,myCampType);
			if(OrganismDieType.NORMAL_DIE != dieType)
				_myCurrentDieType = dieType;
			for each(var target:BasicOrganismElement in vecTargets)
			{
				target.hurtSelf(dmg,atkType,owner,dieType);
			}
			return true;
		}
		
		override public function canSummon(uid:uint,maxCount:int,owner:ISkillOwner):Boolean
		{
			var arrPets:Array = mySummonPets.get(uid);
			if(arrPets && arrPets.length>=maxCount)
				return false;
			return true;
		}
		
		override public function summon(uid:uint,count:int,maxCount:int,owner:ISkillOwner):Boolean
		{
			var arrPets:Array = mySummonPets.get(uid);
			if(arrPets && arrPets.length>=maxCount)
				return false;
			if(!arrPets)
			{
				arrPets = [];
				mySummonPets.put(uid,arrPets);
			}
			var offX:int = 0;
			if(count > maxCount-arrPets.length)
				count = maxCount-arrPets.length;
			
			for(var i:int=0;i<count;++i)
			{
				offX += 10;
				var soldier:SummonByOrganisms = objPoolMgr.createSceneElementObject(GameObjectCategoryType.SUMMON_BY_ORGANISM,uid,false) as SummonByOrganisms;
				if(soldier)
				{
					soldier.master = this;
					soldier.visible = true;
					soldier.x = this.x+offX;
					soldier.y = this.y;
					soldier.notifyLifecycleActive();
					arrPets.push(soldier);
				}	
			}
			return true;
		}
		
		override public function summonAfterDie(uid:uint,duration:int,owner:ISkillOwner):Boolean
		{
			var soldier:SupportSoldier = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.SUPPORT_SOLDIER, uid, false) as SupportSoldier;
			soldier.lifeDuration = duration;
			soldier.visible = true;
			soldier.x = this.x;
			soldier.y = this.y;
			soldier.notifyLifecycleActive();
			return true;
		}
		
		override public function canBeProvoked(owner:ISkillOwner):Boolean
		{
			return isAlive && !fightState.isFlyUnit && !fightState.bSheep;
		}
		
		override public function Invisible(bEnable:Boolean,owner:ISkillOwner):Boolean
		{
			super.Invisible(bEnable,owner);
			if(bEnable)
			{
				myBodySkin.alpha = 0.5;
				enforceTerminateCurrentBehaviorAndThenDoDefaultBehavior();
				setSearchedEnemy(null);
			}
			else
				myBodySkin.alpha = 1.0;
			return true;
		}
		
		/*****************************************************************************/
		
		/**
		 * 移除寒冰盾
		 */
		protected function RemoveIceShield():void
		{
			
		}
		
		protected function onSafeLaunch(area:int,dmg:int,stunTime:int,fallAtkArea:int,fallDmg:int):void
		{
			
		}
		
		override protected function onBetrayed():void
		{
			dispatchLeaveOffScreenSearchRangeEvent();
			setSearchedEnemy(null);
			super.onBetrayed();
		}
		
		override public function get targetName():String
		{
			return myMoveFighterInfo.getName();
		}
		
		override protected function cancleUseSkillState():void
		{
			onDoDefaultBehavior();
		}
		
		override protected function isNotUseSkillState():Boolean
		{
			return OrganismBehaviorState.USE_SKILL != currentBehaviorState;
		}
	}
}