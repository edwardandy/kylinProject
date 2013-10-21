package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.constant.identify.GroundEffectID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SafeLaunchSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.ParabolaBulletTrajectory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 炸弹人
	 */
	public class Bomber extends HeroElement
	{
		private var _safeArea:int = 0;
		private var _safeDmg:int = 0;
		private var _safeStunTime:int = 0;
		private var _fallArea:int = 0;
		private var _fallDmg:int = 0;
		private var _myCurrentRendTimes:int = 0;
		private var _myTotalRendTimes:int = 0;
		private var _launchTrajectory:ParabolaBulletTrajectory = new ParabolaBulletTrajectory();
		public function Bomber(typeId:int)
		{
			super(typeId);
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			if(currentBehaviorState == OrganismBehaviorState.LAUNCH && _myTotalRendTimes>0)
			{
				_myCurrentRendTimes++;
				if(_myCurrentRendTimes > _myTotalRendTimes)
				{
					_myCurrentRendTimes = 0;
					_myTotalRendTimes = 0;
					onSafeLaunchEnd();
				}
				else
				{
					if(_launchTrajectory != null)
					{
						_launchTrajectory.updateProgress(_myCurrentRendTimes/_myTotalRendTimes);
						
						this.x = _launchTrajectory.bulletPositionX;
						this.y = _launchTrajectory.bulletPositionY;
						myAppointPoint.x = x;
						myAppointPoint.y = y;
					}
					
					addGroundEff(GroundEffectID.TrackMissileFog,0,null,this);
				}
			}
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			if(OrganismBehaviorState.LAUNCH == currentBehaviorState)
			{
				myBodySkin.gotoAndStop2(getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START);
			}
		}
		
		/**
		 * 安全弹射装置
		 */
		override protected function onSafeLaunch(area:int,dmg:int,stunTime:int,fallAtkArea:int,fallDmg:int):void
		{
			/*if(currentSearchedEnemy)
				currentSearchedEnemy.notifyBeUnBlockedByEnemy(this);*/
			resetSearchState();
			
			changeToTargetBehaviorState(OrganismBehaviorState.LAUNCH);
			
			_fallArea = fallAtkArea;
			_fallDmg = fallDmg;
			_safeArea = area;
			_safeDmg =  getRandomDamageValue();
			_safeDmg = _safeDmg * dmg/100;
			_safeStunTime = stunTime;
			myFightState.bInvincible = true;
			var pct:int = getSkillDmgAddPct();
			_safeDmg += _safeDmg*pct/10000;
			var skillEffect:SafeLaunchSkillRes = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.SKILLRES, SkillID.SafeLaunch, false) as SafeLaunchSkillRes;
			if(skillEffect)
			{
				skillEffect.setSkillFireFunc(x,y,onSafeLaunchFire);
				skillEffect.notifyLifecycleActive();
			}
		}
		
		private function onSafeLaunchFire():void
		{
			onSafeLaunchAtk(_safeArea,_safeDmg);
			onLaunchSelf();
		}
		
		private function onSafeLaunchAtk(iArea:int,iDmg:int):void
		{
			var vecTarget:Vector.<BasicOrganismElement> = sceneElementsService
				.searchOrganismElementsBySearchArea(this.x, this.y, iArea, oppositeCampType);
			
			if(vecTarget && vecTarget.length>0)
			{	
				for each(var target:BasicOrganismElement in vecTarget)
				{
					target.hurtSelf(iDmg,FightAttackType.PHYSICAL_ATTACK_TYPE,this,OrganismDieType.NORMAL_DIE,1,false);
				}
			}
		}
		
		private function onLaunchSelf():void
		{
			var ptResult:PointVO = sceneElementsService.getCurrentSceneRandomRoadPointByCurrentRoadsData();
			_myCurrentRendTimes = 0;
			_myTotalRendTimes = GameMathUtil.caculateFrameCountByTime(2000);
			
			_launchTrajectory.setUpBulletTrajectoryParameters(new PointVO(this.x,this.y),ptResult,this.y);
		}
		
		private function onSafeLaunchEnd():void
		{
			if(_fallArea>0 && _fallDmg>0)
			{
				onSafeLaunchAtk(_fallArea,_fallDmg);
			}
			var param:Object = {};
			param[BufferFields.BUFF] = BufferID.Dizziness;
			param[BufferFields.DURATION] = _safeStunTime;
			param[SkillResultTyps.STUN] = 1;
			notifyAttachBuffer(BufferID.Dizziness,param,this);
			myFightState.bInvincible = false;
			changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			myAppointPoint.x = x;
			myAppointPoint.y = y;
		}
			
		
		//高爆炸弹	
		override public function processSkillState(state:SkillState):void
		{
			if(state && SkillID.HighBomb == state.id && !myFightState.bStun)
			{	
				var temp:IBaseFighterSheetItem = getBaseSkillInfo(SkillID.HighBomb);
				if(state.mainTarget && GameMathUtil.containsPointInEllipseSearchArea(state.mainTarget.x,state.mainTarget.y,temp.atkRange,x, y) /*GameMathUtil.distance(x,y,state.mainTarget.x,state.mainTarget.y) <= temp.range*/)
				{
					var processor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(state.id);
					var selfState:SkillState = new SkillState;
					selfState.id = state.id;
					selfState.owner = this;
					selfState.mainTarget = this;
					selfState.vecTargets.push(this);
					if(processor)
						processor.processBuffers(selfState);
				}
			}
			
			super.processSkillState(state);
		}
		
		override public function moveToAppointPointByPath(pathPoints:Vector.<PointVO>):void
		{
			if(OrganismBehaviorState.LAUNCH == currentBehaviorState)
				return;
			super.moveToAppointPointByPath(pathPoints);
		}
		
		override protected function get exceptBuffIds():Array
		{
			return arrExceptBuffIds ||= [BufferID.Rebirth,BufferID.SafeLaunch];
		}
	}	
}