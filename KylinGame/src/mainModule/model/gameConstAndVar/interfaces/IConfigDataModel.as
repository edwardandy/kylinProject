package mainModule.model.gameConstAndVar.interfaces
{
	public interface IConfigDataModel
	{
		/**
		 * panel alpha velocity
		 */
		function get nPanelAlphaVelocity():Number;
		/**
		 * panel max scale
		 */
		function get nPanelMaxScale():Number;
		/**
		 * 面板移动速度
		 */
		function get nPanelScaleVelocity():Number;
		/**
		 * 战斗中可以购买并使用的道具 
		 * @return 
		 * 
		 */		
		function get arrItemIdsInFight():Array;
	}
}