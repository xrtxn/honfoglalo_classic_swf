package profile2 {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import syscode.*;
		import uibase.lego_button_1x1_cancel;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol350")]
		public class ProfilePage extends MovieClip {
				public var AVATAR:AvatarAnimMov;
				
				public var BTN_LEAVE_CLAN:lego_button_1x1_cancel;
				
				public var CLAN_CAPTION:MovieClip;
				
				public var CLAN_NAME:MovieClip;
				
				public var CLAN_NUM:MovieClip;
				
				public var C_FIRSTLOGIN:MovieClip;
				
				public var C_FULLMAPVICTORY:MovieClip;
				
				public var C_GAMECOUNT:MovieClip;
				
				public var C_GAMECOUNTSR:MovieClip;
				
				public var C_GLORIOUSVICTORY:MovieClip;
				
				public var C_LASTGAME:MovieClip;
				
				public var C_LAST_GAMES:MovieClip;
				
				public var C_LEAVE_CLAN:MovieClip;
				
				public var C_TOWERS:MovieClip;
				
				public var C_VEP:MovieClip;
				
				public var EDIT_ICON:LegoIconset;
				
				public var FIRSTLOGIN:MovieClip;
				
				public var FULLMAPVICTORY:MovieClip;
				
				public var GAMECOUNT:MovieClip;
				
				public var GAMECOUNTSR:MovieClip;
				
				public var GLORIOUSVICTORY:MovieClip;
				
				public var GUESS:MovieClip;
				
				public var GUEST_PANEL:MovieClip;
				
				public var JEP:MovieClip;
				
				public var JEPICON:LegoIconset;
				
				public var JEP_CAPTION:MovieClip;
				
				public var LASTGAME:MovieClip;
				
				public var LAST_GAMES:MovieClip;
				
				public var LVL1:MovieClip;
				
				public var LVL2:MovieClip;
				
				public var LVLFIELD:MovieClip;
				
				public var MCQ:MovieClip;
				
				public var NAME:MovieClip;
				
				public var NEXTLVLFIELD:MovieClip;
				
				public var PLACE1:MovieClip;
				
				public var PLACE2:MovieClip;
				
				public var PLACE3:MovieClip;
				
				public var SOLDIERS_MC:MovieClip;
				
				public var TOWERS:MovieClip;
				
				public var VEP:MovieClip;
				
				public var XP:MovieClip;
				
				public var XPBAR:MovieClip;
				
				public var XPPOINTS:MovieClip;
				
				public var started:Boolean = false;
				
				public var castles:MovieClip;
				
				public var userdata:Object = null;
				
				public function ProfilePage() {
						super();
						this.SOLDIERS_MC.NEXTBTN.Set("RIGHT_ARROW");
						this.SOLDIERS_MC.PREVBTN.Set("LEFT_ARROW");
						this.SOLDIERS_MC.LOCK.Set("LOCK");
						Imitation.AddEventClick(this.SOLDIERS_MC.NEXTBTN,this.OnPrevNextClick);
						Imitation.AddEventClick(this.SOLDIERS_MC.PREVBTN,this.OnPrevNextClick);
				}
				
				public function Start(_data:Object = null) : void {
						if(_data == null) {
								return;
						}
						if(this.started) {
								return;
						}
						this.started = true;
						this.Draw(_data);
				}
				
				public function Draw(_obj:Object) : void {
						var scale:* = undefined;
						var sp:* = undefined;
						var scale2:* = undefined;
						var sp2:* = undefined;
						this.userdata = _obj;
						this.AVATAR.ShowUID(this.userdata.id);
						this.AVATAR.ShowFrame(this.userdata.xplevel,this.userdata.actleague);
						Util.SetText(this.NAME.FIELD,this.userdata.name);
						Util.SetText(this.LVL1.FIELD,Lang.Get("lvl"));
						Util.SetText(this.LVL2.FIELD,Lang.Get("lvl"));
						Util.SetText(this.XP.FIELD,Lang.Get("xp"));
						this.SOLDIERS_MC.visible = false;
						this.GUEST_PANEL.visible = false;
						this.BTN_LEAVE_CLAN.visible = false;
						this.C_LEAVE_CLAN.visible = false;
						this.EDIT_ICON.Set("EDIT");
						this.EDIT_ICON.visible = false;
						if(MovieClip(parent).uid == Sys.mydata.id) {
								this.EDIT_ICON.visible = true;
								this.SOLDIERS_MC.visible = true;
								this.LVLFIELD.FIELD.text = Sys.mydata.xplevel;
								this.NEXTLVLFIELD.FIELD.text = Sys.mydata.xplevel + 1;
								this.XPPOINTS.FIELD.text = Util.FormatNumber(Util.NumberVal(Sys.mydata.xppoints) - Util.NumberVal(Sys.mydata.xpactmin)) + " / " + Util.FormatNumber(Util.NumberVal(Sys.mydata.xptonextlevel) - Util.NumberVal(Sys.mydata.xpactmin));
								if(Sys.mydata.xppoints !== undefined) {
										scale = (Sys.mydata.xppoints - Sys.mydata.xpactmin) / (Sys.mydata.xptonextlevel - Sys.mydata.xpactmin);
										sp = scale;
										if(sp > 1) {
												sp = 1;
										}
										if(sp < 0) {
												sp = 0;
										}
										this.XPBAR.STRIP.scaleX = sp;
								} else {
										this.XPBAR.STRIP.scaleX = 0.01;
								}
								if(Util.NumberVal(this.userdata.clan_id) != 0) {
										this.BTN_LEAVE_CLAN.visible = true;
										this.C_LEAVE_CLAN.visible = true;
										Util.SetText(this.C_LEAVE_CLAN.FIELD,Lang.Get("exit_clan"));
										this.BTN_LEAVE_CLAN.SetIcon("X");
										this.BTN_LEAVE_CLAN.AddEventClick(this.OnButtonClick,{
												"cmd":"exit",
												"msg":Lang.Get("ask_quit_clan"),
												"target":Util.StringVal(this.userdata.id)
										});
								}
						} else {
								this.GUEST_PANEL.visible = true;
								this.DrawGuestPanel();
								Util.SetText(this.GUEST_PANEL.C_JEP.FIELD,Lang.Get("player_power_points_abr"));
								this.GUEST_PANEL.JEP.FIELD.text = this.userdata.jep;
								this.GUEST_PANEL.JEPICON.Set("JEP" + this.userdata.jeplevel);
								this.LVLFIELD.FIELD.text = this.userdata.xplevel;
								this.NEXTLVLFIELD.FIELD.text = this.userdata.xplevel + 1;
								this.XPPOINTS.FIELD.text = Util.FormatNumber(Util.NumberVal(this.userdata.xppoints) - Util.NumberVal(this.userdata.xpmin)) + " / " + Util.FormatNumber(Util.NumberVal(this.userdata.xpmax) - Util.NumberVal(this.userdata.xpmin));
								if(this.userdata.xppoints !== undefined) {
										scale2 = (this.userdata.xppoints - this.userdata.xpmin) / (this.userdata.xpmax - this.userdata.xpmin);
										sp2 = scale2;
										if(sp2 > 1) {
												sp2 = 1;
										}
										if(sp2 < 0) {
												sp2 = 0;
										}
										this.XPBAR.STRIP.scaleX = sp2;
								} else {
										this.XPBAR.STRIP.scaleX = 0.01;
								}
						}
						Util.SetText(this.JEP_CAPTION.FIELD,Lang.Get("jep_ext"));
						this.JEP.FIELD.text = this.userdata.jep;
						this.JEPICON.Set("JEP" + this.userdata.jeplevel);
						Util.SetText(this.CLAN_CAPTION.FIELD,Lang.Get("clan"));
						if(this.userdata.clan_id) {
								Util.SetText(this.CLAN_NAME.FIELD,this.userdata.clan_name);
								this.CLAN_NUM.FIELD.text = this.userdata.clan_level;
						} else {
								Util.SetText(this.CLAN_NAME.FIELD,Lang.Get("no_clan"));
								if(Util.NumberVal(this.userdata.clan_invited)) {
										Util.SetText(this.CLAN_NAME.FIELD,Lang.Get("invited_to_clan"));
								}
								this.CLAN_NUM.visible = false;
						}
						Util.SetText(this.FIRSTLOGIN.FIELD,Util.StringVal(this.userdata.firstlogin));
						Util.SetText(this.LASTGAME.FIELD,Util.StringVal(this.userdata.lastgame));
						Util.SetText(this.C_FIRSTLOGIN.FIELD,Lang.Get("firstlogin+:"));
						Util.SetText(this.C_LASTGAME.FIELD,Lang.Get("last_game+:"));
						Util.SetText(this.GAMECOUNT.FIELD,Util.NumberVal(this.userdata.gamecount).toString());
						Util.SetText(this.GAMECOUNTSR.FIELD,Util.NumberVal(this.userdata.gamecountsr).toString());
						Util.SetText(this.C_GAMECOUNT.FIELD,Lang.Get("game_count+:"));
						Util.SetText(this.C_GAMECOUNTSR.FIELD,Lang.Get("game_count_separate+:"));
						Util.SetText(this.GLORIOUSVICTORY.FIELD,Util.NumberVal(this.userdata.map50pcnt).toString());
						Util.SetText(this.FULLMAPVICTORY.FIELD,Util.NumberVal(this.userdata.map100pcnt).toString());
						Util.SetText(this.C_FULLMAPVICTORY.FIELD,Lang.Get("fullmap_victory+:"));
						Util.SetText(this.C_GLORIOUSVICTORY.FIELD,Lang.Get("glorious_victory+:"));
						Util.SetText(this.C_TOWERS.FIELD,Lang.Get("towers_destroyed_per_game+:"));
						Util.SetText(this.C_LAST_GAMES.FIELD,Lang.Get("game_count_last30+:"));
						Util.SetText(this.TOWERS.FIELD,this.userdata.rl_gamecount);
						Util.SetText(this.LAST_GAMES.FIELD,this.userdata.rl_towers);
						Util.SetText(this.PLACE1.FIELD,Util.NumberVal(this.userdata.place1cnt).toString());
						Util.SetText(this.PLACE2.FIELD,Util.NumberVal(this.userdata.place2cnt).toString());
						Util.SetText(this.PLACE3.FIELD,Util.NumberVal(this.userdata.place3cnt).toString());
						Util.SetText(this.C_VEP.FIELD,Lang.Get("answer_power+:"));
						if(MovieClip(parent).uid == Sys.mydata.id) {
								Util.SetText(this.VEP.FIELD,Math.round(Util.NumberVal(Sys.mydata.vep) / 100) + "%");
								Util.SetText(this.MCQ.FIELD,Math.round(Util.NumberVal(Sys.mydata.mcq) / 100) + "%");
								Util.SetText(this.GUESS.FIELD,Math.round(Util.NumberVal(Sys.mydata.guess) / 100) + "%");
						} else {
								Util.SetText(this.VEP.FIELD,"-");
								Util.SetText(this.MCQ.FIELD,"-");
								Util.SetText(this.GUESS.FIELD,"-");
						}
						this.UpdateSoldiers();
				}
				
				public function OnPrevNextClick(e:*) : * {
						do {
								if(e.target == this.SOLDIERS_MC.NEXTBTN) {
										if(MovieClip(parent).selected_soldier < this.SOLDIERS_MC.SOLDIER.SKIN.skincount) {
												++MovieClip(parent).selected_soldier;
										} else {
												MovieClip(parent).selected_soldier = 1;
										}
								} else if(MovieClip(parent).selected_soldier > 1) {
										--MovieClip(parent).selected_soldier;
								} else {
										MovieClip(parent).selected_soldier = this.SOLDIERS_MC.SOLDIER.SKIN.skincount;
								}
						}
						while(!MovieClip(parent).soldiers[MovieClip(parent).selected_soldier] || MovieClip(parent).soldiers[MovieClip(parent).selected_soldier].type == 2);
						
						this.UpdateSoldiers();
				}
				
				public function UpdateSoldiers() : void {
						var s:* = undefined;
						var sg:* = undefined;
						this.UpdateSoldier(this.SOLDIERS_MC.SOLDIER,1);
						for(var i:* = 1; i <= 3; i++) {
								s = this.SOLDIERS_MC["SOLDIER" + i];
								this.UpdateSoldier(s,i);
								sg = this.GUEST_PANEL["SOLDIER" + i];
								this.UpdateSoldier(sg,i);
						}
				}
				
				public function UpdateSoldier(s:MovieClip, color:int) : * {
						var skin:int = 0;
						var c:Class = null;
						var remsec:Number = NaN;
						var str:String = null;
						if(MovieClip(parent).uid == Sys.mydata.id) {
								skin = int(MovieClip(parent).selected_soldier);
						} else {
								skin = int(this.userdata.soldier);
						}
						s.gotoAndStop(color);
						if(s.SKIN.contains(s.SKIN.PLACEHOLDER)) {
								s.SKIN.removeChild(s.SKIN.PLACEHOLDER);
						}
						if(!s.SKIN.mc) {
								c = Modules.GetClass("soldiers","Soldiers");
								if(!c) {
										return;
								}
								s.SKIN.mc = new c();
								s.SKIN.mc.scaleX = 0.39;
								s.SKIN.mc.scaleY = s.SKIN.mc.scaleX;
								s.SKIN.addChild(s.SKIN.mc);
						}
						s.SKIN.skincount = s.SKIN.mc.totalFrames;
						if(skin < 1 || skin > s.SKIN.skincount) {
								skin = 1;
						}
						if(!MovieClip(parent).soldiers[skin]) {
								s.visible = false;
								return;
						}
						s.visible = true;
						s.SKIN.mc.gotoAndStop(skin);
						s.SKIN.mc.COLOR.gotoAndStop(color);
						s.SKIN.mc.cacheAsBitmap = true;
						Imitation.SetBitmapScale(s,1.5);
						Imitation.FreeBitmapAll(s);
						Imitation.Update(s);
						if(s != this.SOLDIERS_MC.SOLDIER) {
								return;
						}
						this.SOLDIERS_MC.BUY.BTNBUY.SetIcon("CHECKOUT");
						this.SOLDIERS_MC.BUY.BTNBUY.AddEventClick(this.OnBuyClick);
						Util.SetText(this.SOLDIERS_MC.BUY.C_BUY.FIELD,Lang.Get("buy_soldier"));
						var price:Number = Number(MovieClip(parent).soldiers[skin].cost);
						s.alpha = !!MovieClip(parent).soldiers[skin].have ? 1 : 0.5;
						this.SOLDIERS_MC.BUY.PRICE.FIELD.text = Util.FormatNumber(price);
						this.SOLDIERS_MC.BUY.visible = !MovieClip(parent).soldiers[skin].have;
						var available:* = MovieClip(parent).soldiers[skin].type == 0;
						this.SOLDIERS_MC.LOCK.visible = !available;
						this.SOLDIERS_MC.BUY.BTNBUY.SetEnabled(available);
						if(MovieClip(parent).soldiers[skin].remaining > 0) {
								str = "";
								if(available) {
										str += Lang.Get("available_until+:");
								} else {
										str += Lang.Get("available_in+:");
								}
								remsec = Util.NumberVal(MovieClip(parent).soldiers[skin].remaining);
								str += Util.FormatRemaining(remsec - Math.round((new Date().time - MovieClip(parent).reftime) / 1000));
								Util.SetText(this.SOLDIERS_MC.BUY.C_BUY.FIELD,str);
						}
				}
				
				public function OnBuyClick(e:* = null) : void {
						Comm.SendCommand("BUYITEM","ITEMTYPE=\"SOLDIER\" ITEMINDEX=\"" + MovieClip(parent).selected_soldier + "\"",this.HandleBuyResult);
				}
				
				public function HandleBuyResult(res:int, xml:XML = null) : void {
						if(res == 0) {
								return;
						}
						if(res == 77) {
								WinMgr.OpenWindow("bank.Bank",{"funnelid":"Soldier"});
								return;
						}
				}
				
				public function DrawGuestPanel() : void {
						var c:Class;
						var activecastlelevels:Array;
						var alevel:*;
						var level:*;
						var frame:*;
						var friendly:Boolean;
						var myadminright:Number;
						var i:int = 0;
						if(this.castles != null && this.GUEST_PANEL.contains(this.castles)) {
								this.GUEST_PANEL.removeChild(this.castles);
						}
						this.castles = null;
						c = Modules.GetClass("castles","Castles");
						this.castles = new c();
						this.castles.scaleX = 1.2;
						this.castles.scaleY = this.castles.scaleX;
						this.castles.x = 180;
						this.castles.y = 72;
						this.GUEST_PANEL.addChild(this.castles);
						activecastlelevels = [0,1,2,3,4,6,7,10,13,14];
						alevel = this.userdata.castlelevel;
						alevel = activecastlelevels[alevel];
						level = alevel;
						if(level < 0) {
								level = 0;
						}
						if(level > 14 && level != 20) {
								level = 14;
						}
						frame = level;
						if(level == 0) {
								frame = 15;
						}
						this.castles.gotoAndStop(frame);
						Util.StopAllChildrenMov(this.castles);
						Imitation.SetBitmapScale(this.castles,1.5);
						Imitation.CollectChildrenAll(this.castles);
						Imitation.FreeBitmapAll(this.castles);
						for(i = 1; i <= 5; i++) {
								this.GUEST_PANEL["BTN_" + i + "_R"].visible = false;
								this.GUEST_PANEL["BTN_" + i + "_G"].visible = false;
								this.GUEST_PANEL["BTN_" + i + "_Y"].visible = false;
								this.GUEST_PANEL["C_" + i].visible = false;
								this.GUEST_PANEL["BTN_" + i + "_R"].SetEnabled(true);
								this.GUEST_PANEL["BTN_" + i + "_G"].SetEnabled(true);
								this.GUEST_PANEL["BTN_" + i + "_Y"].SetEnabled(true);
						}
						if(MovieClip(parent).uid == Sys.mydata.id) {
								return;
						}
						this.GUEST_PANEL.FBICON.visible = false;
						if(MovieClip(parent).friendship == null) {
								Util.SetText(this.GUEST_PANEL.C_1.FIELD,Lang.Get("add_friend"));
								this.GUEST_PANEL.C_1.visible = true;
								this.GUEST_PANEL.BTN_1_G.SetIcon("INVITE_WHITE");
								this.GUEST_PANEL.BTN_1_G.AddEventClick(function():* {
										SetButtonsState(false);
										Friends.AddFriendShip(MovieClip(parent).uid,MovieClip(parent).OnFriendsChanged);
								});
								this.GUEST_PANEL.BTN_1_G.visible = true;
								Util.SetText(this.GUEST_PANEL.C_2.FIELD,Lang.Get("block_user"));
								this.GUEST_PANEL.C_2.visible = true;
								this.GUEST_PANEL.BTN_2_R.SetIcon("LOCK_WHITE");
								this.GUEST_PANEL.BTN_2_R.AddEventClick(function():* {
										SetButtonsState(false);
										Friends.BlockUser(MovieClip(parent).uid,MovieClip(parent).OnFriendsChanged);
								});
								this.GUEST_PANEL.BTN_2_R.visible = true;
						} else if(0 == MovieClip(parent).friendship.flag) {
								Util.SetText(this.GUEST_PANEL.C_1.FIELD,Lang.Get("cancel_invitation"));
								this.GUEST_PANEL.C_1.visible = true;
								this.GUEST_PANEL.BTN_1_Y.SetIcon("CLEAR");
								this.GUEST_PANEL.BTN_1_Y.AddEventClick(function():* {
										SetButtonsState(false);
										Friends.CancelFriendShip(MovieClip(parent).friendship.id,MovieClip(parent).OnFriendsChanged);
								});
								this.GUEST_PANEL.BTN_1_Y.visible = true;
						} else if(1 == MovieClip(parent).friendship.flag) {
								Util.SetText(this.GUEST_PANEL.C_1.FIELD,Lang.Get("cancel_friendship"));
								this.GUEST_PANEL.C_1.visible = true;
								this.GUEST_PANEL.BTN_1_R.SetIcon("CLEAR");
								this.GUEST_PANEL.BTN_1_R.AddEventClick(function():* {
										Modules.GetClass("uibase","uibase.MessageWin").AskYesNo(Lang.Get("cancel_friendship"),Lang.Get("ask_cancel_friendship"),Lang.Get("yes"),Lang.Get("cancel"),function(result:*):* {
												if(result == 1) {
														SetButtonsState(false);
														Friends.CancelFriendShip(MovieClip(parent).friendship.id,MovieClip(parent).OnFriendsChanged);
												}
										});
								});
								this.GUEST_PANEL.BTN_1_R.visible = true;
								if(MovieClip(parent).friendship.external) {
										this.GUEST_PANEL.FBICON.visible = true;
										this.GUEST_PANEL.BTN_1_R.SetEnabled(false);
								}
						} else if(2 == MovieClip(parent).friendship.flag) {
								Util.SetText(this.GUEST_PANEL.C_1.FIELD,Lang.Get("accept_friendship"));
								this.GUEST_PANEL.C_1.visible = true;
								this.GUEST_PANEL.BTN_1_G.SetIcon("PIPE_WHITE");
								this.GUEST_PANEL.BTN_1_G.AddEventClick(function():* {
										SetButtonsState(false);
										Friends.AddFriendShip(MovieClip(parent).friendship.id,MovieClip(parent).OnFriendsChanged);
								});
								this.GUEST_PANEL.BTN_1_G.visible = true;
								Util.SetText(this.GUEST_PANEL.C_2.FIELD,Lang.Get("deny_friendship"));
								this.GUEST_PANEL.C_2.visible = true;
								this.GUEST_PANEL.BTN_2_R.SetIcon("X");
								this.GUEST_PANEL.BTN_2_R.AddEventClick(function():* {
										SetButtonsState(false);
										Friends.DenyFriendShip(MovieClip(parent).friendship.id,MovieClip(parent).OnFriendsChanged);
								});
								this.GUEST_PANEL.BTN_2_R.visible = true;
						} else if(3 == MovieClip(parent).friendship.flag) {
								Util.SetText(this.GUEST_PANEL.C_1.FIELD,Lang.Get("cancel_block"));
								this.GUEST_PANEL.C_1.visible = true;
								this.GUEST_PANEL.BTN_1_G.SetIcon("LOCK_OUT_WHITE");
								this.GUEST_PANEL.BTN_1_G.AddEventClick(function():* {
										SetButtonsState(false);
										Friends.CancelBlock(MovieClip(parent).friendship.id,MovieClip(parent).OnFriendsChanged);
								});
								this.GUEST_PANEL.BTN_1_G.visible = true;
						}
						Util.SetText(this.GUEST_PANEL.C_5.FIELD,Lang.Get("report") + ": nincs ilyen funkció!");
						this.GUEST_PANEL.C_5.visible = false;
						this.GUEST_PANEL.BTN_5_R.SetIcon("EXCLAMATION_MARK");
						this.GUEST_PANEL.BTN_5_R.visible = false;
						friendly = Boolean(MovieClip(parent).friendship) && MovieClip(parent).friendship.flag == 1;
						myadminright = Util.NumberVal(Sys.myclanproperties.adminright);
						if(this.userdata.signup_time) {
								Util.SetText(this.GUEST_PANEL.C_3.FIELD,Lang.Get("clan") + ": " + Lang.Get("accept"));
								this.GUEST_PANEL.C_3.visible = true;
								this.GUEST_PANEL.BTN_3_G.SetIcon("PIPE_WHITE");
								this.GUEST_PANEL.BTN_3_G.AddEventClick(function():* {
										SetButtonsState(false);
										WinMgr.ShowLoadWait();
										JsQuery.Load(Profile2.OnClanCommandReady,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
												"cmd":"accept_signup",
												"signupid":Util.StringVal(userdata.id)
										});
								});
								this.GUEST_PANEL.BTN_3_G.visible = true;
								Util.SetText(this.GUEST_PANEL.C_4.FIELD,Lang.Get("clan") + ": " + Lang.Get("deny"));
								this.GUEST_PANEL.C_4.visible = true;
								this.GUEST_PANEL.BTN_4_R.SetIcon("X");
								this.GUEST_PANEL.BTN_4_R.AddEventClick(function():* {
										SetButtonsState(false);
										WinMgr.ShowLoadWait();
										JsQuery.Load(Profile2.OnClanCommandReady,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
												"cmd":"alliance_delete_signup",
												"signupid":Util.StringVal(userdata.id)
										});
								});
								this.GUEST_PANEL.BTN_4_R.visible = true;
						} else if(Util.NumberVal(this.userdata.id) != Util.NumberVal(Sys.mydata.id) && myadminright > 0 && Util.NumberVal(this.userdata.clan_id) == 0 && Util.NumberVal(this.userdata.clan_invited) == 0) {
								Util.SetText(this.GUEST_PANEL.C_3.FIELD,Lang.Get("clan") + ": " + Lang.Get("invite"));
								this.GUEST_PANEL.C_3.visible = true;
								this.GUEST_PANEL.BTN_3_G.SetIcon("PIPE_WHITE");
								this.GUEST_PANEL.BTN_3_G.AddEventClick(function():* {
										SetButtonsState(false);
										WinMgr.ShowLoadWait();
										JsQuery.Load(Profile2.OnClanCommandReady,[],Config.CLAN_PHP + Sys.FormatGetParamsStoc({},true),{
												"cmd":"invite_send",
												"target":Util.StringVal(userdata.id)
										});
								});
								this.GUEST_PANEL.BTN_3_G.visible = true;
						} else if(Util.NumberVal(this.userdata.clan_id) != 0) {
								if(Util.NumberVal(this.userdata.id) == Util.NumberVal(Sys.mydata.id)) {
										Util.SetText(this.GUEST_PANEL.C_3.FIELD,Lang.Get("exit_clan"));
										this.GUEST_PANEL.C_3.visible = true;
										this.GUEST_PANEL.BTN_3_R.SetIcon("X");
										this.GUEST_PANEL.BTN_3_R.AddEventClick(this.OnButtonClick,{
												"cmd":"exit",
												"msg":Lang.Get("ask_quit_clan"),
												"target":Util.StringVal(this.userdata.id)
										});
										this.GUEST_PANEL.BTN_3_R.visible = true;
								} else if(Boolean(Sys.myclanproperties) && Util.NumberVal(this.userdata.clan_id) == Util.NumberVal(Sys.myclanproperties.id)) {
										if(myadminright == 1 && Util.NumberVal(this.userdata.clan_adminright) == 0) {
												Util.SetText(this.GUEST_PANEL.C_3.FIELD,Lang.Get("clan") + ": " + Lang.Get("kick_klan"));
												this.GUEST_PANEL.C_3.visible = true;
												this.GUEST_PANEL.BTN_3_R.SetIcon("X");
												this.GUEST_PANEL.BTN_3_R.AddEventClick(this.OnButtonClick,{
														"cmd":"kick",
														"msg":Lang.Get("ask_kick_clan_member"),
														"target":Util.StringVal(this.userdata.id)
												});
												this.GUEST_PANEL.BTN_3_R.visible = true;
										} else if(myadminright == 2 && Util.NumberVal(this.userdata.clan_adminright) == 1) {
												Util.SetText(this.GUEST_PANEL.C_3.FIELD,Lang.Get("clan") + ": " + Lang.Get("demote_member"));
												this.GUEST_PANEL.C_3.visible = true;
												this.GUEST_PANEL.BTN_3_R.SetIcon("PIPE_WHITE");
												this.GUEST_PANEL.BTN_3_R.AddEventClick(this.OnButtonClick,{
														"cmd":"revoke",
														"msg":Lang.Get("sure_cancel_admin"),
														"target":Util.StringVal(this.userdata.id)
												});
												this.GUEST_PANEL.BTN_3_R.visible = true;
										} else if(myadminright == 2 && Util.NumberVal(this.userdata.clan_adminright) == 0) {
												Util.SetText(this.GUEST_PANEL.C_3.FIELD,Lang.Get("clan") + ": " + Lang.Get("promote_admin"));
												this.GUEST_PANEL.C_3.visible = true;
												this.GUEST_PANEL.BTN_3_G.SetIcon("PIPE_WHITE");
												this.GUEST_PANEL.BTN_3_G.AddEventClick(this.OnButtonClick,{
														"cmd":"grant",
														"msg":Lang.Get("sure_make_admin"),
														"target":Util.StringVal(this.userdata.id)
												});
												this.GUEST_PANEL.BTN_3_G.visible = true;
												Util.SetText(this.GUEST_PANEL.C_4.FIELD,Lang.Get("clan") + ": " + Lang.Get("kick_klan"));
												this.GUEST_PANEL.C_4.visible = true;
												this.GUEST_PANEL.BTN_4_R.SetIcon("X");
												this.GUEST_PANEL.BTN_4_R.AddEventClick(this.OnButtonClick,{
														"cmd":"kick",
														"msg":Lang.Get("ask_kick_clan_member"),
														"target":Util.StringVal(this.userdata.id)
												});
												this.GUEST_PANEL.BTN_4_R.visible = true;
										}
								}
						}
				}
				
				private function OnButtonClick(e:Object) : void {
						this.SetButtonsState(false);
						var msg:String = Util.StringVal(e.params.msg);
						Modules.GetClass("uibase","uibase.MessageWin").AskYesNo("",msg,Lang.Get("ok"),Lang.Get("cancel"),Profile2.OnSendMemberRequest,[e.params]);
				}
				
				public function SetButtonsState(_e:Boolean = false) : void {
						var i:int = 0;
						for(i = 1; i <= 5; i++) {
								this.GUEST_PANEL["BTN_" + i + "_R"].SetEnabled(_e);
								this.GUEST_PANEL["BTN_" + i + "_G"].SetEnabled(_e);
								this.GUEST_PANEL["BTN_" + i + "_Y"].SetEnabled(_e);
						}
				}
				
				public function Destroy() : void {
						trace("profilePage.Destroy");
						Imitation.RemoveEvents(this.SOLDIERS_MC.NEXTBTN);
						Imitation.RemoveEvents(this.SOLDIERS_MC.PREVBTN);
				}
		}
}

