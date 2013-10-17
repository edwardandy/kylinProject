package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	/**
	 * 攻击或使用技能时附带的攻击者信息 
	 * @author Edward
	 * 
	 */	
	public class AttackerInfo implements IDisposeObject
	{
		public var bUsed:Boolean = false;
		
		private var _skillId:uint;
		public function AttackerInfo()
		{
		}
		
		public function get skillId():uint
		{
			return _skillId;
		}

		public function set skillId(value:uint):void
		{
			_skillId = value;
		}

		public function updateInfo(attacker:ISkillOwner):void
		{
			bUsed = true;
		}
		
		public function dispose():void
		{
			bUsed = false;
			
			_skillId = 0;
		}
	}
}