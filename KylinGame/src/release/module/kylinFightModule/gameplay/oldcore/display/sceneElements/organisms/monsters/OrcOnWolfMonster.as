package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.OrganismDieType;
	import com.shinezone.towerDefense.fight.constants.identify.MonsterID;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	public class OrcOnWolfMonster extends BasicMonsterElement
	{
		private var _bOrcDie:Boolean = true;
		/**
		 * 无极幻境，被秒杀就不再变狼或兽人 
		 */		
		private var _bDirectDeath:Boolean = false;
		
		private var _restartX:int = 0;
		private var _restartY:int = 0;
		private var _roadIdx:int = 0;
		private var _pathIdx:int = 0;
		private var _pathStep:int = 0;
		
		public function OrcOnWolfMonster(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_bOrcDie = true;
			_bDirectDeath = false;
		}
		
		override protected function onBehaviorChangeToDying():void
		{
			_bOrcDie = GameMathUtil.randomTrueByProbability(0.5);		
			
			_restartX = this.x;
			_restartY = this.y;
			_roadIdx = escapeRoadIndex;
			_pathIdx = escapePathIndex;
			_pathStep = myMoveState.currentPathStepIndex;
			//_myCurrentDieType = OrganismDieType.NORMAL_DIE;
			
			super.onBehaviorChangeToDying();
		}
		
		override protected function getDyingAnimationFrameKeyByDieType(dieType:int):String
		{
			if(_bOrcDie)
				return GameMovieClipFrameNameType.NORMAL_DIE;
			else
				return GameMovieClipFrameNameType.NORMAL_DIE_1;
		}
		
		override public function hurtBlood(value:uint, attackType:int=FightAttackType.PHYSICAL_ATTACK_TYPE, isMonomerHurt:Boolean=true, byTarget:ISkillOwner=null, isDirectDethMode:Boolean=false, hurtedDeathType:int=OrganismDieType.NORMAL_DIE, scaleValue:Number=1, beKillAll:Boolean=false,bNormalAttack:Boolean = false):void
		{
			if(beKillAll)
				_bDirectDeath = true;
			super.hurtBlood(value,attackType,isMonomerHurt,byTarget,isDirectDethMode,hurtedDeathType,scaleValue,beKillAll,bNormalAttack);
		}
		
		override protected function onDiedAnimationEndHandlerStep1():void
		{		
			if(!_bDirectDeath)
			{
				var uid:uint = _bOrcDie?MonsterID.Wolf:MonsterID.Orc;
				
				var monster:BasicMonsterElement = ObjectPoolManager.getInstance()
					.createSceneElementObject(GameObjectCategoryType.MONSTER, uid) as BasicMonsterElement;
				monster.x = _restartX;
				monster.y = _restartY;
				var pathPoints:Vector.<PointVO> = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.roadVOs[_roadIdx].lineVOs[_pathIdx].points;
				monster.startEscapeByPath(pathPoints, _roadIdx, _pathIdx);
				monster.updateWalkPathStepIndex(_pathStep);
				if(currentSearchedEnemy)
					monster.setEnemyAndIdle(currentSearchedEnemy);
			}
			var checkGameOver:Boolean = _bDirectDeath;
			destorySelf();
			if(checkGameOver)
				GameAGlobalManager.getInstance().gameSuccessAndFailedDetector.onEnemyCampUintDied(this as BasicMonsterElement);
		}
	}
}