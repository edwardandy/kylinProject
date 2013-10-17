package release.module.kylinFightModule.model.sceneElements
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;

	/**
	 * 战斗场景显示元素管理器 
	 * @author Edward
	 * 
	 */
	public interface ISceneElementsModel extends IDisposeObject
	{
		/**
		 * 战斗开始前的初始化，包括怪物路径形状的描绘，生成路径终点动画以及初始化场景元素(塔基，英雄) 
		 * 
		 */		
		function initBeforeFightStart():void;
		/**
		 * 添加场景元素 
		 * @param e
		 * 
		 */		
		function addSceneElemet(e:BasicSceneElement):void;
		/**
		 * 移除场景元素 
		 * @param e
		 * 
		 */		
		function removeSceneElemet(e:BasicSceneElement):void;
		/**
		 * 销毁所有场景元素 
		 * 
		 */		
		function destoryAllSceneElements():void;
		/**
		 * 交换场景元素的显示层次(某些特效在动画的前一阶段在顶层，后一阶段在底层) 
		 * @param e
		 * @param toGroundSceneLayerType
		 * 
		 */		
		function swapSceneElementLayerType(e:BasicSceneElement, toGroundSceneLayerType:int):void;
		/**
		 * 测试坐标是否在逃跑路径上 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		function hisTestMapRoad(x:Number, y:Number):Boolean;
	}
}