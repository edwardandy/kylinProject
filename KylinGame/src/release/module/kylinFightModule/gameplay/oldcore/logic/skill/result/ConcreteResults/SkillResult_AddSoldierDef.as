package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 增加英雄周围士兵的防御
	 */
	public class SkillResult_AddSoldierDef extends BasicSkillResult
	{
		public function SkillResult_AddSoldierDef(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var area:int = arrValue[0];
			var def:int = arrValue[1];
			if(!area || !def)
				return false;
			return target.addSoldierDefFlag(true,area,def,owner);
		}
		
		override public function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return target.addSoldierDefFlag(false,0,0,owner);
		}
	}
}