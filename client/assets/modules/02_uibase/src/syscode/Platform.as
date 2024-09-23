package syscode {
		import flash.display.MovieClip;
		
		public class Platform {
				public static var silentactivate:Boolean = false;
				
				public function Platform() {
						super();
				}
				
				public static function Init(flamc:MovieClip) : void {
				}
				
				public static function ExitApplication() : void {
				}
				
				public static function AddBackHandler(handler:Function) : void {
				}
				
				public static function RemoveBackHandler(handler:Function) : void {
				}
				
				public static function OnBackButtonPressed(event:Object) : void {
				}
				
				public static function LoadPersistentData(key:String) : Object {
						return null;
				}
				
				public static function SavePersistentData(key:String, value:Object) : Boolean {
						return false;
				}
				
				public static function FacebookLogin(callbackFunc:Function) : void {
				}
				
				public static function FacebookLogout(callbackFunc:Function) : void {
				}
				
				public static function FacebookInvite(playerID:String, title:String, message:String, callbackFunc:Function) : void {
				}
				
				public static function InitInterstitial(publisher_id:String, ad_unit_id:String) : Boolean {
						return false;
				}
				
				public static function LoadInterstitial(readyFunc:Function, testAd:Boolean) : Boolean {
						return false;
				}
				
				public static function ShowInterstitial(readyFunc:Function, handleDeActivate:Boolean) : void {
				}
				
				public static function LoadAndShowInterstitial(readyFunc:Function, readyParams:Array = null) : void {
				}
				
				public static function QueryMarketItems(eldorado:Boolean, callbackFunc:Function) : void {
				}
				
				public static function PurchaseMarketItems(itemId:*, payload:String, callbackFunc:Function) : void {
				}
				
				public static function QueryMarketInventory(callbackFunc:Function) : void {
				}
				
				public static function ConsumeInventoryItem(itemId:String) : void {
				}
				
				public static function CreditMarketItem(item:Object, callbackFunc:Function) : void {
				}
				
				public static function CheckMarketInventory(items:Array) : void {
				}
				
				public static function VibrateDevice(duration:Number = 100) : void {
				}
				
				public static function CreateStageText(x:Number, y:Number, w:Number, h:Number, multiline:Boolean, size:Number) : Object {
						return null;
				}
				
				public static function SetStageTextPos(tf:*, x:Number, y:Number) : * {
				}
				
				public static function FocusStageText(tf:*) : * {
				}
				
				public static function SelectEndStageText(tf:Object) : * {
				}
				
				public static function DisposeStageText(tf:Object) : void {
				}
				
				public static function ShowWebView(url:String) : void {
				}
		}
}

