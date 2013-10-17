package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers
{
	import com.shinezone.towerDefense.fight.vo.PointVO;

	//神秘之塔
	public class MysteryMagicTowerElement extends MagicTowerElement
	{
		public function MysteryMagicTowerElement(typeId:int)
		{
			super(typeId);
			
			//myHasTowerSoldier = false;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			myTowerSoldierSkin.x = 0;
		}
		
		/*override protected function fireToTargetEnemy():void
		{
			onFireAnimationTimeHandler();
			onFireAnimationEndHandler();
		}*/
		
		/*override protected function getGlobalFirePoint():PointVO
		{
			return new PointVO(mySearchedEnemy.x, mySearchedEnemy.y - 100);
		}*/
	}
}