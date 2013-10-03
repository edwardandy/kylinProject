package mainModule.model.gameConstAndVar
{
	/**
	 * js传给flash的变量 
	 * @author Edward
	 * 
	 */	
	public final class FlashVarsModel
	{
		/**
		 * 资源发布的版本，用作主程序文件和资源配置文件的后缀进行加载 
		 */		
		public var RES_VER:int;
		/**
		 * 程序语言版本 
		 */		
		public var LAN:String = "us";
		/**
		 * PHP Gateway
		 */
		public var PHP_GATEWAY:String = "http://dev-fb-td.shinezoneapp.com:1078/dev_branch/v20130228/j7/j7.php?";		
		/**
		 * 签名请求 
		 * 跟在GataWay后面
		 */
		//gaojian
		public var SIGNED_REQUEST:String = "5kkfCI5tqyDPsKym4YMaJwEPBfkk57DQDeEfueazWas.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImV4cGlyZXMiOjEzNTk3ODg0MDAsImlzc3VlZF9hdCI6MTM1OTc4MTQ3NSwib2F1dGhfdG9rZW4iOiJBQUFCblkyWVVLZFlCQUdZanVwb3paQUZMcER4c0FpVEo1eVpCYTFoZlNZZTB0TWpKRUNWdUJ2NzJJWHdIaG8wUjJDT2FlUFBiRGlGWkNtMWltSW9aQ095Y3E2c3Vid0tWQnBtRVpDSXB2ckxiQ2lEdTM3S1VGIiwidXNlciI6eyJjb3VudHJ5IjoiaGsiLCJsb2NhbGUiOiJ6aF9DTiIsImFnZSI6eyJtaW4iOjIxfX0sInVzZXJfaWQiOiIxMDAwMDMzNDM0MzM3MjQifQ";
		/**
		 * Flash端资源域 路径
		 * http://dev-tf.shinezoneapp.com/tf_dev_ljs/flash/ 
		 * 如果是本地测试，那么写空字符串
		 */
		public var FLASH_PATH:String = "";
		/**
		 * 缓存Facebook ID
		 * 
		 */
		public var FACEBOOK_ID:String = "100001970795905";
		/**
		 * TOKEN 用于验证玩家
		 * 需要发送至SFS验证
		 */
		public var TOKEN:String = "218d681960530e8cba3bcc6af2236377";
		/**
		 * URL
		 */
		public var URL:String = "";
		
		/**
		 * DomainUrl
		 */
		public var DomainUrl:String = "";
		
		/**
		 * 测试参数
		 */
		public var TEST_PARAMS:String = "";
		
		/**
		 * canvasname=towerdefensedev
		 */
		public var CANVAS_NAME:String = "";
		/**
		 * 用于读取好友信息令牌 
		 */		
		public var ACCESS_TOKEN:String = "";
		/**
		 * 开场动画是否播放
		 */		
		public var PLAY_ANIM:int = 1;
	}
}