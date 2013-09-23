package mainModule.model.gameData.sheetData.skill
{
	/**
	 * 使用技能的基本信息 
	 * @author Edward
	 * 
	 */	
	public final class SkillUseUnit
	{
		/**
		 * 技能id
		 */
		public var skillId:uint = 0;
		/**
		 * 施放动作 0:无动作 1:通用动作 skillid:和技能对应的特定动作
		 */
		public var action:int = 0;
		/**
		 * 施放概率
		 */
		public var odds:int = 100;
		
		public function SkillUseUnit()
		{
		}
	}
}