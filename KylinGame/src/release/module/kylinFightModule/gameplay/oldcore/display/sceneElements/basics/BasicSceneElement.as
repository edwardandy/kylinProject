package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import io.smash.time.IRenderAble;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.ILifecycleObject;
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.model.sceneElements.ISceneElementsModel;

	/**
	 * 此类为战斗场景元素的基础类，实现状态机的更新机制、对自己添加到显示列表的实现。 
	 * @author Administrator
	 * 
	 */	
	public class BasicSceneElement extends BasicView implements IRenderAble, ILifecycleObject
	{
		[Inject]
		public var tickMgr:TickSynchronizer;
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		[Inject]
		public var sceneElementsModel:ISceneElementsModel;
		
		protected var myElemeCategory:String = null;
		protected var myObjectTypeId:int = -1;
		
		/**
		 * 1. 对当前动画状态的守护, 即为不在到了该状态才播放该状态的动画, 动画是在事件中, 即为在状态改变时预先播放
		 * 2.在当前状态对一些逻辑条件进行判断计算, 并做出是否跳转状态的决定, 不再当前状态播放当前状态的动画,不然这样没法控制
		 * 3. 但是有种情况列外,就有一定CD时间的需要重复播放的动画, 实际在动作发生时要进行一次播放,在该状态下,也会持续播放
		 */		
		private var _behaviorState:int = -1;//这个变量在更改时需要同步动画
		
		//一般不是场景级别元素的对象需要设置，该值
		private var _attach2DettachFromParentDisplayListFunction:Function;
		
		protected var myGroundSceneLayerType:int = -1;//表示无效值
		private var _mySourceGroundSceneLayerType:int = -1;
				
		public function BasicSceneElement()
		{
			super();

			//default
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}

		//元素大分类
		public final function get elemeCategory():String
		{
			return myElemeCategory;
		}
		
		public final function get objectTypeId():int
		{
			return myObjectTypeId;
		}
		
		//场景层次结构
		public final function get groundSceneLayerType():int
		{
			return myGroundSceneLayerType;
		}
		
		override protected function onInitialize():void
		{
			_mySourceGroundSceneLayerType = myGroundSceneLayerType;
		}
		
		public function render(iElapse:int):void 
		{
		}
		
		//IReuseAbleObject Interface============================================
		//由ObjectPoolManager完成生命周期管理, 只能由ObjectPoolManager调用
		public final function notifyLifecycleActive():void
		{
			attach2DettachFromParentDisplayListFunction(true);
			onLifecycleActivate(); 
			
			//同步渲染迭代器
			tickMgr.attachToTicker(this);
		}
		
		public final function notifyLifecycleFreeze():void
		{
			//同步渲染迭代器
			tickMgr.dettachFromTicker(this);
			attach2DettachFromParentDisplayListFunction(false);
			myGroundSceneLayerType = _mySourceGroundSceneLayerType;
			_attach2DettachFromParentDisplayListFunction = null;
			_behaviorState = -1;//重置状态机
			
			onLifecycleFreeze();
		}
		
		//只能由GroundScene调用
		public final function notifySwapSceneElementLayerType(layerType:int):void
		{
			myGroundSceneLayerType = layerType;
		}
		
		public final function setAttach2DettachFromParentDisplayListFunction(value:Function):void
		{
			//参数 BasicSceneElement (this, isAttach)
			_attach2DettachFromParentDisplayListFunction = value;
		}
		
		//销毁自己 慎用！
		public function destorySelf():void
		{
			objPoolMgr.recycleSceneElementObject(this);
		}
		
		//need override some times,  like some effects which is no in the groundscene display.
		private function attach2DettachFromParentDisplayListFunction(isAttach:Boolean):void
		{
			if(_attach2DettachFromParentDisplayListFunction != null)
			{
				_attach2DettachFromParentDisplayListFunction(this, isAttach);
			}
			else
			{
				if(isAttach)
				{
					sceneElementsModel.addSceneElemet(this);	
				}
				else
				{
					sceneElementsModel.removeSceneElemet(this);
				}
			}
		}
		
		//这两个函数非常重要，他是对象中激活和冻结的时机，底层会做一些事情，所以在具体的类中一定要要用super中的实现，不然会引发各种隐藏的问题
		//数据在出现时同步
		protected function onLifecycleActivate():void 
		{
			initStateWhenActive();
		}
		
		protected function initStateWhenActive():void
		{
			
		}

		//显示部分要在冻结时，修改，不然会在出现时，出现视觉bug
		protected function onLifecycleFreeze():void
		{
			clearStateWhenFreeze();
		}
		
		protected function clearStateWhenFreeze(bDie:Boolean = false):void
		{
			
		}
		
		override public function dispose():void
		{
			myElemeCategory = null;
			myObjectTypeId = -1;
			_attach2DettachFromParentDisplayListFunction = null;
			_behaviorState = -1;
			myGroundSceneLayerType = -1;//表示无效值
			_mySourceGroundSceneLayerType = -1;
			super.dispose();
		}

		protected final function get currentBehaviorState():int
		{
			return _behaviorState;
		}

		protected function changeToTargetBehaviorState(behaviorState:int):void
		{
			if(_behaviorState != behaviorState && canChangeBehaviorState(behaviorState))
			{
				_behaviorState = behaviorState;
				onBehaviorStateChanged();
			}
		}
		/**
		 * 是否可以切换到目标状态
		 * @param behaviorState 目标状态
		 * @return 
		 * 
		 */		
		protected function canChangeBehaviorState(behaviorState:int):Boolean
		{
			return true;
		}

		protected function onBehaviorStateChanged():void
		{
		}
		
		protected function getDefaultSoundString():String
		{
			return null;
		}
		
		protected function getSoundId(field:String,idx:int=0,soundString:String=null):String
		{
			var arrSounds:Array = getSoundIdArray(field,soundString);
			if(!arrSounds || 0 == arrSounds.length || idx>=arrSounds.length)
				return null;
			if(idx < 0)
				idx = GameMathUtil.randomIndexByLength(arrSounds.length);
			return arrSounds[idx];	
		}
		
		protected function getSoundIdArray(field:String,soundString:String=null):Array
		{
			soundString ||= getDefaultSoundString();
			return [];//GameStringUtil.deserializeSoundString(field,soundString);
		}
		
		protected function playSound(id:String):void
		{
			//if(id)
				//TowerMediaPlayer.getInstance().playEffect(id);
		}
	}
}