package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.core.ILifecycleObject;

	public interface IBufferResource extends ILifecycleObject
	{
		function initializeByParameters(target:ISkillTarget):void;
	}
}