package release.module.kylinFightModule.gameplay.constant
{
	import release.module.kylinFightModule.utili.structure.PointVO;

	public final class GameFightConstant
	{
		//战斗场景高宽
		public static const SCENE_MAP_WIDTH:uint = 760;
		public static const SCENE_MAP_HEIGHT:uint = 650;
		
		//单元格大小，单位像素
		public static const GRID_CELL_SIZE:uint = 30;
		//单元一半大小
		public static const GRID_CELL_HALF_SIZE:uint = GRID_CELL_SIZE / 2;
		
		//格子横向、纵向数量
		public static const SCENE_MAP_CELL_COL_COUNT:uint = Math.ceil(SCENE_MAP_WIDTH / GRID_CELL_SIZE);
		public static const SCENE_MAP_CELL_ROW_COUNT:uint = Math.ceil(SCENE_MAP_HEIGHT / GRID_CELL_SIZE);

		//路宽
		public static const ROAD_WIDTH:uint = 80;
		public static const ROAD_HALF_WIDTH:uint = ROAD_WIDTH / 2;
		public static const ROAD_LINE_GAP:Number = 20;//ROAD_WIDTH / 3;
		public static const HERO_DEFAULT_STAND_CIRCLE_RADIUS:Number = 20;//英雄之终点站立半径的大小

		public static const BUILDING_TOWER_DURATION:uint = 1000;//塔基箭塔时间

		public static const TIME_UINT:uint = 100;//ms 游戏内部基于时间的最小单位

		//出怪间隔时间
		public static const MONSTER_WAVE_DURATION:uint = 20000;

		//战斗帧频
		public static const GAME_FRAME_RATE:uint = 30;
		//每帧消耗时间
		public static const GAME_PER_FRAME_TIME:uint = uint(1000 / GAME_FRAME_RATE);
		
		//战斗画面俯视比例系数
		public static const Y_X_RATIO:Number = 0.7;
		
		//矢量图缩放系数
		public static const MIDDLE_SIZE_BITMAP_SCLE_RATIO:Number = 2;
		public static const BIG_SIZE_BITMAP_SCLE_RATIO:Number = 4;
		
		//士兵集结点半径
		public static const BARRACK_TOWER_SOLDIER_MEETING_RADIUS:Number = 20;
		//X轴方向为士兵朝向，0为X轴朝向1为顺时针Y轴上点，2为顺时针Y轴上的第二个点
		public static var MYBARRACK_SOLDIERS_MEETING_LOCALPOINTS:Vector.<PointVO> = Vector.<PointVO>(
			[
				new PointVO(GameFightConstant.BARRACK_TOWER_SOLDIER_MEETING_RADIUS, 0), 
				new PointVO(0, GameFightConstant.BARRACK_TOWER_SOLDIER_MEETING_RADIUS), 
				new PointVO(0, -GameFightConstant.BARRACK_TOWER_SOLDIER_MEETING_RADIUS)]);
		//士兵三角的各自角度
		public static var MYBARRACK_SOLDIERS_DEGREE:Array = [90,210,330];
		
		//近战单位的搜索范围
		public static const SEARCH_ENEMY_RANGE:uint = 80;
		//当进行远战时，当距离小等于range时切换为近战
		public static const NEAR_ATTACK_RANGE:uint = 25;
		//近战技能的默认使用范围
		public static const NEAR_SKILL_AREA:uint = 40;
		//被召唤者和主人之间的距离超过该值则走向主人
		public static const NEAR_MASTER_DISTANCE:uint = 100;
		
		//生物单位尺寸
		public static const SMALL_ORGANISMELEMENT_BODY_SIZE:uint = 24;
		public static const NORMAL_ORGANISMELEMENT_BODY_SIZE:uint = 48;
		public static const BIG_ORGANISMELEMENT_BODY_SIZE:uint = 100;
		public static const HERO_ORGANISMELEMENT_BODY_SIZE:uint = 30;
		
		//飞行单位离地高度
		public static const FLY_UNIT_OFF_HEIGTH:uint = 24;
		
		//尸体死亡停留时间
		public static const NORMAL_DIE_BODY_STAY_TIME:uint = 3000;
		
		//士兵和英雄在非战斗状态下，每格5000，以每1000的速度10%回血
		public static const NO_FIGHTTING_STAGE_LIFE_RECOVER_TIME:uint = 5000;
		public static const NO_FIGHTTING_STAGE_LIFE_RECOVER_UINT_TIME:uint = 1000;
		
		//爆炸伤害值是子弹伤害值的百分比
		public static const EXPLOSION_HURT_BY_BULLET_PERCENT:Number = 0.7;
		
		//中弹效果消失时间
		public static const STOP_A_BULLET_DISPEAR_TIME:uint = 3000;
		public static const STOP_ARROW_BILLET_ANGLE_INDEXS:Array = [-1, -2, -3, 0, 1, 2, 3];
		public static const STOP_ARROW_BILLET_ANGLE_GAP:uint = 5;
		
		//某些场景小特效播放概率
		public static const PLAY_SCENE_TIP_PROBABILITY:Number = 0.5;
		//小特效高度
		public static const SCENE_TIP_HEIGHT:Number = 20;
		public static const SCENE_TIP_DISAPPEAR_TIME:uint = 500;//消失时间
		public static const SCENE_TIP_RANDOW_ROTATIONS:Array = [-5, 5];//出现时随机角度取值
		
		//progress bar color
		public static const PROGRESS_BAR_COLOR_RED:uint = 0xFF0000;
		public static const PROGRESS_BAR_COLOR_GREEN:uint = 0x35bb00;
		public static const PROGRESS_BAR_COLOR_YELLOW:uint = 0xe4e259;
		public static const PROGRESS_BAR_COLOR_BROWN:uint = 0x767532;
		
		//血槽颜色
		public static const BLOOD_BAR_COLOR_RED:uint = 0x8f4d3b;
		public static const BLOOD_BAR_COLOR_GREEN:uint = 0x77c53b;
		public static const BLOOD_BAR_COLOR_BORDER:uint = 0x6ca63f;
		
		//友军单位焦点颜色
		public static const FRIENDLY_CAMP_FOCUS_COLOR:uint = 0x0066CC;
		//敌军焦点颜色
		public static const ENEMY_CAMP_FOCUS_COLOR:uint = 0xCC0000;
		
		/**
		 * 最大的移动速度，超过就算瞬移
		 */
		public static const MAX_MOVE_SPEED:uint = 100000;
		/**
		 * 需要瞬移的距离
		 */
		public static const MIN_TELEPORT_RANGE:uint = 100;
		/**
		 * 不需要瞬移的范围之内的移动速度
		 */
		public static const NON_TELEPORT_SPEED:Number = 1.0;
	}
}