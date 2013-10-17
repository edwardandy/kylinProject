package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import com.shinezone.towerDefense.fight.constants.BattleEffectType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.FocusTargetType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import com.shinezone.towerDefense.fight.constants.identify.MagicID;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundItem.BasicGroundItem;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.WorkerRopeMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.CommonAnimationEffects;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.MovieClipRasterizationUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadLineVOHelperUtil;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.base.BaseMoveFighterInfo;
	import framecore.structure.model.user.dreamland.DreamLandTemplateInfo;
	import framecore.structure.model.user.monster.MonsterTemplateInfo;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;

	/*
		怪身边可以站的位置说明：，将圆分成12等份， 从X轴0 开始 0度， 30度， 60度， 120度， 150度
	    180度， 210度， 330度共8个位置
	*/
	public class BasicMonsterElement extends BasicOrganismElement
	{
		//private var _myIsBoos:Boolean = false;

		private var _escapeRoadIndex:int = -1;
		private var _escapePathIndex:int = -1;
		
		private var _appearRoadPathStepIndex:int = -1;
		
		protected var mySceneKillLife:int = 1;
		
		private var _ownWave:int;
		
		public function BasicMonsterElement(typeId:int)
		{	
			this.myElemeCategory = GameObjectCategoryType.MONSTER;
			super(typeId);
			myMoveFighterInfo = TemplateDataFactory.getInstance().getMonsterTemplateById(typeId);
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
		
		public final function get monsterTemplateInfo():MonsterTemplateInfo
		{
			return MonsterTemplateInfo(myMoveFighterInfo);
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
			return GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.getDisRatioByPosIndex(this.x,this.y,myMoveState.getCurrentLineIndex(),_escapePathIndex,_escapeRoadIndex);
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
			GameAGlobalManager.getInstance().gameInteractiveManager.disFocusTargetElement(this);
			//setIsOnFocus(false);
			myFocusTipEnable = false;
			super.onBehaviorChangeToDying();
		}
		
		override protected function onFocusChanged():void
		{
			if(myIsInFocus)
			{
				NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_MONSTER,{"param":[myObjectTypeId]});
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
					if(GameAGlobalManager.getInstance().gameDataInfoManager.sceneLife>0 && mySceneKillLife>0)
					{
						GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.HURT_WARN_EFFECT );
					}
					GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneLife(-mySceneKillLife);
					GameAGlobalManager.getInstance().gameSuccessAndFailedDetector.onEnemyCampUintArrivedEndPoint(this,bIsBoss);
					
					
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
				var monster:BasicMonsterElement = ObjectPoolManager.getInstance()
					.createSceneElementObject(GameObjectCategoryType.MONSTER, uid) as BasicMonsterElement;
				monster.x = this.x + arrX[i]*20;
				monster.y = this.y + arrY[i]*20;
				var pathPoints:Vector.<PointVO> = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.roadVOs[_escapeRoadIndex].lineVOs[i%3].points;
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
				var item1:BasicGroundItem = ObjectPoolManager.getInstance().createSceneElementObject(GameObjectCategoryType.GROUNDITEM, itemId,false) as BasicGroundItem;
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
			var atkScale:Number = GameAGlobalManager.getInstance().gameDataInfoManager.monsterAtkScale;
			var lifeScale:Number = GameAGlobalManager.getInstance().gameDataInfoManager.monsterLifeScale;
			if(EndlessBattleMgr.instance.isEndless)
			{
				var temp:DreamLandTemplateInfo = TemplateDataFactory.getInstance().getDreamLandTemplateById(_ownWave);
				if(temp)
				{
					atkScale = temp.atkScale;
					lifeScale = temp.lifeScale;
				}
			}

			myFightState.minAtk = myMoveFighterInfo.baseAtk * atkScale;
			myFightState.maxAtk = myMoveFighterInfo.maxAtk * atkScale;
			myFightState.maxlife = myMoveFighterInfo.life * lifeScale;
			myFightState.curLife = myFightState.maxlife;
		}
		
		override protected function onBufferAttached(buffId:uint):void
		{
			switch(buffId)
			{
				case BufferID.SnowStorm:
					setBodyFilter([GameFilterManager.getInstance().colorBlueMatrixFilter]);
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
		
		override protected function getDefaultSoundString():String
		{
			return monsterTemplateInfo?monsterTemplateInfo.sound:null;
		}
	}
}