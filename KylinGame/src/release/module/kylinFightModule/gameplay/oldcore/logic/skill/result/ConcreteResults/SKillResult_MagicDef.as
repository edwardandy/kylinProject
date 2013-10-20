package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	/**
	 * 增加魔法防御
	 */
	public class SkillResult_MagicDef extends BasicSkillResult
	{
		public function SkillResult_MagicDef(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var def:int = int(value[_id]);
			//if(def>0)
				return target.addMagicDef(def,owner);
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
				return target.addMagicDef(-def,owner);
			//return false;
		}
	}
}