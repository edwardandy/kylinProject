package mainModule.model.gameData.dynamicData
{
	/**
	 * 游戏动态数据类型名 ,用于和后台通信时数据的键名
	 * @author Edward
	 * 
	 */	
	public final class DynamicDataNameConst
	{
		/**
		 * 英雄动态数据 
		 */		
		public static const HeroData:String = "heroData";
		/**
		 * 进入战斗之前获得的战斗动态数据 
		 */		
		public static const FightData:String = "fightData";
		/**
		 * 英雄技能动态数据 
		 */		
		public static const HeroSkillData:String = "heroSkillData";
		/**
		 * 防御塔动态数据 
		 */		
		public static const TowerData:String = "towerData";
		/**
		 * 魔法动态数据 
		 */		
		public static const MagicSkillData:String = "magicSkillData";
	}
}