package release.module.kylinFightModule.gameplay.oldcore.display
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public interface IMonsterMarchImplementor
	{
		function marchMonster(m:BasicMonsterElement, pathPoints:Vector.<PointVO>, roadIndex:int, lineIndex:int):void;
	}
}