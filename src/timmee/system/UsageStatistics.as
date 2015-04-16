package timmee.system
{
	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Capabilities;
	
	import timmee.core.ApplicationSettings;
	import timmee.core.Constants;
	
	
	/**
	 * Google Analytics Measurement Protocol
	 * @guide https://developers.google.com/analytics/devguides/collection/protocol/v1/
	 */
	
	public class UsageStatistics extends EventDispatcher
	{
		public static const ACTION_APP_LAUNCHED:String = "Application launched";
		public static const ACTION_APP_LAUNCHED_FIRST_TIME:String = "Application launched first time";
		
		public static const CATEGORY_DEV_VERSION:String = "Development version";
		
		
		private var app:NativeApplication;
		private var initialized:Boolean;
		
		private var req:URLRequest;
		private var loader:URLLoader;
		
		private var appTrackingPayload:String;
		private var systemInfoPayLoad:String;
		
		
		public function UsageStatistics()
		{
			super(null)
		}
		
		
		public function initielize(app:NativeApplication):void
		{
			if (!initialized)
			{
				this.app = app;
				
				req = new URLRequest(Constants.ANALITYCS_TRACKING_URL);
				req.method = URLRequestMethod.POST;
				
				loader = new URLLoader();
				
				initialized = true;
			}
		}
		
		
		public function dispose():void
		{
			if (initialized)
			{
				initialized = false;
				
				appTrackingPayload = null;
				systemInfoPayLoad = null;
				
				try
				{
					loader.close();
				} catch (error:Error) { }
				loader = null;
				
				req = null;
				
				app = null;
			}
		}
		
		
		public function track(action:String, category:String = null):void
		{
			if (Capabilities.isDebugger) return;
			
			if (action === ACTION_APP_LAUNCHED && ApplicationSettings.appRunningFirstTime)
			{
				action = ACTION_APP_LAUNCHED_FIRST_TIME;
			}
			
			var payload:String = constructTrackingPayload(action, category);
			req.data = payload
			
			loader.load(req);
		}
		
		
		private function constructTrackingPayload(action:String, category:String):String
		{
			var protocolVersion:String = "v=1";
			var trackingID:String = "tid=" + Constants.ANALYTICS_TRACKING_CODE;
			var clientID:String = "cid=" + ApplicationSettings.UUID;
			var hitType:String = "t=event";
			var eventCategory:String = category ? "ec=" + escape(category) : "ec=None";
			var eventAction:String = "ea=" + escape(action);
			
			var payload:Vector.<String> = Vector.<String>([
				protocolVersion,
				trackingID,
				clientID,
				hitType,
				eventCategory,
				eventAction,
				(appTrackingPayload || getAppTrackingPayload()),
				(systemInfoPayLoad || getSystemInfoPayload())
			]);
			
			return payload.join("&");
		}
		
		private function getAppTrackingPayload():String
		{
			var appXML:XML = app.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			
			var appID:String = appXML.ns::id[0];
			var appName:String = appXML.ns::filename[0];
			var appVersion:String = appXML.ns::versionNumber[0];
			
			var applicationID:String = "aid=" + escape(appID);
			var applicationName:String = "an=" + escape(appName);
			var applicationVersion:String = "av=" + escape(appVersion);
			
			var payload:Vector.<String> = Vector.<String>([
				applicationID,
				applicationName,
				applicationVersion
			]);
			
			appTrackingPayload = payload.join("&");
			return appTrackingPayload;
		}
		
		private function getSystemInfoPayload():String
		{
			var flashVersion:String = "fl=" + escape(Capabilities.version);
			var userAgent:String = "ua=" + escape(Capabilities.os);
			var userLanguage:String = "ul=" + escape(Capabilities.language);
			var screenResolution:String = "sr=" + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
			
			var payload:Vector.<String> = Vector.<String>([
				flashVersion,
				userAgent,
				userLanguage,
				
				screenResolution
			]);
			
			systemInfoPayLoad = payload.join("&");
			return systemInfoPayLoad;
		}
	}
}