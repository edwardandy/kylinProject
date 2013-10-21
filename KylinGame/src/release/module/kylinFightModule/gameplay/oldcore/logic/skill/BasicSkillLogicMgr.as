package release.module.kylinFightModule.gameplay.oldcore.logic.skill
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.BasicHashMapMgr;
	
	public class BasicSkillLogicMgr extends BasicHashMapMgr
	{
		protected var _defaultCondition:BasicSkillLogicUnit;
		
		public function BasicSkillLogicMgr()
		{
			super();
		}
		
		protected function getSkillLogicById(id:uint):BasicSkillLogicUnit
		{
			var result:BasicSkillLogicUnit = _hashMap.get(id) as BasicSkillLogicUnit;
			if(result)
			{
				result.setData(id);
				return result;
			}
			
			result = getLogic(id);
			if(result)
				result.setData(id);
			
			if(!result)
			{
				if(!_defaultCondition)
					_defaultCondition = createDefaultLogic();	
				if(_defaultCondition)
					_defaultCondition.setData(id);
				result = _defaultCondition;
			}
			
			if(result)
				_hashMap.put(id,result);
			return result;	
		}
		
		protected function getLogic(id:uint):BasicSkillLogicUnit
		{
			return null;
		}
		
		protected function createDefaultLogic():BasicSkillLogicUnit
		{
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_defaultCondition = null;	
		}
	}
}