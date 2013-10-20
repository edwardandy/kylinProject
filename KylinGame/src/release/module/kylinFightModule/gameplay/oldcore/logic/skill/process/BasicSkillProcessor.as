package release.module.kylinFightModule.gameplay.oldcore.logic.skill.process
{
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicItem;
	import mainModule.model.gameData.sheetData.skill.heroSkill.IHeroSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.skillBullets.BasicSkillBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.BasicBufferProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.GameFightBufferProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.GameFightSkillResultMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	
	/**
	 * 技能逻辑处理类
	 */
	public class BasicSkillProcessor extends BasicSkillLogicUnit implements ISkillProcessor
	{
		[Inject]
		public var skillResultMgr:GameFightSkillResultMgr;
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		[Inject]
		public var heroSkillData:IHeroSkillDynamicDataModel;
		[Inject]
		public var buffProcessorMgr:GameFightBufferProcessorMgr;
		//private var _hashResults:HashMap = new HashMap;
		private var _arrResultKeys:Array = [];
		private var _effectParam:Object = {};
		//[bufferid->Object]
		private var _hashBuffs:HashMap = new HashMap;
				
		public function BasicSkillProcessor()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			initResult();
			initBuffs();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_hashBuffs.clear();
			_hashBuffs = null;
			_arrResultKeys = null;
		}
		
		public function get effectParam():Object
		{
			return _effectParam;
		}
		
		//处理单个对象
		public function processSingleEnemy(state:SkillState,target:ISkillTarget):Boolean
		{
			if(!state || !target || _id != state.id || -1 == state.vecTargets.indexOf(target))
				return false;
			
			var skillResult:ISkillResult;
			for each(var strId:String in _arrResultKeys)
			{
				skillResult = skillResultMgr.getSkillResultById(strId);
				if(skillResult)
				{
					skillResult.effect(changeParamBeforeUse(_effectParam,state.owner),target,state.owner);
				}
			}
			
			for each(var buffId:uint in _hashBuffs.keys())
			{
				
				target.notifyAttachBuffer(buffId,changeParamBeforeUse(_hashBuffs.get(buffId),state.owner),state.owner);
			}
			
			return true;
		}
		
		public function processSkill(state:SkillState):void
		{		
			processResults(state);
			processBuffers(state);
		}
		
		//处理技能效果的出现
		public function appearSkill(state:SkillState):void
		{
			if(_skillInfo.weapon)
				appearSkillWeapon(state);
		}
		//发射技能的子弹
		private function appearSkillWeapon(state:SkillState):void
		{
			var bulletEffect:BasicSkillBulletEffect;
			if(state.vecTargets && state.vecTargets.length>0)
			{
				for each(var target:ISkillTarget in state.vecTargets)
				{
					bulletEffect = objPoolMgr.createSceneElementObject(GameObjectCategoryType.BULLET, _skillInfo.weapon, false) as BasicSkillBulletEffect;
					if(!bulletEffect)
						return; 
					bulletEffect.skillFire(state,(target as BasicOrganismElement),state.owner.getGlobalFirePoint(),-1);
					bulletEffect.notifyLifecycleActive();
				}
				
			}
		}
		
		//处理技能的直接结果
		protected function initResult():void
		{
			if(!_skillInfo.objEffect)
				return;
			for(var key:String in _skillInfo.objEffect)
			{
				var skillResult:ISkillResult = skillResultMgr.getSkillResultById(key);
				if(skillResult)
					_arrResultKeys.push(key);	
				_effectParam[key] = _skillInfo.objEffect[key];
			}
		}
	
		
		public function processResults(state:SkillState):void
		{
			for each(var strId:String in _arrResultKeys)
			{
				processEachResult(strId,state);
			}	
		}
		
		public function processBuffers(state:SkillState):void
		{
			var bShareOdds:Boolean = false;
			var iShareOdds:int = 0;
			for each(var buffId:uint in _hashBuffs.keys())
			{
				var param:Object = changeParamBeforeUse(_hashBuffs.get(buffId),state.owner);
				if(param.hasOwnProperty(BufferFields.SHARE_ODDS))
				{
					bShareOdds = true;
					var curOdds:int = param[BufferFields.SHARE_ODDS];
					if(iShareOdds+curOdds<100 && !GameMathUtil.randomTrueByProbability(curOdds/100.0))
					{
						iShareOdds += curOdds;
						continue;
					}
				}
				processEachBuffer(buffId,param,state);
				if(bShareOdds)
					return;
			}
		}
		
		protected function processEachResult(id:String,state:SkillState):void
		{
			var skillResult:ISkillResult = skillResultMgr.getSkillResultById(id);
			if(!skillResult)
				return;
			var vecTargets:Vector.<ISkillTarget> = state.vecTargets;
			
			for each(var target:ISkillTarget in vecTargets)
			{
				skillResult.effect(changeParamBeforeUse(_effectParam,state.owner),target,state.owner);
			}
		}

		//处理buff
		protected function initBuffs():void
		{
			var arrBuffs:Array = _skillInfo.getBuffs();
			var arrPairs:Array;
			var arrFields:Array;
			var param:Object;
			for each(var buf:Object in arrBuffs)
			{
				param = {};
				for(var key:String in buf)
				{
					param[key] = buf[key];
				}
				
				if(param.hasOwnProperty(BufferFields.BUFF))
				{
					_hashBuffs.put(uint(param[BufferFields.BUFF]),param);
				}
				
			}
		}
		
		protected function processEachBuffer(id:uint,param:Object,state:SkillState):void
		{
			var vecTargets:Vector.<ISkillTarget> = state.vecTargets;
			
			for each(var target:ISkillTarget in vecTargets)
			{
				target.notifyAttachBuffer(id,param,state.owner);
			}
		}
		
		public function canUse(target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			for each(var strId:String in _arrResultKeys)
			{
				var skillResult:ISkillResult = skillResultMgr.getSkillResultById(strId);
				if(!skillResult)
					continue;
				
				if(skillResult.canUse(target,owner,_effectParam))
					return true;
			}

			for each(var buffId:uint in _hashBuffs.keys())
			{
				var processer:BasicBufferProcessor = buffProcessorMgr.getBufferProcessorById(buffId);
				if(processer && processer.canUse(target,owner,_hashBuffs.get(buffId)))
					return true;
			}
			return false;
		}
		
		protected function changeParamBeforeUse(src:Object,owner:ISkillOwner):Object
		{
			if(!_isHeroSkill || !src || !(owner is HeroElement))
				return src;
			
			var heroSkillInfo:IHeroSkillDynamicItem = heroSkillData.getHeroSkillDataById(owner.objId,_id);
			var heroSkillSheet:IHeroSkillSheetItem = heroSkillModel.getHeroSkillSheetById(_id);
			if(!heroSkillInfo || heroSkillInfo.level<=1 || 0 == heroSkillSheet.growth)
				return src;
			
			var param:Object = {};
			var field:*;
			for(field in src)
			{
				param[field] = src[field];
			}
			var grow:Number = heroSkillInfo.level * heroSkillSheet.growth;
			var arrValue:Array;
			for(field in param)
			{
				switch(field)
				{
					case SkillResultTyps.PASSIVE_MAXLIFE_PCT:
					case SkillResultTyps.PASSIVE_DEF:
					case SkillResultTyps.PASSIVE_ATK:
					case SkillResultTyps.PASSIVE_ATK_PCT:
					case SkillResultTyps.PASSIVE_ATK_AREA_PCT:
					case SkillResultTyps.PASSIVE_MAXLIFE:
					case SkillResultTyps.PASSIVE_MOVE_SPEED:
					case SkillResultTyps.PASSIVE_ATK_SPD_PCT:
					case SkillResultTyps.PASSIVE_RDC_REBIRTH_PCT:
					case SkillResultTyps.PASSIVE_SKILL_ATK_PCT:
					case SkillResultTyps.PASSIVE_RDC_SKILL_CD_PCT:
					case SkillResultTyps.TARGET_DMG_PCT_TO_LIFE:
					case SkillResultTyps.REBOUND_DMG_PCT:
					case SkillResultTyps.DMG_ADDITION:
					case SkillResultTyps.ADD_ATK_AREA:
						param[field] = int(param[field]) + grow;
						break;
					case SkillResultTyps.ADD_TOWER_ATK:
					case SkillResultTyps.ADD_SOLDIER_ATK:
					case SkillResultTyps.ADD_SOLDIER_DEF:
						arrValue = (param[field] as String).split("-");
						arrValue[1] = int(arrValue[1]) + grow;
						param[field] = arrValue.join("-");
						break;
					case SkillResultTyps.HUGE_DMG__PCT:
						arrValue = (param[field] as String).split("-");
						arrValue[2] = int(arrValue[2]) + grow;
						param[field] = arrValue.join("-");
						break;
					case BufferFields.ODDS:
						if(SkillID.CutNerve == _id || SkillID.CutNerveAdv == _id)
							param[field] = int(param[field]) + grow;
						break;
					case BufferFields.CD:
						if(SkillID.Dexterous == _id || SkillID.Rebirth == _id || SkillID.ShieldBlock == _id || SkillID.ShieldBlockAdv == _id
						|| SkillID.ArcaneSpirit == _id || SkillID.ArcaneSpiritAdv == _id)
							param[field] = int(param[field]) + grow;
						break;
					case SkillResultTyps.SAFE_LAUNCH:
						var arrParam:Array = (param[field] as String).split("-");
						arrParam[1] += grow;
						param[field] = arrParam.join("-");
						break;
				}
			}
			return param;
		}
	}
}