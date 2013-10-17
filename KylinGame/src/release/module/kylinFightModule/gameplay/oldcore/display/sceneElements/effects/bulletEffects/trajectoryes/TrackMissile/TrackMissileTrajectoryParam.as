package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.trajectoryes.TrackMissile
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IPositionUnit;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	public class TrackMissileTrajectoryParam
	{
		/**
		 * 速度
		 */
		public var speedPerFrame:Number;
		/**
		 * 直线飞向目标时的速度
		 */
		public var speedToTarget:Number;
		/**
		 * 向上发射到开始转向的垂直距离
		 */
		public var turnY:Number;
		/**
		 * 圆形轨迹的中心
		 */
		public var center:PointVO = new PointVO;
		/**
		 * 圆形轨迹的半径
		 */
		public var radius:int;
		/**
		 * 目标
		 */
		public var target:BasicOrganismElement;
		
		public function TrackMissileTrajectoryParam()
		{
		}
	}
}