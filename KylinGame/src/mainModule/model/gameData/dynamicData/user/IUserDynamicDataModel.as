package mainModule.model.gameData.dynamicData.user
{
	/**
	 * 用户动态信息数据 
	 * @author Edward
	 * 
	 */	
	public interface IUserDynamicDataModel
	{
		/**
		 * vip等级
		 */
		function get vipLevel():uint;
		/**
		 * @private
		 */
		//function set vipLevel(value:uint):void;
		/**
		 * 能量上一次恢复时间
		 */
		function get lastEnegyRecoverTime():uint;
		/**
		 * @private
		 */
		//function set lastEnegyRecoverTime(value:uint):void;
		/**
		 * facebook id
		 */
		function get platformId():String;
		/**
		 * @private
		 */
		//function set platformId(value:String):void;
		/**
		 * 性别 1是女 2是男
		 */
		function get sex():int;
		/**
		 * @private
		 */
		//function set sex(value:int):void;
		/**
		 * 全名
		 */
		function get fullName():String;
		/**
		 * @private
		 */
		//function set fullName(value:String):void;
		/**
		 * 名字
		 */
		function get firstName():String;
		/**
		 * @private
		 */
		//function set firstName(value:String):void;
		/**
		 * 当天登录次数 
		 */
		function get todayLoginTimes():int;
		/**
		 * @private
		 */
		//function set todayLoginTimes(value:int):void;
		/**
		 * 连续登录的天数 
		 */
		function get continuouslyLoginDays():int;
		/**
		 * @private
		 */
		//function set continuouslyLoginDays(value:int):void;
		/**
		 * 等级 
		 */
		function get level():int;
		/**
		 * 玩家经验 
		 */	
		function get exp():uint;
		/**
		 * @private
		 */
		//function set exp( value:uint ):void;
		/**
		 * 玩家当前荣誉 
		 */		
		function get honor():uint;
		/**
		 * @private
		 */
		//function set honor( value:uint ):void;
		/**
		 * 背包格子数量
		 */
		function get bagNum():int; 
		/**
		 * @private
		 */
		//function set bagNum(value:int):void; 
		/**
		 * 用户平台币数
		 */
		function get diamonds():uint;
		/**
		 * @private
		 */
		//function set diamonds(value:uint):void;
		/**
		 * 用户金币数
		 */
		function get golds():uint;
		/**
		 * @private
		 */
		//function set golds(value:uint):void;
		/**
		 * 用户当前能量值
		 */
		function get energy():uint;
		/**
		 * @private
		 */
		//function set energy(value:uint):void;
	}
}