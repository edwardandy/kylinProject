package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	/**
	 * 增加物理防御力
	 */
	public class SkillResult_Def extends BasicSkillResult
	{
		public function SkillResult_Def(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var def:int = int(value[_id]);
			//if(def>0)
				return target.addPhysicDef(def,owner);
			//return false;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			return effect(value,target,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var def:int = int(value[_id]);
			//if(def>0)
				return target.addPhysicDef(-def,owner);
			//return false;
		}
	}
}