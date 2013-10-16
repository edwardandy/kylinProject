package mainModule.model.gameData.sheetData.subwave
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;

	/**
	 * 出怪小波次数值表项 
	 * @author Edward
	 * 
	 */
	public interface ISubwaveSheetItem extends IBaseSheetItem
	{
		/**
		 * 出怪总数量 
		 */
		function get monsterCount():int;
		/**
		 * 出怪的怪物id 
		 */
		function get monsterTypeId():uint;
		/**
		 * 有多少条路就给多少个编号
		 * 从零开始算 
		 */
		function get roadIndex():int;
		/**
		 * 小波次在大波次上的出怪时间截点 
		 */
		function get startTime():int;
		/**
		 * 小波次内怪物的平均间隔时间
		 * 必须被小波次时长整除
		 */
		function get interval():int;
		/**
		 * 出场次数
		 * monsterCount/times 必须是1到3之前的实数 
		 */
		function get times():int;
		/**
		 * 跑道类型
		 *  0=随机
		 *	1=只在中间出现
		 */
		function get roadType():int;
	}
}