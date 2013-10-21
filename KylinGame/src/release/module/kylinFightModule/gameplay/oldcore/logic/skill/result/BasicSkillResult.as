package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result
{
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillResult;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	
	/**
	 * 技能的直接作用效果
	 */
	public class BasicSkillResult implements ISkillResult
	{
		protected var _id:String;
		/**
		 * 是否是被动触发的效果，比如死亡后爆炸 0表示非被动触发的
		 */
		protected var _triggerCondition:int = 0;
		
		public function BasicSkillResult(strId:String)
		{
			_id = strId;
		}
		
		public function dispose():void
		{
			_id = "";
		}
		
		public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function start(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function end(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			return false;
		}
		
		public function canUse(target:ISkillTarget,owner:ISkillOwner,param:Object):Boolean
		{
			return true;
		}
		
		public function get triggerCondition():int
		{
			return _triggerCondition;
		}
		
		/**
		 * 取一个范围的随机值，value是 "100-500" 之类的格式
		 */
		protected function getRandomValue(value:String):uint
		{
			var arrValue:Array = value.split("-");
			if(arrValue.length == 1)
				return arrValue[0];
			var result:uint = GameMathUtil.randomUintBetween(arrValue[0],arrValue[1]);
			return result;
		}
		/**
		 * 是否有此效果，如无敌，复活等
		 */
		protected function hasFlag(value:Object):Boolean
		{
			if(value[_id] == 1)
				return true;
			return false;
		}
		
		protected function getValueArray(value:Object):Array
		{
			return (value[_id] as String).split("-");
		}
		
		protected function getDieType(value:Object):int
		{
			if(value.hasOwnProperty(BufferFields.DIETYPE))
				return value[BufferFields.DIETYPE];
			return OrganismDieType.NORMAL_DIE;
		}
	}
}