package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	
	public interface ISkillProcessor extends IDisposeObject
	{
		/**
		 * 处理技能的结果
		 */
		function processSkill(state:SkillState):void;
		/**
		 * 处理技能的单个作用对象结果
		 */
		function processSingleEnemy(state:SkillState,target:ISkillTarget):Boolean;
		/**
		 * 显示技能的表现，包括子弹和技能特效
		 */
		function appearSkill(state:SkillState):void;
		/**
		 * 检查该技能对该目标是否可用
		 */
		function canUse(target:ISkillTarget,owner:ISkillOwner):Boolean;
		/**
		 * 技能效果参数 
		 * @return 
		 * 
		 */		
		function get effectParam():Object;
	}
}