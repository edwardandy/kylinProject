package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BattleEffectType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundItem.BasicGroundItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.utils.CommonAnimationEffects;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/*
		怪身边可以站的位置说明：，将圆分成12等份， 从X轴0 开始 0度， 30度， 60度， 120度， 150度
	    180度， 210度， 330度共8个位置
	*/
	public class BasicMonsterElement extends BasicOrganismElement
	{
		//private var _myIsBoos:Boolean = false;
		[Inject]
		public var mapModel:IMapRoadModel;
		[Inject]
		public var monsterModel:IMonsterSheetDataModel;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		
		private var _escapeRoadIndex:int = -1;
		private var _escapePathIndex:int = -1;
		
		private var _appearRoadPathStepIndex:int = -1;
		
		protected var mySceneKillLife:int = 1;
		
		private var _ownWave:int;
		
		public function BasicMonsterElement(typeId:int)
		{	
			this.myElemeCategory = GameObjectCategoryType.MONSTER;
			super(typeId);
			myMoveFighterInfo = monsterModel.getMonsterSheetById(typeId);
			this.myCampType = FightElementCampType.ENEMY_CAMP;
			mySceneKillLife = monsterTemplateInfo.killLife;
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return myElemeCategory+"_"+ (monsterTemplateInfo.resId || myObjectTypeId);
		}
		
		public function get ownWave():int
		{
			return _ownWave;
		}

		public function set ownWave(value:int):void
		{
			_ownWave = value;
			updateAtkAndLife();
		}

		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
		}
		
		override protected function initStateWhenActive():void
		{
			this.myCampType = FightElementCampType.ENEMY_CAMP;
			myFocusTipEnable = true;
			setBodyFilter(null);
			super.initStateWhenActive();
		}
		
		public final function get monsterTemplateInfo():IMonsterSheetItem
		{
			return IMonsterSheetItem(myMoveFighterInfo);
		}
		
		/*public final function get isBoos():Boolean
		{
			return _myIsBoos;
		}*/
		
		public final function get escapeRoadIndex():int
		{
			return _escapeRoadIndex;
		}
		
		public final function get escapePathIndex():int
		{
			return _escapePathIndex;
		}
		
		//只有地方阵营的生物才会逃跑
		public function startEscapeByPath(pathPoints:Vector.<PointVO>, escapeRoadIndex:int, escapePathIndex:int):void
		{
			if(myCampType != FightElementCampType.ENEMY_CAMP) return;

			_escapeRoadIndex = escapeRoadIndex;
			_escapePathIndex = escapePathIndex;
			
			myMoveLogic.moveToByPath(myMoveState,pathPoints);
			changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
		}
		
		public final function setAppearRoadPathStepIndex(appearRoadPathStepIndex:int):void
		{
			_appearRoadPathStepIndex = appearRoadPathStepIndex;
		}
		/**
		 * 距离终点的比例，用于判断怪物是否更靠近终点
		 * @return  距离终点的比例
		 * 
		 */		
		public function getDisToEndPointRatio():Number
		{
			return mapModel.getDisRatioByPosIndex(this.x,this.y,myMoveState.getCurrentLineIndex(),_escapePathIndex,_escapeRoadIndex);
		}
		
		public function setEnemyAndIdle(target:BasicOrganismElement):void
		{
			if(target)
			{
				mySearchedEnemy = target;
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}
		}
		
		override protected function onEnforceAppear():void
		{
			if(myCampType == FightElementCampType.ENEMY_CAMP)
			{
				if(_appearRoadPathStepIndex >= 0)
				{
					updateWalkPathStepIndex(_appearRoadPathStepIndex);
					_appearRoadPathStepIndex = -1;
				}
			}
			super.onEnforceAppear();
		}
		
		override protected function onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior():void
		{
			super.onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior();
			
			if(myCampType == FightElementCampType.ENEMY_CAMP && isAlive && OrganismBehaviorState.USE_SKILL != currentBehaviorState)
			{
				changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
			}
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.ENEMY_ESCAPING:
					if(!isAlive)
						var gaojian:int = 0;
					if(myFightState.betrayState.bBetrayed)
					{
						changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
						return;
					}
					restoreMoveState();
					myMoveLogic.resumeWalk(myMoveState);
					break;
			}
		}
		
		override protected function onBehaviorChangeToDying():void
		{
			gameInteractiveMgr.disFocusTargetElement(this);
			//setIsOnFocus(false);
			myFocusTipEnable = false;
			super.onBehaviorChangeToDying();
		}
		
		override protected function onFocusChanged():void
		{
			if(myIsInFocus)
			{
				//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_MONSTER,{"param":[myObjectTypeId]});
			}
			super.onFocusChanged();
		}
		
		/*override protected function onSkillDisappearAnimEnd():void
		{
			super.onSkillDisappearAnimEnd();
			if(isAlive)
				changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
		}*/
		
		override protected function onArrivedEndPoint():void
		{
			super.onArrivedEndPoint();
			
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.ENEMY_ESCAPING:
					dispatchLeaveOffScreenSearchRangeEvent();
					
					//并通知系统，敌人跑掉啦
					var bIsBoss:Boolean = isBoss;
					destorySelf();
					//胜利失败检测
					if(sceneModel.sceneLife>0 && mySceneKillLife>0)
					{
						GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.HURT_WARN_EFFECT );
					}
					sceneModel.updateSceneLife(-mySceneKillLife);
					successAndFailedDetector.onEnemyCampUintArrivedEndPoint(this,bIsBoss);
					
					
					break;
			}
		}
		
		override protected function storeMoveState():void
		{
			myMoveState.storePath();
		}
		
		override protected function restoreMoveState():void
		{
			myMoveState.restorePath();
		}
		
		override public function get isBoss():Boolean
		{
			return monsterTemplateInfo.isBoss;
		}
		
		override public function rollBack(range:uint,owner:ISkillOwner):Boolean
		{
			var results:Array = getRollbackPositionVOByDistance(range); 
			setAppearRoadPathStepIndex(results[0]);
			var p:PointVO = results[1];
			enforceDisappear(p, true,true);
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
			var arrX:Array = [-1,0,1,-1,1,-1,0,1];
			var arrY:Array = [-1,-1,-1,0,0,1,1,1];
			if(count > maxCount-arrPets.length)
				count = maxCount-arrPets.length;
			
			for(var i:int=0;i<count;++i)
			{
				var monster:BasicMonsterElement = objPoolMgr
					.createSceneElementObject(GameObjectCategoryType.MONSTER, uid) as BasicMonsterElement;
				monster.x = this.x + arrX[i]*20;
				monster.y = this.y + arrY[i]*20;
				
				var pathPoints:Vector.<PointVO> = mapModel.getMapRoad(_escapeRoadIndex).lineVOs[i%3].points;
				monster.startEscapeByPath(pathPoints, _escapeRoadIndex, i%3);
				monster.updateWalkPathStepIndex(myMoveState.currentPathStepIndex);
			}
			return true;
		}
		
		override public function dropBox(itemId:uint,count:int,duration:int,money:uint,owner:ISkillOwner):Boolean
		{
			if(count<=0 || duration<=0 || money == 0 || itemId == 0)
				return false;
			var ix:int = 0;
			var iy:int = 0;
			for(var i:int = 0;i<count;++i)
			{
				var item1:BasicGroundItem = objPoolMgr.createSceneElementObject(GameObjectCategoryType.GROUNDITEM, itemId,false) as BasicGroundItem;
				item1.initByParam(duration,money);
				if(i > 0)
				{
					ix = Math.random()*80 - 40;
					iy = Math.random()*80 - 40;
				}
				item1.x = this.x + ix;
				item1.y = this.y + iy;
				item1.notifyLifecycleActive();
			}
			return true;
		}
		
		override public function get type():int
		{
			return FocusTargetType.MONSTER_TYPE;
		}
		
		override public function get hurt():int
		{
			return monsterTemplateInfo.killLife;
		}
		
		override protected function onHurtedEff(hurtValue:int,owner:ISkillOwner):void
		{
			super.onHurtedEff(hurtValue,owner);
			if(GameObjectCategoryType.HERO == owner.elemeCategory)
			{
				var idx:int;
				if(owner.fightState.hugeDmgState.bHasBuff && owner.fightState.hugeDmgState.bShooted)
				{
					idx = 0;
					owner.fightState.hugeDmgState.bShooted = false;
				}
				else
					idx = int(GameMathUtil.randomFromValues([1,2]));
				
				CommonAnimationEffects.hurtEffect( this, hurtValue.toString(), 0,-bodyHeight, idx);
			}
		}
		
		override protected function initFightState():void
		{
			super.initFightState();
			updateAtkAndLife();
		}
		
		private function updateAtkAndLife():void
		{
			var atkScale:Number = fightData.monAtkScale;
			var lifeScale:Number = fightData.monLifeScale;
			/*if(EndlessBattleMgr.instance.isEndless)
			{
				var temp:DreamLandTemplateInfo = TemplateDataFactory.getInstance().getDreamLandTemplateById(_ownWave);
				if(temp)
				{
					atkScale = temp.atkScale;
					lifeScale = temp.lifeScale;
				}
			}*/

			myFightState.minAtk = myMoveFighterInfo.minAtk * atkScale;
			myFightState.maxAtk = myMoveFighterInfo.maxAtk * atkScale;
			myFightState.maxlife = myMoveFighterInfo.life * lifeScale;
			myFightState.curLife = myFightState.maxlife;
		}
		
		override protected function onBufferAttached(buffId:uint):void
		{
			switch(buffId)
			{
				case BufferID.SnowStorm:
					setBodyFilter([filterMgr.colorBlueMatrixFilter]);
					break;
			}
			super.onBufferAttached(buffId);
		}
		
		override protected function onBufferDettached(buffId:uint):void
		{
			switch(buffId)
			{
				case BufferID.SnowStorm:
					setBodyFilter(null);
					break;
			}
			super.onBufferDettached(buffId);
		}
		
		override protected function getDefaultSoundObj():Object
		{
			return monsterTemplateInfo?monsterTemplateInfo.objSound:null;
		}
	}
}