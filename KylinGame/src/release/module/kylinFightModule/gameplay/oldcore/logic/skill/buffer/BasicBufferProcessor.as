package release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer
{
	import com.shinezone.core.datastructures.HashMap;
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IBufferProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.buff.BuffTemplateInfo;
	
	public class BasicBufferProcessor implements IBufferProcessor
	{
		private var _id:uint;
		private var _buffInfo:BuffTemplateInfo;
		private var _bossList:Array;
		private var _hashBuffResults:HashMap = new HashMap;
		private var _hashTriggerResults:HashMap = new HashMap;
		
		private var _overType:int = 0;
		private var _hasDirectBuff:Boolean = false;
		private var _hasTriggerBuff:Boolean = false;
		
		public function BasicBufferProcessor(uid:uint)
		{
			_id = uid;
			init();
		}
		
		private function init():void
		{
			_buffInfo = TemplateDataFactory.getInstance().getBuffTemplateById(_id);
			_overType = _buffInfo.overType;
			initBossList();
			initFields();
		}
		
		private function initBossList():void
		{
			_bossList = null;
			if(!_buffInfo.bossEffect)
				return;
			var arrBoss:Array = _buffInfo.bossEffect.split(",");
			_bossList = [];
			for each(var strId:uint in arrBoss)
			{
				_bossList.push(strId);
			}
		}
		
		private function initFields():void
		{
			var arrFields:Array = _buffInfo.buffMode.split(",");
			var result:ISkillResult;
			for each(var field:String in arrFields)
			{
				result = GameAGlobalManager.getInstance().gameSkillResultMgr.getSkillResultById(field);
				if(result)
				{
					if(TriggerConditionType.NOT_TRIGGER == result.triggerCondition)
					{
						_hashBuffResults.put(field,result);
						_hasDirectBuff = true;
					}
					else
					{
						var arrCondition:Array = _hashTriggerResults.get(result.triggerCondition) as Array;
						if(!arrCondition)
						{
							arrCondition = [];
							_hashTriggerResults.put(result.triggerCondition,arrCondition);
						}
						if(!arrCondition[field])
							arrCondition[field] = result;
						_hasTriggerBuff = true;
					}
				}
			}
		}
		
		public function processBuff(target:ISkillTarget, param:Object,owner:ISkillOwner):void
		{
			for each(var field:String in _hashBuffResults.keys())
			{
				if(param.hasOwnProperty(field))
					(_hashBuffResults.get(field) as ISkillResult).effect(param,target,owner);
			}	
		}
		
		public function notifyTriggerBuff(condition:int,target:ISkillTarget,param:Object,owner:ISkillOwner):Boolean
		{
			if(TriggerConditionType.NOT_TRIGGER == condition)
				return false;
			var arrCondition:Array = _hashTriggerResults.get(condition) as Array;
			if(!arrCondition)
				return false;
			var result:Boolean = true;
			for(var field:String in arrCondition)
			{
				if(param.hasOwnProperty(field) && !(arrCondition[field] as ISkillResult).effect(param,target,owner) && result)
					result = false;
			}
			return result;
		}
		
		public function notifyBuffStart(target:ISkillTarget, param:Object,owner:ISkillOwner):Boolean
		{
			return processTriggerStartOrEnd(true,target,param,owner);
		}
		
		public function notifyBuffEnd(target:ISkillTarget, param:Object,owner:ISkillOwner):Boolean
		{
			return processTriggerStartOrEnd(false,target,param,owner);
		}
		
		private function processTriggerStartOrEnd(isStart:Boolean,target:ISkillTarget, param:Object,owner:ISkillOwner):Boolean
		{
			var arrCondition:Array;
			var result:Boolean = true;
			for each(var condition:int in _hashTriggerResults.keys())
			{
				arrCondition = _hashTriggerResults.get(condition) as Array;
				if(!arrCondition)
					continue;
				for(var field:String in arrCondition)
				{
					if(param.hasOwnProperty(field))
					{
						if(isStart)
						{
							if((arrCondition[field] as ISkillResult).start(param,target,owner) && result)
								result = false;
						}
						else
						{
							if((arrCondition[field] as ISkillResult).end(param,target,owner) && result)
								result = false;
						}
					}
				}
			}
			
			return result;
		}
		
		public function canUse(target:ISkillTarget,owner:ISkillOwner,param:Object):Boolean
		{
			if(target != owner && target.isBoss && (!_bossList || (-1 == _bossList.indexOf(target.objId))))
				return false;
			
			var field:String;
			for each(field in _hashBuffResults.keys())
			{
				if((_hashBuffResults.get(field) as ISkillResult).canUse(target,owner,param))
					return true;
			}
			
			var arrCondition:Array;
			for each(var condition:int in _hashTriggerResults.keys())
			{
				arrCondition = _hashTriggerResults.get(condition) as Array;
				if(!arrCondition)
					continue;
				for(field in arrCondition)
				{
					if((arrCondition[field] as ISkillResult).canUse(target,owner,param))
						return true;
				}
			}
			
			return false;
		}
		
		public function dispose():void
		{
			_hashBuffResults.clear();
			_hashBuffResults = null;
			
			_hashTriggerResults.clear();
			_hashTriggerResults = null;
			
			_buffInfo = null;
		}
		
		public function get overType():int
		{
			return _overType;
		}
		
		public function get hasDirectBuff():Boolean
		{
			return _hasDirectBuff;
		}
		
		public function get hasTriggerBuff():Boolean
		{
			return _hasTriggerBuff;
		}
		/**
		 * 所有触发条件
		 */
		public function get triggerConditions():Array
		{
			return _hashTriggerResults.keys();
		}
			
	}
}