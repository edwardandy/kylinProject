package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;

	public interface ISkillResult extends IDisposeObject
	{
		/**
		 * 效果的直接影响
		 */
		function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean;
		/**
		 * buff开始时的作用，比如立即施加无敌状态
		 */
		function start(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean;
		/**
		 * buff结束时撤销作用，比如撤销无敌状态
		 */
		function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean;
		/**
		 * 是否可对该目标使用
		 */
		function canUse(target:ISkillTarget,owner:ISkillOwner,param:Object):Boolean;
		/**
		 * 效果触发类型
		 */
		function get triggerCondition():int;
	}
}