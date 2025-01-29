package syscode
{
    import com.greensock.TweenMax;

    import flash.display.MovieClip;
    import flash.geom.Rectangle;
    import flash.media.SoundMixer;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.text.TextField;
    import flash.text.TextFieldType;

    public class Platform
    {
        public static var silentactivate:Boolean = false;
        private static var reconnect:Boolean = false;
        private static var deactivated:Boolean = false;
        private static var showactivate:Boolean = false;
        private static var lastscreen:String = "";
        private static var backhandlers:Array = [];
        private static var flamc:MovieClip = null;

        public static function Init(flamc:MovieClip):void
        {
            Platform.flamc = flamc;
            Platform.flamc.stage.addEventListener("BACKBUTTONPRESSED", Platform.OnBackButtonPressed);
            Platform.flamc.stage.addEventListener("ACTIVATE", Platform.OnActivate);
            Platform.flamc.stage.addEventListener("DEACTIVATE", Platform.OnDeactivate);
            Platform.flamc.stage.addEventListener("PURCHASE_SUCCESS", Platform.OnPurchaseSuccess);
        }

        public static function ExitApplication():void
        {
            trace("ExitApplication");
            if (Config.android && Boolean(Platform.flamc))
            {
                trace("Platform.ExitApplication");
                Platform.flamc.OnExitApplication(null);
            }
        }

        public static function AddBackHandler(handler:Function):void
        {
            Platform.backhandlers.push(handler);
        }

        public static function RemoveBackHandler(handler:Function):void
        {
            var i:int = 0;
            while (i < Platform.backhandlers.length)
            {
                if (Platform.backhandlers[i] === handler)
                {
                    Platform.backhandlers.splice(i, 1);
                }
                else
                {
                    i++;
                }
            }
        }

        public static function OnBackButtonPressed(event:Object):void
        {
            var i:int = 0;
            var mw:Object = null;
            if (Platform.backhandlers.length > 0)
            {
                i = int(Platform.backhandlers.length - 1);
                Platform.backhandlers[i](event);
            }
            else if (Config.android && WinMgr.initialized)
            {
                mw = Modules.GetClass("uibase", "uibase.MessageWin");
                if (mw)
                {
                    mw.AskYesNo(Lang.Get("quit_app"), Lang.Get("are_you_sure_quit_the_game"), Lang.Get("yes"), Lang.Get("no"), OnCloseApplication);
                }
            }
        }

        public static function LoadPersistentData(key:String):Object
        {
            if (Config.android && Boolean(Platform.flamc))
            {
                return Platform.flamc.LoadPersistentData(key);
            }
            if (Config.ios && Boolean(Platform.flamc))
            {
                return Platform.flamc.LoadPersistentData(key);
            }
            return null;
        }

        public static function SavePersistentData(key:String, value:Object):Boolean
        {
            if (Config.android && Boolean(Platform.flamc))
            {
                return Platform.flamc.SavePersistentData(key, value);
            }
            if (Config.ios && Boolean(Platform.flamc))
            {
                return Platform.flamc.SavePersistentData(key, value);
            }
            return false;
        }

        public static function FacebookLogin(callbackFunc:Function):void
        {
            trace("FacebookLogin");
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.flamc.FacebookLogin(Config.facebook_appid, callbackFunc);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.flamc.FacebookLogin(Config.facebook_appid, callbackFunc);
            }
            else
            {
                callbackFunc(null);
            }
        }

        public static function FacebookLogout(callbackFunc:Function):void
        {
            trace("FacebookLogout");
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.flamc.FacebookLogout(Config.facebook_appurl, callbackFunc);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.flamc.FacebookLogout(Config.facebook_appurl, callbackFunc);
            }
            else
            {
                callbackFunc(null);
            }
        }

        public static function FacebookInvite(playerID:String, title:String, message:String, callbackFunc:Function):void
        {
            trace("FacebookInvite");
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.flamc.FacebookInvite(playerID, title, message, callbackFunc);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.flamc.FacebookInvite(playerID, title, message, callbackFunc);
            }
            else
            {
                callbackFunc(null);
            }
        }

        public static function InitInterstitial(publisher_id:String, ad_unit_id:String):Boolean
        {
            if (Config.android && Boolean(Platform.flamc))
            {
                return Platform.flamc.CheckAdMobSupport(publisher_id, ad_unit_id);
            }
            return false;
        }

        public static function LoadInterstitial(readyFunc:Function, testAd:Boolean):Boolean
        {
            if (Config.android && Boolean(Platform.flamc))
            {
                return Platform.flamc.LoadInterstitial(readyFunc, testAd);
            }
            if (Boolean(readyFunc))
            {
                readyFunc(false);
            }
            return false;
        }

        public static function ShowWebView(url:String):void
        {
        }

        public static function ShowInterstitial(readyFunc:Function, handleDeActivate:Boolean):void
        {
            var callback:Function = null;
            callback = function():void
            {
                if (Boolean(readyFunc))
                {
                    readyFunc();
                }
                if (handleDeActivate)
                {
                    Platform.silentactivate = false;
                }
            };
            if (Config.android && Boolean(Platform.flamc))
            {
                if (handleDeActivate)
                {
                    Platform.silentactivate = true;
                }
                Platform.flamc.ShowInterstitial(callback);
            }
            else if (Boolean(readyFunc))
            {
                readyFunc();
            }
        }

        public static function LoadAndShowInterstitial(readyFunc:Function, readyParams:Array = null):void
        {
            var InterstitialReady:Function = null;
            var InterstitialOver:Function = null;
            InterstitialReady = function(enabled:Boolean):void
            {
                trace("Platform.LoadAndShowInterstitial.InterstitialReady");
                UIBase.HideWaitAnim();
                if (enabled)
                {
                    trace("Platform.LoadAndShowInterstitial.InterstitialReady:enabled");
                    Platform.silentactivate = true;
                    Platform.ShowInterstitial(InterstitialOver, false);
                }
                else
                {
                    trace("Platform.LoadAndShowInterstitial.InterstitialReady:disabled ready");
                    if (Boolean(readyFunc))
                    {
                        readyFunc.apply(null, readyParams);
                    }
                }
            };
            InterstitialOver = function():void
            {
                trace("Platform.LoadAndShowInterstitial.InterstitialOver");
                if (Boolean(readyFunc))
                {
                    readyFunc.apply(null, readyParams);
                }
                if (!Platform.deactivated)
                {
                    Platform.silentactivate = false;
                }
            };
            trace("Platform.LoadAndShowInterstitial");
            if (Platform.LoadInterstitial(InterstitialReady, false))
            {
                trace("Platform.LoadAndShowInterstitial:ShowWaitAnim");
                UIBase.ShowWaitAnim();
            }
            else
            {
                trace("Platform.LoadAndShowInterstitial:instant ready");
                UIBase.HideWaitAnim();
                Platform.silentactivate = true;
                Platform.ShowInterstitial(InterstitialOver, false);
            }
        }

        public static function QueryMarketItems(eldorado:Boolean, callbackFunc:Function):void
        {
            trace("Platform.QueryMarketItems");
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.flamc.QueryBillingItems(eldorado, callbackFunc);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.flamc.QueryBillingItems(eldorado, callbackFunc);
            }
            else if (Boolean(callbackFunc))
            {
                callbackFunc();
            }
        }

        public static function PurchaseMarketItems(itemId:*, payload:String, callbackFunc:Function):void
        {
            var OnVoxPayment:Function = null;
            var OnXsollaPayment:Function = null;
            var callback:Function = null;
            OnVoxPayment = function(jsq:Object, itemId:*, payload:*, callbackFunc:*):void
            {
                DBG.Trace("OnVoxPayment:", jsq);
                var request2:URLRequest = new URLRequest(Config.extdatauribase + "ext/hu/payplaza.php");
                var vars2:URLVariables = new URLVariables();
                vars2.cmd = "start";
                vars2.pack = Util.StringVal(itemId);
                vars2.payment_stoc = jsq.data.payment_stoc;
                request2.method = URLRequestMethod.GET;
                request2.data = vars2;
                navigateToURL(request2, "_blank");
            };
            OnXsollaPayment = function(jsq:Object, itemId:*, payload:*, callbackFunc:*):void
            {
                DBG.Trace("OnXsollaPayment:", jsq);
                var request2:URLRequest = new URLRequest(Config.extdatauribase + "ext/common/xsolla_popup.php");
                var vars2:URLVariables = new URLVariables();
                vars2.request = Util.StringVal(itemId);
                vars2.payment_stoc = jsq.data.payment_stoc;
                request2.method = URLRequestMethod.GET;
                request2.data = vars2;
                navigateToURL(request2, "_blank");
            };
            callback = function(item:Object):void
            {
                if (item)
                {
                    CreditMarketItem(item, callbackFunc);
                }
                else if (callbackFunc != null)
                {
                    callbackFunc(false);
                }
                Platform.silentactivate = false;
            };
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.silentactivate = true;
                Platform.flamc.MakePlayPurchase(Util.StringVal(itemId), payload, callback);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.silentactivate = true;
                Platform.flamc.MakePlayPurchase(Util.StringVal(itemId), payload, callback);
            }
            else if (Config.loginsystem == "YAHO" && Config.pagemode == "CANVAS" && Util.StringVal(itemId.params.real_currency) == "USD")
            {
                Platform.silentactivate = true;
                Util.ExternalCall("YahooPayment", itemId.params);
            }
            else if (Config.desktop)
            {
                Platform.silentactivate = true;
                if (Config.siteid == "hu")
                {
                    JsQuery.Load(OnVoxPayment, [itemId, payload, callbackFunc], "ext/common/xsolla_session.php?" + Sys.FormatGetParamsStoc(null));
                }
                else
                {
                    JsQuery.Load(OnXsollaPayment, [itemId, payload, callbackFunc], "ext/common/xsolla_session.php?" + Sys.FormatGetParamsStoc(null));
                }
            }
            else
            {
                Platform.silentactivate = true;
                Util.ExternalCall("StartPayment", Util.StringVal(itemId), payload);
            }
        }

        public static function QueryMarketInventory(callbackFunc:Function):void
        {
            trace("Platform.QueryMarketInventory");
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.flamc.QueryPlayInventory(callbackFunc);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.flamc.CheckPurchasedItem();
            }
            else if (Boolean(callbackFunc))
            {
                callbackFunc(null);
            }
        }

        public static function ConsumeInventoryItem(itemId:String):void
        {
            trace("Platform.ConsumeInventoryItem:", itemId);
            if (Config.android && Boolean(Platform.flamc))
            {
                Platform.flamc.ConsumeInventoryItem(itemId);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                Platform.flamc.manualFinishTransaction(itemId);
            }
        }

        public static function CreditMarketItem(item:Object, callbackFunc:Function):void
        {
            var obj:Object = null;
            if (Config.android && Boolean(Platform.flamc))
            {
                obj = {
                        "cmd": "purchase",
                        "data": item.data,
                        "sign": item.sign
                    };
                JsQuery.Load(OnServerPurchase, [item.id, callbackFunc], "ext/common/googleplay_payment.php?" + Sys.FormatGetParamsStoc(null), obj);
            }
            else if (Config.ios && Boolean(Platform.flamc))
            {
                trace("CreditMarketItem, id:" + item.id + ", transaction:" + item.transaction + ", receipt:" + item.data);
                obj = {
                        "cmd": "purchase",
                        "data": item.data,
                        "product_id": item.id,
                        "transaction": item.transaction
                    };
                JsQuery.Load(OnServerPurchase, [item.transaction, callbackFunc], "ext/common/applestore_payment.php?" + Sys.FormatGetParamsStoc(null), obj);
            }
        }

        public static function CheckMarketInventory(items:Array):void
        {
            var i:int = 0;
            DBG.Trace("Platform.CheckMarketInventory:", items);
            if (items)
            {
                for (i = 0; i < items.length; i++)
                {
                    CreditMarketItem(items[i], null);
                }
            }
        }

        public static function VibrateDevice(duration:Number = 100):void
        {
            if (Config.android && Boolean(Platform.flamc))
            {
                return;
            }
        }

        public static function CreateStageText(x:Number, y:Number, w:Number, h:Number, multiline:Boolean, size:Number):Object
        {
            var tf:* = undefined;
            if ((Config.ios || Config.android) && Boolean(Platform.flamc))
            {
                tf = Platform.flamc.CreateStageText(Imitation.stage, x, y, w, h, multiline);
                tf.editable = true;
                tf.fontSize = size;
            }
            else
            {
                tf = new TextField();
                Imitation.stage.addChild(tf);
                tf.x = x;
                tf.y = y;
                tf.width = w;
                tf.height = h;
                tf.defaultTextFormat.size = size;
                tf.multiline = multiline;
                tf.type = TextFieldType.INPUT;
            }
            return tf;
        }

        public static function SetStageTextPos(tf:*, x:Number, y:Number):*
        {
            if ((Config.ios || Config.android) && Boolean(Platform.flamc))
            {
                tf.viewPort = new Rectangle(x, y, tf.viewPort.width, tf.viewPort.height);
            }
            else
            {
                tf.x = x;
                tf.y = y;
            }
        }

        public static function FocusStageText(tf:*):*
        {
            if ((Config.ios || Config.android) && Boolean(Platform.flamc))
            {
                tf.assignFocus();
            }
            else
            {
                Imitation.stage.focus = tf;
            }
        }

        public static function SelectEndStageText(tf:Object):*
        {
            if ((Config.ios || Config.android) && Boolean(Platform.flamc))
            {
                tf.selectRange(tf.text.length, tf.text.length);
            }
            else
            {
                tf.setSelection(tf.text.length, tf.text.length);
            }
        }

        public static function DisposeStageText(tf:Object):void
        {
            if ((Config.ios || Config.android) && Boolean(Platform.flamc))
            {
                tf.stage = null;
            }
            else if (tf && tf.parent && Boolean(tf.parent.contains(tf)))
            {
                tf.parent.removeChild(tf);
            }
        }

        private static function OnCloseApplication(res:int):void
        {
            trace("OnCloseApplication:", res);
            if (res == 1)
            {
                Platform.ExitApplication();
            }
        }

        private static function DoActivate():void
        {
            if (Sys.connection_lost_visible)
            {
                return;
            }
            Platform.deactivated = false;
            Platform.showactivate = false;
            Platform.silentactivate = false;
            if (Platform.reconnect)
            {
                Platform.reconnect = false;
                if (Comm.connstate <= 0)
                {
                    Comm.ReConnect(Platform.lastscreen);
                }
            }
        }

        private static function OnActivate(event:Object):void
        {
            var mw:Object = null;
            Imitation.Restart();
            if (Sys.connection_lost_visible)
            {
                return;
            }
            if (Platform.deactivated && Config.afterlogin)
            {
                TweenMax.resumeAll();
                if (Platform.silentactivate || Sys.screen.substr(0, 3) != "MAP")
                {
                    DoActivate();
                }
                else if (!Platform.showactivate)
                {
                    Platform.showactivate = true;
                    mw = Modules.GetClass("uibase", "uibase.AppDeactivated");
                    mw.Show(Lang.Get("appdeactivated_msg"), DoActivate);
                }
            }
            WinMgr.UpdateBackground();
        }

        private static function OnDeactivate(event:Object):void
        {
            if (Sys.connection_lost_visible)
            {
                return;
            }
            if (!Platform.deactivated && Config.afterlogin)
            {
                Platform.deactivated = true;
                Platform.lastscreen = Sys.screen;
                Sys.gsqc.Clear();
                TweenMax.pauseAll();
                SoundMixer.stopAll();
                Imitation.Stop();
                if (!Platform.silentactivate)
                {
                    Platform.reconnect = Comm.connstate > 0;
                    if (Platform.reconnect)
                    {
                        DBG.Trace("Platform.OnDeactivate");
                        Comm.StopCommunication("OnDeactivate", "Silent:" + (Platform.silentactivate || Sys.screen.substr(0, 3) != "MAP" ? "1" : "0"));
                    }
                }
            }
        }

        private static function OnServerPurchase(jsq:Object, itemId:String, callbackFunc:Function):void
        {
            DBG.Trace("Platform.OnServerPurchase:" + itemId, jsq);
            if (Boolean(jsq) && jsq.error == 0)
            {
                ConsumeInventoryItem(itemId);
            }
            if (callbackFunc != null)
            {
                callbackFunc(true);
            }
        }

        public function Platform()
        {
            super();
        }

        private static function OnPurchaseSuccess(event:CustomEvent):void
        {
            CreditMarketItem(event.params, null);
        }
    }
}
