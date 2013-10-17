package release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.bufferState
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.BasicBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IBufferResource;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.BasicBufferProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.buff.BuffTemplateInfo;
	
	public class BasicBufferState implements IDisposeObject
	{
		private var _id:uint = 0;
		private var _param:Object;
		private var _owner:ISkillOwner;
		private var _target:ISkillTarget;
		/**
		 * 触发的cd 比如240秒才能重生一次
		 */
		private var _triggerCd:SimpleCDTimer;
		
		private var _buffRes:BasicBufferResource;
		private var _iTimeTask:int = 0;
		private var _buffInfo:BuffTemplateInfo;
		
		public function BasicBufferState(uid:uint,owner:ISkillOwner,target:ISkillTarget,param:Object)
		{
			_id = uid;
			_owner = owner;
			_target = target;
			_param = param;
			init();
		}
		
		private function init():void
		{
			_buffInfo = TemplateDataFactory.getInstance().getBuffTemplateById(_id);
			var processor:BasicBufferProcessor = GameAGlobalManager.getInstance().gameBufferProcessorMgr.getBufferProcessorById(_id);
			if(!_buffInfo || !processor)
				return;
			initRes();
			initTimerCd();	
			initTriggerCd();
			processor.notifyBuffStart(_target,_param,_owner);
		}
		
		private function initRes():void
		{
			if(int(_buffInfo.resourceId) == -1)
				return;
			_buffRes = ObjectPoolManager.getInstance().createSceneElementObject(GameObjectCategoryType.ORGANISM_SKILL_BUFFER,_id,false) as BasicBufferResource;
			if(!_buffRes)
				return;
			_buffRes.initializeByParameters(_target);
			//_buffRes.setAttach2DettachFromParentDisplayListFunction(attach2DettachSkillBufferFromDisplayListHandler);
			_buffRes.notifyLifecycleActive();
		}
		
		/*private function attach2DettachSkillBufferFromDisplayListHandler(skillBuffer:BasicBufferResource, isAttch:Boolean):void
		{
			skillBuffer.attach2DettachFromParent(isAttch);
		}*/
		
		private function initTimerCd():void
		{
			clearTimeTask();
			var processor:BasicBufferProcessor = GameAGlobalManager.getInstance().gameBufferProcessorMgr.getBufferProcessorById(_id);
			var dur:uint = 0;
			if(_param.hasOwnProperty(BufferFields.DURATION))				
				dur = uint(_param[BufferFields.DURATION]);
			//一直存在的buff，且该buff的效果都是被动的
			if(0 == dur && !processor.hasDirectBuff)
				return;
			var interval:uint = dur;
			if(processor.hasDirectBuff)
				interval = GameFightConstant.TIME_UINT*10;
			var repeat:int = (0 == dur?-1:(dur/interval));
		
			_iTimeTask = TimeTaskManager.getInstance().createTimeTask(interval,onBuffInterval,null,repeat,onBuffEnd,null);
		}
		
		private function initTriggerCd():void
		{
			if(_param.hasOwnProperty(BufferFields.CD))
			{
				var cd:int = _param[BufferFields.CD];
				if(cd > 0)
				{
					_triggerCd = new SimpleCDTimer(cd);
					_triggerCd.clearCDTime();
				}
			}
		}
		
		private function updateTriggerCd(bClear:Boolean):void
		{
			if(_param.hasOwnProperty(BufferFields.CD))
			{
				var cd:int = _param[BufferFields.CD];
				if(cd > 0)
				{
					if(!_triggerCd)
					{
						_triggerCd = new SimpleCDTimer(cd);
						_triggerCd.clearCDTime();
					}
					else
					{
						_triggerCd.setDurationTime(cd,bClear);
					}
				}
			}
		}
		/**
		 * 每秒的buff处理
		 */
		private function onBuffInterval():void
		{
			var processor:BasicBufferProcessor = GameAGlobalManager.getInstance().gameBufferProcessorMgr.getBufferProcessorById(_id);
			if(processor.canUse(_target,_owner,_param))
				processor.processBuff(_target,_param,_owner);
		}
		/**
		 * 处理触发条件的buff
		 */
		public function notifyTriggerBuff(condition:int):void
		{
			var processor:BasicBufferProcessor = GameAGlobalManager.getInstance().gameBufferProcessorMgr.getBufferProcessorById(_id);
			if(processor.notifyTriggerBuff(condition,_target,_param,_owner) && _triggerCd)
				_triggerCd.resetCDTime();
		}
		/**
		 * buff结束的处理
		 */
		private function onBuffEnd():void
		{
			if(_buffRes)
				_buffRes.disappear();
			_buffRes = null;
			if(_target)
				_target.notifyDettachBuffer(_id);
			//dispose();
		}
		
		private function clearTimeTask():void
		{
			if(_iTimeTask)
				TimeTaskManager.getInstance().destoryTimeTask(_iTimeTask);
			_iTimeTask = 0;
		}
		
		public function notifyDettached(bImmediate:Boolean = true):void
		{
			var processor:BasicBufferProcessor = GameAGlobalManager.getInstance().gameBufferProcessorMgr.getBufferProcessorById(_id);
			processor.notifyBuffEnd(_target,_param,_owner);
			
			if(_buffRes)
			{
				if(bImmediate)
					_buffRes.destorySelf();
				else
					_buffRes.disappear();
			}
			clearAllParam();
		}
		
		private function clearAllParam():void
		{
			_buffRes = null;
			clearTimeTask();
			_owner = null;
			_target = null;
			_id = 0;
			_buffInfo = null;
			_param = null;
			_triggerCd = null;
		}
		
		public function dispose():void
		{
			if(_buffRes)
				_buffRes.destorySelf();
	
			clearAllParam();
		}
		
		/**
		 * 被同一id的buff重用
		 */
		public function updateByNewState(param:Object,owner:ISkillOwner):void
		{
			_owner = owner;
			_param = param;
			initTimerCd();
			updateTriggerCd(false);
		}
		
		public function get overType():int
		{
			return _buffInfo.overType;
		}
		
		/**
		 * 强制buff结束,不需要通知目标，否则可能死循环
		 */
		/*public function forceBuffEnd():void
		{
			if(_buffRes)
				_buffRes.destorySelf();
			_buffRes = null;
			dispose();
		}*/
		/**
		 * 是否有某个触发条件
		 */
		public function hasCondition(iCondition:int):Boolean
		{
			var processor:BasicBufferProcessor = GameAGlobalManager.getInstance().gameBufferProcessorMgr.getBufferProcessorById(_id);
			if(processor.triggerConditions && -1 != processor.triggerConditions.indexOf(iCondition))
				return true;
			return false;
		}
		
		public function isCdEnd():Boolean
		{
			return !_triggerCd || _triggerCd.getIsCDEnd();
		}
	}
}