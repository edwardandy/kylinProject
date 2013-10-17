package release.module.kylinFightModule.gameplay.oldcore.logic.skill
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import framecore.structure.model.user.base.BaseSkillInfo;

	public class SkillState implements IDisposeObject
	{
		public var id:uint;
		public var skillCd:SimpleCDTimer = new SimpleCDTimer();
		public var owner:ISkillOwner;
		public var mainTarget:ISkillTarget;
		public var vecTargets:Vector.<ISkillTarget> = new Vector.<ISkillTarget>;
		
		/**
		 * 施放者施放该技能动作名
		 */
		public var strAppearName:String;
		/**
		 * 施放者引导动作名
		 */
		public var strIdleName:String;
		/**
		 * 施放者结束动作名
		 */
		public var strDisappearName:String;
		/**
		 * 施放者技能出现动作中的开火点(放出子弹或者技能特效)
		 */
		public var strFireName:String;
		
		public function SkillState(uid:uint = 0)
		{
			id = uid;
		}
		
		public function dispose():void
		{
			id = 0;
			owner = null;
			mainTarget = null;
			vecTargets.length = 0;
			strAppearName = null;
			strIdleName = null;
			strDisappearName = null;
			strFireName = null;
		}
				
		
	}
}