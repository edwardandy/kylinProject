package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	/**
	 *  
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public interface IFocusTargetInfo
	{
		/**
		 * 类型
		 * 0英雄	1士兵	 2怪	 3攻击塔	4防御塔
		 * 参见FocusTargetType类常量定义
		 * @return 
		 * 
		 */		
		function get type():int;
		
		/**
		 * 目标名字 
		 * @return 
		 * 
		 */		
		function get targetName():String;
		
		/**
		 * 图标资源ID 
		 * @return 
		 * 
		 */		
		function get resourceID():int;
		
		/**
		 * 当前生命 
		 * @return 
		 * 
		 */		
		function get curLife():int;
		
		/**
		 * 最大生命 
		 * （若是防御塔，则是所产士兵的最大生命）
		 * @return 
		 * 
		 */		
		function get maxLife():int;
		
		/**
		 * 最小攻击 
		 * @return 
		 * 
		 */		
		function get minAttack():int;
		
		/**
		 * 最大攻击 
		 * @return 
		 * 
		 */		
		function get maxAttack():int;
		
		/**
		 * 攻击类型
		 * true		魔法
		 * false	物理 
		 * @return 
		 * 
		 */		
		function get attackType():Boolean;
		
		/**
		 * 护罩 
		 * @return 
		 * 
		 */		
		function get defense():int;
		
		/**
		 * 护罩类型 
		 * true		魔法
		 * false	物理 
		 * @return 
		 * 
		 */		
		function get defenseType():Boolean;
		
		/**
		 * 伤害 
		 * @return 
		 * 
		 */		
		function get hurt():int;
		
		/**
		 * 攻击范围 
		 * @return 
		 * 
		 */		
		function get attackArea():uint;
		
		/**
		 * 攻击间隔 
		 * @return 
		 * 
		 */		
		function get attackGap():int;
		
		/**
		 * 重生时间 
		 * @return 
		 * 
		 */		
		function get rebirthTime():int;
	}
}