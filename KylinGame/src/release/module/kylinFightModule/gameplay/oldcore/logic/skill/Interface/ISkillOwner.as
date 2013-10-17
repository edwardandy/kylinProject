package release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.IOrganismSkiller;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.BasicSummonSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	public interface ISkillOwner extends ISkillTarget, IOrganismSkiller
	{
		/**
		 * 技能cd是否已结束
		 */
		function isSkillCDEnd(id:uint):Boolean;
		/**
		 * 技能使用的概率
		 */
		function getSkillUseOdds(id:uint):int;	
		/**
		 * 得到子弹发射点
		 */
		function getGlobalFirePoint():PointVO;
		/**
		 * 获得技能伤害加成万分比，FightUnitState.skillAtk
		 */
		function getSkillDmgAddPct():int;
		/**
		 * 子弹击中目标后回调计算伤害，或技能效果
		 */
		function hurtTarget(target:ISkillTarget,state:SkillState):void;
		/**
		 * 爆炸或特效作用于对象效果
		 */
		function processSkillState(state:SkillState):void;
		/**
		 * 宠物死亡或消失了
		 */
		function notifyPetDisappear(uid:uint,pet:BasicSummonSoldier):void;
		/**
		 * 当前的等级
		 */		
		function get curLevel():int;
	}
}