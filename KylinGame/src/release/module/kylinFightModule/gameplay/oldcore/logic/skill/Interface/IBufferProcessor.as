package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public interface IBufferProcessor extends IDisposeObject
	{
		/**
		 * 处理主动的buff效果，比如每秒伤害，每秒加血
		 */
		function processBuff(target:ISkillTarget,param:Object,owner:ISkillOwner):void;
		/**
		 * 处理被动的buff效果，比如死亡后复活，死亡后爆炸
		 */
		function notifyTriggerBuff(condition:int,target:ISkillTarget,param:Object,owner:ISkillOwner):Boolean;
		/**
		 * buff开始
		 */
		function notifyBuffStart(target:ISkillTarget, param:Object,owner:ISkillOwner):Boolean;
		/**
		 * buff结束
		 */
		function notifyBuffEnd(target:ISkillTarget, param:Object,owner:ISkillOwner):Boolean;
		/**
		 * buff 的覆盖类型，为0则不覆盖也不被其他buff覆盖
		 */
		function get overType():int;
		/**
		 * 是否有主动作用的效果
		 */
		function get hasDirectBuff():Boolean;
		/**
		 * 是否有被动触发的buff效果
		 */
		function get hasTriggerBuff():Boolean;
		/**
		 * 是否可对该目标使用
		 */
		function canUse(target:ISkillTarget,owner:ISkillOwner,param:Object):Boolean;
	}
}