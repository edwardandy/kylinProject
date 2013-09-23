package mainModule.model.gameData.sheetData.subwave
{
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;
	/**
	 * 出怪小波次数值表项 
	 * @author Edward
	 * 
	 */
	public class SubwaveSheetItem extends BaseDescSheetItem
	{
		/**
		 * 跑道类型
		 *  0=随机
		 *	1=只在中间出现
		 */		
		public var roadType:int;
		/**
		 * 出场次数
		 * monsterCount/times 必须是1到3之前的实数 
		 */		
		public var times:int;
		/**
		 * 小波次内怪物的平均间隔时间
		 * 必须被小波次时长整除
		 */		
		public var interval:int;
		/**
		 * 小波次在大波次上的出怪时间截点 
		 */		
		public var startTime:int;
		/**
		 * 有多少条路就给多少个编号
		 * 从零开始算 
		 */		
		public var roadIndex:int;
		/**
		 * 出怪的怪物id 
		 */		
		public var monsterTypeId:uint;
		/**
		 * 出怪总数量 
		 */		
		public var monsterCount:int;
		
		public function SubwaveSheetItem()
		{
			super();
		}
	}
}