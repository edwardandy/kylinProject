package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 *  英雄亲手杀死怪物所获得的物资提高百分比
	 * @author Edward
	 * 
	 */	
	public class SkillResult_AddGoodsPct extends BasicSkillResult
	{
		public function SkillResult_AddGoodsPct(strId:String)
		{
			super(strId);
			_triggerCondition = TriggerConditionType.BUFFER_START_END;
		}
		
		override public function start(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var pct:int = value[_id];
			if(0 == pct)
				return false;
			return target.addGoodsPct(pct,owner);
		}
		
		override public function effect(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var pct:int = value[_id];
			if(0 == pct)
				return false;
			return target.addGoodsPct(pct,owner);
		}
		
		override public function end(value:Object, target:ISkillTarget, owner:ISkillOwner):Boolean
		{
			var pct:int = value[_id];
			if(0 == pct)
				return false;
			return target.addGoodsPct(pct*-1,owner);
		}
	}
}