package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;
	
	public class SkillResult_Infect extends BasicSkillResult
	{
		/**
		 * 死亡后感染周围目标
		 */
		public function SkillResult_Infect(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.AFTER_DIE_BEFORE_REBIRTH;
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{	
			//buff才能感染
			if(!value.hasOwnProperty(BufferFields.BUFF))
				return false;
			var buffId:uint = value[BufferFields.BUFF];
			var arrValue:Array = getValueArray(value);
			
			return target.infectRoundUnits(buffId,value,uint(arrValue[0]),int(arrValue[1]),int(arrValue[2]),owner);
		}
	}
}