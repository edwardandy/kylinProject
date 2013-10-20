package release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition
{
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.FightUnitType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillAttackType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillTargetType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillUseCondition;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.GameFightSkillProcessorMgr;
	import release.module.kylinFightModule.service.sceneElements.ISceneElementsService;
	
	/**
	 * 技能使用条件判断类
	 */
	public class BasicSkillUseCondition extends BasicSkillLogicUnit implements ISkillUseCondition
	{	
		[Inject]
		public var skillProcessorMgr:GameFightSkillProcessorMgr;
		[Inject]
		public var sceneElementsService:ISceneElementsService;
		
		private var _curOwner:ISkillOwner;
		protected var _processer:ISkillProcessor;
		
		public function BasicSkillUseCondition()
		{

		}
		
		public function get id():uint
		{
			return _id;
		}
		
		override public function setData(skillId:uint):void
		{
			super.setData(skillId);
			_processer = skillProcessorMgr.getSkillProcessorById(_id);
		}
		
		public function canUse(owner:ISkillOwner,state:SkillState):Boolean
		{
			if(!owner || !state)
				return false;	
			var vecTarget:Vector.<ISkillTarget> = new Vector.<ISkillTarget>;
			var mainTarget:ISkillTarget;
			//作用范围中心的目标
			var centerTarget:ISkillTarget;
			//技能cd是否结束
			if(!owner.isSkillCDEnd(_id))
				return false;
			//技能使用的概率是否随到
			var odds:int = owner.getSkillUseOdds(_id);
			if(Math.random()*100 > odds)
				return false;
			
			//被动技能只能对自身使用
			if(SkillType.PASSIVITY == _skillInfo.type)
			{
				mainTarget = owner;
				state.mainTarget =	mainTarget;
				centerTarget = owner;
				vecTarget.push(owner);
				state.vecTargets = vecTarget ;
				return true;
			}
			//技能作用对象包括自身
			if(_skillInfo.hasTargetType(SkillTargetType.SELF) && processor.canUse(owner,owner))
			{
				mainTarget = owner;
				centerTarget = owner;
				vecTarget.push(owner);
				if(0 == _skillInfo.range)
				{
					state.vecTargets = vecTarget;
					state.mainTarget =	mainTarget;
					return true;
				}
			}
			var skillArea:int = _skillInfo.atkArea || GameFightConstant.NEAR_SKILL_AREA;
			if(-1 == skillArea && !centerTarget)//以自身为中心的作用范围
			{
				centerTarget = owner;
			}
			
			var vecUnits:Vector.<ISkillTarget> = new Vector.<ISkillTarget>;
			var vecTower:Vector.<BasicTowerElement>;
			var vecTemp:Vector.<BasicOrganismElement>;
			_curOwner = owner;
			//选取技能作用主对象
			//技能作用对象包括防御塔
			if(null == centerTarget && _skillInfo.hasTargetType(SkillTargetType.TOWER))
			{
				//技能所有者的攻击范围+作用范围内的所有塔
				vecTower = sceneElementsService.searchTowersBySearchArea(owner.x,owner.y,skillArea,1,necessarySearchConditionFilter);
				if(vecTower && 1 == vecTower.length)
				{	
					centerTarget = vecTower[0] as ISkillTarget;
					mainTarget = centerTarget;
				}
			}
			//技能作用于本方
			if(null == centerTarget && _skillInfo.hasTargetType(SkillTargetType.SAMECAMP))
			{
				centerTarget = sceneElementsService.searchOrganismElementEnemy(owner.x,owner.y,skillArea,
						FightElementCampType.FRIENDLY_CAMP == owner.campType?FightElementCampType.FRIENDLY_CAMP:FightElementCampType.ENEMY_CAMP,
						necessarySearchConditionFilter,ignoreAlive) as ISkillTarget;
				if(centerTarget)
					mainTarget = centerTarget;
			}
			//技能作用于对方
			if(null == centerTarget && _skillInfo.hasTargetType(SkillTargetType.OPPOSECAMP))
			{
				centerTarget = sceneElementsService.searchOrganismElementEnemy(owner.x,owner.y,skillArea,
						FightElementCampType.ENEMY_CAMP == owner.campType?FightElementCampType.FRIENDLY_CAMP:FightElementCampType.ENEMY_CAMP,
						necessarySearchConditionFilter,ignoreAlive) as ISkillTarget;
				if(centerTarget)
					mainTarget = centerTarget;
			}
			
			if(null == centerTarget)
			{
				_curOwner = null;
				return false;
			}
			//单体技能
			if(0 == _skillInfo.range)
			{
				if(!mainTarget)
				{
					_curOwner = null;
					return false;
				}
				if(0 == vecTarget.length)
				{
					vecTarget.push(mainTarget);
				}
				state.vecTargets = vecTarget ;
				state.mainTarget =	mainTarget;
				_curOwner = null;
				return true;
			}
			//技能作用于目标的数量
			var targetCount:int = _skillInfo.targetCount;
			var searchCount:int = targetCount;
			var bEndSearch:Boolean = false;
			//技能作用对象包括防御塔
			if(_skillInfo.hasTargetType(SkillTargetType.TOWER))
			{
				//技能所有者的攻击范围+作用范围内的所有塔
				vecTower = sceneElementsService.searchTowersBySearchArea(centerTarget.x,centerTarget.y
					,_skillInfo.range,searchCount,necessarySearchConditionFilter);
				if(vecTower && vecTower.length>0)
					vecUnits = vecUnits.concat(vecTower);
				if(targetCount>0)
				{
					if(vecUnits.length+vecTarget.length>=targetCount)
						bEndSearch = true;
					else
						searchCount = targetCount - vecUnits.length - vecTarget.length;
				}
					
			}
			//技能作用于本方
			if(!bEndSearch && _skillInfo.hasTargetType(SkillTargetType.SAMECAMP))
			{
				vecTemp = sceneElementsService.searchOrganismElementsBySearchArea(centerTarget.x,centerTarget.y,_skillInfo.range,
						FightElementCampType.FRIENDLY_CAMP == owner.campType?FightElementCampType.FRIENDLY_CAMP:FightElementCampType.ENEMY_CAMP,
					necessarySearchConditionFilter,ignoreAlive,(targetCount>0?searchCount:0));
				if(vecTemp && vecTemp.length>0)
					vecUnits = vecUnits.concat(vecTemp);
				if(targetCount>0)
				{
					if(vecUnits.length+vecTarget.length>=targetCount)
						bEndSearch = true;
					else
						searchCount = targetCount - vecUnits.length - vecTarget.length;
				}
			}
			//技能作用于对方
			if(!bEndSearch && _skillInfo.hasTargetType(SkillTargetType.OPPOSECAMP))
			{
				vecTemp = sceneElementsService.searchOrganismElementsBySearchArea(centerTarget.x,centerTarget.y,_skillInfo.range,
						FightElementCampType.ENEMY_CAMP == owner.campType?FightElementCampType.FRIENDLY_CAMP:FightElementCampType.ENEMY_CAMP,
						necessarySearchConditionFilter,ignoreAlive,(targetCount>0?searchCount:0));
				if(vecTemp && vecTemp.length>0)
					vecUnits = vecUnits.concat(vecTemp);
			}
			
			if(vecUnits && vecUnits.length>0)
			{
				for each(var unit:ISkillTarget in vecUnits)
				{
					vecTarget.push(unit);
				}
			}
			
			if(vecTarget.length > 0)
			{
				state.vecTargets = vecTarget ;
				state.mainTarget =	mainTarget;
				_curOwner = null;
				return true;
			}
			_curOwner = null;
			return false;
		}
		
		protected function get ignoreAlive():Boolean
		{
			return false;
		}
		
		protected final function get processor():ISkillProcessor
		{
			return _processer;
		}
		
		protected function necessarySearchConditionFilter(target:ISkillTarget):Boolean
		{
			if(target == _curOwner)
				return false;	
			if(!_processer || !_processer.canUse(target,_curOwner))
				return false;
			if(SkillAttackType.LAND == _skillInfo.canAirFight && FightUnitType.LAND == target.fightUnitType)
				return true;
			if(SkillAttackType.AIR == _skillInfo.canAirFight && FightUnitType.AIR == target.fightUnitType)
				return true;
			if(SkillAttackType.LAND_AIR == _skillInfo.canAirFight)
				return true;
			return false;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_curOwner = null;
			_processer = null;
		}
	}
}