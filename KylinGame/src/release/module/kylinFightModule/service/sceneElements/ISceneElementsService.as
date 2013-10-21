package release.module.kylinFightModule.service.sceneElements
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IPositionUnit;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 场景管理提供的功能 
	 * @author Edward
	 * 
	 */	
	public interface ISceneElementsService extends IFightLifecycle
	{
		/**
		 * 获取当前场景敌方阵营的数量
		 * @return 
		 * 
		 */		
		function getAllEnemyCampOrganismElementsCount():int;
		/**
		 * 获取当前所有激活且生存的敌人 
		 * @return 
		 * 
		 */		
		function getAllAliveEnemys():Vector.<BasicMonsterElement>;
		/**
		 * 杀死所有的敌人 
		 * @return 
		 * 
		 */		
		function killAllEnemies():Boolean;
		/**
		 * 无极幻境给所有防御塔增加攻击力buff
		 * @param atkPct
		 * 
		 */		
		function addAllTowerEndlessAtkBuff(atkPct:Number):void;
		/**
		 * 无极幻境给所有防御塔增加攻击速度buff
		 * @param atkSpdPct
		 * 
		 */		
		function addAllTowerEndlessAtkSpdBuff(atkSpdPct:int):void;
		/**
		 * 获得最近的单位
		 * @param orgX
		 * @param orgY
		 * @param vecUnits
		 * @return 
		 * 
		 */		
		function getNearestUnit(orgX:int,orgY:int,vecUnits:Vector.<IPositionUnit>):IPositionUnit;
		/**
		 * 范围搜索, 是能搜到隐身怪的
		 * @param centerX
		 * @param centerY
		 * @param searchArea
		 * @param searchCamp
		 * @param necessarySearchConditionFilter
		 * @param ignoreIsAlive
		 * @param count
		 * @return 
		 * 
		 */
		function searchOrganismElementsBySearchArea(centerX:Number, centerY:Number, searchArea:int,searchCamp:int,
													necessarySearchConditionFilter:Function = null, 
													ignoreIsAlive:Boolean = false,count:int = 0):Vector.<BasicOrganismElement>;
		/**
		 * 搜索一定范围内的防御塔 
		 * @param centerX
		 * @param centerY
		 * @param searchArea
		 * @param count
		 * @param necessarySearchConditionFilter
		 * @return 
		 * 
		 */		
		function searchTowersBySearchArea(centerX:Number, centerY:Number, searchArea:int,count:int = 0,
										  necessarySearchConditionFilter:Function = null):Vector.<BasicTowerElement>;
		/**
		 * 通过范围搜索地表特效 
		 * @param centerX
		 * @param centerY
		 * @param searchArea
		 * @param count
		 * @param necessarySearchConditionFilter
		 * @return 
		 * 
		 */		
		function searchGroundEffsBySearchArea(centerX:Number, centerY:Number, searchArea:int,count:int = 0
											  ,necessarySearchConditionFilter:Function = null):Vector.<BasicGroundEffect>;
		/**
		 *  个体普通搜索是搜不到隐身的怪的 
		 * @param centerX
		 * @param centerY
		 * @param searchArea
		 * @param searchCamp
		 * @param necessarySearchConditionFilter
		 * @param ignoreIsAlive
		 * @return 
		 * 
		 */		
		function searchOrganismElementEnemy(centerX:Number, centerY:Number, searchArea:int,searchCamp:int,
												   necessarySearchConditionFilter:Function = null,ignoreIsAlive:Boolean = false):BasicOrganismElement;
		/**
		 * 通过id查找英雄 
		 * @param heroTypeId 英雄id
		 * @return 
		 * 
		 */		
		function findHeroElementByHeroTypeId(heroTypeId:int):HeroElement;
		/**
		 * 搜索boss召唤的恶魔之门 
		 * @param ix
		 * @param iy
		 * @param area
		 * @return 
		 * 
		 */		
		function searchSummonDoorByArea(ix:int,iy:int,area:int):SummonDemonDoorSkillRes;
		/**
		 * 关闭所有的恶魔之门 
		 * 
		 */		
		function disappearAllSummonDoor():void;
		/**
		 * 计算某条路径上的随机点 
		 * @param roadLineIndex
		 * @param arrIdxes
		 * @param minLineIdx
		 * @param maxLineIdx
		 * @param minDistance
		 * @return 
		 * 
		 */		
		function getCurrentSceneRandomRoadPointByCurrentRoadsData(roadLineIndex:int = -1,arrIdxes:Array = null
																  ,minLineIdx:int = 0,maxLineIdx:int = 0,minDistance:int = 0):PointVO;
		/**
		 * 获得路径上的多个随机点 
		 * @param count
		 * @param arrPtIdxes
		 * @param minLineIdx
		 * @param maxLineIdx
		 * @param minDistance
		 * @param bIsSummonDoor
		 * @return 
		 * 
		 */		
		function getSomeRandomRoadPoints(count:int,arrPtIdxes:Array = null,minLineIdx:int = 0
										 ,maxLineIdx:int = 0,minDistance:int = 0,bIsSummonDoor:Boolean = false):Vector.<PointVO>;
	}
}