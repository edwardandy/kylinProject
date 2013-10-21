package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.FightUnitType;
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.IOrganismSkiller;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.IFocusTargetInfo;
	import release.module.kylinFightModule.gameplay.oldcore.logic.hurt.FightUnitState;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class BasicFightElement extends BasicSceneInteractiveElement implements IOrganismSkiller, IFocusTargetInfo
	{
		protected var myFireLocalPoint:PointVO = new PointVO();
		protected var mySearchedEnemy:BasicOrganismElement = null;
		private var _myCampType:int = -1;
		
		protected var myFightState:FightUnitState;
		
		protected var myAttackCDTimer:SimpleCDTimer;
		protected var myResurrectionCDTimer:SimpleCDTimer;
		protected var myIdelAnimationCDTimer:SimpleCDTimer;
		
		public function BasicFightElement()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			initStateWhenActive();
		}
		
		override protected function initStateWhenActive():void
		{
			if(myBodySkin)
				myBodySkin.visible = true;
		}
		
		override protected function onLifecycleFreeze():void
		{
			clearStateWhenFreeze();
			//myFightState = null;
			//myFireLocalPoint = null;
			//myIdelAnimationCDTimer = null;
			//myResurrectionCDTimer = null;
			//myAttackCDTimer = null;
			//mySearchedEnemy = null;
			super.onLifecycleFreeze();
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean = false):void
		{
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			myFireLocalPoint = null;
			myIdelAnimationCDTimer = null;
			myAttackCDTimer = null;
			mySearchedEnemy = null;
			myFightState = null;
			mySearchedEnemy = null;
			myResurrectionCDTimer = null;
		}
		
		protected function get myCampType():int
		{
			if(myFightState && myFightState.betrayState.bBetrayed)
				return myFightState.betrayState.betrayCamp;
			return _myCampType;
		}
		
		protected function set myCampType(type:int):void
		{
			_myCampType = type;
		}
		
		public function get attackArea():uint
		{
			return myFightState.atkArea;
		}
		
		public function get fightUnitType():int
		{
			return FightUnitType.LAND;
		}
		
		public function get campType():int
		{
			return myCampType;
		}
		
		public function get atkType():int
		{
			return myFightState.atkType;
		}
		
		public function get objId():uint
		{
			return myObjectTypeId;
		}
		
		public function get isBoss():Boolean
		{
			return false;
		}
		
		public function get isAlive():Boolean
		{
			return true;
		}
		
		public function isFreezedState():Boolean
		{
			return -1 == currentBehaviorState;
		}
		
		public function get isFullLife():Boolean
		{
			return myFightState.curLife == myFightState.getRealMaxLife();
		}
		
		public function get isHero():Boolean
		{
			return GameObjectCategoryType.HERO == myElemeCategory;
		}
		
		public function get subjectCategory():int
		{
			return 0;
		}
		
		public function get fightState():FightUnitState
		{
			return myFightState;
		}
		
		public function get curLevel():int
		{
			return 1;
		}
	
		/**
		 * 最小攻击
		 */
		public function get minAtk():int
		{
			return myFightState?myFightState.realMinAtk:0;
		}
		
		/**
		 * 最大攻击
		 */
		public function get maxAtk():int
		{
			return myFightState?myFightState.realMaxAtk:0;
		}
		
		//获取对立阵营
		public final function get oppositeCampType():int
		{
			return myCampType == FightElementCampType.ENEMY_CAMP ?
				FightElementCampType.FRIENDLY_CAMP :
				FightElementCampType.ENEMY_CAMP;
		}
		
		public function get hurtPositionHeight():Number
		{
			return 0;
		}
		
		protected function getBaseFightInfo():IBaseFighterSheetItem
		{
			return null;
		}
		
		/**
		 * 获取全局开火点
		 */
		public function getGlobalFirePoint():PointVO
		{
			return new PointVO(this.x + myFireLocalPoint.x, this.y + myFireLocalPoint.y);
		}
		
		/**
		 * 获取随机伤害值
		 */
		protected function getRandomDamageValue():uint
		{
			return GameMathUtil.randomUintBetween(myFightState.minAtk, myFightState.maxAtk);
		}
		
		protected function getRealDamage():uint
		{
			var dmg:int = getRandomDamageValue();
			return dmg + myFightState.extraAtk + dmg*myFightState.extraAtkPct/100;
		}
		
		protected function getDmgBeforeHurtTarget(bNear:Boolean = true,target:BasicOrganismElement = null):int
		{
			return getRealDamage();
		}
		
		public function notifyHurtTagetOnkill(beHurtTarget:BasicOrganismElement, finalHurtValue:uint):void
		{
		}
		
		protected function initFightState():void
		{
			
		}
		
		//private var _t:int;
		/**
		 * 攻击目标敌人
		 */
		protected function fireToTargetEnemy():void
		{
			//trace(getTimer() - _t);
			//_t = getTimer();
		}
		
		/**
		 * 有些召唤宠物没有上下移动的动作，就直接用walk的动作
		 */	
		protected function getUpWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.UP_WALK;
		}
		
		protected function getDownWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.DOWN_WALK;
		}
		
		protected function getWalkTypeStr():String
		{
			return GameMovieClipFrameNameType.WALK;
		}
		
		protected function getNearAttackTypeStr():String
		{
			return GameMovieClipFrameNameType.NEAR_ATTACK;
		}
		
		protected function getNearFirePointTypeStr():String
		{
			return GameMovieClipFrameNameType.NEAR_FIRE_POINT;
		}
		
		protected function getFarAttackTypeStr():String
		{
			return GameMovieClipFrameNameType.FAR_ATTACK;
		}
		
		protected function getFarFirePointTypeStr():String
		{
			return GameMovieClipFrameNameType.FAR_FIRE_POINT;
		}
		
		protected function getIdleTypeStr():String
		{
			return GameMovieClipFrameNameType.IDLE;
		}
		
		/**
		 * implements IFocusTargetInfo
		 */		
		//
		public function get type():int
		{
			return FocusTargetType.NONE_TYPE;
		}
		
		public function get targetName():String
		{
			return "";
		}
			
		public function get resourceID():int
		{
			return myObjectTypeId;
		}
			
		public function get curLife():int
		{
			return fightState.curLife;
		}
			
		public function get maxLife():int
		{
			return fightState.getRealMaxLife();
		}

		public function get minAttack():int
		{
			return fightState.realMinAtk;
		}
	
		public function get maxAttack():int
		{
			return fightState.realMaxAtk;
		}

		public function get attackType():Boolean
		{
			return fightState.atkType == FightAttackType.MAGIC_ATTACK_TYPE;
		}

		public function get defense():int
		{
			return fightState.magicDefense>0 ? fightState.magicDefense : fightState.physicDefense;
		}
	
		public function get defenseType():Boolean
		{
			return fightState.magicDefense>0;
		}
	
		public function get hurt():int
		{
			return 0;
		}
	
		public function get attackGap():int
		{
			return fightState.cdTime;
		}

		public function get rebirthTime():int
		{
			return myFightState.rebirthTime;
		}
	}
}