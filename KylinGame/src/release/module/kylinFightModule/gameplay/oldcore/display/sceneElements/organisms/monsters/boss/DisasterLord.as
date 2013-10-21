package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss
{
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.FlameRainSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 灾难领主
	 */
	public class DisasterLord extends BasicMonsterElement
	{
		private static const FLAMERAIN_COUNT:int = 5;
		
		private var _flameRainInfo:SkillTemplateInfo;
		private var _showFlameTick:int;
		private var _vecFlamePoints:Vector.<PointVO>;
		
		private var _hellCurseInfo:SkillTemplateInfo;
		private var _hellCurseParam:Object = {};
		private var _vecEffMonsters:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>;
		private var _iHellCurseClickCnt:int = 0;
		
		public function DisasterLord(typeId:int)
		{
			super(typeId);
			this.mouseEnabled = true;
			_flameRainInfo = getBaseSkillInfo(SkillID.FlameRain) as SkillTemplateInfo;
			_hellCurseInfo = getBaseSkillInfo(SkillID.HellCurse) as SkillTemplateInfo;
			_hellCurseParam[BufferFields.BUFF] = BufferID.BeHellCurse;
			_hellCurseParam[BufferFields.DURATION] = 0;
			_hellCurseParam[SkillResultTyps.INVINCIBLE] = 1;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean=false):void
		{
			super.clearStateWhenFreeze(bDie);
			if(_vecEffMonsters && _vecEffMonsters.length>0)
				clearAllEffMonster();
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClickHellCurse);
			_iHellCurseClickCnt = 0;
			stopClickEff();
		}
		
		override protected function onBehaviorChangeToUseSkill():void
		{
			super.onBehaviorChangeToUseSkill();
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			checkHellCurseState();
		}
		
		override protected function onBufferAttached(buffId:uint):void
		{
			if(BufferID.HellCurseSelf == buffId)
			{
				addEventListener(MouseEvent.CLICK,onClickHellCurse);
				playClickEff();
				return;
			}
			super.onBufferAttached(buffId);
		}
		
		override protected function onBufferDettached(buffId:uint):void
		{
			if(BufferID.HellCurseSelf == buffId)
			{
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,onClickHellCurse);
				clearAllEffMonster();
				stopClickEff();
				return;
			}
			super.onBufferDettached(buffId);
		}
		
		override protected function appearSkillEffect():void
		{
			if(SkillID.HellCurse == myFightState.curUseSkillId)
			{
				onHellCurse();
				return;
			}
			super.appearSkillEffect();
		}
		
		override protected function showSkillEffect(resId:uint,state:SkillState):void
		{
			if(SkillID.FlameRain == myFightState.curUseSkillId)
			{
				showFlameRain();
				return;
			}
			else if(SkillID.SummonDemon == myFightState.curUseSkillId)
			{	
				showSummonDoor();
				return;
			}
			super.showSkillEffect(resId,state);
		}
		/**
		 * 火焰雨特效 
		 */
		private function showFlameRain():void
		{
			if(_showFlameTick>0)
			{
				TimeTaskManager.getInstance().destoryTimeTask(_showFlameTick);
				_showFlameTick = 0;
			}
			_showFlameTick = TimeTaskManager.getInstance().createTimeTask(500,onShowSingleFlame,null,5);
			_vecFlamePoints = GameAGlobalManager.getInstance().groundSceneHelper.getSomeRandomRoadPoints(5,null,1,-1);
		}
		
		private function onShowSingleFlame():void
		{
			var iCnt:int = TimeTaskManager.getInstance().getTimeTaskCurrentRepeatCount(_showFlameTick);
			
			var skillEffect:FlameRainSkillRes = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.SKILLRES, SkillID.FlameRain, false) as FlameRainSkillRes;
			if(skillEffect)
			{
				skillEffect.activeSkillEffect(this,null);
				skillEffect.x = _vecFlamePoints[iCnt-1].x;
				skillEffect.y = _vecFlamePoints[iCnt-1].y;
				skillEffect.notifyLifecycleActive();
			}
			if(5 == iCnt)
				_showFlameTick = 0;
		}
		
		/**
		 * 召唤恶魔之门
		 */
		private function showSummonDoor():void
		{
			var arrIdxes:Array = [];
			_vecFlamePoints = GameAGlobalManager.getInstance().groundSceneHelper.getSomeRandomRoadPoints(5,arrIdxes,1,-1,400,true);
			for(var i:int = 0; i<5;++i)
			{
				var skillEffect:SummonDemonDoorSkillRes = ObjectPoolManager.getInstance()
					.createSceneElementObject(GameObjectCategoryType.SKILLRES, SkillID.SummonDemon, false) as SummonDemonDoorSkillRes;
				if(skillEffect)
				{
					skillEffect.activeSkillEffect(this,null);
					skillEffect.x = _vecFlamePoints[i].x;
					skillEffect.y = _vecFlamePoints[i].y;
					skillEffect.setRouteLineIdxes(arrIdxes[i]);
					skillEffect.notifyLifecycleActive();
				}
			}
		}
		/**
		 * 地狱诅咒
		 */
		private function onHellCurse():void
		{
			var hellCurseProcessor:BasicSkillProcessor = GameAGlobalManager.getInstance().gameSkillProcessorMgr.getSkillProcessorById(SkillID.HellCurse,false);
			var state:SkillState = new SkillState;
			state.id = SkillID.HellCurse;
			state.owner = this;
			state.vecTargets.push(this);
			hellCurseProcessor.processBuffers(state);
		}
		
		
		private function checkHellCurseState():void
		{
			if(!isAlive || !hasBuffer(BufferID.HellCurseSelf))
				return;
			
			var vecMonsters:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance().groundSceneHelper.
				searchOrganismElementsBySearchArea(this.x,this.y,_hellCurseInfo.range,myCampType,searchMonsterFilter);
			if(!vecMonsters || 0 == vecMonsters.length)
			{
				clearAllEffMonster();
				return;
			}
			var monster:BasicOrganismElement;
			for each(monster in _vecEffMonsters)
			{
				if(vecMonsters.indexOf(monster) == -1 && monster.isAlive)
				{
					monster.notifyDettachBuffer(BufferID.BeHellCurse);
				}
			}
			if(vecMonsters && vecMonsters.length>0)
			{
				for each(monster in vecMonsters)
				{
					monster.notifyAttachBuffer(BufferID.BeHellCurse,_hellCurseParam,this);
				}
			}
			_vecEffMonsters = vecMonsters;
		}
		
		private function searchMonsterFilter(e:BasicOrganismElement):Boolean
		{
			return !e.isBoss;
		}
		
		private function clearAllEffMonster():void
		{
			for each(var monster:BasicOrganismElement in _vecEffMonsters)
			{
				if(monster.isAlive && !monster.isFreezedState() && monster.hasBuffer(BufferID.BeHellCurse))
					monster.notifyDettachBuffer(BufferID.BeHellCurse);
			}	
			_vecEffMonsters.length = 0;
		}
		
		private function onClickHellCurse(e:MouseEvent):void
		{
			++_iHellCurseClickCnt;
			if(_iHellCurseClickCnt>=10)
			{
				notifyDettachBuffer(BufferID.HellCurseSelf);
			}
		}
	}
}