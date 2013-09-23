package release.module.kylinFightModule.model.interfaces
{
	
	import kylin.echo.edward.gameplay.IKylinGameManager;
	
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 战斗地图路径数据 
	 * @author Edward
	 * 
	 */	
	public interface IMapRoadModel extends IKylinGameManager
	{
		/**
		 *  获得一个给定点到该路线终点的距离绝对值或比例
		 * @param ix 定点x坐标
		 * @param iy 定点y坐标
		 * @param ptIdx 开始计算的导航点索引
		 * @param lineIdx 路线索引(左中右)
		 * @param roadIdx 路径索引
		 * @param bRatio 是否返回一个比例
		 * @return 距离绝对值或比例
		 * 
		 */	
		function getDisRatioByPosIndex(ix:int,iy:int,ptIdx:int,lineIdx:int,roadIdx:int,bRatio:Boolean = true):Number;
		/**
		 * 根据地图配置文件设置路径数据 
		 * @param data 地图xml配置文件
		 * 
		 */		
		function updateData(data:XML):void;
		/**
		 * 取得某条路径数据 
		 * @param idx 路径索引
		 * @return 
		 * 
		 */		
		function getMapRoad(idx:int):MapRoadVO;
		/**
		 * 怪物逃跑路径的总数量 
		 * @return 
		 * 
		 */		
		function get roadCount():int;
		/**
		 * 地图的怪物逃跑终点 
		 * @return 
		 * 
		 */		
		function get ptRoadEnd():PointVO;		
	}
}