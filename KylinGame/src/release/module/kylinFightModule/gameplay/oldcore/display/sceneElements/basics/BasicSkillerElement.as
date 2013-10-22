package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import mainModule.model.gameData.sheetData.interfaces.IBaseFighterSheetItem;
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;
	import mainModule.model.gameData.sheetData.skill.SkillUseUnit;
	import mainModule.model.gameData.sheetData.skill.heroSkill.IHeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.monsterSkill.IMonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.towerSkill.ITowerSkillSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillSpecialType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillType;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.BasicBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.BasicSkillEffectRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.BasicSummonSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.logic.hurt.AttackerInfo;
	import release.module.kylinFightModule.gameplay.oldcore.logic.hurt.FightUnitState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.BasicSkillUseCondition;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.GameFightSkillConditionMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.GameFightSkillProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.service.sceneElements.ISceneElementsService;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class BasicSkillerElement extends BasicFightElement implements ISkillOwner
	{
		[Inject]
		public var skillProcessorMgr:GameFightSkillProcessorMgr;
		[Inject]
		public var skillConditionMgr:GameFightSkillConditionMgr;
		[Inject]
		public var timeTaskMgr:TimeTaskManager;
		[Inject]
		public var towerSkillModel:ITowerSkillSheetDataModel;
		[Inject]
		public var heroSkillModel:IHeroSkillSheetDataModel;
		[Inject]
		public var monsterSkillModel:IMonsterSkillSheetDataModel;
		
		/**
		 * 检查可用技能的间隔 
		 */		
		private var myCheckSkillCD:SimpleCDTimer = new SimpleCDTimer(1000);
		/**
		 * 施法者出现后到可使用技能的间隔 
		 */		
		private var myStartCheckSkillCD:SimpleCDTimer = new SimpleCDTimer(5000);
		/**
		 * 所有可用的主动技能
		 */
		protected var mySkillIds:Array = [];
		/**
		 * 特殊条件下必定优先使用的特殊主动技能
		 */
		protected var mySpecialSkills:HashMap = new HashMap;
		/**
		 * 条件触发使用的主动技能
		 */
		protected var myTriggerSkills:HashMap = new HashMap;
		/**
		 * 剩余的随机选择使用的主动技能
		 */
		protected var myRandomSkills:Array = [];
		protected var mySkillStates:HashMap = new HashMap;
		protected var mySkillUseUnits:HashMap = new HashMap;
		
		protected var mySummonPets:HashMap = new HashMap;
		
		protected var _lastExplosionPoint:PointVO;
		
		public function BasicSkillerElement()
		{
			super();
		}
		
		public function get lastExplosionPoint():PointVO
		{
			return _lastExplosionPoint ||= new PointVO;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			myFightState = new FightUnitState(this);
			initFightState();
			myAttackCDTimer = new SimpleCDTimer(myFightState.cdTime);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
		}
		
		override protected function initStateWhenActive():void
		{
			super.initStateWhenActive();
			myFightState = new FightUnitState(this);
			initFightState();
			myAttackCDTimer.setDurationTime(myFightState.cdTime);
			myCheckSkillCD.resetCDTime();
			myStartCheckSkillCD.resetCDTime();
			getCanUseSkills();		
			processPassiveSkills();	
			genSKillUseUnits();
			myBodySkin.alpha = 1.0;
			this.visible = true
			if(_lastExplosionPoint)
			{
				_lastExplosionPoint.x = -1;
				_lastExplosionPoint.y = -1;
			}
		}
		
		override protected function onLifecycleFreeze():void
		{	
			super.onLifecycleFreeze();	
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean = false):void
		{
			freezeAllPets();
			super.clearStateWhenFreeze(bDie);	
			mySkillIds = [];
			myRandomSkills = [];
			mySpecialSkills.clear();		
			mySkillUseUnits.clear();	
			mySkillStates.clear();	
			mySummonPets.clear();
			clearTriggerSkills(bDie);
		}
		
		private function clearTriggerSkills(bDie:Boolean = false):void
		{
			if(!bDie)
			{
				myTriggerSkills.clear();
				return;
			}
			var keys:Array = myTriggerSkills.keys().concat();
			
			for each(var type:int in keys)
			{
				if(TriggerConditionType.AFTER_DIE != type)
					myTriggerSkills.remove(type);
			}
			
			for each(var id:uint in myTriggerSkills.get(TriggerConditionType.AFTER_DIE))
			{
				mySkillIds.push(id);
				genSingleSkillUseUnit(id);
			}
		}
		
		private function freezeAllPets():void
		{
			var allPets:Array = [];
			for each(var id:uint in mySummonPets.keys())
			{
				var arrPets:Array = mySummonPets.get(id);
				if(!arrPets || arrPets.length<=0)
					continue;
				allPets = allPets.concat(arrPets);	
			}
			
			for each(var pet:BasicSummonSoldier in allPets)
			{
				pet.destorySelf();
			}	
		}		
		
		override public function dispose():void
		{
			super.dispose();
			mySkillIds = null;
			myRandomSkills = null;
			mySpecialSkills = null;
			myTriggerSkills = null;
			mySkillUseUnits = null;
			mySkillStates = null;
			mySummonPets = null;
		}
		
		public function hurtTarget(target:ISkillTarget,state:SkillState):void
		{
			if(isFreezedState() || !fightState)
				return;
			if(!state && target)
				onFarAttackTarget(target);
			else
			{
				var processor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(state.id);
				if(processor)
				{
					processor.processSingleEnemy(state,target);
				}
			}
		}
		
		protected function onFarAttackTarget(target:ISkillTarget):void
		{
			
		}
		
		protected function areaAttack(target:ISkillTarget,dmg:int,range:int):void
		{
			if(range<=0)
				return;
			var vecTargets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(target.x, target.y, range, 
					oppositeCampType, searchCanAreaAtkTargets);
			if(!vecTargets || vecTargets.length <=0)
				return;
			for each(var enemy:BasicOrganismElement in vecTargets)
			{
				if(enemy != target)
					enemy.hurtSelf(dmg,atkType,this);
			}
		}
		
		protected function searchCanAreaAtkTargets(e:BasicOrganismElement):Boolean
		{
			return true;
		}
		
		public function processSkillState(state:SkillState):void
		{
			var processor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(state.id);
			if(processor)
			{
				processor.processSkill(state);
			}
		}
		
		public function isSkillCDEnd(skillId:uint):Boolean
		{
			if(mySkillIds.indexOf(skillId) == -1)
				return false;
			var state:SkillState = mySkillStates.get(skillId) as SkillState;
			if(!state)
				return true;
			var rdcPct:int = 0;
			if(myFightState.rdcSkillCd[skillId])
				rdcPct += myFightState.rdcSkillCd[skillId];
			if(myFightState.rdcSkillCd[0])
				rdcPct += myFightState.rdcSkillCd[0];
			return state.skillCd.getIsCDEnd(state.skillCd.duration * rdcPct/100);
		}
		
		public function getSkillUseOdds(skillId:uint):int
		{
			if(mySkillIds.indexOf(skillId) == -1)
				return 0;
			var unit:SkillUseUnit = mySkillUseUnits.get(skillId) as SkillUseUnit;
			if(!unit)
				return 0;
			return unit.odds;
		}
		
		public function getSkillDmgAddPct():int
		{
			return myFightState?myFightState.skillAtk:0;
		}
		
		//技能相关
		protected function getCanUseSkills():void
		{
			
		}
		
		protected function getBaseSkillInfo(id:uint):IBaseOwnerSkillSheetItem
		{
			var skillInfo:IBaseOwnerSkillSheetItem;
			switch(myElemeCategory)
			{
				case GameObjectCategoryType.TOWER:
					skillInfo = towerSkillModel.getTowerSkillSheetById(id);
				case GameObjectCategoryType.MONSTER:
					skillInfo = monsterSkillModel.getMonsterSkillSheetById(id);
				case GameObjectCategoryType.HERO:
					skillInfo = heroSkillModel.getHeroSkillSheetById(id);	
			}
			return skillInfo;
		}
		
		/**
		 * 初始化时处理对象所有的被动技能，并从可用技能id列表中删除
		 */
		protected function processPassiveSkills():void
		{
			var info:IBaseOwnerSkillSheetItem;
			for (var i:int=0;i<mySkillIds.length;++i)
			{
				info = getBaseSkillInfo(mySkillIds[i]);
				if(!info)
				{
					mySkillIds.splice(i,1);
					--i;
					continue;
				}
				if(SkillType.PASSIVITY == info.type)
				{
					processSinglePassiveSkill(mySkillIds[i]);
					mySkillIds.splice(i,1);
					--i;
					continue;
				}
			}
		}
		
		protected function processSinglePassiveSkill(skillId:uint):void
		{
			var state:SkillState = new SkillState();
			state.owner = this;
			state.vecTargets.push(this);
			
			var processor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(skillId);
			if(processor)
			{
				state.id = skillId;	
				processor.processSkill(state);
			}
		}
		
		/**
		 * 生成所有主动技能的使用信息
		 */
		protected function genSKillUseUnits():void
		{
			for each(var skillId:uint in mySkillIds)
			{
				genSingleSkillUseUnit(skillId);
			}
		}
		
		protected function genSingleSkillUseUnit(skillId:uint):void
		{
			var info:IBaseFighterSheetItem = getBaseFightInfo();
			if(!info)
				return;
			
			var arr:Array = info.skillUseUnits;
			var skillUnit:SkillUseUnit;
			for each(var unit:SkillUseUnit in arr)
			{
				if(unit.skillId == skillId)
				{
					skillUnit = unit;
					break;
				}
			}
			skillUnit ||= new SkillUseUnit;
			
			if(mySkillIds.indexOf(skillId) != -1)
			{
				mySkillUseUnits.put(skillId,skillUnit);
				classifySkillType(skillId);		
			}
		}
		
		protected function classifySkillType(skillId:uint,bRemove:Boolean = false):void
		{
			var skillTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
			var idx:int;
			if(!skillTemp)
				return;
			
			if(skillTemp && SkillSpecialType.NOT_SPECIAL != skillTemp.specialType)
			{
				addOrRemoveElementToSkillHash(mySpecialSkills,skillTemp.specialType,skillId,bRemove);
			}
			else if(skillTemp && TriggerConditionType.NOT_TRIGGER != skillTemp.triggerType)
			{
				addOrRemoveElementToSkillHash(myTriggerSkills,skillTemp.triggerType,skillId,bRemove);
			}
			else if(skillTemp)
			{
				if(!bRemove)
					myRandomSkills.push(skillId);
				else
				{
					removeElementFromArray(myRandomSkills,skillId);
				}
			}
		}
		
		private function addOrRemoveElementToSkillHash(hash:HashMap,key:int,skillId:int,bRemove:Boolean = false):void
		{
			var arrSub:Array = hash.get(key);
			if(!arrSub && !bRemove)
			{
				arrSub = [];
				hash.put(key,arrSub);
			}
			if(arrSub)
			{
				if(!bRemove)
				{
					if(-1 == arrSub.indexOf(skillId))
						arrSub.push(skillId);
				}
				else
				{
					removeElementFromArray(arrSub,skillId);
				}
			}
		}
		
		private function removeElementFromArray(arr:Array,e:*):void
		{
			var idx:int = arr.indexOf(e);
			if(idx != -1)
				arr.splice(idx,1);
		}
		
		protected function removeSkillFromSelf(skillId:uint):void
		{
			removeElementFromArray(mySkillIds,skillId);			
			classifySkillType(skillId,true);
			
			/*var state:SkillState = mySkillStates.get(skillId);
			if(state)
				state.dispose();
			mySkillStates.remove(skillId);*/
			
			mySkillUseUnits.remove(skillId);
		}
		
		protected function updateSkill(skillId:uint,iLvl:int):void
		{
			removeOldSkillByLvl(skillId,iLvl);
			addNewSkillByLvl(skillId,iLvl);
		}
		
		private function addNewSkillByLvl(skillId:uint,iLvl:int):void
		{
			var curId:uint = getCurSkillIdByLvl(skillId,iLvl);
			var info:IBaseOwnerSkillSheetItem = getBaseSkillInfo(curId);
			
			if(SkillType.PASSIVITY == info.type)
			{
				processSinglePassiveSkill(curId);
			}
			else
			{
				var oldId:uint = getOldSkillIdByLvl(skillId,iLvl);
				var state:SkillState = mySkillStates.get(oldId);
				if(state)
					state.id = curId;
				
				mySkillIds.push(curId);
				genSingleSkillUseUnit(curId);
			}
			
			playSound(getSoundId(SoundFields.Upgrade,0,info.objSound));
		}
		
		private function removeOldSkillByLvl(skillId:uint,iLvl:int):void
		{
			var oldId:uint = getOldSkillIdByLvl(skillId,iLvl);
			var info:IBaseOwnerSkillSheetItem;
			if(oldId>0)
			{
				info = getBaseSkillInfo(oldId);
				if(SkillType.INITIATIVE == info.type)
				{
					removeSkillFromSelf(oldId);
				}
			}
		}
			
		
		private function getOldSkillIdByLvl(skillId:uint,iLvl:int):uint
		{
			if(2 == iLvl)
			{
				return skillId;
			}
			else if(iLvl >= 3)
			{
				return uint(skillId.toString()+(iLvl-2));
			}
			return 0;
		}
		
		protected function getCurSkillIdByLvl(skillId:uint,iLvl:int):uint
		{
			if(2 == iLvl)
			{
				return uint(skillId.toString()+1);
			}
			else if(iLvl >= 3)
			{
				return uint(skillId.toString()+(iLvl-1));
			}
			return skillId;
		}
		
		protected function onRenderWhenUseSkill():void
		{
			
		}
		
		protected function adjustUseSkillAngle():void
		{
			
		}
		
		protected var _skillChantTimeTick:int = 0;
		/**
		 * 状态机改变至使用技能状态
		 */
		protected function onBehaviorChangeToUseSkill():void
		{
			var skillId:uint = myFightState.curUseSkillId;
			var skillTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
			var useUnit:SkillUseUnit = mySkillUseUnits.get(skillId) as SkillUseUnit;
			var state:SkillState = mySkillStates.get(skillId) as SkillState;
			state.skillCd.resetCDTime();
			myAttackCDTimer.resetCDTime();
			
			adjustUseSkillAngle();
			
			if(0 == useUnit.action)
			{
				appearSkillEffect();
				onSkillDisappearAnimEnd();
				return;
			}
			else
			{
				var appearName:String;
				var idleName:String;
				var disappearName:String;
				var fireName:String;
				if(useUnit.action>0)//有施法动作
				{
					appearName = GameMovieClipFrameNameType.SPELL_SUFFIX+useUnit.action+"_"+GameMovieClipFrameNameType.APPEAR;
					fireName = GameMovieClipFrameNameType.SPELL_SUFFIX+useUnit.action+"_"+GameMovieClipFrameNameType.FIRE_POINT;
					idleName = GameMovieClipFrameNameType.SPELL_SUFFIX+useUnit.action+"_"+GameMovieClipFrameNameType.IDLE;
					disappearName = GameMovieClipFrameNameType.SPELL_SUFFIX+useUnit.action+"_"+GameMovieClipFrameNameType.IDLE;	
				}
				else if(-1 == useUnit.action)//重用近战攻击动作
				{
					appearName = getNearAttackTypeStr();
					fireName = getNearFirePointTypeStr();
				}
				
				else if(-2 == useUnit.action)//重用远程攻击动作
				{
					appearName = getFarAttackTypeStr();
					fireName = getFarFirePointTypeStr();
				}
				else if(-3 == useUnit.action)//重用塔的攻击动作
				{
					appearName = GameMovieClipFrameNameType.ATTACK;
					fireName = GameMovieClipFrameNameType.FIRE_POINT;
				}
				if(appearName && skillActionSkin.hasFrameName(appearName+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
					state.strAppearName = appearName;
				if(idleName && skillActionSkin.hasFrameName(idleName+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
					state.strIdleName = idleName;
				if(disappearName && skillActionSkin.hasFrameName(disappearName+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
					state.strDisappearName = disappearName;
				if(fireName && skillActionSkin.hasFrameName(fireName))
					state.strFireName = fireName;
				if(state.strAppearName)
				{
					skillActionSkin.gotoAndPlay2(state.strAppearName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						state.strAppearName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
						onSkillAppearAnimEnd,state.strFireName,state.strFireName?appearSkillEffect:null);
				}
				else
				{
					onSkillAppearAnimEnd();
				}
			}
		}
		
		protected function get skillActionSkin():NewBitmapMovieClip
		{
			return myBodySkin;
		}
		
		protected function cancleUseSkillState():void
		{
			
		}
		
		protected function isNotUseSkillState():Boolean
		{
			return false;
		}
		
		private function onSkillAppearAnimEnd():void
		{
			if(isNotUseSkillState())
				return;
			
			var skillId:uint = myFightState.curUseSkillId;
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			var skillTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
			if(!state)
			{
				cancleUseSkillState();
				return;
			}
			
			if(state.strIdleName && skillTemp.needChant && skillTemp.chantDuration>0)
			{
				//需要等待技能处理器通知技能引导结束
				onStartChant(state,skillTemp.chantDuration);
				playSound(getSoundId(SoundFields.Chant,0,skillTemp.objSound));
				return;
			}
			
			if(!state.strFireName)
				appearSkillEffect();
			
			onSkillDisappear();
		}
		
		protected function onSkillDisappear():void
		{
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			if(isNotUseSkillState())
				return;
			if(!state)
			{
				cancleUseSkillState();
				return;
			}
			if(state.strDisappearName)
			{
				myBodySkin.gotoAndPlay2(state.strDisappearName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					state.strDisappearName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onSkillDisappearAnimEnd);
			}
			else
			{
				onSkillDisappearAnimEnd();
			}
		}
		
		/**
		 * 技能动作施放结束
		 */
		protected function onSkillDisappearAnimEnd():void
		{
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			if(isNotUseSkillState())
				return;
			if(!state)
			{
				cancleUseSkillState();
				return;
			}
			state.skillCd.resetCDTime();
			myAttackCDTimer.resetCDTime();
			notifyTriggerSkillAndBuff(TriggerConditionType.AFTER_USE_SKILL);
		}
		
		protected function onStartChant(state:SkillState,duration:int):void
		{
			_skillChantTimeTick = timeTaskMgr.createTimeTask(GameFightConstant.TIME_UINT*10,onSkillChantInterval,[state.id],
				duration/(GameFightConstant.TIME_UINT*10),onSkillChantEnd,[state.id]);
			skillActionSkin.gotoAndPlay2(state.strIdleName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				state.strIdleName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			onSkillChantStart(state.id);
		}
		
		protected function isChanting():Boolean
		{
			return _skillChantTimeTick>0;
		}
		
		protected function onSkillChantStart(skillId:uint):void
		{
			
		}
		
		protected function onSkillChantInterval(skillId:uint):void
		{
			
		}
		
		protected function onSkillChantEnd(skillId:uint):void
		{
			_skillChantTimeTick = 0;
			appearSkillEffect();
			onSkillDisappear();
		}
		/**
		 * 清除技能引导状态，要在状态切换到死亡时调用，否则会死亡后有可能又变为使用技能状态 
		 */		
		protected function clearSkillChantState():void
		{
			if(_skillChantTimeTick>0)
			{
				timeTaskMgr.destoryTimeTask(_skillChantTimeTick);
				_skillChantTimeTick= 0;
			}
		}
		
		/**
		 * 发出技能的子弹或者特效
		 */
		private var arrDelayWeapons:Array = [];
		private var iDelayWeaponTick:int = 0;
		protected function appearSkillEffect():void
		{
			if(isNotUseSkillState())
				return;
			//此处有bug，使用技能同时升级技能可能导致旧技能信息丢失
			var skillId:uint = myFightState.curUseSkillId;
			var state:SkillState = mySkillStates.get(skillId) as SkillState;
			if(!state)
			{
				cancleUseSkillState();
				return;
			}
			var buffTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
			if(!buffTemp)
				return;
			if(buffTemp.weapon > 0)
			{
				fireSkillWeapons(skillId);
			}
			else if(buffTemp.resId>0)
			{
				showSkillEffect(buffTemp.resId,state);
			}
			else 
			{
				processSkillState(state);
			}
			
			playSkillSound(skillId);
		}
		
		
		private function fireSkillWeapons(skillId:uint):void
		{
			var buffTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
			var state:SkillState = mySkillStates.get(skillId) as SkillState;
			
			arrDelayWeapons.length = 0;
			var weaponCount:int = buffTemp.weaponCount;
			if(0 == weaponCount)
				weaponCount = 1;
			var j:int = 0;
			var delayCount:int = 0; 
			var targets:Vector.<ISkillTarget> = state.vecTargets;
			
			for(var i:int=0;i<weaponCount;++i,++j)
			{
				if(j >= targets.length)//分配多余子弹
				{
					j = 0;
					delayCount++;
				}
				
				var enemy:ISkillTarget = targets[j];
				//不排除目标死亡的情况，即使目标死亡，子弹也要发出去
				if(!enemy || enemy.isFreezedState())
					continue;
				
				var bulletEffect:BasicBulletEffect = objPoolMgr.createSceneElementObject(GameObjectCategoryType.BULLET
					, buffTemp.weapon, false) as BasicBulletEffect;
				
				if(bulletEffect)
				{
					var info:AttackerInfo = objPoolMgr.getEmptyAttackerInfo();
					info.skillId = skillId;
					info.updateInfo(this);
					bulletEffect.fire(enemy,this,getGlobalFirePoint(),0,100,null,state);
				}
				if(0 == delayCount)
					bulletEffect.notifyLifecycleActive();
				else
				{
					if(null == arrDelayWeapons[delayCount-1])
						arrDelayWeapons[delayCount-1] = [];
					(arrDelayWeapons[delayCount-1] as Array).push(bulletEffect);
				}			
			}	
			if(arrDelayWeapons.length>0)
				iDelayWeaponTick = timeTaskMgr.createTimeTask(GameFightConstant.TIME_UINT,onIntervalDelayWeapon,null,delayCount,onCmpDelayWeapon,null);
		}
		
		protected function playSkillSound(skillId:uint,field:String="use"):void
		{
			var info:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
			//if(!info || !info.sound)
			//	return;
			playSound(getSoundId(field,0,info.objSound));
		}
			
		
		protected function showSkillEffect(resId:uint,state:SkillState):void
		{
			var skillEffect:BasicSkillEffectRes = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.SKILLRES, resId, false) as BasicSkillEffectRes;
			if(skillEffect)
			{
				skillEffect.activeSkillEffect(this,state);
				skillEffect.notifyLifecycleActive();
			}
		}
		
		private function onIntervalDelayWeapon():void
		{
			if(arrDelayWeapons && arrDelayWeapons.length>0)
			{
				var arrBullets:Array = arrDelayWeapons[0];
				if(arrBullets && arrBullets.length>0)
				{
					for each(var bullet:BasicBulletEffect in arrBullets)
					{
						bullet.notifyLifecycleActive();
					}
					arrBullets.length = 0;
				}
				arrDelayWeapons[0] = null;
				arrDelayWeapons.splice(0,1);
			}
		}
		
		private function onCmpDelayWeapon():void
		{
			arrDelayWeapons.length = 0;
			iDelayWeaponTick = 0;
		}
		
		/**
		 * 检查现在是否有技能可以使用
		 */
		protected function checkCanUseSkill():Boolean
		{
			if(!myCheckSkillCD.getIsCDEnd() || !myStartCheckSkillCD.getIsCDEnd() || isOutOfScreen())
				return false;
			myCheckSkillCD.resetCDTime();
			
			var skillId:uint = checkShouldUseOnCdReadySkill();
			
			if(0 == skillId)
				skillId = getRandomSKillId();
			if(0 == skillId)
				return false;
						
			return checkSkillCondition(skillId);
		}
		
		public function isOutOfScreen():Boolean
		{
			return this.x<-(this.width>>1) || this.x>GameFightConstant.SCENE_MAP_WIDTH+(this.width>>1) || this.y<-(this.height>>1) || this.y>GameFightConstant.SCENE_MAP_HEIGHT+(this.height>>1)
		}
		/**
		 * 检查是否有cd时间一到就必定会使用的技能 
		 * @return 技能id
		 */		
		private function checkShouldUseOnCdReadySkill():uint
		{
			var arrSpecialSkills:Array = mySpecialSkills.get(SkillSpecialType.SHOULD_USE_ON_CD_READY);
			if(arrSpecialSkills && arrSpecialSkills.length>0)
			{
				for each(var id:uint in arrSpecialSkills)
				{
					if(isSkillCDEnd(id))
						return id;
				}
			}
			return 0;
		}
		
		protected function checkSpecialSkillBeforeAttack(target:ISkillTarget):void
		{
			var skillId:uint = 0;
			var arrSpecialSkills:Array = mySpecialSkills.get(SkillSpecialType.ATTACH_BUFF_ON_NORMAL_ATK);
			var state:SkillState = new SkillState;
			if(arrSpecialSkills && arrSpecialSkills.length>0)
			{
				for each(var id:uint in arrSpecialSkills)
				{
					var unit:SkillUseUnit = mySkillUseUnits.get(id) as SkillUseUnit;
					if(!unit)
						continue;
					if(Math.random()*100 > unit.odds)
						continue;
					
					state.dispose();
					state.id = id;
					state.mainTarget = target;
					state.vecTargets.push(target);
					state.owner = this;
					state.skillCd.clearCDTime();
					processSkillState(state);
				}
			}
		}
		
		private function getSkillState(skillId:uint):SkillState
		{
			var state:SkillState = mySkillStates.get(skillId) as SkillState;
			if(!state)
			{
				state = new SkillState(skillId);
				state.owner = this;
				state.skillCd.setDurationTime(getBaseSkillInfo(skillId).cdTime);
				mySkillStates.put(skillId,state);	
			}
			return state;
		}
		/**
		 * 检查指定的技能是否可以被使用 
		 * @param skillId 技能id
		 * @return 是否可使用
		 */		
		private function checkSkillCondition(skillId:uint):Boolean
		{
			var condition:BasicSkillUseCondition = skillConditionMgr.getSkillConditionById(skillId);
			var state:SkillState = getSkillState(skillId);
			if(condition && condition.canUse(this,state))
			{
				myFightState.curUseSkillId = skillId;
				if(GameObjectCategoryType.TOWER == elemeCategory)
					changeToTargetBehaviorState(TowerBehaviorState.USE_SKILL);
				else
					changeToTargetBehaviorState(OrganismBehaviorState.USE_SKILL);
				return true;
			}
			return false;
		}
		/**
		 * 随机选择可使用的主动技能id 
		 * @return 技能id
		 */		
		private function getRandomSKillId():uint
		{
			if(0 == myRandomSkills.length)
				return 0;
			var idx:uint = GameMathUtil.randomUintBetween(0,myRandomSkills.length-1);
			return myRandomSkills[idx];
		}
		
		public function notifyTriggerSkillAndBuff(condition:int):void
		{
			if(condition<= TriggerConditionType.NOT_TRIGGER || !isNotUseSkillState())
				return;
			var arrSkills:Array = myTriggerSkills.get(condition);
			if(arrSkills && arrSkills.length>0)
			{
				for(var i:int = 0;i<arrSkills.length;++i)
				{
					//默认某个触发条件每次触发时只能使用一个触发技能
					if(checkSkillCondition(arrSkills[i]))
						break;
				}
			}
		}
		
		//buff
		
		public function notifyAttachBuffer(buffId:uint,param:Object,owner:ISkillOwner):void
		{
			
		}
		
		public function notifyDettachBuffer(buffId:uint,bImmediate:Boolean = true):void
		{
			
		}
		
		public function notifyAddBuffRes(buffRes:BasicBufferResource,layer:int,offsetX:int,offsetY:int):void
		{
		}
		
		public function notifyRemoveBuffRes(buffRes:BasicBufferResource):void
		{
		}
		
		public function hasBuffer(buffId:uint):Boolean
		{
			return false;
		}
		
		protected function checkWeaknessAtk(dmg:int,target:BasicOrganismElement):int
		{
			var addDmg:int = 0;
			if(myFightState.weaknessAtkState.bHasState)
			{
				if(!target)
					target = mySearchedEnemy;
				if(myFightState.weaknessAtkState.lastTarget != target)
				{
					if(myFightState.weaknessAtkState.lastTarget)
						myFightState.weaknessAtkState.lastTarget.notifyDettachBuffer(BufferID.WeaknessShoot);
					myFightState.weaknessAtkState.lastTarget = target;
					myFightState.weaknessAtkState.atkTimes = 1;
					if(myFightState.weaknessAtkState.lastTarget.isBoss)
						return addDmg;
					var param:Object = {};
					param[BufferFields.BUFF] = BufferID.WeaknessShoot;
					param[BufferFields.DURATION] = 0;
					param[SkillResultTyps.SPECIAL_PROCESS] = 1;
					myFightState.weaknessAtkState.lastTarget.notifyAttachBuffer(BufferID.WeaknessShoot,param,this);	
				}
				else /*if(!myFightState.weaknessAtkState.lastTarget.isBoss)*/
				{
					addDmg = myFightState.weaknessAtkState.atkTimes * myFightState.weaknessAtkState.addtionAtk;
					//logch("checkWeaknessAtk",addDmg.toString(),myFightState.weaknessAtkState.atkTimes.toString(),myFightState.weaknessAtkState.addtionAtk.toString());
					myFightState.weaknessAtkState.atkTimes++;
				}
			}
			return addDmg;
		}
		
		//技能或buff造成效果
		
		/****************************** 所有被动技能效果 *************************/
		public function addPassiveMaxLife(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.maxlife += value;
			return true;
		}
		
		public function addPassiveMaxLifePct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.maxlife += myFightState.maxlife * value/100;
			return true;
		}
		
		public function addPassivePhysicDef(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.physicDefense += value;
			return true;
		}

		public function addPassiveMagicDef(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.magicDefense += value;
			return true;
		}
		
		public function addPassiveAtk(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.minAtk += value;
			myFightState.maxAtk += value;
			return true;
		}
		
		public function addPassiveAtkPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.minAtk += myFightState.minAtk * value/100;
			myFightState.maxAtk += myFightState.maxAtk * value/100;
			return true;
		}
		
		public function addPassiveAtkAreaPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.baseAtkArea = myFightState.baseAtkArea*(100+value)/100.0;
			return true;
		}
		
		public function addPassiveAtkArea(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.baseAtkArea += value;
			return true;
		}
		
		public function addPassiveMoveSpeedPct(value:int,owner:ISkillOwner):Boolean
		{
			return true;
		}
		
		public function addPassiveMoveSpeed(value:int,owner:ISkillOwner):Boolean
		{
			return true;
		}
		
		public function addPassiveAtkSpdPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.cdTime = myFightState.cdTime*(100 - value)/100.0;
			if(myAttackCDTimer)
				myAttackCDTimer.setDurationTime(myFightState.cdTime);
			return true;
		}
		
		public function addPassiveSkillAtkPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.skillAtk += value*100;
			return true;
		}
		
		public function rdcPassiveRebirthPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraRebirthTime = value;
			/*if(myResurrectionCDTimer)
				myResurrectionCDTimer.setDurationTime(myFightState.rebirthTime);*/
			return true;
		}
		
		public function rdcPassiveSkillCdPct(value:int,skillId:uint,owner:ISkillOwner):Boolean
		{
			if(null == myFightState.rdcSkillCd[skillId])
				myFightState.rdcSkillCd[skillId] = 0;
			myFightState.rdcSkillCd[skillId] += value;
			return true;
		}
		
		public function addPassiveEquipPct(value:Array,owner:ISkillOwner):Boolean
		{
			return false;
		}
		/******************************* 所有动态技能和buff效果 **************************/
		public function addAtk(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraAtk += value;
			return true;
		}
		
		public function addAtkPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraAtkPct += value;
			return true;
		}
		
		public function addAtkArea(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraAtkArea += value;
			return true;
		}
		
		public function addAtkSpdPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraAtkSpdPct += value;
			return true;
		}
		
		public function addMaxLife(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraMaxlife += value;
			return true;
		}
		
		public function addPhysicDef(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraPhysicDefense += value;
			return true;
		}
		
		public function addMagicDef(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.extraMagicDefense += value;
			return true;
		}
		
		public function addGoodsPct(value:int,owner:ISkillOwner):Boolean
		{
			myFightState.addGoodsPct += value;
			return true;
		}
		
		public function hurtSelf(value:int,atkType:int,owner:ISkillOwner,dieType:int = OrganismDieType.NORMAL_DIE,scaleValue:Number = 1,bNormalAttack:Boolean = true):Boolean
		{
			return true;
		}
		
		public function dmgAddition(pct:int,owner:ISkillOwner,dieType:int = 0):Boolean
		{
			return true;
		}
		
		public function addLife(value:int,owner:ISkillOwner,hasAnim:Boolean = true):Boolean
		{
			return false;
		}
		
		public function addMaxLifePct(pct:int,atkType:int,owner:ISkillOwner,hasAnim:Boolean = true,dieType:int = OrganismDieType.NORMAL_DIE):Boolean
		{
			var value:int = myFightState.getRealMaxLife()*pct/10000;
			if(value>=0)
				return addLife(value,owner,hasAnim);
			else
				return hurtSelf(value*-1,atkType,owner,dieType,1,false);
		}
		
		public function rebirthNow(owner:ISkillOwner):Boolean
		{
			return true;
		}
		
		public function addBlockFlag(atkPct:int,owner:ISkillOwner):Boolean
		{
			if(atkPct>0)
				myFightState.iBlockAtkPct = atkPct;
			if(myFightState.bBlock)
				return false;
			myFightState.bBlock = true;
			return true;
		}
		
		public function infectRoundUnits(buffId:uint,param:Object,area:uint,infectCount:int,iCampType:int,owner:ISkillOwner):Boolean
		{
			var searchCamp:int;
			if(1 == iCampType)
				searchCamp = campType;
			else if(2 == iCampType)
				searchCamp = oppositeCampType;
			else if(3 == iCampType)
				searchCamp = FightElementCampType.ALL_CAMP;
			else 
				return false;
			var count:int;
			var vecTargets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x,this.y,area,searchCamp);
			if(infectCount>0 && infectCount<vecTargets.length)
				count = infectCount;
			else 
				count = vecTargets.length;
			for(var i:int;i<count;++i)
			{
				vecTargets[i].notifyAttachBuffer(buffId,param,owner);
			}
			return true;
		}
		
		public function invincibleSlef(bEnable:Boolean,owner:ISkillOwner):Boolean
		{
			myFightState.bInvincible = bEnable;
			return true;
		}
		
		public function stunSlef(bEnable:Boolean,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function hugeDmgEff(bAdd:Boolean,owner:ISkillOwner,odds:int,nearPct:int,farPct:int):Boolean
		{
			if(bAdd)
			{
				myFightState.hugeDmgState.bHasBuff = true;
				myFightState.hugeDmgState.odds = odds;
				myFightState.hugeDmgState.nearPct = nearPct;
				myFightState.hugeDmgState.farPct = farPct;
			}
			else
			{
				myFightState.hugeDmgState.dispose();
			}
			return true;
		}
		
		public function setReboundDmg(bEnable:Boolean,iPct:int,owner:ISkillOwner):Boolean
		{
			if(bEnable)
			{
				if(iPct<=0)
					return false;
				myFightState.iReboundDmgPct = iPct;
			}
			else
			{
				myFightState.iReboundDmgPct = 0;
			}
			return true;
		}
		
		public function addSafeLaunchFlag(atkArea:int,dmg:int,stunTime:int,fallAtkArea:int,fallDmg:int,owner:ISkillOwner):Boolean
		{
			if(myFightState.safeLaunchState.hasSafeLaunch)
				return false;
			myFightState.safeLaunchState.hasSafeLaunch = true;
			myFightState.safeLaunchState.atkArea = atkArea;
			myFightState.safeLaunchState.dmg = dmg;
			myFightState.safeLaunchState.stunTime = stunTime;
			myFightState.safeLaunchState.fallAtkArea = fallAtkArea;
			myFightState.safeLaunchState.fallDmg = fallDmg;
			return true;
		}
		
		public function setMultyAtkCount(count:int,owner:ISkillOwner):Boolean
		{
			myFightState.iMultyAtk = count;
			return true;
		}
		
		public function addTowerAtkFlag(bAdd:Boolean,iArea:int,iAtk:int,owner:ISkillOwner):Boolean
		{
			if(bAdd)
			{
				if(myFightState.addTowerAtk.bHasState)
					return false;
				myFightState.addTowerAtk.bHasState = true;
				myFightState.addTowerAtk.iArea = iArea;
				myFightState.addTowerAtk.iAtkPct = iAtk;
			}
			else 
			{
				myFightState.addTowerAtk.dispose();
			}
			return true;
		}
		
		public function addExtraAddTowerAtk(value:Array,owner:ISkillOwner):Boolean
		{
			if(!value || value.length < 2)
				return false;
			myFightState.extraAddTowerAtk.extraAddTowerAtkAreaPct += value[0];
			myFightState.extraAddTowerAtk.extraAddTowerAtkValuePct += value[1];
			return true;
		}
		
		public function addSoldierAtkFlag(bAdd:Boolean,iArea:int,iAtk:int,owner:ISkillOwner):Boolean
		{
			if(bAdd)
			{
				myFightState.addSoldierState.bHasState = true;
				myFightState.addSoldierState.iAtkArea = iArea;
				myFightState.addSoldierState.iAtkPct = iAtk;
			}
			else 
			{
				myFightState.addTowerAtk.dispose();
			}
			return true;
		}

		public function addSoldierDefFlag(bAdd:Boolean,iArea:int,iDef:int,owner:ISkillOwner):Boolean
		{
			if(bAdd)
			{
				myFightState.addSoldierState.bHasState = true;
				myFightState.addSoldierState.iDefArea = iArea;
				myFightState.addSoldierState.iDef = iDef;
			}
			else 
			{
				myFightState.addTowerAtk.dispose();
			}
			return true;
		}
		
		public function addTargetDmgPctToLife(iPct:int,owner:ISkillOwner):Boolean
		{
			myFightState.iAtkToLifePct = iPct;
			return true;
		}
		
		public function changeMoveSpeed(iPct:int,owner:ISkillOwner,bBuffEnd:Boolean = false):Boolean
		{
			return false;
		}
		
		public function addImmuneRdcMoveSpdFlag(bAdd:Boolean,owner:ISkillOwner):Boolean
		{
			myFightState.bImmuneRdcMoveSpd = bAdd;
			return true;
		}
		
		public function canBetray():Boolean
		{
			if(myFightState.betrayState.bBetrayed || isHero || isBoss || GameObjectCategoryType.SUMMON_BY_TOWER == myElemeCategory
			|| GameObjectCategoryType.SUMMON_BY_ORGANISM == myElemeCategory || myFightState.bSheep || myFightState.isFlyUnit || myFightState.provokeTarget)
				return false;
			return true;
		}
		
		public function setBetrayFlag(bBetray:Boolean,owner:ISkillOwner):Boolean
		{
			if(bBetray)
			{
				if(myFightState.betrayState.bBetrayed)
					return false;
				myFightState.betrayState.bBetrayed = true;
				myFightState.betrayState.betrayCamp = owner.campType;
				onBetrayed();
			}
			else
			{
				myFightState.betrayState.dispose();
				myFightState.curLife = 0;
				changeToTargetBehaviorState(OrganismBehaviorState.DYING);
			}
			return true;
		}
		
		protected function onBetrayed():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
		}
		
		public function lifeToPhysicDef(pct:int,def:int,owner:ISkillOwner):Boolean
		{
			if(!pct || !def)
				return false;
			myFightState.lifeRdcToPhysicDef = (myFightState.getRealMaxLife() - myFightState.curLife)*100.0/myFightState.getRealMaxLife()/pct*def;
			return true;
		}
		
		public function addBeastAngryFlag(pct:int,area:int,atkSpd:int,moveSpd:int,owner:ISkillOwner):Boolean
		{
			if(myFightState.beastState.bHasState)
				return false;
			myFightState.beastState.bHasState = true;
			myFightState.beastState.iAtkArea = area;
			myFightState.beastState.iLifeDownPct = pct;
			myFightState.beastState.iAtkSpd = atkSpd;
			myFightState.beastState.iMoveSpd = moveSpd;
			return true;
		}
		
		public function SnowballMax(atk:int,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function addReflectRdcAtkSpdFlag(pct:int,owner:ISkillOwner):Boolean
		{
			myFightState.iReflectRdcAtkSpd = pct;
			return true;
		}
		
		public function atkRoundUnits(area:int,atk:int,camp:int,owner:ISkillOwner,dieType:int = 0):Boolean
		{
			return true;
		}
		
		public function canBeProvoked(owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function Provoked(bProvoked:Boolean,owner:ISkillOwner):Boolean
		{
			if(bProvoked)
			{
				myFightState.provokeTarget = owner as BasicOrganismElement;
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}
			else 
				myFightState.provokeTarget = null;
			return true;
		}
		
		public function addWeaknessAtk(bAdd:Boolean,atk:int,owner:ISkillOwner):Boolean
		{
			if(bAdd)
			{
				if(myFightState.weaknessAtkState.bHasState)
					return false;
				myFightState.weaknessAtkState.dispose();
				myFightState.weaknessAtkState.bHasState = true;
				myFightState.weaknessAtkState.addtionAtk = atk;
				
			}
			else 
			{
				myFightState.weaknessAtkState.dispose();
			}		
			return true;
		}
		
		public function addDmgPctBySize(bAdd:Boolean,pctSmall:int,pctNormal:int,pctBig:int,owner:ISkillOwner):Boolean
		{
			if(bAdd)
			{
				if(myFightState.dmgPctBySizeState.bHasState)
					return false;
				myFightState.dmgPctBySizeState.dispose();
				myFightState.dmgPctBySizeState.bHasState = true;
				myFightState.dmgPctBySizeState.iPctSmall = pctSmall;
				myFightState.dmgPctBySizeState.iPctNormal = pctNormal;
				myFightState.dmgPctBySizeState.iPctBig = pctBig;
			}
			else
			{
				myFightState.dmgPctBySizeState.dispose();
			}
			return true;
		}
		
		public function RdcDmgByLifeDown(bAdd:Boolean,lifeLimit:int,dmgRdc:int,owner:ISkillOwner):Boolean
		{
			if(bAdd)
			{
				if(myFightState.rdcDmgByLifeDownState.bHasState)
					return false;
				myFightState.rdcDmgByLifeDownState.dispose();
				myFightState.rdcDmgByLifeDownState.bHasState = true;
				myFightState.rdcDmgByLifeDownState.iDmgRdcPct = dmgRdc;
				myFightState.rdcDmgByLifeDownState.iLifeLimitPct = lifeLimit;
			}
			else
			{
				myFightState.rdcDmgByLifeDownState.dispose();
			}
			return true;
		}
		
		public function addWalkEff(effId:uint,duration:uint,param:Array,owner:ISkillOwner):Boolean
		{
			myFightState.groundEffcetState.effId = effId;
			myFightState.groundEffcetState.duration = duration;
			myFightState.groundEffcetState.arrParam = param;
			return true;
		}
		
		public function addGroundEff(effId:uint,duration:uint,param:Array,owner:ISkillOwner):Boolean
		{
			var eff:BasicGroundEffect = objPoolMgr.createSceneElementObject(
				GameObjectCategoryType.GROUNDEFFECT,effId,false) as BasicGroundEffect;
			if(!eff)
				return false;
			if(_lastExplosionPoint && (-1 != _lastExplosionPoint.x || -1 != _lastExplosionPoint.y))
			{
				eff.x = _lastExplosionPoint.x;
				eff.y = _lastExplosionPoint.y;
			}
			else
			{
				eff.x = x;
				eff.y = y;
			}
			eff.setEffectParam(duration,param,owner);
			eff.notifyLifecycleActive();
			return true;
		}
		
		public function rdcDmgByCategory(category:int,pct:int,owner:ISkillOwner):Boolean
		{
			myFightState.iRdcDmgFromCategory = category;
			myFightState.iDmgFromCategoryPct = pct;
			return true;
		}
		
		public function Invisible(bEnable:Boolean,owner:ISkillOwner):Boolean
		{
			myFightState.bInvisible = bEnable;
			return true;
		}
		
		public function dropBox(itemId:uint,count:int,duration:int,money:uint,owner:ISkillOwner):Boolean
		{
			return true;
		}
		
		public function suddenDeath(owner:ISkillOwner,dieType:int = 0):Boolean
		{
			return false;
		}
		
		public function canSummon(uid:uint,maxCount:int,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function summon(uid:uint,count:int,maxCount:int,owner:ISkillOwner):Boolean
		{
			return false;
		}	
		
		public function notifyPetDisappear(uid:uint,pet:BasicSummonSoldier):void
		{
			var arrPets:Array = mySummonPets.get(uid);
			var idx:int;
			if(arrPets && (idx = arrPets.indexOf(pet)) != -1)
			{
				arrPets.splice(idx,1);
			}
		}
		
		public function addFireMoreDmgPct(iPct:int,owner:ISkillOwner):Boolean
		{
			myFightState.iFireMoreDmgPct = iPct;
			return true;
		}
		
		public function rollBack(range:uint,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function changeToSheep(bChange:Boolean,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function explodeAfterDie(dmg:int,range:int,owner:ISkillOwner,dieType:int):Boolean
		{
			return false;
		}
		
		public function changeWeapon(weapon:uint,owner:ISkillOwner):Boolean
		{
			myFightState.weapon = weapon;
			return true;
		}
		
		public function hasIceShield():Boolean
		{
			return false;
		}
		
		public function addIceShield(pct:int,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function addDmgUnderAtkPct(pct:int,owner:ISkillOwner):Boolean
		{
			myFightState.iDmgUnderAtkPct += pct;
			return true;
		}
		
		public function summonAfterDie(uid:uint,duration:int,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function isStun():Boolean
		{
			return myFightState.bStun;
		}
	
	}
}