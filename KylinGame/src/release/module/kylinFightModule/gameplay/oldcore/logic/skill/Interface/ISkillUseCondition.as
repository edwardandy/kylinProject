package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	
	public interface ISkillUseCondition extends IDisposeObject
	{
		function get id():uint;
		function canUse(owner:ISkillOwner,state:SkillState):Boolean;
	}
}