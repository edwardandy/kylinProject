package release.module.kylinFightModule.model.roads
{		
	import release.module.kylinFightModule.utili.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	import utili.behavior.interfaces.IDispose;

	/**
	 * 每条路径都有3条平行的路线
	 * @author Edward
	 * 
	 */	
	public class MapLineVO implements IDispose
	{
		/**
		 * 该条路线的索引: 0:左边;1:中间;2:右边 
		 */		
		public var lineIndex:int = 0;
		private var _points:Vector.<PointVO>;
		private var _vecDistance:Vector.<int>;
		private var _totalDis:int = 0;
		
		public function MapLineVO()
		{
			//_points = new Vector.<PointVO>;
			_vecDistance = new Vector.<int>;
		}
		
		/**
		 * 导航点数组
		 */
		public function get points():Vector.<PointVO>
		{
			return _points;
		}
		/**
		 * @private
		 */		
		public function set points(value:Vector.<PointVO>):void
		{
			_points = value;
		}
		/**
		 * 根据导航点生成各点之间的距离数组并计算该路线的总长度 
		 * 
		 */		
		public function genDistance():void
		{
			_vecDistance.length = 0;
			_totalDis = 0;
			var dis:int;
			for(var i:int = 0;i<points.length-1;++i)
			{
				dis = GameMathUtil.distance(points[i].x,points[i].y,points[i+1].x,points[i+1].y);
				_vecDistance.push(dis);
				_totalDis += dis;
			}
		}
		/**
		 *  获得一个给定点到该路线终点的距离绝对值或比例
		 * @param ix 定点x坐标
		 * @param iy 定点y坐标
		 * @param ptIdx 开始计算的导航点索引
		 * @param bRatio 是否返回一个比例
		 * @return 距离绝对值或比例
		 * 
		 */		
		public function getDisRatioByPtAndIndex(ix:int,iy:int,ptIdx:int,bRatio:Boolean = true):Number
		{
			if(ptIdx<0 || ptIdx>=points.length)
				throw new Error("LineVO::getDisRatioByPtAndIndex error idx");
			
			var dis:Number;
			if(0 == ptIdx)
				return 1;
			
			dis = GameMathUtil.distance(ix,iy,points[ptIdx].x,points[ptIdx].y);
			
			if(ptIdx != points.length-1)
			{
				dis += getRestDisSumByIndex(ptIdx);
			}
			
			if(bRatio)
				return dis/_totalDis;
			else
				return dis;
		}
		
		private function getRestDisSumByIndex(idx:int):int
		{
			var total:int = 0;
			for(var i:int = idx;i<_vecDistance.length;++i)
			{
				total += _vecDistance[i];
			}
			return total;
		}
		
		public function dispose():void
		{
			if(_points)
				_points.length = 0;
			_points = null;
			if(_vecDistance)
				_vecDistance.length = 0;
			_vecDistance = null;
			_totalDis = 0;
		}
	}
}