package mainModule.service.gameDataServices.helpServices
{
	/**
	 * 关卡相关逻辑方法
	 * @author Edward
	 * 
	 */	
	public interface ITollgateService
	{
		/**
		 * 防御塔是否可以在该关卡中建造 
		 * @param tollgateId 关卡id
		 * @param towerId 防御塔id
		 * @return 
		 * 
		 */		
		function canTowerBuildInTollgate(tollgateId:uint,towerId:uint):Boolean;
	}
}