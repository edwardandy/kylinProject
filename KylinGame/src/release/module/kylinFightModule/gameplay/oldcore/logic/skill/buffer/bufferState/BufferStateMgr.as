package release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.bufferState
{
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.BasicBufferProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.GameFightBufferProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	
	import robotlegs.bender.framework.api.IInjector;
	
	public class BufferStateMgr implements IDisposeObject
	{
		[Inject]
		public var buffProcessorMgr:GameFightBufferProcessorMgr;
		[Inject]
		public var injector:IInjector;
		/**
		 * buffId->BasicBufferState
		 */
		private var _hashStates:HashMap = new HashMap;
		private var _target:ISkillTarget;
		
		public function BufferStateMgr(target:ISkillTarget)
		{
			_target = target;
		}
		
		public function attachBuff(id:uint,param:Object,owner:ISkillOwner):Boolean
		{
			//概率不满足
			if(param.hasOwnProperty(BufferFields.ODDS))
			{
				var odds:int = param[BufferFields.ODDS];
				if(!GameMathUtil.randomTrueByProbability(odds/100.0))
					return false;
			}
			var state:BasicBufferState;
			//同一个buff直接更新作用参数
			if(_hashStates.containsKey(id))
			{
				state = _hashStates.get(id) as BasicBufferState;
				if(state)
					state.updateByNewState(param,owner);
				return true;
			}
			var processer:BasicBufferProcessor = buffProcessorMgr.getBufferProcessorById(id);
			if(!processer || !processer.canUse(_target,owner,param))
				return false;
			//如果已经有相同覆盖类型的buff，则移除旧的，添加新的
			var key:uint = 0;
			var overProc:BasicBufferState;
			for each(var keyId:* in _hashStates.keys())
			{
				var  proc:BasicBufferState = _hashStates.get(keyId) as BasicBufferState;
				if(proc && proc.overType>0  && proc.overType == processer.overType)
				{
					key = keyId;
					overProc = proc;
					break;
				}
			}
			if(key>0)
			{
				overProc.dispose();
				_hashStates.remove(key);
			}
			//添加buff
			state = new BasicBufferState(id,owner,_target,param);
			injector.injectInto(state);
			_hashStates.put(id,state);
			return true;
		}
		
		public function dettachBuff(id:uint,bImmediate:Boolean = true):void
		{
			var  proc:BasicBufferState = _hashStates.get(id) as BasicBufferState;
			if(proc)
			{
				proc.notifyDettached(bImmediate);
				_hashStates.remove(id);
			}
		}
		
		public function hasBuffer(id:uint):Boolean
		{
			if(_hashStates.containsKey(id))
			{
				var state:BasicBufferState = _hashStates.get(id) as BasicBufferState;
				if(state)
					return true;
			}
			return false;
		}
		
		/**
		 * 处理触发条件的buff
		 */
		public function notifyTriggerBuff(iCondition:int):void
		{
			for each(var state:BasicBufferState in _hashStates.values() )
			{
				if(state.isCdEnd() && state.hasCondition(iCondition))
					state.notifyTriggerBuff(iCondition);
			}
		}
		
		public function clear():void
		{
			_hashStates.eachValue(disposeEachState);
			_hashStates.clear();
		}
		
		public function clearExcept(arrIds:Array):void
		{
			if(!arrIds || 0 == arrIds.length)
				return;
			var keys:Array = _hashStates.keys().concat();
			for each(var buff:uint in keys)
			{
				if(-1 == arrIds.indexOf(buff))
				{
					(_hashStates.get(buff) as BasicBufferState).dispose();
					_hashStates.remove(buff);
				}
			}
		}
		
		public function dispose():void
		{
			_hashStates= null;
			_target = null;
		}
		
		private function disposeEachState(e:IDisposeObject):void
		{
			e.dispose();
		}
	}
}