package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import com.shinezone.towerDefense.fight.constants.identify.GroundEffectID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.BasicBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ParabolaBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.StraightBullectTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	public class IceElement extends BasicMonsterElement
	{
		private var _boss:HeartOfIce;
		
		private var _ptNow:PointVO = new PointVO;
		private var _ptDest:PointVO = new PointVO;
		private var _ptSrc:PointVO = new PointVO;
		private var _parabolaTrajectory:ParabolaBulletTrajectory;
		private var _straightTrajectory:StraightBullectTrajectory;
		private var _launchTrajectory:BasicBulletTrajectory;
		private var _myCurrentRendTimes:int = 0;
		private var _myTotalRendTimes:int = 0;
		public function IceElement(typeId:int)
		{
			super(typeId);
			_parabolaTrajectory = new ParabolaBulletTrajectory;
			_straightTrajectory = new StraightBullectTrajectory;
		}
		
		public function initByBoss(boss:HeartOfIce,ix:int,iy:int):void
		{
			_boss = boss;
			_ptDest.x = ix;
			_ptDest.y = iy;
			this.x = _ptSrc.x = boss.x;
			this.y = _ptSrc.y = boss.y;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			_myTotalRendTimes = GameMathUtil.caculateFrameCountByTime(2000);
			changeToTargetBehaviorState(OrganismBehaviorState.ICE_SPLIT);
		}
		
		override protected function canChangeBehaviorState(behaviorState:int):Boolean
		{
			if(OrganismBehaviorState.ICE_RESTORE == currentBehaviorState)
				return false;
			return super.canChangeBehaviorState(behaviorState);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			if(OrganismBehaviorState.ENEMY_ESCAPING == currentBehaviorState)
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			else if(OrganismBehaviorState.DYING == currentBehaviorState)
				_boss.notifyElementDie(this);
			
			super.onBehaviorStateChanged();
			
			if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState || OrganismBehaviorState.ICE_RESTORE == currentBehaviorState)
			{
				dispatchLeaveOffScreenSearchRangeEvent();
				myBodySkin.gotoAndStop2(getWalkTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
				_myCurrentRendTimes = 0;				
				myFightState.bInvincible = true;
				myFightState.bInvisible = true;
				
				_ptNow.x = x;
				_ptNow.y = y;
				if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState)
				{
					_myTotalRendTimes = GameMathUtil.caculateFrameCountByTime(2000);
					_parabolaTrajectory.setUpBulletTrajectoryParameters(_ptNow,_ptDest,150);
					_launchTrajectory = _parabolaTrajectory;
				}
				else
				{
					_myTotalRendTimes = GameMathUtil.caculateFrameCountByTime(1000);
					_straightTrajectory.setUpBulletTrajectoryParameters(_ptNow,_ptSrc,150);
					_launchTrajectory = _straightTrajectory;
				}
			}
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState || OrganismBehaviorState.ICE_RESTORE == currentBehaviorState)
			{
				onRenderWhenFly();
			}
		}
		
		override protected function onRenderWhenNearFighttingState():void
		{
			super.onRenderWhenNearFighttingState();
		}
		
		private function onRenderWhenFly():void
		{
			_myCurrentRendTimes++;
			//if(0 == _myCurrentRendTimes % 15)
			//{
				//资源暂缺
				addGroundEff(GroundEffectID.IceElementFog,0,null,this);
			//}
			if(_myCurrentRendTimes > _myTotalRendTimes)
			{
				_myCurrentRendTimes = 0;
				_myTotalRendTimes = 0;
				if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState)
				{
					changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
					FreezeNearTower();
					myFightState.bInvincible = false;
					myFightState.bInvisible = false;
				}
				else if(OrganismBehaviorState.ICE_RESTORE == currentBehaviorState)
				{
					myFightState.bInvincible = false;
					myFightState.bInvisible = false;
					_boss.notifyRestore(this);
					destorySelf();
				}
			}
			else
			{
				if(_launchTrajectory != null)
				{
					_launchTrajectory.updateProgress(_myCurrentRendTimes/_myTotalRendTimes);
					
					this.x = _launchTrajectory.bulletPositionX;
					this.y = _launchTrajectory.bulletPositionY;
				}
			}
		}
		
		private function FreezeNearTower():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.SPELL_SUFFIX+GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START
				,GameMovieClipFrameNameType.SPELL_SUFFIX+GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,null
				,GameMovieClipFrameNameType.SPELL_SUFFIX+GameMovieClipFrameNameType.FIRE_POINT,onFreezeTower);
		}
		
		private function onFreezeTower():void
		{
			var vecTowers:Vector.<BasicTowerElement> = GameAGlobalManager.getInstance().groundSceneHelper.searchTowersBySearchArea(this.x,this.y,100,1);
			if(!vecTowers || vecTowers.length <= 0)
				return;
			var param:Object = {};
			param[BufferFields.BUFF] = BufferID.FreezeTower;
			param[BufferFields.DURATION] = 5000;
			param[SkillResultTyps.STUN] = 1;
			param[BufferFields.CLICK] = 1;
			vecTowers[0].notifyAttachBuffer(BufferID.FreezeTower,param,this);
		}
		
		public function notifyBackToBoss():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.ICE_RESTORE);
		}
		
		override public function getDisToEndPointRatio():Number
		{
			return 0;
		}
	}
}