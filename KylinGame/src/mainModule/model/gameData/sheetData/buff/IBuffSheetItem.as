package mainModule.model.gameData.sheetData.buff
{
	import flash.geom.Point;
	
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;

	/**
	 * buff数值表项 
	 * @author Edward
	 * 
	 */
	public interface IBuffSheetItem extends IBaseSheetItem
	{
		/**
		 *  显示位置的相对点
		 * 	0表示在目标的头上显示
		 *	1表示在目标的脚下显示
		 *	2表示在身体中间
		 */
		function get positionType():int;
		/**
		 * 附加资源
		 */
		function get otherResIds():String;
		/**
		 * 资源id，如果不为0，则使用该id对应的buff的资源
		 * 否则使用自己id所对应的资源
		 */
		function get resId():int;
		/**
		 *覆盖类别
		 *旧的buff会被新的与他同类的buff覆盖掉
		 *不填或者填0表示buff不会被覆盖也不会覆盖别的buff
		 *从数字1开始，相同数字的buff表示同类。
		 **/
		function get overType():int;
		/**
		 * 偏移位置
		 */
		function get ptOffset():Point;
		/**
		 *属性格式
		 * ["buffid","life","duration"]
		 */
		function get arrModes():Array;
		/**
		 *	该buf所能影响的boss列表
		 * 	[bossid1,bossid2]
		 */
		function get arrEffectBosses():Array;
	}
}