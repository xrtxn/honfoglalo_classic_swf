package profile2 {
		import com.greensock.easing.*;
		import flash.display.MovieClip;
		import syscode.*;
		
		[Embed(source="/_assets/assets.swf", symbol="symbol587")]
		public class SchoolsPage extends MovieClip {
				public var C_NAME:MovieClip;
				
				public var C_REGIO:MovieClip;
				
				public var C_SCHOOL:MovieClip;
				
				public var EDSEARCH:MovieClip;
				
				public var REGIOSEARCH:MovieClip;
				
				public var SCHOOL:MovieClip;
				
				public var SCHOOLSLIST:MovieClip;
				
				public var SCHOOL_DESC:MovieClip;
				
				public var schoolsListArray:Array;
				
				public var filteredSchools:Array;
				
				public var actRegio:String = "";
				
				public function SchoolsPage() {
						super();
						trace("SchoolsPage.Constructor");
						this.schoolsListArray = new Array();
						Util.SetText(this.C_REGIO.FIELD,Lang.Get("school_regio"));
						Util.SetText(this.C_NAME.FIELD,Lang.Get("school_name"));
						Util.SetText(this.C_SCHOOL.FIELD,Lang.Get("school_your"));
						Util.SetText(this.SCHOOL.FIELD,"NOT YET");
						Util.SetText(this.SCHOOL_DESC.FIELD,Lang.Get("school_desc"));
						this.WriteSchoolList();
						Util.AddEventListener(this.REGIOSEARCH.FIELD,"change",this.RegioChanged);
						Util.AddEventListener(this.EDSEARCH.FIELD,"change",this.FilterChanged);
				}
				
				public function Start(_data:Object = null) : void {
						trace("SchoolsPage.Start");
						this.Draw(_data);
				}
				
				public function Draw(_obj:Object = null) : void {
						trace("SchoolsPage.Draw");
						this.FilterSchools();
				}
				
				private function RegioChanged(e:Object) : void {
						this.FilterSchools();
				}
				
				private function FilterChanged(e:Object) : void {
						this.FilterSchools();
				}
				
				public function FilterSchools() : void {
						var actName:String;
						var regio:String = null;
						var i:int = 0;
						var obj:Object = null;
						var objn:String = null;
						var results:Array = null;
						var filteredRegios:Array = new Array();
						this.filteredSchools = new Array();
						actName = Util.GetRTLEditText(this.EDSEARCH.FIELD).toLowerCase();
						this.actRegio = Util.GetRTLEditText(this.REGIOSEARCH.FIELD).toLowerCase();
						for(i = 0; i < this.schoolsListArray.length; i++) {
								regio = this.schoolsListArray[i].regio.toLowerCase();
								if(this.actRegio != "") {
										if(this.actRegio.indexOf(regio) > -1) {
												filteredRegios.push(this.schoolsListArray[i]);
										}
								} else {
										filteredRegios.push(this.schoolsListArray[i]);
								}
						}
						if(filteredRegios.length <= 0) {
								filteredRegios = this.schoolsListArray;
						}
						for(i = 0; i < filteredRegios.length; i++) {
								obj = filteredRegios[i];
								if(actName != "") {
										objn = obj.name.toLowerCase();
										results = objn.match(actName);
										if(results != null) {
												this.filteredSchools.push(obj);
										}
								} else {
										this.filteredSchools.push(obj);
								}
						}
						if(this.filteredSchools.length <= 0) {
								this.filteredSchools = this.schoolsListArray;
						}
						this.filteredSchools.sort(function(a:*, b:*):* {
								return a.name.localeCompare(b.name);
						});
						this.SCHOOLSLIST.SCLINES.Set("SCLINE",this.filteredSchools,40,1,this.OnSchoolsListClick,this.DrawSchoolsLine,this.SCHOOLSLIST.MASK_LINES,this.SCHOOLSLIST.SB);
						this.SCHOOLSLIST.SB.ScrollTo(0,0);
						this.SCHOOLSLIST.SB.dragging = true;
				}
				
				public function OnSchoolsListClick(_item:MovieClip, _id:int) : void {
						trace(_item.data.zip);
						trace(_item.data.regio);
						trace(_item.data.name);
						Util.SetText(this.SCHOOL.FIELD,_item.data.regio + " " + _item.data.name);
				}
				
				public function DrawSchoolsLine(_item:MovieClip, _id:int) : void {
						if(_id >= this.schoolsListArray.length) {
								return;
						}
						if(_item && _item.CNAME && Boolean(_item.CNAME.FIELD)) {
								if(this.filteredSchools[_id]) {
										_item.visible = true;
										Util.SetText(_item.CNAME.FIELD,this.filteredSchools[_id].zip + " " + this.filteredSchools[_id].regio + " " + this.filteredSchools[_id].name);
										_item.data = this.filteredSchools[_id];
								} else {
										_item.visible = false;
								}
						}
				}
				
				public function ObjectTrace(_obj:Object, sPrefix:String = "") : void {
						var i:* = undefined;
						if(sPrefix == "") {
								sPrefix = "-->";
						} else {
								sPrefix += " -->";
						}
						for(i in _obj) {
								trace(sPrefix,i + ":" + _obj[i]," ");
								if(typeof _obj[i] == "object") {
										this.ObjectTrace(_obj[i],sPrefix);
								}
						}
				}
				
				public function Destroy() : void {
						trace("SettingsPage.Destroy");
						Util.RemoveEventListener(this.EDSEARCH.FIELD,"change",this.FilterChanged);
						Util.RemoveEventListener(this.REGIOSEARCH.FIELD,"change",this.RegioChanged);
				}
				
				private function WriteSchoolList() : void {
						this.schoolsListArray.push({
								"zip":7300,
								"regio":"Komló",
								"name":"Kenderföld-Somági Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7300,
								"regio":"Komló",
								"name":"Szilvási Általános Iskola Felsőszilvási Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7700,
								"regio":"Mohács",
								"name":"Boldog Gizella Katolikus Óvoda és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7800,
								"regio":"Siklós",
								"name":"Szent Imre Katolikus Általános Iskola és Előkészítő Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":7624,
								"regio":"Pécs",
								"name":"Miroslav Krleža Horvát Óvoda, Általános Iskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7621,
								"regio":"Pécs",
								"name":"Városközponti Általános Iskola Belvárosi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7633,
								"regio":"Pécs",
								"name":"Megyervárosi Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7632,
								"regio":"Pécs",
								"name":"Megyervárosi Általános Iskola és Gimnázium Anikó Utcai Általános Iskolája "
						});
						this.schoolsListArray.push({
								"zip":7386,
								"regio":"Gödre",
								"name":"Gödrei Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7696,
								"regio":"Hidas",
								"name":"Benedek Elek Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7694,
								"regio":"Hosszúhetény",
								"name":"Hosszúhetényi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7349,
								"regio":"Szászvár",
								"name":"Kiss György Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7695,
								"regio":"Mecseknádasd",
								"name":"Liszt Ferenc Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7723,
								"regio":"Erdősmecske",
								"name":"Liszt Ferenc Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola Erdősmecskei Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7391,
								"regio":"Mindszentgodisa",
								"name":"Mindszentgodisai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7731,
								"regio":"Nagypall",
								"name":"Kodolányi János Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola Nagypalli Német Nemzetiségi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7720,
								"regio":"Zengővárkony",
								"name":"Kodolányi János Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola Zengővárkonyi Német Nemzetiségi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7733,
								"regio":"Geresdlak",
								"name":"Kodolányi János Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola Geresdlaki Német Nemzetiségi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7362,
								"regio":"Vásárosdombó",
								"name":"Vásárosdombói Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7754,
								"regio":"Bóly",
								"name":"Bólyi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7784,
								"regio":"Nagynyárád",
								"name":"Bólyi Általános Iskola Nagynyárádi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7756,
								"regio":"Borjád",
								"name":"Bólyi Általános Iskola Borjádi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7753,
								"regio":"Szajk",
								"name":"Bólyi Általános Iskola Szajki Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7757,
								"regio":"Babarc",
								"name":"Bólyi Általános Iskola Babarci Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7759,
								"regio":"Lánycsók",
								"name":"Lánycsóki Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7781,
								"regio":"Lippó",
								"name":"Lippói Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7783,
								"regio":"Majs",
								"name":"Frey János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7745,
								"regio":"Olasz",
								"name":"Olaszi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7728,
								"regio":"Somberek",
								"name":"Sombereki Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7712,
								"regio":"Dunaszekcső",
								"name":"Sombereki Általános Iskola és Alapfokú Művészeti Iskola Dunaszekcsői Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7727,
								"regio":"Palotabozsok",
								"name":"Sombereki Általános Iskola és Alapfokú Művészeti Iskola Palotabozsoki Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7751,
								"regio":"Szederkény",
								"name":"Szederkényi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7726,
								"regio":"Véménd",
								"name":"Véméndi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7664,
								"regio":"Berkesd",
								"name":"Berkesdi Fekete István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7742,
								"regio":"Bogád",
								"name":"Bogádi Dr. Berze Nagy János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7761,
								"regio":"Kozármisleny",
								"name":"Kozármislenyi Janikovszky Éva Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7831,
								"regio":"Pellérd",
								"name":"Pellérdi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7668,
								"regio":"Gyód",
								"name":"Pellérdi Általános Iskola Gyódi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7833,
								"regio":"Görcsöny",
								"name":"Pellérdi Általános Iskola Görcsönyi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7827,
								"regio":"Beremend",
								"name":"Beremendi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7851,
								"regio":"Drávaszabolcs",
								"name":"Drávaszabolcsi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7960,
								"regio":"Drávasztára",
								"name":"Drávasztárai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7824,
								"regio":"Egyházasharaszti",
								"name":"Egyházasharaszti Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7823,
								"regio":"Siklósnagyfalu",
								"name":"Egyházasharaszti Körzeti Általános Iskola Siklósnagyfalui Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7815,
								"regio":"Harkány",
								"name":"Kitaibel Pál Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7843,
								"regio":"Kémes",
								"name":"Munkácsy Albert Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7817,
								"regio":"Diósviszló",
								"name":"Munkácsy Albert Általános Iskola Beleváry Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7775,
								"regio":"Magyarbóly",
								"name":"Magyarbólyi Nyelvoktató Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7954,
								"regio":"Magyarmecske",
								"name":"Magyarmecskei Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7960,
								"regio":"Sellye",
								"name":"Kiss Géza Általános Iskola és Zenei Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7964,
								"regio":"Csányoszró",
								"name":"Kiss Géza Általános Iskola és Zenei Alapfokú Művészeti Iskola Csányoszrói Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7811,
								"regio":"Szalánta",
								"name":"Szalántai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7763,
								"regio":"Egerág",
								"name":"Szalántai Általános Iskola Arany János Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7766,
								"regio":"Újpetre",
								"name":"Újpetrei Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7838,
								"regio":"Vajszló",
								"name":"Vajszlói Kodolányi János Szakközépiskola, Szakiskola és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7836,
								"regio":"Bogádmindszent",
								"name":"Vajszlói Kodolányi Általános Iskola és Szakképző Iskola Bogádmindszenti Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7773,
								"regio":"Villány",
								"name":"Villányi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7773,
								"regio":"Villány",
								"name":"Villányi Általános Iskola és Alapfokú Művészeti Iskola Rákóczi utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7768,
								"regio":"Vokány",
								"name":"Vokányi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7934,
								"regio":"Almamellék",
								"name":"Almamellék-Somogyhárságyi Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7925,
								"regio":"Somogyhárságy",
								"name":"Almamellék-Somogyhárságyi Általános Iskola és Kollégium Somogyhárságyi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7915,
								"regio":"Dencsháza",
								"name":"Dencsháza-Hobol Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7971,
								"regio":"Hobol",
								"name":"Dencsháza-Hobol Általános Iskola Hoboli Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7968,
								"regio":"Felsőszentmárton",
								"name":"Felsőszentmártoni Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7681,
								"regio":"Hetvehely",
								"name":"Hetvehelyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7621,
								"regio":"Pécs",
								"name":"Pécsi Leőwey Klára Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7629,
								"regio":"Pécs",
								"name":"Pécsi Kodály Zoltán Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7632,
								"regio":"Pécs",
								"name":"Pécsi Apáczai Csere János Általános Iskola, Gimnázium, Kollégium, Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7666,
								"regio":"Pogány",
								"name":"Pécsi Apáczai Csere János Általános Iskola, Gimnázium, Kollégium, Alapfokú Művészeti Iskola Pogányi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7700,
								"regio":"Mohács",
								"name":"Mohácsi Kisfaludy Károly Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7800,
								"regio":"Siklós",
								"name":"Siklósi Táncsics Mihály Gimnázium, Szakközépiskola és Szakiskola, Általános Iskola és Alapfokú Művészeti Iskola , Battyány Kázmér Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7900,
								"regio":"Szigetvár",
								"name":"Zrínyi Miklós Középiskola Istvánffy Miklós Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7900,
								"regio":"Szigetvár",
								"name":"Zrínyi Miklós Középiskola Tinódi Lantos Sebestyén Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7975,
								"regio":"Kétújfalu",
								"name":"Zrínyi Miklós Középiskola Kétújfalui Konrád Ignác Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7985,
								"regio":"Nagydobsza",
								"name":"Zrínyi Miklós Középiskola Nagydobszai Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7912,
								"regio":"Nagypeterd",
								"name":"Zrínyi Miklós Középiskola Nagypeterd-Rózsafai Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7914,
								"regio":"Rózsafa",
								"name":"Zrínyi Miklós Középiskola Nagypeterd-Rózsafai Általános Iskolája "
						});
						this.schoolsListArray.push({
								"zip":7922,
								"regio":"Somogyapáti",
								"name":"Zrínyi Miklós Középiskola Somogyapáti Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7922,
								"regio":"Somogyapáti",
								"name":"Zrínyi Miklós Középiskola Somogyapáti Általános Iskolája "
						});
						this.schoolsListArray.push({
								"zip":7936,
								"regio":"Szentlászló",
								"name":"Zrínyi Miklós Középiskola Szentlászlói Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7932,
								"regio":"Mozsgó",
								"name":"Zrínyi Miklós Középiskola Mozsgói Lengyeltóti János Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7967,
								"regio":"Drávafok",
								"name":"Pécsi Református Kollégium Csikesz Sándor Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7822,
								"regio":"Nagyharsány",
								"name":"Pécsi Református Kollégium Nagyharsányi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7629,
								"regio":"Pécs",
								"name":"Gandhi Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7633,
								"regio":"Pécs",
								"name":"Baptista Szeretetszolgálat EJSZ Széchenyi István Gimnáziuma, Szakközépiskolája, Általános Iskolája és Sportiskolája Radnóti utcai Telephely"
						});
						this.schoolsListArray.push({
								"zip":7623,
								"regio":"Pécs",
								"name":"Pécsi Kereskedelmi, Idegenforgalmi és Vendéglátóipari Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":7623,
								"regio":"Pécs",
								"name":"Pécsi Kereskedelmi, Idegenforgalmi és Vendéglátóipari Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":7700,
								"regio":"Mohács",
								"name":"Mohácsi Radnóti Miklós Szakképző Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7754,
								"regio":"Bóly",
								"name":"Montenuovo Nándor Szakközépiskola, Szakiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":6500,
								"regio":"Baja",
								"name":"Bajai Szentistváni Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Főiskola Petőfi Sándor Gyakorló Általános Iskola és Gyakorló Óvoda"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Református Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6400,
								"regio":"Kiskunhalas",
								"name":"Szent József Katolikus Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":6400,
								"regio":"Kiskunhalas",
								"name":"Kiskunhalasi Fazekas Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6400,
								"regio":"Kiskunhalas",
								"name":"Kiskunhalasi Felsővárosi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6400,
								"regio":"Kiskunhalas",
								"name":"Kiskunhalasi Kertvárosi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6522,
								"regio":"Gara",
								"name":"Garai Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6525,
								"regio":"Hercegszántó",
								"name":"Hercegszántói Horvát Tanítási Nyelvű Óvoda, Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":6525,
								"regio":"Hercegszántó",
								"name":"Hercegszántói Horvát Tanítási Nyelvű Óvoda, Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":6346,
								"regio":"Sükösd",
								"name":"Sükösdi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6512,
								"regio":"Szeremle",
								"name":"Szeremle-Dunafalva Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6513,
								"regio":"Dunafalva",
								"name":"Szeremle-Dunafalva Általános Iskola Dunafalvai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6521,
								"regio":"Vaskút",
								"name":"Vaskúti Német Nemzetiségi Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":6528,
								"regio":"Bátmonostor",
								"name":"Vaskúti Német Nemzetiségi Általános Iskola Becsei Töttös Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6344,
								"regio":"Hajós",
								"name":"Hajósi Szent Imre Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6343,
								"regio":"Miske",
								"name":"Hajósi Szent Imre Általános Iskola Miskei Tóth Menyhért Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6326,
								"regio":"Harta",
								"name":"Hartai Ráday Pál Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6326,
								"regio":"Harta",
								"name":"Hartai Ráday Pál Általános Iskola és Alapfokú Művészeti Iskola Templom Utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":6098,
								"regio":"Tass",
								"name":"Földváry Gábor Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6098,
								"regio":"Tass",
								"name":"Földváry Gábor Két Tanítási Nyelvű Általános Iskola Dunai út 1. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":6500,
								"regio":"Baja",
								"name":"Magyarországi Németek Általános Művelődési Központja"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Katona József Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Bolyai János Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6400,
								"regio":"Kiskunhalas",
								"name":"Kiskunhalasi Bibó István Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"ÁFEOSZ (Általános Fogyasztási Szövetkezetek és Kereskedelmi Társaságok Országos Szövetsége) Kereskedelmi, Közgazdasági Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5600,
								"regio":"Békéscsaba",
								"name":"Jankay Tibor Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5600,
								"regio":"Békéscsaba",
								"name":"Jankay Tibor Két Tanítási Nyelvű Általános Iskola Thurzó utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5600,
								"regio":"Békéscsaba",
								"name":"Jankay Tibor Két Tanítási Nyelvű Általános Iskola Dedinszky Gyula utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5540,
								"regio":"Szarvas",
								"name":"Benka Gyula Evangélikus Angol Két Tanítási Nyelvű Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":5500,
								"regio":"Gyomaendrőd",
								"name":"Gyomaendrődi Kis Bálint Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5500,
								"regio":"Gyomaendrőd",
								"name":"Gyomaendrődi Kis Bálint Általános Iskola Telephelye "
						});
						this.schoolsListArray.push({
								"zip":5502,
								"regio":"Gyomaendrőd",
								"name":"Rózsahegyi Kálmán Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5621,
								"regio":"Csárdaszállás",
								"name":"Rózsahegyi Kálmán Általános Iskola és Kollégium Csárdaszállási Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5720,
								"regio":"Sarkad",
								"name":"Sarkadi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5725,
								"regio":"Kötegyán",
								"name":"Sarkadi Általános Iskola Kötegyáni Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":5830,
								"regio":"Battonya",
								"name":"Battonyai Két Tanítási Nyelvű Szerb Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":5830,
								"regio":"Battonya",
								"name":"Magdu Lucian Román Általános Iskola és Óvoda "
						});
						this.schoolsListArray.push({
								"zip":5624,
								"regio":"Doboz",
								"name":"Dobozi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5553,
								"regio":"Kondoros",
								"name":"Kondorosi Petőfi István Általános és Alapfokú Művészeti Iskola, Kollégium Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5742,
								"regio":"Elek",
								"name":"Eleki Román Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5741,
								"regio":"Kétegyháza",
								"name":"Kétegyházi Márki Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5741,
								"regio":"Kétegyháza",
								"name":"Kétegyházi Román Nemzetiségi Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":5741,
								"regio":"Kétegyháza",
								"name":"Kétegyházi Román Nemzetiségi Általános Iskola és Óvoda Úttörő utca 83  szám alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5743,
								"regio":"Lőkösháza",
								"name":"Lökösházi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5743,
								"regio":"Lőkösháza",
								"name":"Lökösházi Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5940,
								"regio":"Tótkomlós",
								"name":"Szlovák Két Tanítási Nyelvű Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":5836,
								"regio":"Dombegyház",
								"name":"Balsaráti Vitus János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5836,
								"regio":"Dombegyház",
								"name":"Balsaráti Vitus János Általános Iskola Felszabadulás Utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5726,
								"regio":"Méhkerék",
								"name":"Méhkeréki Román Nemzetiségi Kétnyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5650,
								"regio":"Mezőberény",
								"name":"Mezőberényi Petőfi Sándor Evangélikus Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5720,
								"regio":"Sarkad",
								"name":"Ady Endre-Bay Zoltán Középiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5700,
								"regio":"Gyula",
								"name":"N. Balcescu Román Gimnázium, Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5600,
								"regio":"Békéscsaba",
								"name":"Békéscsabai Széchenyi István Két Tanítási Nyelvű Közgazdasági Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5630,
								"regio":"Békés",
								"name":"Szegedi Kis István Református Gimnázium, Általános Iskola, Óvoda és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5630,
								"regio":"Békés",
								"name":"Szegedi Kis István Református Gimnázium, Általános Iskola, Óvoda és Kollégium Alsó tagozata"
						});
						this.schoolsListArray.push({
								"zip":5630,
								"regio":"Békés",
								"name":"Szegedi Kis István Református Gimnázium, Általános Iskola, Óvoda és Kollégium Szánthó Albert utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":5630,
								"regio":"Békés",
								"name":"Szegedi Kis István Református Gimnázium, Általános Iskola, Óvoda és Kollégium Rákóczi utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":3780,
								"regio":"Edelény",
								"name":"Új Esély Oktatási Központ"
						});
						this.schoolsListArray.push({
								"zip":3731,
								"regio":"Szuhakálló",
								"name":"Kazincbarcikai Pollack Mihály Általános Iskola Gárdonyi Géza Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3627,
								"regio":"Domaháza",
								"name":"Ózdi Árpád Vezér Általános Iskola Domaházi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"Ózdi Árpád Vezér Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3661,
								"regio":"Ózd",
								"name":"Csépányi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"Ózdi Apáczai Csere János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"Ózdi Apáczai Csere János Általános Iskola Ózd, Kőalja út 147 sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3608,
								"regio":"Farkaslyuk",
								"name":"Farkaslyuki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"Ózdi Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"Sajóvárkonyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"Sajóvárkonyi Általános Iskola Mekcsey István út 118.sz alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3630,
								"regio":"Putnok",
								"name":"Péczeli József Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3529,
								"regio":"Miskolc",
								"name":"Miskolci Kazinczy Ferenc Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3519,
								"regio":"Miskolc",
								"name":"Miskolci Kazinczy Ferenc Magyar-Angol Két Tanítási Nyelvű Általános Iskola Miskolctapolcai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3530,
								"regio":"Miskolc",
								"name":"Miskolci Szabó Lőrinc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3527,
								"regio":"Miskolc",
								"name":"Selyemréti Református Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3526,
								"regio":"Miskolc",
								"name":"Miskolci Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3526,
								"regio":"Miskolc",
								"name":"Miskolci 10. Számú Petőfi Sándor Általános Iskola Rónai Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3526,
								"regio":"Miskolc",
								"name":"Miskolci 10. Számú Petőfi Sándor Általános Iskola-Kórházi Iskola"
						});
						this.schoolsListArray.push({
								"zip":3528,
								"regio":"Miskolc",
								"name":"Miskolci Arany János Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3535,
								"regio":"Miskolc",
								"name":"Diósgyőri Nagy Lajos Király Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3532,
								"regio":"Miskolc",
								"name":"Miskolci II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3532,
								"regio":"Miskolc",
								"name":"Miskolci II. Rákóczi Ferenc Általános Iskola Győri Kapui Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3534,
								"regio":"Miskolc",
								"name":"Miskolci Könyves Kálmán Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3534,
								"regio":"Miskolc",
								"name":"Miskolci Könyves Kálmán Általános Iskola és Alapfokú Művészeti Iskola Kaffka Margit Általános és Alapfokú Művészeti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3529,
								"regio":"Miskolc",
								"name":"Miskolci Szilágyi Dezső Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3516,
								"regio":"Miskolc",
								"name":"Miskolci Szilágyi Dezső Általános Iskola Görömbölyi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3534,
								"regio":"Miskolc",
								"name":"Bulgárföldi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3518,
								"regio":"Miskolc",
								"name":"Bulgárföldi Általános Iskola Erenyői Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3529,
								"regio":"Miskolc",
								"name":"Miskolci Herman Ottó Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3529,
								"regio":"Miskolc",
								"name":"Miskolci Herman Ottó Általános Iskola és Alapfokú Művészeti Iskola Munkácsy Mihály Általános és Alapfokú Művészeti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3524,
								"regio":"Miskolc",
								"name":"Avastetői Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3524,
								"regio":"Miskolc",
								"name":"Avastetői Általános Iskola és Alapfokú Művészeti Iskola Széchenyi István Általános és Alapfokú Művészeti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3533,
								"regio":"Miskolc",
								"name":"Komlóstetői Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3534,
								"regio":"Miskolc",
								"name":"Miskolc-Diósgyőri Református Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":3811,
								"regio":"Alsóvadász",
								"name":"Alsóvadászi Tompa Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3841,
								"regio":"Aszaló",
								"name":"Göőz József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3837,
								"regio":"Csenyéte",
								"name":"Baktakéki Körzeti Általános Iskola Csenyétei Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3885,
								"regio":"Boldogkőváralja",
								"name":"Boldogkőváraljai Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3814,
								"regio":"Felsővadász",
								"name":"Felsővadászi II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3849,
								"regio":"Forró",
								"name":"Forrói Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3895,
								"regio":"Gönc",
								"name":"Károlyi Gáspár Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3842,
								"regio":"Halmaj",
								"name":"Halmaji Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3876,
								"regio":"Hidasnémeti",
								"name":"Hidasnémeti II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3831,
								"regio":"Kázsmárk",
								"name":"Fogarasi János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3832,
								"regio":"Léh",
								"name":"Fogarasi János Általános Iskola Léhi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3821,
								"regio":"Krasznokvajda",
								"name":"Béres Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3871,
								"regio":"Méra",
								"name":"Dayka Gábor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3863,
								"regio":"Szalaszend",
								"name":"Szalaszendi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3864,
								"regio":"Fulókércs",
								"name":"Szalaszendi Körzeti Általános Iskola Fulókércsi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3891,
								"regio":"Vilmány",
								"name":"Vilmányi II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3888,
								"regio":"Vizsoly",
								"name":"Vizsolyi Rákóczi Zsigmond Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3744,
								"regio":"Múcsony",
								"name":"Kalász László Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3741,
								"regio":"Izsófalva",
								"name":"Kalász László Általános Iskola Izsó Miklós Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3643,
								"regio":"Dédestapolcsány",
								"name":"Lajos Árpád Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3732,
								"regio":"Kurityán",
								"name":"Kurityáni Kossuth Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3742,
								"regio":"Rudolftelep",
								"name":"Kurityáni Kossuth Lajos Általános Iskola Mikoviny Sámuel Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3724,
								"regio":"Ragály",
								"name":"Ragályi Balassi Bálint Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3723,
								"regio":"Zubogy",
								"name":"Ragályi Balassi Bálint Általános Iskola Zubogyi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3733,
								"regio":"Rudabánya",
								"name":"Gvadányi József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3735,
								"regio":"Felsőtelekes",
								"name":"Gvadányi József Általános Iskola Telekes Béla Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3720,
								"regio":"Sajókaza",
								"name":"Sajókazai Balassi Bálint Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3467,
								"regio":"Ároktő",
								"name":"Dr. Mészáros Kálmán Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3593,
								"regio":"Hejőbába",
								"name":"Hejőbábai Zrínyi Ilona Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3594,
								"regio":"Hejőpapi",
								"name":"Hejőpapi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3599,
								"regio":"Sajószöged",
								"name":"Sajószögedi Kölcsey Ferenc Körzeti Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3713,
								"regio":"Arnót",
								"name":"Arnóti Weöres Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3578,
								"regio":"Girincs",
								"name":"Dőry Ferenc Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3564,
								"regio":"Hernádnémeti",
								"name":"Hernádnémeti Református Általános Iskola, Két Tanítási Nyelvű és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3579,
								"regio":"Kesznyéten",
								"name":"Kesznyéteni Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3777,
								"regio":"Parasznya",
								"name":"Pitypalatty-völgyi Református Körzeti Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3576,
								"regio":"Sajóhídvég",
								"name":"Rákóczi Julianna Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3663,
								"regio":"Arló",
								"name":"Arlói Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3663,
								"regio":"Arló",
								"name":"Arlói Széchenyi István Általános Iskola Rákóczi út 14/A. sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3663,
								"regio":"Arló",
								"name":"Arlói Széchenyi István Általános Iskola Rákóczi út 3. sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3663,
								"regio":"Arló",
								"name":"Arlói Széchenyi István Általános Iskola Rákóczi út 3/B. sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3663,
								"regio":"Arló",
								"name":"Arlói Széchenyi István Általános Iskola Rákóczi út 3/C. sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3654,
								"regio":"Bánréve",
								"name":"Szent Mihály Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3729,
								"regio":"Serényfalva",
								"name":"Szent Mihály Katolikus Általános Iskola - Serényfalvai Katolikus Általános Iskola Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3658,
								"regio":"Borsodbóta",
								"name":"Borsodbótai Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3664,
								"regio":"Járdánháza",
								"name":"Járdánházi IV. Béla Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3958,
								"regio":"Hercegkút",
								"name":"Gyöngyszem Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3937,
								"regio":"Komlóska",
								"name":"Komlóskai Ruszin Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3973,
								"regio":"Cigánd",
								"name":"Kántor Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3973,
								"regio":"Cigánd",
								"name":"Kántor Mihály Általános Iskola Cigánd, Iskola utca 12/a sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3963,
								"regio":"Karcsa",
								"name":"Karcsai Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3974,
								"regio":"Ricse",
								"name":"Ricsei II. Rákóczi Ferenc Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3971,
								"regio":"Tiszakarád",
								"name":"Sánta Erzsébet Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3881,
								"regio":"Abaújszántó",
								"name":"Ilosvai Selymes Péter Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3896,
								"regio":"Telkibánya",
								"name":"Ilosvai Selymes Péter Általános Iskola és Alapfokú Művészeti Iskola Telkibányai Szepsi Csombor Márton Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3718,
								"regio":"Megyaszó",
								"name":"Megyaszói Mészáros Lőrinc Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3717,
								"regio":"Alsódobsza",
								"name":"Megyaszói Mészáros Lőrinc Körzeti Általános Iskola Alsódobszai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3931,
								"regio":"Mezőzombor",
								"name":"Mezőzombori Kölcsey Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3925,
								"regio":"Prügy",
								"name":"Prügyi Móricz Zsigmond Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3908,
								"regio":"Rátka",
								"name":"Rátkai Német Nemzetiségi, Kéttannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3922,
								"regio":"Taktaharkány",
								"name":"Taktaharkányi Apáczai Csere János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3921,
								"regio":"Taktaszada",
								"name":"Taktaszadai Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3565,
								"regio":"Tiszalúc",
								"name":"Tiszalúci Arany János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3926,
								"regio":"Taktabáj",
								"name":"Patay Sámuel Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3763,
								"regio":"Bódvaszilas",
								"name":"Bódvaszilasi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3768,
								"regio":"Hidvégardó",
								"name":"Bódvaszilasi Körzeti Általános Iskola Hídvégardói Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3756,
								"regio":"Perkupa",
								"name":"Bódvaszilasi Körzeti Általános Iskola Stépán Ilona Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3794,
								"regio":"Boldva",
								"name":"Szathmáry Király Ádám Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3795,
								"regio":"Nyomár",
								"name":"Szathmáry Király Ádám Körzeti Általános Iskola Nyomári Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3796,
								"regio":"Borsodszirák",
								"name":"Borsodsziráki Bartók Béla Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3786,
								"regio":"Lak",
								"name":"Laki Körzeti Általános Iskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":3825,
								"regio":"Rakaca",
								"name":"Rakacai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3754,
								"regio":"Szalonna",
								"name":"Szalonnai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3752,
								"regio":"Szendrő",
								"name":"Szendrői Apáczai Csere János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3751,
								"regio":"Szendrőlád",
								"name":"Szendrőládi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3761,
								"regio":"Szin",
								"name":"Szini Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3759,
								"regio":"Aggtelek",
								"name":"Aggteleki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3525,
								"regio":"Miskolc",
								"name":"Miskolci Herman Ottó Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":3534,
								"regio":"Miskolc",
								"name":"Diósgyőri Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":3530,
								"regio":"Miskolc",
								"name":"Miskolci Zrínyi Ilona Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":3524,
								"regio":"Miskolc",
								"name":"Avasi Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":3525,
								"regio":"Miskolc",
								"name":"Berzeviczy Gergely Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":3525,
								"regio":"Miskolc",
								"name":"Földes Ferenc Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6600,
								"regio":"Szentes",
								"name":"Szentesi Deák Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6722,
								"regio":"Szeged",
								"name":"Béke Utcai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6723,
								"regio":"Szeged",
								"name":"Tarjáni Kéttannyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6791,
								"regio":"Szeged",
								"name":"Szegedi Orczy István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6721,
								"regio":"Szeged",
								"name":"Szegedi Madách Imre Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6800,
								"regio":"Hódmezővásárhely",
								"name":"Bethlen Gábor Református Gimnázium és Szathmáry Kollégium"
						});
						this.schoolsListArray.push({
								"zip":6722,
								"regio":"Szeged",
								"name":"Szegedi Tudományegyetem Ságvári Endre Gyakorló Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6723,
								"regio":"Szeged",
								"name":"Szegedi Deák Ferenc Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6720,
								"regio":"Szeged",
								"name":"Szegedi Tömörkény István Gimnázium és Művészeti Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":6900,
								"regio":"Makó",
								"name":"Szent István Egyházi Általános Iskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Petőfi Sándor Általános Iskola Lovarda utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Petőfi Sándor Általános Iskola Wekerle Sándor utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Dr. Zimmermann Ágoston Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Szent Erzsébet Római Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8000,
								"regio":"Székesfehérvár",
								"name":"Székesfehérvári II. Rákóczi Ferenc Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8000,
								"regio":"Székesfehérvár",
								"name":"Felsővárosi Általános Iskola, Oberstädtische Grundschule"
						});
						this.schoolsListArray.push({
								"zip":8096,
								"regio":"Sukoró",
								"name":"Felsővárosi Általános Iskola Sukorói Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8000,
								"regio":"Székesfehérvár",
								"name":"Comenius Angol-Magyar Két Tanítási Nyelvi Általános Iskola, Gimnázium és Gazdasági Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":8000,
								"regio":"Székesfehérvár",
								"name":"Comenius Angol-Magyar Két Tanítási Nyelvi Általános Iskola, Gimnázium és Gazdasági Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":8000,
								"regio":"Székesfehérvár",
								"name":"Comenius Angol-Magyar Két Tanítási Nyelvi Általános Iskola, Gimnázium és Gazdasági Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":2455,
								"regio":"Beloiannisz",
								"name":"Nikosz Beloiannisz Általános Művelődési Központ"
						});
						this.schoolsListArray.push({
								"zip":2422,
								"regio":"Mezőfalva",
								"name":"Mezőfalvi Petőfi Sándor Általános Iskola, Előkészítő Szakiskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8082,
								"regio":"Gánt",
								"name":"Esterházy Móric Nyelvoktató Német Nemzetiségi Általános Iskola Gánti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2065,
								"regio":"Mány",
								"name":"Hársfadombi Nyelvoktató Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8085,
								"regio":"Vértesboglár",
								"name":"Vértesboglári Nyelvoktató Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Táncsics Mihály Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":8000,
								"regio":"Székesfehérvár",
								"name":"Székesfehérvári Széchenyi István Műszaki Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":9200,
								"regio":"Mosonmagyaróvár",
								"name":"Haller János Általános Iskola, Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":9200,
								"regio":"Mosonmagyaróvár",
								"name":"Haller János Általános Iskola, Szakközépiskola és Szakiskola 002-es Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9231,
								"regio":"Máriakálnok",
								"name":"Haller János Általános Iskola, Szakközépiskola és Szakiskola 003-as Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9200,
								"regio":"Mosonmagyaróvár",
								"name":"Mosonmagyaróvári Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9400,
								"regio":"Sopron",
								"name":"Soproni Német Nemzetiségi Általános Iskola - Deutsche Nationalitätenschule Ödenburg"
						});
						this.schoolsListArray.push({
								"zip":9400,
								"regio":"Sopron",
								"name":"Hunyadi János Evangélikus Óvoda és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9024,
								"regio":"Győr",
								"name":"Győri Arany János Angol-Német Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9028,
								"regio":"Győr",
								"name":"Szabadhegyi Magyar-Német Két Tanítási Nyelvű Általános Iskola és Középiskola"
						});
						this.schoolsListArray.push({
								"zip":9144,
								"regio":"Kóny",
								"name":"Kónyi Deák Ferenc Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9161,
								"regio":"Győrsövényház",
								"name":"Kónyi Deák Ferenc Általános Iskola és Alapfokú Művészeti Iskola Győrsövönyházi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":9095,
								"regio":"Táp",
								"name":"Tápi József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9085,
								"regio":"Pázmándfalu",
								"name":"Tápi József Attila Általános Iskola Pázmándfalui Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":9223,
								"regio":"Bezenye",
								"name":"Bezenyei Horvát‒Magyar Kétnyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9233,
								"regio":"Lipót",
								"name":"Szigetköz Körzeti Általános Iskola és Alapfokú Művészeti Iskola Magyar-Angol Két Tanítási Nyelvű Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":9181,
								"regio":"Kimle",
								"name":"Kimlei Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9221,
								"regio":"Levél",
								"name":"Levéli Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9221,
								"regio":"Levél",
								"name":"Levéli Német Nemzetiségi Általános Iskola 002"
						});
						this.schoolsListArray.push({
								"zip":9155,
								"regio":"Lébény",
								"name":"Lébényi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9155,
								"regio":"Lébény",
								"name":"Lébényi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9155,
								"regio":"Lébény",
								"name":"Lébényi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9162,
								"regio":"Bezi",
								"name":"Lébényi Általános Iskola és Alapfokú Művészeti Iskola Bezi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":9423,
								"regio":"Ágfalva",
								"name":"Ágfalvi Váci Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9423,
								"regio":"Ágfalva",
								"name":"Ágfalvi Váci Mihály Általános Iskola 002-es Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9431,
								"regio":"Fertőd",
								"name":"Babos József Térségi Általános Iskola 004-es Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9421,
								"regio":"Fertőrákos",
								"name":"Fertőrákosi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9495,
								"regio":"Kópháza",
								"name":"Nakovich Mihály Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":9463,
								"regio":"Sopronhorpács",
								"name":"Sopronhorpácsi Általános Iskola Fő u. 5. sz. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":9400,
								"regio":"Sopron",
								"name":"Berzsenyi Dániel Evangélikus (Líceum) Gimnázium, Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":9200,
								"regio":"Mosonmagyaróvár",
								"name":"Mosonmagyaróvári Kossuth Lajos Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":9021,
								"regio":"Győr",
								"name":"Jedlik Ányos Gépipari és Informatikai Középiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":9024,
								"regio":"Győr",
								"name":"Győri Krúdy Gyula Gimnázium, Két Tanítási Nyelvű Középiskola, Idegenforgalmi és Vendéglátóipari Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":9024,
								"regio":"Győr",
								"name":"Baross Gábor Közgazdasági és Két Tanítási Nyelvű Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":4200,
								"regio":"Hajdúszoboszló",
								"name":"Gönczy Pál Sport és Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4200,
								"regio":"Hajdúszoboszló",
								"name":"Thököly Imre Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4242,
								"regio":"Hajdúhadház",
								"name":"Földi János Két Tanítási Nyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4242,
								"regio":"Hajdúhadház",
								"name":"Földi János Két Tanítási Nyelvű Általános Iskola és Alapfokú Művészeti Iskola Szilágyi Dániel Úti Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4025,
								"regio":"Debrecen",
								"name":"Debreceni Fazekas Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4031,
								"regio":"Debrecen",
								"name":"Lilla Téri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4031,
								"regio":"Debrecen",
								"name":"Lilla Téri Általános Iskola Bartók Béla úti telephelye"
						});
						this.schoolsListArray.push({
								"zip":4116,
								"regio":"Berekböszörmény",
								"name":"Berekböszörményi Kossuth Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4133,
								"regio":"Konyár",
								"name":"Derecskei Bocskai István Általános Iskola és Alapfokú Művészeti Iskola II. Rákóczi Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":4133,
								"regio":"Konyár",
								"name":"Bocskai István Általános Iskola és Alapfokú Művészeti Iskola II. Rákóczi Ferenc Tagiskolája Konyár Rákóczi Utca 9. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4141,
								"regio":"Furta",
								"name":"Furtai Bessenyei György Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4141,
								"regio":"Furta",
								"name":"Furtai Bessenyei György Általános Iskola Furta Petőfi utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":4135,
								"regio":"Körösszegapáti",
								"name":"Magyarhomorogi Szabó Pál Általános Iskola Körösszegapáti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":4142,
								"regio":"Zsáka",
								"name":"Zsákai Kölcsey Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4211,
								"regio":"Ebes",
								"name":"Ebesi Arany János Magyar-Angol Két Tanítási Nyelvű Általános és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4212,
								"regio":"Hajdúszovát",
								"name":"Diószegi Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4174,
								"regio":"Bihartorda",
								"name":"Nagyrábéi Móricz Zsigmond Általános Iskola Bihartordai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4032,
								"regio":"Debrecen",
								"name":"Debreceni Csokonai Vitéz Mihály Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":4025,
								"regio":"Debrecen",
								"name":"Debreceni Fazekas Mihály Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":4024,
								"regio":"Debrecen",
								"name":"Debreceni Ady Endre Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":4024,
								"regio":"Debrecen",
								"name":"Debreceni Irinyi János Gimnázium, Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":4025,
								"regio":"Debrecen",
								"name":"Mechwart András Gépipari és Informatikai Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":4026,
								"regio":"Debrecen",
								"name":"Debreceni Bethlen Gábor Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":4027,
								"regio":"Debrecen",
								"name":"Dienes László Gimnázium és Egészségügyi Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":4024,
								"regio":"Debrecen",
								"name":"Debreceni Vegyipari Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":3300,
								"regio":"Eger",
								"name":"Egri Arany János Általános Iskola, Szakiskola, Speciális Szakiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":3200,
								"regio":"Gyöngyös",
								"name":"Gyöngyösi Egressy Béni Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3346,
								"regio":"Bélapátfalva",
								"name":"Bélapátfalvai Petőfi Sándor Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3396,
								"regio":"Kerecsend",
								"name":"Kerecsendi Magyary Károly Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3258,
								"regio":"Tarnalelesz",
								"name":"Utassy József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3257,
								"regio":"Bükkszenterzsébet",
								"name":"Utassy József Általános Iskola Bükkszenterzsébeti Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3351,
								"regio":"Verpelét",
								"name":"Verpeléti Arany János Általános Iskola és Reményi Ede Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3273,
								"regio":"Halmajugra",
								"name":"Halmajugrai Arany János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3264,
								"regio":"Kisnána",
								"name":"Kisnánai Szent Imre Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3235,
								"regio":"Mátraszentimre",
								"name":"Felső-Mátrai Zakupszky László Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":3282,
								"regio":"Nagyfüged",
								"name":"Nagyfügedi Arany János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3015,
								"regio":"Csány",
								"name":"Csányi Szent György Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3358,
								"regio":"Erdőtelek",
								"name":"Erdőteleki Mikszáth Kálmán Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3283,
								"regio":"Tarnazsadány",
								"name":"Erdőteleki Mikszáth Kálmán Általános Iskola Tarnazsadányi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3384,
								"regio":"Kisköre",
								"name":"Kiskörei Vásárhelyi Pál Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3294,
								"regio":"Tarnaörs",
								"name":"Tarnaörs-Boconádi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3356,
								"regio":"Kompolt",
								"name":"Kompolt-Nagyúti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3388,
								"regio":"Poroszló",
								"name":"Poroszlói Vass Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3386,
								"regio":"Sarud",
								"name":"Poroszlói Vass Lajos Általános Iskola Sarudi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3300,
								"regio":"Eger",
								"name":"Neumann János Középiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":3304,
								"regio":"Eger",
								"name":"Egri Pásztorvölgyi Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":3300,
								"regio":"Eger",
								"name":"Gárdonyi Géza Ciszterci Gimnázium, Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":3300,
								"regio":"Eger",
								"name":"Andrássy György Katolikus Közgazdasági Középiskola"
						});
						this.schoolsListArray.push({
								"zip":2510,
								"regio":"Dorog",
								"name":"Dorogi Magyar-Angol Két Tanítási Nyelvű és Sportiskolai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2510,
								"regio":"Dorog",
								"name":"Dorogi Magyar-Angol Két Tanítási Nyelvű és Sportiskolai Általános Iskola Zrínyi Ilona Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2500,
								"regio":"Esztergom",
								"name":"Pázmány Péter Katolikus Egyetem Vitéz János Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2800,
								"regio":"Tatabánya",
								"name":"Sárberki Általános Iskola Telephelye  "
						});
						this.schoolsListArray.push({
								"zip":2536,
								"regio":"Nyergesújfalu",
								"name":"Nyergesújfalui Kernstok Károly Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2521,
								"regio":"Csolnok",
								"name":"Csolnok és Környéke Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2529,
								"regio":"Annavölgy",
								"name":"Sárisáp és Környéke Körzeti Általános Iskola Cser Simon Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2522,
								"regio":"Dág",
								"name":"Sárisáp és Környéke Körzeti Általános Iskola Dági Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2523,
								"regio":"Sárisáp",
								"name":"Sárisáp és Környéke Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2528,
								"regio":"Úny",
								"name":"Sárisáp és Környéke Körzeti Általános Iskola Dági Tagiskolája Únyi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2534,
								"regio":"Tát",
								"name":"Táti III. Béla Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2534,
								"regio":"Tát",
								"name":"Táti III. Béla Általános Iskola Fő úti telephelye"
						});
						this.schoolsListArray.push({
								"zip":2535,
								"regio":"Mogyorósbánya",
								"name":"Táti III. Béla Általános Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2944,
								"regio":"Bana",
								"name":"Banai Jókai Mór Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2836,
								"regio":"Baj",
								"name":"Baji Szent István Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2831,
								"regio":"Tarján",
								"name":"Tarjáni Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2832,
								"regio":"Héreg",
								"name":"Tarjáni Német Nemzetiségi Általános Iskola Héregi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":2833,
								"regio":"Vértestolna",
								"name":"Tarjáni Német Nemzetiségi Általános Iskola Vértestolnai Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":2837,
								"regio":"Vértesszőlős",
								"name":"Vértesszőlősi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2822,
								"regio":"Szomor",
								"name":"Kézdi-Vásárhelyi Imre Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2890,
								"regio":"Tata",
								"name":"Talentum Angol Magyar Két Tanítási Nyelvű Általános Iskola, Gimnázium és Művészeti Szakközépiskola "
						});
						this.schoolsListArray.push({
								"zip":3142,
								"regio":"Mátraszele",
								"name":"Salgótarjáni Általános Iskola Gárdonyi Géza Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3100,
								"regio":"Salgótarján",
								"name":"Salgótarjáni Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":2687,
								"regio":"Bercel",
								"name":"Berceli Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2693,
								"regio":"Becske",
								"name":"Berceli Széchenyi István Általános Iskola Móra Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2686,
								"regio":"Galgaguta",
								"name":"Berceli Széchenyi István Általános Iskola Kincskereső Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2671,
								"regio":"Őrhalom",
								"name":"Őrhalmi József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2699,
								"regio":"Szügy",
								"name":"Szügyi Madách Imre Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2696,
								"regio":"Terény",
								"name":"Bujáki Szent-Györgyi Albert Általános Iskola Terényi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2176,
								"regio":"Erdőkürt",
								"name":"Wilczek Frigyes Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2177,
								"regio":"Erdőtarcsa",
								"name":"Kállói II. Rákóczi Ferenc Általános Iskola Erdőtarcsai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2175,
								"regio":"Kálló",
								"name":"Kállói II. Rákóczi Ferenc Ált. Iskola Alsó Tagozata"
						});
						this.schoolsListArray.push({
								"zip":2175,
								"regio":"Kálló",
								"name":"Kállói II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3041,
								"regio":"Héhalom",
								"name":"Héhalmi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3043,
								"regio":"Egyházasdengeleg",
								"name":"Héhalmi Általános Iskola Egyházasdengelegi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2688,
								"regio":"Vanyarc",
								"name":"Veres Pálné Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3045,
								"regio":"Bér",
								"name":"Veres Pálné Általános Iskola Béri Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3123,
								"regio":"Cered",
								"name":"Id. Szabó István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3186,
								"regio":"Litke",
								"name":"Etesi Általános Iskola Litkei Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3183,
								"regio":"Karancskeszi",
								"name":"Platthy József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3182,
								"regio":"Karancslapujtő",
								"name":"Mocsáry Antal Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3182,
								"regio":"Karancslapujtő",
								"name":"Mocsáry Antal Általános Iskola és Alapfokú Művészeti Iskola Petőfi út 13. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3163,
								"regio":"Karancsság",
								"name":"Karancssági I. István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3133,
								"regio":"Magyargéc",
								"name":"Magyargéci Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3131,
								"regio":"Sóshartyán",
								"name":"Magyargéci Gárdonyi Géza Általános Iskola Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3177,
								"regio":"Rimóc",
								"name":"Rimóci Szent István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3177,
								"regio":"Rimóc",
								"name":"Szent István Általános Iskola 1-4.osztály"
						});
						this.schoolsListArray.push({
								"zip":3132,
								"regio":"Nógrádmegyer",
								"name":"Rimóci Szent István Általános Iskola Mikszáth Kálmán Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3162,
								"regio":"Ságújfalu",
								"name":"Ságújfalui Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3129,
								"regio":"Lucfalva",
								"name":"Lucfalvi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2646,
								"regio":"Drégelypalánk",
								"name":"Drégelypalánki Szondi György Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2618,
								"regio":"Nézsa",
								"name":"Nézsai Mikszáth Kálmán Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2642,
								"regio":"Nógrád",
								"name":"Hesz Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2610,
								"regio":"Nőtincs",
								"name":"Nőtincsi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2611,
								"regio":"Felsőpetény",
								"name":"Nőtincsi Általános Iskola Felsőpetényi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2640,
								"regio":"Szendehely",
								"name":"Szendehelyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2652,
								"regio":"Tereske",
								"name":"Tereskei Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3100,
								"regio":"Salgótarján",
								"name":"Salgótarjáni Bolyai János Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":3060,
								"regio":"Pásztó",
								"name":"Mikszáth Kálmán Líceum Fő úti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2685,
								"regio":"Nógrádsáp",
								"name":"Nógrádsápi Fekete István Általános Iskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":2131,
								"regio":"Göd",
								"name":"Huzella Tivadar Két Tanítási Nyelvű Általános Iskola 001-es Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2049,
								"regio":"Diósd",
								"name":"Diósdi Eötvös József Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2049,
								"regio":"Diósd",
								"name":"Diósdi Eötvös József Német Nemzetiségi  Általános Iskola, Gárdonyi Géza utca 9. Telephely"
						});
						this.schoolsListArray.push({
								"zip":2141,
								"regio":"Csömör",
								"name":"Csömöri Mátyás Király Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2141,
								"regio":"Csömör",
								"name":" Csömöri Mátyás Király Általános Iskola Szabadság úti telephelye"
						});
						this.schoolsListArray.push({
								"zip":2181,
								"regio":"Iklad",
								"name":"Ikladi Tasnádi Lajos Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2182,
								"regio":"Domony",
								"name":"Ikladi Tasnádi Lajos Német Nemzetiségi Általános Iskola Koren István Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2144,
								"regio":"Kerepes",
								"name":"Kerepesi Széchenyi István Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2011,
								"regio":"Budakalász",
								"name":"Kalász Suli Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2023,
								"regio":"Dunabogdány",
								"name":"Dunabogdányi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2095,
								"regio":"Pilisszántó",
								"name":"Pilisszántói Szlovák Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2098,
								"regio":"Pilisszentkereszt",
								"name":"Pilisszentkereszti Szlovák Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2025,
								"regio":"Visegrád",
								"name":"Visegrádi Áprily Lajos Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2024,
								"regio":"Kisoroszi",
								"name":"Visegrádi Áprily Lajos Általános Iskola Kisoroszi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2013,
								"regio":"Pomáz",
								"name":"Pomázi Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2683,
								"regio":"Acsa",
								"name":"Acsai Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2615,
								"regio":"Csővár",
								"name":"Acsai Petőfi Sándor Általános Iskola Csővári Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2626,
								"regio":"Nagymaros",
								"name":"Nagymarosi Kittenberger Kálmán Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2626,
								"regio":"Nagymaros",
								"name":"Nagymarosi Kittenberger Kálmán Általános Iskola és Alapfokú Művészeti Iskola Váci úti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2682,
								"regio":"Püspökhatvan",
								"name":"Püspökhatvani Bene József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2627,
								"regio":"Zebegény",
								"name":"Szőnyi István Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2093,
								"regio":"Budajenő",
								"name":"Budajenői Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2092,
								"regio":"Budakeszi",
								"name":"Budakeszi Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2071,
								"regio":"Páty",
								"name":"Bocskai István Magyar-Német Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2074,
								"regio":"Perbál",
								"name":"Kis-forrás Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2084,
								"regio":"Pilisszentiván",
								"name":"Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2085,
								"regio":"Pilisvörösvár",
								"name":"Pilisvörösvári Templom Téri Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2083,
								"regio":"Solymár",
								"name":"Solymári Hunyadi Mátyás Német Nemzetiségi Általános Iskola, Alapfokú Művészeti Iskola "
						});
						this.schoolsListArray.push({
								"zip":2083,
								"regio":"Solymár",
								"name":"Solymári Hunyadi Mátyás Német Nemzetiségi Általános Iskola, Alapfokú Művészeti Iskola Bajcsy-Zsilinszky utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2045,
								"regio":"Törökbálint",
								"name":"Zimándy Ignác Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2097,
								"regio":"Pilisborosjenő",
								"name":"Pilisborosjenői Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2072,
								"regio":"Zsámbék",
								"name":"Zsámbéki Zichy Miklós Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2085,
								"regio":"Pilisvörösvár",
								"name":"Pilisvörösvári Német Nemzetiségi Általános Iskola Deutsche Nationalitätenschule Werischwar"
						});
						this.schoolsListArray.push({
								"zip":2330,
								"regio":"Dunaharaszti",
								"name":"Dunaharaszti Hunyadi János Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2330,
								"regio":"Dunaharaszti",
								"name":"Dunaharaszti Hunyadi János Német Nemzetiségi Általános Iskola Fő úti Telephely"
						});
						this.schoolsListArray.push({
								"zip":2330,
								"regio":"Dunaharaszti",
								"name":"Dunaharaszti II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2330,
								"regio":"Dunaharaszti",
								"name":"Dunaharaszti II. Rákóczi Ferenc Általános Iskola Rákóczi utca 1. szám alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2330,
								"regio":"Dunaharaszti",
								"name":"Dunaharaszti Kőrösi Csoma Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2335,
								"regio":"Taksony",
								"name":"Taksony Vezér Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2316,
								"regio":"Tököl",
								"name":"Tököli Weöres Sándor Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":2316,
								"regio":"Tököl",
								"name":"Tököli Weöres Sándor Általános Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2366,
								"regio":"Kakucs",
								"name":"Kakucsi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2377,
								"regio":"Örkény",
								"name":"Huszka Hermina Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2375,
								"regio":"Tatárszentgyörgy",
								"name":"Tatárszentgyörgyi II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2367,
								"regio":"Újhartyán",
								"name":"Újhartyáni Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2220,
								"regio":"Vecsés",
								"name":"GRASSALKOVICH ANTAL NÉMET NEMZETISÉGI ÉS KÉTNYELVŰ ÁLTALÁNOS ISKOLA"
						});
						this.schoolsListArray.push({
								"zip":2336,
								"regio":"Dunavarsány",
								"name":"Dunavarsányi Árpád Fejedelem Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2336,
								"regio":"Dunavarsány",
								"name":"Dunavarsányi Árpád Fejedelem Általános Iskola Kossuth Lajos utca 33.alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2336,
								"regio":"Dunavarsány",
								"name":"Dunavarsányi Árpád Fejedelem Általános Iskola Bartók Béla utca 25. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2322,
								"regio":"Makád",
								"name":"Szigetbecse-Makád Általános Iskola Thúry József Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":2321,
								"regio":"Szigetbecse",
								"name":"Szigetbecse-Makád Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2317,
								"regio":"Szigetcsép",
								"name":"Szigetcsépi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2318,
								"regio":"Szigetszentmárton",
								"name":"Szigetszentmártoni Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2319,
								"regio":"Szigetújfalu",
								"name":"Szigetújfalui Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2170,
								"regio":"Aszód",
								"name":"Petőfi Sándor Gimnázium, Gépészeti Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":2100,
								"regio":"Gödöllő",
								"name":"Gödöllői Török Ignác Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":2600,
								"regio":"Vác",
								"name":"Boronkay György Műszaki Szakközépiskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":4945,
								"regio":"Szatmárcseke",
								"name":"Szatmárcsekei Kölcsey Ferenc Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4700,
								"regio":"Mátészalka",
								"name":"Mátészalkai Móricz Zsigmond Magyar- Angol Kéttannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4400,
								"regio":"Nyíregyháza",
								"name":"Túróczy Zoltán Evangélikus Óvoda és Magyar-Angol Két Tanítási Nyelvű Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":4955,
								"regio":"Botpalád",
								"name":"Szabó Magda Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4732,
								"regio":"Cégénydányád",
								"name":"Cégénydányádi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4967,
								"regio":"Csaholc",
								"name":"Csaholci Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4741,
								"regio":"Jánkmajtis",
								"name":"Jánkmajtisi Móricz Zsigmond Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4742,
								"regio":"Csegöld",
								"name":"Jánkmajtisi Móricz Zsigmond Általános Iskola Csegöldi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4921,
								"regio":"Kisar",
								"name":"Kisari Kölcsey Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4965,
								"regio":"Kölcse",
								"name":"Kölcsei Kölcsey Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4975,
								"regio":"Méhtelek",
								"name":"Méhteleki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4971,
								"regio":"Rozsály",
								"name":"Maróthy János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4951,
								"regio":"Tiszabecs",
								"name":"Tiszabecsi II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4731,
								"regio":"Tunyogmatolcs",
								"name":"Tunyogmatolcsi Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4944,
								"regio":"Túristvándi",
								"name":"Túristvándi Molnár Mátyás Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4943,
								"regio":"Kömörő",
								"name":"Túristvándi Molnár Mátyás Általános Iskola Kömörői Taginzézménye"
						});
						this.schoolsListArray.push({
								"zip":4646,
								"regio":"Eperjeske",
								"name":"Eperjeskei Arany János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4644,
								"regio":"Mándok",
								"name":"Mándoki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4631,
								"regio":"Pap",
								"name":"Papi Kölcsey Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4633,
								"regio":"Lövőpetri",
								"name":"Papi Kölcsey Ferenc Általános Iskola Lövőpetri Telephelye "
						});
						this.schoolsListArray.push({
								"zip":4634,
								"regio":"Aranyosapáti",
								"name":"Papi Kölcsey Ferenc Általános Iskola Aranyosapáti Tagiskolája "
						});
						this.schoolsListArray.push({
								"zip":4523,
								"regio":"Pátroha",
								"name":"Pátrohai Móricz Zsigmond Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4525,
								"regio":"Rétközberencs",
								"name":"I. István Király Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4493,
								"regio":"Tiszakanyár",
								"name":"Tiszakanyári Hunyadi Mátyás Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4623,
								"regio":"Tuzsér",
								"name":"Lónyay Menyhért Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4624,
								"regio":"Tiszabezdéd",
								"name":"Lónyay Menyhért Általános Iskola Tiszabezdédi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4752,
								"regio":"Győrtelek",
								"name":"Győrteleki Fekete István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4751,
								"regio":"Kocsord",
								"name":"Kocsordi Jókai Mór Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4352,
								"regio":"Mérk",
								"name":"Mérk-Vállaj Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4351,
								"regio":"Vállaj",
								"name":"Mérk-Vállaj  Német Nemzetiségi Általános Iskola Vállaji Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4822,
								"regio":"Nyírparasznya",
								"name":"Nyírparasznyai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4821,
								"regio":"Ópályi",
								"name":"Ópályi Jókai Mór Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4761,
								"regio":"Porcsalma",
								"name":"Porcsalmai Kiss Áron Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4326,
								"regio":"Máriapócs",
								"name":"Máriapócsi Magyar-Angol Két Tanítási Nyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4372,
								"regio":"Nyírbéltek",
								"name":"Nyírbélteki Szent László Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4373,
								"regio":"Ömböly",
								"name":"Nyírbélteki Szent László Általános Iskola Ömbölyi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4363,
								"regio":"Nyírmihálydi",
								"name":"Nyírmihálydi Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4376,
								"regio":"Nyírpilis",
								"name":"Nyírpilisi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4561,
								"regio":"Baktalórántháza",
								"name":"Baktalórántházi Reguly Antal Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4483,
								"regio":"Buj",
								"name":"Buji II. Rákóczi Ferenc Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4445,
								"regio":"Nagycserkesz",
								"name":"Nagycserkeszi Mikszáth Kálmán Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4552,
								"regio":"Napkor",
								"name":"Napkori Jósika Miklós Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4531,
								"regio":"Nyírpazony",
								"name":"Színi Károly Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4466,
								"regio":"Timár",
								"name":"Szabolcsvezér Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4472,
								"regio":"Gávavencsellő",
								"name":"Rakovszky Sámuel Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4564,
								"regio":"Nyírmada",
								"name":"Patay István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4564,
								"regio":"Nyírmada",
								"name":"Patay István Általános Iskola 1. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4516,
								"regio":"Demecser",
								"name":"Demecseri Oktatási Centrum Gimnázium, Szakközépiskola, Általános Iskola, Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4516,
								"regio":"Demecser",
								"name":"DOC Középiskola és Általános Iskola Demecseri Általános Iskolája, Alapfokú Művészeti Iskolája"
						});
						this.schoolsListArray.push({
								"zip":4521,
								"regio":"Berkesz",
								"name":"DOC Középiskola és Általános Iskola Berkeszi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4534,
								"regio":"Székely",
								"name":"DOC Középiskola és Általános Iskola Székelyi tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4320,
								"regio":"Nagykálló",
								"name":"Korányi Frigyes Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":4432,
								"regio":"Nyíregyháza",
								"name":"Nyíregyházi Arany János Gimnázium, Általános Iskola és Kollégium Szőlőskerti Angol Kéttannyelvű Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4400,
								"regio":"Nyíregyháza",
								"name":"Nyíregyházi Arany János Gimnázium, Általános Iskola és Kollégium Zelk Zoltán Angol és Német Kéttannyelvű Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4400,
								"regio":"Nyíregyháza",
								"name":"Sipkay Barna Kereskedelmi, Vendéglátóipari, Idegenforgalmi Középiskola, Szakiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7400,
								"regio":"Kaposvár",
								"name":"Kaposvári Kodály Zoltán Központi Általános Iskola Zrínyi Ilona Magyar-Angol Két Tanítási Nyelvű Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7400,
								"regio":"Kaposvár",
								"name":"Kaposvári Kodály Zoltán Központi Általános Iskola Pécsi Utcai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7584,
								"regio":"Babócsa",
								"name":"Gábor Andor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7537,
								"regio":"Homokszentgyörgy",
								"name":"Homokszentgyörgyi I. István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7535,
								"regio":"Lad",
								"name":"Homokszentgyörgyi I. István Általános Iskola Arany János Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7538,
								"regio":"Kálmáncsa",
								"name":"Homokszentgyörgyi I. István Általános Iskola Kálmáncsai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7526,
								"regio":"Csököly",
								"name":"Csökölyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7432,
								"regio":"Hetes",
								"name":"Somssich Imre Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7435,
								"regio":"Somogysárd",
								"name":"Somssich Imre Általános Iskola Noszlopy Gáspár Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7472,
								"regio":"Szentbalázs",
								"name":"Szentbalázsi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7272,
								"regio":"Gölle",
								"name":"Taszári Körzeti Általános Iskola Göllei Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8716,
								"regio":"Mesztegnyő",
								"name":"Ladi János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7553,
								"regio":"Görgeteg",
								"name":"Görgetegi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7513,
								"regio":"Rinyaszentkirály",
								"name":"Görgetegi Általános Iskola Rinyaszentkirályi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8725,
								"regio":"Iharosberény",
								"name":"Iharosberényi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8724,
								"regio":"Inke",
								"name":"Inkei Bethlen István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7400,
								"regio":"Kaposvár",
								"name":"Kaposvári Munkácsy Mihály Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":8600,
								"regio":"Siófok",
								"name":"Siófoki Perczel Mór Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7400,
								"regio":"Kaposvár",
								"name":"Noszlopy Gáspár Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":7400,
								"regio":"Kaposvár",
								"name":"TIT Alapítványi Középiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":1116,
								"regio":"Budapest",
								"name":"Szent Benedek Óvoda, Általános Iskola és Két Tanítási Nyelvű Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1023,
								"regio":"Budapest",
								"name":"Újlaki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1022,
								"regio":"Budapest",
								"name":"Fillér Utcai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1035,
								"regio":"Budapest",
								"name":"Óbudai Nagy László Általános Iskola Váradi u. 15/b. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1039,
								"regio":"Budapest",
								"name":"Medgyessy Ferenc Német Nemzetiségi Nyelvoktató Általános Iskola Ferenc Medgyessy Deutsche Nationalitätengrundschule"
						});
						this.schoolsListArray.push({
								"zip":1033,
								"regio":"Budapest",
								"name":"Első Óbudai Német Nyelvoktató Nemzetiségi Általános Iskola Erste Altofener Deutsche Nationalitätenschule"
						});
						this.schoolsListArray.push({
								"zip":1031,
								"regio":"Budapest",
								"name":"Aquincum Angol-Magyar Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1054,
								"regio":"Budapest",
								"name":"Budapest V. Kerületi Szent István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1051,
								"regio":"Budapest",
								"name":"Budapest V. Kerületi Hild József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1062,
								"regio":"Budapest",
								"name":"Budapest VI. Kerület Bajza Utcai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1084,
								"regio":"Budapest",
								"name":"Budapest VIII. Kerületi Németh László Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":1083,
								"regio":"Budapest",
								"name":"Losonci Téri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1085,
								"regio":"Budapest",
								"name":"Molnár Ferenc Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1091,
								"regio":"Budapest",
								"name":"Budapest IX. Kerületi Kőrösi Csoma Sándor Kéttannyelvű Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":1101,
								"regio":"Budapest",
								"name":"Kőbányai Janikovszky Éva Magyar - Angol Két Tanítási Nyelvű Általános Iskola Üllői Úti Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":1105,
								"regio":"Budapest",
								"name":"Kőbányai Janikovszky Éva Magyar - Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1108,
								"regio":"Budapest",
								"name":"Kőbányai Széchenyi István Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1119,
								"regio":"Budapest",
								"name":"Újbudai Teleki Blanka Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":1118,
								"regio":"Budapest",
								"name":"Gazdagrét - Törökugrató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1125,
								"regio":"Budapest",
								"name":"Jókai Mór Német Nemzetiségi Általános  Iskola"
						});
						this.schoolsListArray.push({
								"zip":1126,
								"regio":"Budapest",
								"name":"Osztrák-Magyar Európaiskola"
						});
						this.schoolsListArray.push({
								"zip":1121,
								"regio":"Budapest",
								"name":"Budapesti Nemzetközi Iskola-International School of Budapest és Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1133,
								"regio":"Budapest",
								"name":"Budapest XIII. Kerületi Pannónia Német Nemzetiségi Kétnyelvű és Angol Nyelvet Oktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1146,
								"regio":"Budapest",
								"name":"Városligeti Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1144,
								"regio":"Budapest",
								"name":"Budapest XIV. Kerületi Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1142,
								"regio":"Budapest",
								"name":"Zuglói Hajós Alfréd Magyar-Német Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1157,
								"regio":"Budapest",
								"name":"Hartyán Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1151,
								"regio":"Budapest",
								"name":"Budapest XV. Kerületi Kossuth Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1163,
								"regio":"Budapest",
								"name":"Budapest XVI. Kerületi Lemhényi Dezső Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1173,
								"regio":"Budapest",
								"name":"Újlak Utcai Általános, Német Nemzetiségi és Magyar-Angol Két Tanítási Nyelvű Iskola"
						});
						this.schoolsListArray.push({
								"zip":1181,
								"regio":"Budapest",
								"name":"Darus Utcai Magyar-Német Két Tannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1181,
								"regio":"Budapest",
								"name":"Darus Utcai Magyar- Német Két Tannyelvű Általános Iskola Margó Tivadar Utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1188,
								"regio":"Budapest",
								"name":"Kapocs Magyar-Angol Két Tannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1188,
								"regio":"Budapest",
								"name":"Budapest XVIII. Kerületi Táncsics Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1184,
								"regio":"Budapest",
								"name":"Pestszentlőrinci Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1188,
								"regio":"Budapest",
								"name":"Kastélydombi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1192,
								"regio":"Budapest",
								"name":"Kispesti Erkel Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1196,
								"regio":"Budapest",
								"name":"Reménység Két Tanítási Nyelvű Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1201,
								"regio":"Budapest",
								"name":"József Attila Nyelvoktató Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1239,
								"regio":"Budapest",
								"name":"Budapest XXIII. Kerületi Grassalkovich Antal Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1238,
								"regio":"Budapest",
								"name":"Budapest XXIII. Kerületi  Páneurópa Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":1213,
								"regio":"Budapest",
								"name":"Budapest XXI. Kerületi Eötvös József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1212,
								"regio":"Budapest",
								"name":"Budapest XXI. Kerületi Széchenyi István Általános és Kéttannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1222,
								"regio":"Budapest",
								"name":"Árpád Utcai Német Nemzetiségi Nyelvoktató Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":1225,
								"regio":"Budapest",
								"name":"Budapest XXII. Kerületi Bartók Béla Magyar - Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1221,
								"regio":"Budapest",
								"name":"Budafoki Kossuth Lajos Magyar - Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1034,
								"regio":"Budapest",
								"name":"Óbudai Árpád Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1048,
								"regio":"Budapest",
								"name":"Budapest IV. Kerületi Babits Mihály Magyar-Angol Két Tanítási Nyelvű Általános Iskola és Gimnázium Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1063,
								"regio":"Budapest",
								"name":"Budapest VI. Kerületi Kölcsey Ferenc Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1102,
								"regio":"Budapest",
								"name":"Kőbányai Szent László Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1183,
								"regio":"Budapest",
								"name":"Karinthy Frigyes Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1184,
								"regio":"Budapest",
								"name":"Karinthy Frigyes Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1191,
								"regio":"Budapest",
								"name":"Kispesti Károlyi Mihály Magyar-Spanyol Tannyelvű Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1065,
								"regio":"Budapest",
								"name":"Terézvárosi Magyar-Angol, Magyar-Német Két Tannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1041,
								"regio":"Budapest",
								"name":"Újpesti Két Tanítási Nyelvű Műszaki Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":1138,
								"regio":"Budapest",
								"name":"Újpesti Két Tanítási Nyelvű Műszaki Szakközépiskola és Szakiskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1074,
								"regio":"Budapest",
								"name":"Nikola Tesla Szerb Tanítási Nyelvű Óvoda, Általános Iskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":1139,
								"regio":"Budapest",
								"name":"Szlovák Tanítási Nyelvű Óvoda, Általános Iskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":1183,
								"regio":"Budapest",
								"name":"Pogány Frigyes Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1191,
								"regio":"Budapest",
								"name":"Trefort Ágoston Két Tanítási Nyelvű Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1124,
								"regio":"Budapest",
								"name":"Tamási Áron Általános Iskola és Német Két Tannyelvű Nemzetiségi Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1086,
								"regio":"Budapest",
								"name":"Bókay János Humán Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1203,
								"regio":"Budapest",
								"name":"Budapest XX. Kerületi Német Nemzetiségi Gimnázium és Kollégium "
						});
						this.schoolsListArray.push({
								"zip":1165,
								"regio":"Budapest",
								"name":"Budapest XVI. Kerületi Táncsics Mihály Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1117,
								"regio":"Budapest",
								"name":"Kürt Alapítványi Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1204,
								"regio":"Budapest",
								"name":"Budapest XX. Kerületi Kossuth Lajos Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1144,
								"regio":"Budapest",
								"name":"Horvát Óvoda, Általános Iskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":1028,
								"regio":"Budapest",
								"name":"Klebelsberg Kuno Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1026,
								"regio":"Budapest",
								"name":"Budapest II. Kerületi Szabó Lőrinc Kéttannyelvű Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1026,
								"regio":"Budapest",
								"name":"Budapest II. Kerületi Szabó Lőrinc Kéttannyelvű Általános Iskola és Gimnázium Fenyves utca 1. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1111,
								"regio":"Budapest",
								"name":"BME Két Tanítási Nyelvű Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":1037,
								"regio":"Budapest",
								"name":"Budapest III. Kerületi Krúdy Gyula Angol-Magyar Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1087,
								"regio":"Budapest",
								"name":"Schulek Frigyes Két Tanítási Nyelvű Építőipari Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1087,
								"regio":"Budapest",
								"name":"Schulek Frigyes Két Tanítási Nyelvű Építőipari  Szakközépiskola Festetics u. 3. telephelye"
						});
						this.schoolsListArray.push({
								"zip":1149,
								"regio":"Budapest",
								"name":"Egressy Gábor Két Tanítási Nyelvű Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1146,
								"regio":"Budapest",
								"name":"Petrik Lajos Két Tanítási Nyelvű Vegyipari, Környezetvédelmi és Informatikai Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1211,
								"regio":"Budapest",
								"name":"Kossuth Lajos Két Tanítási Nyelvű Műszaki Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1211,
								"regio":"Budapest",
								"name":"Kossuth Lajos Két Tanítási Nyelvű Műszaki Szakközépiskola Weiss Manfréd út 203. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1097,
								"regio":"Budapest",
								"name":"Gundel Károly Vendéglátóipari és Idegenforgalmi Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":1011,
								"regio":"Budapest",
								"name":"Hunfalvy János Két Tanítási Nyelvű Közgazdasági és Kereskedelmi Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1047,
								"regio":"Budapest",
								"name":"Berzeviczy Gergely Két Tanítási Nyelvű Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1075,
								"regio":"Budapest",
								"name":"II. Rákóczi Ferenc Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1139,
								"regio":"Budapest",
								"name":"Károlyi Mihály Két Tanítási Nyelvű Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":1055,
								"regio":"Budapest",
								"name":"Xántus János Két Tanítási Nyelvű, Gyakorló Gimnázium és Idegenforgalmi Szakközépiskola, Szakiskola és Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":1139,
								"regio":"Budapest",
								"name":"Forrai Művészeti Szakközépiskola és Gimnázium a Magyarországi Metodista Egyház Fenntartásában"
						});
						this.schoolsListArray.push({
								"zip":1195,
								"regio":"Budapest",
								"name":"Ganz Ábrahám Két Tanítási Nyelvű Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":1195,
								"regio":"Budapest",
								"name":"Ganz Ábrahám Két Tanítási Nyelvű Szakközépiskola és Szakiskola Üllői út 270. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1184,
								"regio":"Budapest",
								"name":"Ganz Ábrahám Két Tanítási Nyelvű Szakközépiskola és Szakiskola Hengersor utca 34. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":1078,
								"regio":"Budapest",
								"name":"Vendéglátó, Idegenforgalmi és Kereskedelmi Baptista Középiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":5100,
								"regio":"Jászberény",
								"name":"Jászberényi Nagyboldogasszony Kéttannyelvű Katolikus Általános Iskola, Szakközépiskola, Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5400,
								"regio":"Mezőtúr",
								"name":"Mezőtúri II. Rákóczi Ferenc Magyar-Angol Két Tanítási Nyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":5400,
								"regio":"Mezőtúr",
								"name":"Mezőtúri Általános Iskola és Alapfokú Művészeti Iskola Kossuth Lajos Magyar-Angol Két Tanítási Nyelvű Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":5400,
								"regio":"Mezőtúr",
								"name":"Mezőtúri Általános Iskola és Alapfokú Művészeti Iskola Kossuth Lajos Magyar-Angol Két Tanítási Nyelvű Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":5000,
								"regio":"Szolnok",
								"name":"Kassai Úti Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5200,
								"regio":"Törökszentmiklós",
								"name":"Hunyadi Mátyás Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5200,
								"regio":"Törökszentmiklós",
								"name":"Hunyadi M. Kéttannyelvű Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5200,
								"regio":"Törökszentmiklós",
								"name":"Hunyadi M. Kéttannyelvű Iskola Sajátos Nevelési Igényű Tanulók Tagozata"
						});
						this.schoolsListArray.push({
								"zip":5126,
								"regio":"Jászfényszaru",
								"name":"Jászfényszarui IV. Béla Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":5126,
								"regio":"Jászfényszaru",
								"name":"Jászfényszarui IV. Béla Általános Iskola, Alapfokú Művészeti Iskola és Szakiskola 002-es Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5137,
								"regio":"Jászkisér",
								"name":"Csete Balázs Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3381,
								"regio":"Pély",
								"name":"Csete Balázs Általános Iskola Petőfi Sándor Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5137,
								"regio":"Jászkisér",
								"name":"Csete Balázs Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5137,
								"regio":"Jászkisér",
								"name":"Csete Balázs Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5137,
								"regio":"Jászkisér",
								"name":"Csete Balázs Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5055,
								"regio":"Jászladány",
								"name":"Jászladányi Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5055,
								"regio":"Jászladány",
								"name":"Móra Ferenc Általános Iskola 1-4 évfolyama és a Sajátos Nevelési igényű tanulók szegregált oktatása"
						});
						this.schoolsListArray.push({
								"zip":5331,
								"regio":"Kenderes",
								"name":"Kenderesi Apáczai Csere János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5349,
								"regio":"Kenderes",
								"name":"Kenderesi Apáczai Csere János Általános Iskola Bánhalmai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":5331,
								"regio":"Kenderes",
								"name":"Kenderesi Apáczai Csere János Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5430,
								"regio":"Tiszaföldvár",
								"name":"Tiszaföldvári Kossuth Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5235,
								"regio":"Tiszabura",
								"name":"Tiszaburai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5235,
								"regio":"Tiszabura",
								"name":"Tiszaburai Általános Iskola 002"
						});
						this.schoolsListArray.push({
								"zip":5451,
								"regio":"Öcsöd",
								"name":"Öcsödi József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5451,
								"regio":"Öcsöd",
								"name":"Öcsödi József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5451,
								"regio":"Öcsöd",
								"name":"Öcsödi József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5000,
								"regio":"Szolnok",
								"name":"Varga Katalin Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7150,
								"regio":"Bonyhád",
								"name":"Bonyhádi Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola Szent Imre utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7150,
								"regio":"Bonyhád",
								"name":"Bonyhádi Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7122,
								"regio":"Kakasd",
								"name":"Bonyhádi Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola Kakasdi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7200,
								"regio":"Dombóvár",
								"name":"Dombóvári József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7252,
								"regio":"Attala",
								"name":"Dombóvári József Attila Általános Iskola Attalai Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7030,
								"regio":"Paks",
								"name":"Paksi Bezerédj Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7030,
								"regio":"Paks",
								"name":"Paksi Deák Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7030,
								"regio":"Paks",
								"name":"Deák Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Szekszárdi Babits Mihály Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7057,
								"regio":"Medina",
								"name":"Szekszárdi Babits Mihály Általános Iskola Medinai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Szekszárdi Dienes Valéria Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Pécsi Tudományegyetem Illyés Gyula Gyakorlóiskola, Alapfokú Művészeti Iskola és Gyakorlóóvoda"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Szekszárdi Baka István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Szent József Katolikus Általános Iskola Katholische Grundschule és Szent Rita Katolikus Óvoda"
						});
						this.schoolsListArray.push({
								"zip":7130,
								"regio":"Tolna",
								"name":"Wosinsky Mór Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7130,
								"regio":"Tolna",
								"name":"Wosinsky Mór Általános Iskola és Alapfokú Művészeti Iskola Eötvös utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":7130,
								"regio":"Tolna",
								"name":"Wosinsky Mór Általános Iskola és Alapfokú Művészeti Iskola Kossuth Lajos utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":7130,
								"regio":"Tolna",
								"name":"Wosinsky Mór Általános Iskola és Alapfokú Művészeti Iskola Szent Imre utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":7131,
								"regio":"Tolna",
								"name":"Wosinsky Mór Általános Iskola és Alapfokú Művészeti Iskola Iskola utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":7186,
								"regio":"Aparhant",
								"name":"Aparhanti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7161,
								"regio":"Cikó",
								"name":"Cikói Perczel Mór Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7161,
								"regio":"Cikó",
								"name":"Cikói Perczel Mór Általános Iskola Iskola téri telephelye"
						});
						this.schoolsListArray.push({
								"zip":7165,
								"regio":"Mórágy",
								"name":"Mórágyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7164,
								"regio":"Bátaapáti",
								"name":"Mórágyi Általános Iskola Bátaapáti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7355,
								"regio":"Nagymányok",
								"name":"Nagymányoki II. Rákóczi Ferenc Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7355,
								"regio":"Nagymányok",
								"name":"Nagymányoki II. Rákóczi Ferenc Általános Iskola és Alapfokú Művészeti Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7181,
								"regio":"Tevel",
								"name":"Teveli Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7352,
								"regio":"Györe",
								"name":"Györei Templom Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7227,
								"regio":"Gyulaj",
								"name":"Gyulaji Galló József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7227,
								"regio":"Gyulaj",
								"name":"Galló József Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":7226,
								"regio":"Kurd",
								"name":"Kurdi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7226,
								"regio":"Kurd",
								"name":"Kurdi Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7213,
								"regio":"Szakcs",
								"name":"Szakcsi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7212,
								"regio":"Kocsola",
								"name":"Szakcsi Általános Iskola Kocsolai Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7045,
								"regio":"Györköny",
								"name":"Györkönyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7149,
								"regio":"Báta",
								"name":"Bátai Hunyadi János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7132,
								"regio":"Bogyiszló",
								"name":"Bogyiszlói Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7133,
								"regio":"Fadd",
								"name":"Faddi Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7133,
								"regio":"Fadd",
								"name":"Faddi Gárdonyi Géza Általános Iskola 004"
						});
						this.schoolsListArray.push({
								"zip":7134,
								"regio":"Gerjen",
								"name":"Faddi Gárdonyi Géza Általános Iskola Gerjeni Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7143,
								"regio":"Őcsény",
								"name":"Őcsényi Perczel Mór Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7143,
								"regio":"Őcsény",
								"name":"Őcsényi Perczel Mór Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7146,
								"regio":"Várdomb",
								"name":"Várdomb-Alsónána Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7147,
								"regio":"Alsónána",
								"name":"Várdomb-Alsónána Általános Iskola Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7173,
								"regio":"Zomba",
								"name":"Zombai Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7175,
								"regio":"Felsőnána",
								"name":"Zombai Általános Iskola Felsőnánai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7172,
								"regio":"Harc",
								"name":"Zombai Általános Iskola Harci Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7054,
								"regio":"Tengelic",
								"name":"Zombai Általános Iskola Tengelici Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7064,
								"regio":"Gyönk",
								"name":"Hőgyészi Hegyhát Általános Iskola és Gimnázium Gyönki Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7191,
								"regio":"Hőgyész",
								"name":"Hőgyészi Hegyhát Általános Iskola, Gimnázium, Alapfokú Művészeti Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7064,
								"regio":"Gyönk",
								"name":"Hőgyészi Hegyhát Általános Iskola és Gimnázium Tolnai Lajos Gimnáziumi és Kollégiumi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7086,
								"regio":"Ozora",
								"name":"Ozorai Illyés Gyula Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7087,
								"regio":"Fürged",
								"name":"Ozorai Illyés Gyula Általános Iskola Fürgedi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7193,
								"regio":"Regöly",
								"name":"Tamási Általános Iskola és Gimnázium Regölyi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7090,
								"regio":"Tamási",
								"name":"Tamási Általános Iskola, Gimnázium, Alapfokú Művészeti Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7192,
								"regio":"Szakály",
								"name":"Tamási Általános Iskola és Gimnázium Szakályi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7192,
								"regio":"Szakály",
								"name":"Tamási Általános Iskola és Gimnázium Szakályi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7150,
								"regio":"Bonyhád",
								"name":"Bonyhádi Petőfi Sándor Evangélikus Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7200,
								"regio":"Dombóvár",
								"name":"Dombóvári Illyés Gyula Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7200,
								"regio":"Dombóvár",
								"name":"Dombóvári Belvárosi Általános és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7361,
								"regio":"Kaposszekcső",
								"name":"Dombóvári Belvárosi Általános és Alapfokú Művészeti Iskola Kaposszekcsői Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7341,
								"regio":"Csikóstőttős",
								"name":"Dombóvári Belvárosi Általános és Alapfokú Művészeti Iskola Kaposszekcsői Általános Iskolája Csikóstőttősi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Szekszárdi Kolping Katolikus Szakképző Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Palánk Tanműhely"
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Rákóczi utca 73."
						});
						this.schoolsListArray.push({
								"zip":9730,
								"regio":"Kőszeg",
								"name":"Kőszegi Béri Balog Ádám Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9730,
								"regio":"Kőszeg",
								"name":"Bersek József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9733,
								"regio":"Horvátzsidány",
								"name":"Bersek József Általános Iskola Horvátzsidányi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Dési Huber István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Szombathelyi Reguly Antal Nyelvoktató Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Szombathelyi Reguly Antal Nyelvoktató Nemzetiségi Általános Iskola Rákóczi Ferenc utca 77. sz. alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Szombathelyi Váci Mihály Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9982,
								"regio":"Apátistvánfalva",
								"name":"APÁTISTVÁNFALVI KÉTTANNYELVŰ ÁLTALÁNOS ISKOLA ÉS ÓVODA"
						});
						this.schoolsListArray.push({
								"zip":9985,
								"regio":"Felsőszölnök",
								"name":"Kossics József Kétnyelvű Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":9794,
								"regio":"Felsőcsatár",
								"name":"Felsőcsatári Nyelvoktató Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9794,
								"regio":"Felsőcsatár",
								"name":"Felsőcsatári Nyelvoktató Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9798,
								"regio":"Ják",
								"name":"Jáki Nagy Márton Nyelvoktató Nemzetiségi Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":9799,
								"regio":"Szentpéterfa",
								"name":"Szentpéterfai Horvát-Magyar Kétnyelvű Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9799,
								"regio":"Szentpéterfa",
								"name":"Szentpéterfai Horvát- Magyar Kétnyelvű Általános Iskola Március 15. téri telephelye"
						});
						this.schoolsListArray.push({
								"zip":9730,
								"regio":"Kőszeg",
								"name":"Jurisich Miklós Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Szombathelyi Kanizsai Dorottya Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Premontrei Rendi Szent Norbert Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Szombathelyi Kereskedelmi és Vendéglátói Szakképző Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":9970,
								"regio":"Szentgotthárd",
								"name":"Szentgotthárdi III. Béla Szakképző Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":8447,
								"regio":"Ajka",
								"name":"Laschober Mária Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8500,
								"regio":"Pápa",
								"name":"Munkácsy Mihály Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8500,
								"regio":"Pápa",
								"name":"Munkácsy Mihály Német Nemzetiségi Nyelvoktató Általános Iskola Fiumei utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8500,
								"regio":"Pápa",
								"name":"Tarczy Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8500,
								"regio":"Pápa",
								"name":"Tarczy Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8200,
								"regio":"Veszprém",
								"name":"Hriszto Botev Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8200,
								"regio":"Veszprém",
								"name":"Veszprémi Dózsa György Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8412,
								"regio":"Veszprém",
								"name":"Gyulaffy László Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8420,
								"regio":"Zirc",
								"name":"Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8420,
								"regio":"Zirc",
								"name":"Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola F épület"
						});
						this.schoolsListArray.push({
								"zip":8425,
								"regio":"Lókút",
								"name":"Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola Lókúti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8427,
								"regio":"Bakonybél",
								"name":"Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola Szent Gellért Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8414,
								"regio":"Olaszfalu",
								"name":"Zirci Reguly Antal Német Nemzetiségi Nyelvoktató Általános Iskola Villax Ferdinánd Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8460,
								"regio":"Devecser",
								"name":"Devecseri Gárdonyi Géza Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8460,
								"regio":"Devecser",
								"name":"Devecseri Gárdonyi Géza Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8492,
								"regio":"Kerta",
								"name":"Kertai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8492,
								"regio":"Kerta",
								"name":"Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8484,
								"regio":"Nagyalásony",
								"name":"Nagyalásonyi Kinizsi Pál Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8456,
								"regio":"Noszlop",
								"name":"Noszlopi Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8449,
								"regio":"Magyarpolány",
								"name":"Noszlopi Német Nemzetiségi Nyelvoktató Általános Iskola Magyarpolányi Kerek Nap Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8481,
								"regio":"Somlóvásárhely",
								"name":"Somlóvásárhelyi Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8409,
								"regio":"Úrkút",
								"name":"Hauser Lajos Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8251,
								"regio":"Zánka",
								"name":"Bozzay Pál Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8272,
								"regio":"Balatoncsicsó",
								"name":"Nivegy-völgyi Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8558,
								"regio":"Csót",
								"name":"Csóthi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8553,
								"regio":"Lovászpatona",
								"name":"Lovászpatonai Bánki Donát Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8552,
								"regio":"Vanyola",
								"name":"Lovászpatonai Bánki Donát Általános Iskola Vajda Péter Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8596,
								"regio":"Pápakovácsi",
								"name":"Kastély Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8564,
								"regio":"Ugod",
								"name":"Ugodi Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8563,
								"regio":"Homokbödöge",
								"name":"Ugodi Német Nemzetiségi Nyelvoktató Általános Iskola Homokbödögei Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8561,
								"regio":"Adásztevel",
								"name":"Ugodi Német Nemzetiségi Nyelvoktató Általános Iskola Adászteveli Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8181,
								"regio":"Berhida",
								"name":"Ady Endre Német Nemzetiségi Nyelvoktató Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8182,
								"regio":"Berhida",
								"name":"Berhidai II. Rákóczi Ferenc Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8440,
								"regio":"Herend",
								"name":"Herendi Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8291,
								"regio":"Nagyvázsony",
								"name":"Nagyvázsonyi Kinizsi Pál Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8248,
								"regio":"Nemesvámos",
								"name":"Nemesvámosi Petőfi Sándor Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8428,
								"regio":"Borzavár",
								"name":"Borzavár-Porvai Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8429,
								"regio":"Porva",
								"name":"Borzavár-Porvai Német Nemzetiségi Nyelvoktató Általános Iskola Porvai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8415,
								"regio":"Nagyesztergár",
								"name":"Ányos Pál Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8220,
								"regio":"Balatonalmádi",
								"name":"Magyar-Angol Tannyelvű Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":8230,
								"regio":"Balatonfüred",
								"name":"Lóczy Lajos Gimnázium és Két Tanítási Nyelvű Idegenforgalmi Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":8200,
								"regio":"Veszprém",
								"name":"Lovassy László Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":8200,
								"regio":"Veszprém",
								"name":"Vetési Albert Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":8500,
								"regio":"Pápa",
								"name":"Pápai Petőfi Sándor Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":2120,
								"regio":"Dunakeszi",
								"name":"Dunakeszi Fazekas Mihály Német Nyelvoktató Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2030,
								"regio":"Érd",
								"name":"Érdi Bolyai János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2030,
								"regio":"Érd",
								"name":"Érdi Bolyai János Általános Iskola Alsó utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":2030,
								"regio":"Érd",
								"name":"Marianum Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2100,
								"regio":"Gödöllő",
								"name":"Gödöllői Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8895,
								"regio":"Pusztamagyaród",
								"name":"Pusztamagyaródi Kenyeres Elemér Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8896,
								"regio":"Bánokszentgyörgy",
								"name":"Pusztamagyaródi Kenyeres Elemér Általános Iskola Arany János Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Kőrösi Csoma Sándor-Péterfy Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Kőrösi Csoma Sándor - Péterfy Sándor Általános Iskola Péterfy Sándor Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Rozgonyi Úti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Kiskanizsai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Zrínyi Miklós - Bolyai János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Zrínyi Miklós - Bolyai János Általános Iskola Szent Imre utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":8808,
								"regio":"Nagykanizsa",
								"name":"Palini Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Miklósfai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Hevesi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8900,
								"regio":"Zalaegerszeg",
								"name":"Landorhegyi Sportiskolai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8900,
								"regio":"Zalaegerszeg",
								"name":"Petőfi Sándor és Dózsa György Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8900,
								"regio":"Zalaegerszeg",
								"name":"Petőfi Sándor és Dózsa György Magyar-Angol Két Tanítási Nyelvű Általános Iskola Dózsa György Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8756,
								"regio":"Csapi",
								"name":"Térségi Általános Iskola, Szakiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":8861,
								"regio":"Szepetnek",
								"name":"Királyi Pál Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8924,
								"regio":"Alsónemesapáti",
								"name":"Csertán Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8923,
								"regio":"Nemesapáti",
								"name":"Csertán Sándor Általános Iskola Nemesapáti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8943,
								"regio":"Bocfölde",
								"name":"Bocföldei Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8918,
								"regio":"Csonkahegyhát",
								"name":"Gárdonyi Géza és Szegi Suli Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8761,
								"regio":"Pacsa",
								"name":"Pacsai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8762,
								"regio":"Szentpéterúr",
								"name":"Szentpéterúri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8946,
								"regio":"Tófej",
								"name":"Tófeji Kincskereső Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8951,
								"regio":"Gutorfölde",
								"name":"Tófeji Kincskereső Általános Iskola Gutorföldi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8866,
								"regio":"Becsehely",
								"name":"Becsehelyi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8887,
								"regio":"Bázakerettye",
								"name":"Becsehelyi Általános Iskola Bázakerettyei Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8872,
								"regio":"Muraszemenye",
								"name":"Muraszemenyei Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8864,
								"regio":"Tótszerdahely",
								"name":"Tótszerdahelyi Zrínyi Katarina Horvát Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8865,
								"regio":"Tótszentmárton",
								"name":"Tótszerdahelyi Zrínyi Katarina Horvát Általános Iskola Szent István Király Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8885,
								"regio":"Borsfa",
								"name":"Borsfai Fekete István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8900,
								"regio":"Zalaegerszeg",
								"name":"Zalaegerszegi Kölcsey Ferenc Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":8900,
								"regio":"Zalaegerszeg",
								"name":"Zalaegerszegi Báthory István Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":8900,
								"regio":"Zalaegerszeg",
								"name":"Zalaegerszegi Báthory István Szakképző Iskola Ebergényi utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":2100,
								"regio":"Gödöllő",
								"name":"Gödöllői Damjanich János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2000,
								"regio":"Szentendre",
								"name":"Agy Tanoda Magyar- Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2040,
								"regio":"Budaörs",
								"name":"Budaörsi 1. Számú Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2040,
								"regio":"Budaörs",
								"name":"Mindszenty József Római Katolikus Óvoda és Nyelvoktató Német Nemzetiségi Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":2371,
								"regio":"Dabas",
								"name":"Dabasi II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2300,
								"regio":"Ráckeve",
								"name":"Ráckevei Árpád Fejedelem Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2440,
								"regio":"Százhalombatta",
								"name":"Százhalombattai 1. Számú Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2440,
								"regio":"Százhalombatta",
								"name":"Százhalombattai Eötvös Loránd Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3743,
								"regio":"Ormosbánya",
								"name":"Hosztják Albert Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1121,
								"regio":"Budapest",
								"name":"Thomas Mann Gymnasium-Deutsche Schule Budapest, Budapesti Német Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":8246,
								"regio":"Tótvázsony",
								"name":"Padányi Biró Márton Római Katolikus Gimnázium, Egészségügyi Szakközépiskola és Általános Iskola - Tótvázsonyi Tagiskola"
						});
						this.schoolsListArray.push({
								"zip":5232,
								"regio":"Tiszabő",
								"name":"Tiszabői Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8424,
								"regio":"Jásd",
								"name":"Képesség- és Tehetségfejlesztő Magán Általános Iskola, Szakképző Iskola, Gimnázium, Alapfokú Művészeti Iskola és Kollégium - Jásd, Kossuth u. 114.  alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":4400,
								"regio":"Nyíregyháza",
								"name":"Nyíregyházi Göllesz Viktor Speciális Szakiskola, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény"
						});
						this.schoolsListArray.push({
								"zip":1084,
								"regio":"Budapest VIII. kerület",
								"name":"Józsefvárosi Egységes Gyógypedagógiai Módszertani Intézmény és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3526,
								"regio":"Miskolc",
								"name":"Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény"
						});
						this.schoolsListArray.push({
								"zip":3532,
								"regio":"Miskolc",
								"name":"Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Tüskevár Tagóvodája és Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3526,
								"regio":"Miskolc",
								"name":"Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Kassai utca 15. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3534,
								"regio":"Miskolc",
								"name":"Miskolci Éltes Mátyás Óvoda, Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Tüskevár Tagóvodája és Tagiskolája Gagarin utca 50. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4087,
								"regio":"Hajdúdorog",
								"name":"Kalkuttai Teréz Anya Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3630,
								"regio":"Putnok",
								"name":"Serényi László Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7570,
								"regio":"Barcs",
								"name":"Barcsi Szivárvány Óvoda, Általános Iskola, Speciális Szakiskola, Kollégium, Egységes Gyógypedagógiai Módszertani Intézmény"
						});
						this.schoolsListArray.push({
								"zip":7673,
								"regio":"Kővágószőlős",
								"name":"Kővágószőlősi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4125,
								"regio":"Pocsaj",
								"name":"Pocsaji Lorántffy Zsuzsanna Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2543,
								"regio":"Süttő",
								"name":"Süttői II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2040,
								"regio":"Budaörs",
								"name":"Bleyer Jakab Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4375,
								"regio":"Piricse",
								"name":"Piricsei Eötvös József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5321,
								"regio":"Kunmadaras",
								"name":"Kunmadarasi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5321,
								"regio":"Kunmadaras",
								"name":"Kunmadarasi Általános Iskola 002 telephelye"
						});
						this.schoolsListArray.push({
								"zip":3950,
								"regio":"Sárospatak",
								"name":"Sárospataki Református Kollégium Gimnáziuma, Általános Iskolája és Diákotthona"
						});
						this.schoolsListArray.push({
								"zip":6914,
								"regio":"Pitvaros",
								"name":"Pitvarosi Petőfi Sándor Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6914,
								"regio":"Pitvaros",
								"name":"Pitvarosi Petőfi Sándor Általános Iskola és Alapfokú Művészeti Iskola Petőfi téri telephelye"
						});
						this.schoolsListArray.push({
								"zip":6916,
								"regio":"Ambrózfalva",
								"name":"Pitvarosi Petőfi Sándor Általános Iskola és Alapfokú Művészeti Iskola Ambrózfalvi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6915,
								"regio":"Csanádalberti",
								"name":"Pitvarosi Petőfi Sándor Általános Iskola és Alapfokú Művészeti Iskola Csanádalberti Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8706,
								"regio":"Nikla",
								"name":"Bölcsesség Kezdete Oktatási Központ Berzsenyi Dániel Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2371,
								"regio":"Dabas",
								"name":"Szent János Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5734,
								"regio":"Geszt",
								"name":"Geszti Arany János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4492,
								"regio":"Dombrád",
								"name":"Dombrádi Móra Ferenc Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4492,
								"regio":"Dombrád",
								"name":"Dombrádi Móra Ferenc Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola Andrássy Úti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4031,
								"regio":"Debrecen",
								"name":"EURO Baptista Két Tanítási Nyelvű Gimnázium,Szakközépiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":2081,
								"regio":"Piliscsaba",
								"name":"Hauck János Német Nemzetiségi Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":7700,
								"regio":"Mohács",
								"name":"Mohács Térségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7700,
								"regio":"Mohács",
								"name":"Mohács Térségi Általános Iskola feladatellátási helye"
						});
						this.schoolsListArray.push({
								"zip":7714,
								"regio":"Mohács",
								"name":"Mohács Térségi Általános Iskola Völgyesi Jenő Tag Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7785,
								"regio":"Sátorhely",
								"name":"Mohács Térségi Általános Iskola Sátorhelyi Tag Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":1062,
								"regio":"Budapest",
								"name":"Kalyi Jag Roma Nemzetiségi Szakiskola, Szakközépiskola, Alapfokú Művészeti Iskola és Felnőttoktatási Intézmény"
						});
						this.schoolsListArray.push({
								"zip":3527,
								"regio":"Miskolc",
								"name":"Kalyi Jag Roma Nemzetiségi Szakiskola, Szakközépiskola, Alapfokú Művészeti Iskola és Felnőttoktatási Intézmény - miskolci telephely"
						});
						this.schoolsListArray.push({
								"zip":1033,
								"regio":"Budapest",
								"name":"Kőrösi Csoma Sándor Két Tanítási Nyelvű Baptista Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":4481,
								"regio":"Nyíregyháza",
								"name":"Abigél TCI Sóstóhegy Tagiskola"
						});
						this.schoolsListArray.push({
								"zip":4400,
								"regio":"Nyíregyháza",
								"name":"Abigél TCI Nyíregyháza Tagiskola"
						});
						this.schoolsListArray.push({
								"zip":4405,
								"regio":"Nyíregyháza",
								"name":"Abigél Két Tanítási Nyelvű Általános Iskola, Alapfokú Művészeti Iskola, Szakképző Iskola, Gimnázium, Művészeti Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":2089,
								"regio":"Telki",
								"name":"Pipacsvirág Magyar-Angol Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3525,
								"regio":"Miskolc",
								"name":"Jókai Mór Református Magyar-Angol Két Tanítási Nyelvű Általános Iskola, Alapfokú Művészeti Iskola és Óvoda "
						});
						this.schoolsListArray.push({
								"zip":5000,
								"regio":"Szolnok",
								"name":"Dr. Hegedűs T. András Szakiskola, Középiskola, Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7624,
								"regio":"Pécs",
								"name":"Koch Valéria Gimnázium, Általános Iskola, Óvoda, Kollégium és Pedagógiai Intézet"
						});
						this.schoolsListArray.push({
								"zip":2085,
								"regio":"Pilisvörösvár",
								"name":"Friedrich Schiller Gimnázium, Szakközépiskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":1126,
								"regio":"Budapest",
								"name":"Budai Középiskola"
						});
						this.schoolsListArray.push({
								"zip":7030,
								"regio":"Paks",
								"name":"Paksi II. Rákóczi Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7039,
								"regio":"Németkér",
								"name":"Paksi II.Rákóczi Ferenc Általános Iskola Németkéri Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5540,
								"regio":"Szarvas",
								"name":"Szlovák Általános Iskola, Óvoda és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7434,
								"regio":"Mezőcsokonya",
								"name":"Somogyjádi Illyés Gyula Általános Iskola és Alapfokú Művészeti Iskola Mezőcsokonyai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2091,
								"regio":"Etyek",
								"name":"Etyeki Nyelvoktató Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2091,
								"regio":"Etyek",
								"name":"Etyeki Nyelvoktató Német Nemzetiségi Általános Iskola és  Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2091,
								"regio":"Etyek",
								"name":"Etyeki Nyelvoktató Német Nemzetiségi Általános Iskola, és Alapfokú  Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3866,
								"regio":"Szemere",
								"name":"Szemerei Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3865,
								"regio":"Fáj",
								"name":"Szemerei Általános Iskola Fáji Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":1157,
								"regio":"Budapest",
								"name":"Magyar-Kínai Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4235,
								"regio":"Biri",
								"name":"Dankó Pista Egységes Óvoda- Bölcsőde, Általános Iskola, Szakképző Iskola, Gimnázium, Kollégium és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4232,
								"regio":"Geszteréd",
								"name":"Dankó Pista Egységes Óvoda-Bölcsőde, Általános Iskola, Szakképző Iskola, Gimnázium, Kollégium és Alapfokú Művészeti Iskola Geszterédi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4235,
								"regio":"Biri",
								"name":"Dankó Pista Egységes Óvoda- Bölcsőde, Általános Iskola, Szakképző Iskola, Gimnázium, Kollégium és Alapfokú Művészeti Iskola Mező utca 1-3. Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4235,
								"regio":"Biri",
								"name":"Dankó Pista Egységes Óvoda- Bölcsőde, Általános Iskola, Szakképző Iskola, Gimnázium, Kollégium és Alapfokú Művészeti Iskola Mező utca 2. Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4320,
								"regio":"Nagykálló",
								"name":"Dankó Pista Egységes Óvoda-Bölcsőde, Általános Iskola, Szakképző Iskola, Gimnázium, Kollégium és Alapfokú Művészeti Iskola Nagykállói Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3281,
								"regio":"Karácsond",
								"name":"Karácsondi Gönczy Pál Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3980,
								"regio":"Sátoraljaújhely",
								"name":"Kazinczy Ferenc Általános Iskola Esze Tamás Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3980,
								"regio":"Sátoraljaújhely",
								"name":"Kazinczy Ferenc Általános Iskola Jókai Mór Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3989,
								"regio":"Mikóháza",
								"name":"Kazinczy Ferenc Általános Iskola Mikóházi Lőrincze Lajos Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3980,
								"regio":"Sátoraljaújhely",
								"name":"Kazinczy Ferenc Magyar-Angol Két Tanítási Nyelvű, Nyelvoktató Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":1093,
								"regio":"Budapest",
								"name":"Bolgár Nyelvoktató Nemzetiségi Iskola"
						});
						this.schoolsListArray.push({
								"zip":1062,
								"regio":"Budapest",
								"name":"Bolgár Nyelvoktató Nemzetiségi Iskola"
						});
						this.schoolsListArray.push({
								"zip":1102,
								"regio":"Budapest",
								"name":"LENGYEL NYELVOKTATÓ NEMZETISÉGI ISKOLA"
						});
						this.schoolsListArray.push({
								"zip":1041,
								"regio":"Budapest",
								"name":"Újpesti Lengyel Kisebbségi Önkormányzat"
						});
						this.schoolsListArray.push({
								"zip":1051,
								"regio":"Budapest",
								"name":"Magyarországi Bem József Lengyel Kulturális Egyesület"
						});
						this.schoolsListArray.push({
								"zip":2100,
								"regio":"Gödöllő",
								"name":"Gödöllői Lengyel Kisebbségi Önkormányzat"
						});
						this.schoolsListArray.push({
								"zip":7400,
								"regio":"Kaposvár",
								"name":"Lengyel Kisebbségi Önkormányzat"
						});
						this.schoolsListArray.push({
								"zip":8200,
								"regio":"Veszprém",
								"name":"Veszprémi Lengyel Kisebbségi Önkormányzat"
						});
						this.schoolsListArray.push({
								"zip":7826,
								"regio":"Alsószentmárton",
								"name":"Kis Tigris Gimnázium, Szakiskola és Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":7300,
								"regio":"Komló",
								"name":"Kis Tigris Gimnázium, Szakiskola és Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":7958,
								"regio":"Kákics",
								"name":"Kis Tigris Gimnázium és Szakiskola "
						});
						this.schoolsListArray.push({
								"zip":7100,
								"regio":"Szekszárd",
								"name":"Szekszárdi Garay János Általános Iskola, Alapfokú Művészeti Iskola és Pedagógiai Intézet"
						});
						this.schoolsListArray.push({
								"zip":7171,
								"regio":"Sióagárd",
								"name":"Szekszárdi Garay János Általános Iskola és Alapfokú Művészeti Iskola Sióagárdi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3907,
								"regio":"Tállya",
								"name":"Zempléni Árpád Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8834,
								"regio":"Murakeresztúr",
								"name":"Zrínyi Miklós Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6300,
								"regio":"Kalocsa",
								"name":"Kalocsai Fényi Gyula Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":9241,
								"regio":"Jánossomorja",
								"name":"Jánossomorjai Körzeti Általános Iskola Klafszky Katalin Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5732,
								"regio":"Mezőgyán",
								"name":"Mezőgyáni Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3980,
								"regio":"Sátoraljaújhely",
								"name":"Sátoraljaújhelyi Kossuth Lajos Gimnázium és Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":5600,
								"regio":"Békéscsaba",
								"name":"Szlovák Gimnázium, Általános Iskola, Óvoda és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5650,
								"regio":"Mezőberény",
								"name":"Mezőberényi Általános Iskola, Alapfokú Művészeti Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5650,
								"regio":"Mezőberény",
								"name":"Mezőberényi Általános Iskola, Alapfokú Művészeti Iskola és Kollégium Luther téri telephelye"
						});
						this.schoolsListArray.push({
								"zip":9970,
								"regio":"Szentgotthárd",
								"name":"Szentgotthárd és Térsége Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9970,
								"regio":"Szentgotthárd",
								"name":"Szentgotthárd és Térsége Iskola Arany János 1-4. Évfolyamos Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":9970,
								"regio":"Szentgotthárd",
								"name":"Szentgotthárd és Térsége Iskola Széchenyi István 5-8. Évfolyamos Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":5551,
								"regio":"Csabacsűd",
								"name":"Csabacsűdi Trefort Ágoston Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5551,
								"regio":"Csabacsűd",
								"name":"Csabacsűdi Trefort Ágoston Általános Iskola Iskola u. 9. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":3412,
								"regio":"Bogács",
								"name":"Bükkalja Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3411,
								"regio":"Szomolya",
								"name":"Bükkalja Általános Iskola Móra Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7678,
								"regio":"Abaliget",
								"name":"Pécsi Püspöki Hittudományi Főiskola Szent Mária Magdolna Gyakorló Általános Iskola, Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3704,
								"regio":"Berente",
								"name":"Berentei Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3779,
								"regio":"Alacska",
								"name":"Berentei Általános Iskola Alacska Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2691,
								"regio":"Nógrádkövesd",
								"name":"Nógrádkövesdi József Attila Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3341,
								"regio":"Egercsehi",
								"name":"Egercsehi Zrínyi Ilona Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3322,
								"regio":"Hevesaranyos",
								"name":"Egercsehi Zrínyi Ilona Általános Iskola Hevesaranyosi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8422,
								"regio":"Bakonynána",
								"name":"Bakonynánai Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3450,
								"regio":"Mezőcsát",
								"name":"Mezőcsáti Egressy Béni Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3589,
								"regio":"Tiszatarján",
								"name":"Mezőcsáti Általános Iskola Édes Gergely Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5340,
								"regio":"Kunhegyes",
								"name":"Kunhegyesi Általános Iskola, Alapfokú Művészeti Iskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":5340,
								"regio":"Kunhegyes",
								"name":"Kunhegyesi Általános Iskola, Alapfokú Művészeti Iskola és Szakiskola Kossuth Úti Általános Iskolai és Szakiskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":1139,
								"regio":"Budapest",
								"name":"ORCHIDEA Magyar-Angol Két Tanítási Nyelvű Óvoda,Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":2526,
								"regio":"Epöl",
								"name":"Epöli Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8800,
								"regio":"Nagykanizsa",
								"name":"Szivárvány Óvoda, Általános Iskola, Speciális Szakiskola és Egységes Gyógypedagógiai Módszertani Intézmény"
						});
						this.schoolsListArray.push({
								"zip":3165,
								"regio":"Endrefalva",
								"name":"Endrefalvai Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3135,
								"regio":"Szécsényfelfalu",
								"name":"Endrefalvai Móra Ferenc Általános Iskola Szécsényfelfalui Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3134,
								"regio":"Piliny",
								"name":"Endrefalvai Móra Ferenc Általános Iskola Pilinyi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8446,
								"regio":"Kislőd",
								"name":"Városlődi Német Nemzetiségi Nyelvoktató Általános Iskola Kislődi Rőthy Mihály Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8445,
								"regio":"Városlőd",
								"name":"Városlődi Német Nemzetiségi Nyelvoktató Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7735,
								"regio":"Himesháza",
								"name":"Hímesházi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6454,
								"regio":"Bácsborsód",
								"name":"Bácskai Általános Iskola Moholy Nagy László Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6455,
								"regio":"Katymár",
								"name":"Bácskai Általános Iskola Katymári Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6453,
								"regio":"Bácsbokod",
								"name":"Bácskai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2823,
								"regio":"Vértessomló",
								"name":"Vértessomlói Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2824,
								"regio":"Várgesztes",
								"name":"Vértessomlói Német Nemzetiségi Általános Iskola Várgesztesi Német Nemzetiségi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":1135,
								"regio":"Budapest",
								"name":"Oroszországi Föderáció Magyarországi Nagykövetség Mellett Működő Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":2641,
								"regio":"Berkenye",
								"name":"Wilhelm Hauff Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1026,
								"regio":"Budapest",
								"name":"Szabó Magda Angol-Magyar Kéttannyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3170,
								"regio":"Szécsény",
								"name":"II. Rákóczi Ferenc Általános Iskola, Gimnázium és Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":3175,
								"regio":"Nagylóc",
								"name":"Nagylóc, 1-4. évfolyamokon Tagiskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":3187,
								"regio":"Nógrádszakál",
								"name":"Nógrádszakál 1-4. évfolyamokon Tagiskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":3900,
								"regio":"Szerencs",
								"name":"Szerencsi Rákóczi Zsigmond Református Két Tanítási Nyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":5211,
								"regio":"Tiszapüspöki",
								"name":"Tiszapüspöki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6800,
								"regio":"Hódmezővásárhely",
								"name":"Németh László Gimnázium, Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Oladi Általános Iskola, Középiskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":9700,
								"regio":"Szombathely",
								"name":"Oladi Általános Iskola, Középiskola és Szakiskola Nyitra Utcai Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":5630,
								"regio":"Békés",
								"name":"Dr. Hepp Ferenc Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8330,
								"regio":"Sümeg",
								"name":"Ramassetter Vince Testnevelési Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8330,
								"regio":"Sümeg",
								"name":"Ramassetter Vince Testnevelési Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7539,
								"regio":"Szulok",
								"name":"Barcsi Általános Iskola Arany János Tagiskolája Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7570,
								"regio":"Barcs",
								"name":"Barcsi Általános Iskola Deák Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7570,
								"regio":"Barcs",
								"name":"Barcsi Általános Iskola, Gimnázium, Kollégium, Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6723,
								"regio":"Szeged",
								"name":"Szeged és Térsége Eötvös József Gimnázium, Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6771,
								"regio":"Szeged",
								"name":"Szeged és Térsége Eötvös József Gimnázium, Általános Iskola Kossuth Lajos Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6772,
								"regio":"Deszk",
								"name":"Zoltánfy István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6763,
								"regio":"Szatymaz",
								"name":"Szeged és Térsége Eötvös József Gimnázium, Általános Iskola Szatymazi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6772,
								"regio":"Deszk",
								"name":"Zoltánfy István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4300,
								"regio":"Nyírbátor",
								"name":"Nyírbátori Magyar - Angol Kéttannyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Corvin Mátyás Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Vásárhelyi Pál Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4090,
								"regio":"Polgár",
								"name":"Polgári Vásárhelyi Pál Általános Iskola,Móricz Zsigmond utcai telephelye "
						});
						this.schoolsListArray.push({
								"zip":4090,
								"regio":"Polgár",
								"name":"Polgári Vásárhelyi Pál Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4060,
								"regio":"Balmazújváros",
								"name":"Balmazújvárosi Általános Iskola Bocskai István Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4060,
								"regio":"Balmazújváros",
								"name":"Balmazújvárosi Általános Iskola Kalmár Zoltán Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4060,
								"regio":"Balmazújváros",
								"name":"Balmazújvárosi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4440,
								"regio":"Tiszavasvári",
								"name":"Tiszavasvári Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4440,
								"regio":"Tiszavasvári",
								"name":"Tiszavasvári Általános Iskola Vasvári Pál Utca 97/A. szám alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":6440,
								"regio":"Jánoshalma",
								"name":"Jánoshalmi Hunyadi János Általános Iskola, Gimnázium és Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":6239,
								"regio":"Császártöltés",
								"name":"KT Általános- és Középiskola Császártöltési Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6430,
								"regio":"Bácsalmás",
								"name":"Bácsalmási Körzeti Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6430,
								"regio":"Bácsalmás",
								"name":"Bácsalmási Körzeti Általános Iskola és Művészeti Iskolájának Bácsalmási Vörösmarty Mihály Általános  Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6424,
								"regio":"Csikéria",
								"name":"Bácsalmási Körzeti Általános Iskola és Alapfokú Művészeti Iskola Csikériai Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6435,
								"regio":"Kunbaja",
								"name":"Bácsalmási Körzeti Általános Iskola és Alapfokú Művészeti Iskola Kunbajai Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6353,
								"regio":"Dusnok",
								"name":"Dusnok-Fajsz Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6527,
								"regio":"Nagybaracska",
								"name":"Csátalja-Nagybaracska Általános Iskola Simonyi Márton Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6523,
								"regio":"Csátalja",
								"name":"Csátalja-Nagybaracska Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6523,
								"regio":"Csátalja",
								"name":"Csátalja-Nagybaracska Általános Iskola Garai utca 1. alatti telephelye "
						});
						this.schoolsListArray.push({
								"zip":3434,
								"regio":"Mályi",
								"name":"Mályi Móra Ferenc Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4150,
								"regio":"Püspökladány",
								"name":"Püspökladányi Petőfi Sándor Általános Iskola és Speciális Szakiskola Bajcsy-Zsilinszky utca 3-5. szám alatti Telephely"
						});
						this.schoolsListArray.push({
								"zip":4150,
								"regio":"Püspökladány",
								"name":"Püspökladányi Petőfi Sándor Általános Iskola és Speciális Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":4150,
								"regio":"Püspökladány",
								"name":"Püspökladányi Petőfi Sándor Általános Iskola és Speciális Szakiskola Bajcsy-Zsilinszky utca 7. szám alatti Telephely"
						});
						this.schoolsListArray.push({
								"zip":6326,
								"regio":"Harta",
								"name":"DRK Mezőföld Gimnázium Hartai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3943,
								"regio":"Bodrogolaszi",
								"name":"Zempléni Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3959,
								"regio":"Makkoshotyka",
								"name":"Zempléni Általános Iskola Makkoshotykai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6345,
								"regio":"Nemesnádudvar",
								"name":"Nemesnádudvar-Érsekhalma Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6348,
								"regio":"Érsekhalma",
								"name":"Nemesnádudvar-Érsekhalma Német Nemzetiségi Általános Iskola Érsekhalmi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3360,
								"regio":"Heves",
								"name":"Hevesi József Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3360,
								"regio":"Heves",
								"name":"Hevesi József Általános Iskola és Alapfokú Művészeti Iskola Körzeti Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3360,
								"regio":"Heves",
								"name":"Hevesi József Általános Iskola és Alapfokú Művészeti Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2066,
								"regio":"Szár",
								"name":"Szári Romhányi György Nyelvoktató Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7585,
								"regio":"Háromfa",
								"name":"Nagyatádi Általános Iskola Móricz Zsigmond Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2861,
								"regio":"Bakonysárkány",
								"name":"Bakonysárkányi Fekete István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2861,
								"regio":"Bakonysárkány",
								"name":"Bakonysárkányi Fekete István Általános Iskola Béke út 80. szám alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7144,
								"regio":"Decs",
								"name":"Bíborvég Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7145,
								"regio":"Sárpilis",
								"name":"Bíborvég Általános Iskola Bogár István Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":6323,
								"regio":"Dunaegyháza",
								"name":"Dunaegyházi Szlovák Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8956,
								"regio":"Páka",
								"name":"Pákai Öveges József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3355,
								"regio":"Kápolna",
								"name":"Aldebrői Tarnavölgye Általános Iskola Kápolnai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Radnóti Miklós Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8044,
								"regio":"Kincsesbánya",
								"name":"Móri Radnóti Miklós Általános Iskola Kazinczy Ferenc Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8066,
								"regio":"Pusztavám",
								"name":"Móri Radnóti Miklós Általános Iskola Pusztavámi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":8053,
								"regio":"Bodajk",
								"name":"Bodajki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8074,
								"regio":"Csókakő",
								"name":"Bodajki Általános Iskola Nádasdy Tamás Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":4465,
								"regio":"Rakamaz",
								"name":"Erzsébet Királyné Német Nemzetiségi Általános Iskola, Alapfokú Művészeti Iskola és Szakiskola"
						});
						this.schoolsListArray.push({
								"zip":4465,
								"regio":"Rakamaz",
								"name":"Erzsébet Királyné Általános Iskola, Alapfokú Művészeti Iskola és Szakiskola Rakamazi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3720,
								"regio":"Sajókaza",
								"name":"Dr. Ámbédkar Iskola sajókazai telephelye"
						});
						this.schoolsListArray.push({
								"zip":3571,
								"regio":"Alsózsolca",
								"name":"Dr. Ámbédkar Gimnázium, Szakképző Iskola, Speciális Szakiskola és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7555,
								"regio":"Csokonyavisonta",
								"name":"Drávamenti Körzeti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7988,
								"regio":"Darány",
								"name":"Drávamenti Körzeti Általános Iskola Darányi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7918,
								"regio":"Lakócsa",
								"name":"Drávamenti Körzeti Általános Iskola Lakócsai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2629,
								"regio":"Márianosztra",
								"name":"Szobi Fekete István Általános Iskola Virág Benedek Általános Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2634,
								"regio":"Nagybörzsöny",
								"name":"Szobi Fekete István Általános Iskola, Nagybörzsönyi Általános Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7940,
								"regio":"Szentlőrinc",
								"name":"Szentlőrinci Általános Iskola, Előkészítő Szakiskola, Egységes Gyógypedagógiai Módszertani Intézmény, Alapfokú Művészeti Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7940,
								"regio":"Szentlőrinc",
								"name":"Szentlőrinci Általános Iskola Egységes Gyógypedagógiai Módszertani Intézménye "
						});
						this.schoolsListArray.push({
								"zip":7953,
								"regio":"Királyegyháza",
								"name":"Szentlőrinci Általános Iskola Királyegyházai Általános Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7682,
								"regio":"Bükkösd",
								"name":"Szentlőrinci Általános Iskola Bükkösdi Általános Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7951,
								"regio":"Szabadszentkirály",
								"name":"Szentlőrinci Általános Iskola Zsigmond Király Általános Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8767,
								"regio":"Felsőrajk",
								"name":"Suli Harmónia Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":8929,
								"regio":"Pölöske",
								"name":"Suli Harmónia Általános Iskola Pölöske"
						});
						this.schoolsListArray.push({
								"zip":9684,
								"regio":"Egervölgy",
								"name":"Suli Harmónia Általános Iskola Egervölgy"
						});
						this.schoolsListArray.push({
								"zip":9673,
								"regio":"Káld",
								"name":"Suli Harmónia Általános Iskola Káld"
						});
						this.schoolsListArray.push({
								"zip":8936,
								"regio":"Zalaszentmihály",
								"name":"Suli Harmónia Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3557,
								"regio":"Bükkszentkereszt",
								"name":"Bükki Szlovák Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3559,
								"regio":"Répáshuta",
								"name":"Bükki Szlovák Nemzetiségi Általános Iskola Répáshutai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2014,
								"regio":"Csobánka",
								"name":"Csobánkai Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4475,
								"regio":"Paszab",
								"name":"Ibrányi Árpád Fejedelem Általános Iskola Paszabi Turi Sándor Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4474,
								"regio":"Tiszabercel",
								"name":"Ibrányi Árpád Fejedelem Általános Iskola Tiszaberceli Bessenyei György Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3980,
								"regio":"Sátoraljaújhely",
								"name":"Magyar-Szlovák Két Tanítási Nyelvű Nemzetiségi Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":3933,
								"regio":"Olaszliszka",
								"name":"Olaszliszkai Hegyalja Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3935,
								"regio":"Erdőhorváti",
								"name":"Olaszliszkai Hegyalja Általános Iskola Erdőhorváti Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4136,
								"regio":"Körösszakál",
								"name":"Bihar Román Nemzetiségi Kéttannyelvű Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":4128,
								"regio":"Bedő",
								"name":"Bihar Román Nemzetiségi Kéttannyelvű Általános Iskola és Óvoda Bedői Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5539,
								"regio":"Körösnagyharsány",
								"name":"Bihar Román Nemzetiségi Kéttannyelvű Általános Iskola és Óvoda Körösnagyharsányi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5000,
								"regio":"Szolnok",
								"name":"Szolnoki Szolgáltatási Szakközép- és Szakiskola Vásárhelyi Pál Közgazdasági, Egészségügyi és Idegenforgalmi Két Tanítási Nyelvű Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8300,
								"regio":"Tapolca",
								"name":"Tapolcai Bárdos Lajos Általános Iskola Batsányi János Magyar-Angol Két Tanítási Nyelvű Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2890,
								"regio":"Tata",
								"name":"Eötvös József Gimnázium és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Humán Szakképző Iskola Kada Elek Közgazdasági Szakközépiskolája"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Humán Szakképző Iskola Széchenyi István Idegenforgalmi, Vendéglátóipari Szakközépiskola és Szakiskolája"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Humán Szakképző Iskola Kocsis Pál Mezőgazdasági és Környezetvédelmi Szakközépiskola és Szakiskolája"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Műszaki Szakképző Iskola, Speciális Szakiskola és Kollégium Kandó Kálmán Szakközépiskolája és Szakiskolája"
						});
						this.schoolsListArray.push({
								"zip":7561,
								"regio":"Nagybajom",
								"name":"Nagybajomi Csokonai Vitéz Mihály Általános Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7525,
								"regio":"Jákó",
								"name":"Nagybajomi Csokonai Vitéz Mihály Általános Iskola és Kollégium Jákói Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7561,
								"regio":"Pálmajor",
								"name":"Nagybajomi Csokonai Vitéz Mihály Általános Iskola és Kollégium Pálmajori Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6500,
								"regio":"Baja",
								"name":"Sugovica Sportiskolai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6500,
								"regio":"Baja",
								"name":"Sugovica Sportiskolai Általános Iskola Vöröskereszt Téri Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3531,
								"regio":"Miskolc",
								"name":"Balázs Győző Református Magyar - Angol Két Tanítási Nyelvű, Egységes Művészeti Általános- és Középiskola, Alapfokú Művészetoktatási Iskola"
						});
						this.schoolsListArray.push({
								"zip":3532,
								"regio":"Miskolc",
								"name":"Balázs Győző Református Líceum Műtermek"
						});
						this.schoolsListArray.push({
								"zip":5530,
								"regio":"Vésztő",
								"name":"Szabó Pál Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":5530,
								"regio":"Vésztő",
								"name":"Szabó Pál Általános Iskola és Alapfokú Művészeti Iskola Bartók Béla Téri Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3078,
								"regio":"Bátonyterenye",
								"name":"Bátonyterenyei Kossuth Lajos Térségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3070,
								"regio":"Bátonyterenye",
								"name":"Kossuth Térségi Általános Iskola Bartók Béla Tagintézménye és Alapfokú Művészeti Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3145,
								"regio":"Mátraterenye",
								"name":"Kossuth Térségi Általános Iskola Móra Ferenc Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3077,
								"regio":"Mátraverebély",
								"name":"Kossuth Térségi Általános Iskola Madách Imre Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3075,
								"regio":"Nagybárkány",
								"name":"Kossuth Térségi Általános Iskola Nagybárkányi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3075,
								"regio":"Nagybárkány",
								"name":"Kossuth Térségi Általános Iskola Nagybárkányi Tagintézményének Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2623,
								"regio":"Kismaros",
								"name":"Vilcsek Gyula Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3372,
								"regio":"Kömlő",
								"name":"Sütő András Általános Iskola és Alapfokú Művészeti Iskola Gárdonyi Géza Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3371,
								"regio":"Átány",
								"name":"Hanyi-menti Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9224,
								"regio":"Rajka",
								"name":"Békefi Ernő Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4642,
								"regio":"Tornyospálca",
								"name":"Tornyospálcai Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":4641,
								"regio":"Mezőladány",
								"name":"Tornyospálcai Általános Iskola és Alapfokú Művészeti Iskola Mezőladányi Tagintézménye "
						});
						this.schoolsListArray.push({
								"zip":4546,
								"regio":"Anarcs",
								"name":"Tornyospálcai Általános Iskola és Alapfokú Művészeti Iskola Czóbel Minka Tagintézménye "
						});
						this.schoolsListArray.push({
								"zip":4566,
								"regio":"Ilk",
								"name":"Tornyospálcai Általános Iskola és Alapfokú Művészeti Iskola Bethlen Gábor Tagintézménye "
						});
						this.schoolsListArray.push({
								"zip":4242,
								"regio":"Hajdúhadház",
								"name":"Rózsai Tivadar Református Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":4334,
								"regio":"Hodász",
								"name":"Hodászi Kölcsey Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3994,
								"regio":"Pálháza",
								"name":"Hegyközi Nyelvoktató Szlovák Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3996,
								"regio":"Füzér",
								"name":"Hegyközi Általános Iskola Füzéri Perényi Péter Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3992,
								"regio":"Kovácsvágás",
								"name":"Hegyközi Általános Iskola Kovácsvágási II. Rákóczi Ferenc Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3999,
								"regio":"Hollóháza",
								"name":"Hegyközi Általános Iskola Hollóházi Istványi Ferenc Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":1117,
								"regio":"Budapest",
								"name":"Lágymányosi Bárdos Lajos Két Tanítási Nyelvű Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7300,
								"regio":"Komló",
								"name":"Kökönyösi Általános Iskola, Gimnázium, Szakközépiskola, Szakiskola, Speciális Szakiskola, Kollégium, Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7396,
								"regio":"Magyarszék",
								"name":"Kökönyösi Szakközépiskola Magyarszéki Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":2800,
								"regio":"Tatabánya",
								"name":"Felsőgallai Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2800,
								"regio":"Tatabánya",
								"name":"Bánhidai Jókai Mór Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6725,
								"regio":"Szeged",
								"name":"Szegedi Móravárosi Ipari Szakképző és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6724,
								"regio":"Szeged",
								"name":"Szegedi Ipari Szakképző Iskola és Általános Iskola Déri Miksa Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6723,
								"regio":"Szeged",
								"name":"Szegedi Ipari Szakképző Iskola és Általános Iskola József Attila Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8087,
								"regio":"Alcsútdoboz",
								"name":"Alcsútdobozi József Nádor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2064,
								"regio":"Csabdi",
								"name":"Alcsútdobozi József Nádor Általános Iskola Petőfi Sándor Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7370,
								"regio":"Sásd",
								"name":"Sásdi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7523,
								"regio":"Kaposfő",
								"name":"Szennai Fekete László Általános Iskola Kaposfői Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7562,
								"regio":"Segesd",
								"name":"Segesd-Taranyi IV. Béla Király Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7514,
								"regio":"Tarany",
								"name":"Segesd-Taranyi IV. Béla Király Általános Iskola Taranyi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3211,
								"regio":"Gyöngyösoroszi",
								"name":"Gyöngyösoroszi Árpád Fejedelem Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7140,
								"regio":"Bátaszék",
								"name":"Cikádor Általános Iskola, Gimnázium és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7142,
								"regio":"Pörböly",
								"name":"Cikádor Általános Iskola és Gimnázium Pörbölyi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":5742,
								"regio":"Elek",
								"name":"Dr. Mester György Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5742,
								"regio":"Elek",
								"name":"Dr Mester György Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5300,
								"regio":"Karcag",
								"name":"Szent Pál Marista Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7342,
								"regio":"Mágocs",
								"name":"Hegyháti Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":7347,
								"regio":"Egyházaskozár",
								"name":"Hegyháti Általános Iskola és Alapfokú Művészeti Iskola Egyházaskozár - Bikali Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7346,
								"regio":"Bikal",
								"name":"Hegyháti Általános Iskola és Alapfokú Művészeti Iskola Egyházaskozár-Bikali Tagintézménye, Bikali Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5142,
								"regio":"Alattyán",
								"name":"Jászsági Általános Iskola Gerevich Aladár Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":5111,
								"regio":"Jászfelsőszentgyörgy",
								"name":"Jászsági Általános Iskola Szent György Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":5121,
								"regio":"Jászjákóhalma",
								"name":"Jászsági Általános Iskola IV. Béla Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":5141,
								"regio":"Jásztelek",
								"name":"Jászsági Általános Iskola Hunyadi Mátyás Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7394,
								"regio":"Magyarhertelend",
								"name":"Brázay Kálmán Általános Iskola, Gimnázium és Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":2737,
								"regio":"Ceglédbercel",
								"name":"Ceglédberceli Eötvös József Nyelvoktató Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":2737,
								"regio":"Ceglédbercel",
								"name":"Ceglédberceli Eötvös József Nyelvoktató Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola Petőfi Sándor utcai Telephely"
						});
						this.schoolsListArray.push({
								"zip":3905,
								"regio":"Monok",
								"name":"Monoki Kossuth Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2518,
								"regio":"Leányvár",
								"name":"Pilisi Általános Iskolák Közössége"
						});
						this.schoolsListArray.push({
								"zip":2517,
								"regio":"Kesztölc",
								"name":"Pilisi Általános Iskolák Közössége Kincses József Tagiskolája "
						});
						this.schoolsListArray.push({
								"zip":2519,
								"regio":"Piliscsév",
								"name":"Pilisi Általános Iskolák Közössége Piliscsévi Tagiskolája "
						});
						this.schoolsListArray.push({
								"zip":3044,
								"regio":"Szirák",
								"name":"Teleki József Általános Iskola és Szakiskola "
						});
						this.schoolsListArray.push({
								"zip":4700,
								"regio":"Mátészalka",
								"name":"Széchenyi István Katolikus és Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9184,
								"regio":"Kunsziget",
								"name":"Kunszigeti Két Tanítási Nyelvű Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":1077,
								"regio":"Budapest",
								"name":"Erzsébetvárosi Kéttannyelvű Általános Iskola, Szakiskola és Szakközépiskola Dob u. 85.Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5900,
								"regio":"Orosháza",
								"name":"Orosházi Református Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3533,
								"regio":"Miskolc",
								"name":"Nyitott Ajtó Baptista Általános Iskola ,Óvoda és Szakképző Iskola"
						});
						this.schoolsListArray.push({
								"zip":3295,
								"regio":"Erk",
								"name":"Erki Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3369,
								"regio":"Tarnabod",
								"name":"Máltai Óvoda és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3369,
								"regio":"Tarnabod",
								"name":"Máltai Óvoda és Általános Iskola Kossuth tér 1 sz. alatti telephelye - általános iskola"
						});
						this.schoolsListArray.push({
								"zip":3369,
								"regio":"Tarnabod",
								"name":"Máltai Óvoda és Általános Iskola Kossuth tér 5 sz. alatti Telephelye - általános iskola"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"II. János Pál Katolikus Általános Iskola 001-es telephelye"
						});
						this.schoolsListArray.push({
								"zip":3600,
								"regio":"Ózd",
								"name":"II. János Pál Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1158,
								"regio":"Budapest",
								"name":"Neptun Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6237,
								"regio":"Kecel",
								"name":"II. János Pál Katolikus Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":6238,
								"regio":"Imrehegy",
								"name":"II. János Pál Katolikus Általános Iskola és Óvoda Imrehegy Iskola Utcai Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":6236,
								"regio":"Tázlár",
								"name":"II. János Pál Katolikus Általános Iskola és Óvoda Tázlár Templom Közi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3529,
								"regio":"Miskolc",
								"name":"Fáy András Görögkatolikus Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":5200,
								"regio":"Törökszentmiklós",
								"name":"Bercsényi Miklós Katolikus Gimnázium és Kollégium, Általános Iskola, Óvoda"
						});
						this.schoolsListArray.push({
								"zip":6200,
								"regio":"Kiskőrös",
								"name":"Kiskőrösi Petőfi Sándor Evangélikus Óvoda, Általános Iskola, Gimnázium és Kertészeti Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":6200,
								"regio":"Kiskőrös",
								"name":"Kiskőrösi Evangélikus Középiskola Petőfi Sándor Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":3780,
								"regio":"Edelény",
								"name":"Szent Miklós Görögkatolikus Általános Iskola, Óvoda és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":3826,
								"regio":"Rakacaszend",
								"name":"Szent Miklós Görögkatolikus Általános Iskola, Óvoda és Alapfokú Művészeti Iskola Rakacaszendi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3812,
								"regio":"Homrogd",
								"name":"Homrogdi Görögkatolikus Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":3809,
								"regio":"Selyeb",
								"name":"Homrogdi Görögkatolikus Általános Iskola és Óvoda Szent Gergely Görögkatolikus Általános Iskola és Óvoda Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6932,
								"regio":"Magyarcsanád",
								"name":"Magyarcsanádi Református Általános Iskola és Hétszínvirág Református Óvoda és Egységes Óvoda-bölcsőde"
						});
						this.schoolsListArray.push({
								"zip":2531,
								"regio":"Tokod",
								"name":"Tokodi Hegyeskő Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2531,
								"regio":"Tokod",
								"name":"Hegyeskő Általános Iskola Határ utcai Épülete"
						});
						this.schoolsListArray.push({
								"zip":8123,
								"regio":"Soponya",
								"name":"Zichy János Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":1074,
								"regio":"Budapest",
								"name":"Bét Menachem Héber-Magyar Két Tannyelvű  Általános Iskola, Óvoda, Bölcsőde"
						});
						this.schoolsListArray.push({
								"zip":1223,
								"regio":"Budapest",
								"name":"Tomori Pál Magyar-Angol Két tanítási nyelvű Közgazdasági Szakközépiskola"
						});
						this.schoolsListArray.push({
								"zip":9026,
								"regio":"Győr",
								"name":"AUDI HUNGARIA Óvoda, Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":6230,
								"regio":"Soltvadkert",
								"name":"Kossuth Lajos Evangélikus Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":5130,
								"regio":"Jászapáti",
								"name":"Jászapáti Szent Imre Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5630,
								"regio":"Békés",
								"name":"Reményhír Szakképző Iskola, Általános Iskola, Óvoda és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":3561,
								"regio":"Felsőzsolca",
								"name":"Kazinczy Ferenc Református Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3561,
								"regio":"Felsőzsolca",
								"name":"Felsőzsolcai Szent István Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3360,
								"regio":"Heves",
								"name":"Eötvös József Református Oktatási Központ - Óvoda, Általános Iskola, Gimnázium, Szakközépiskola, Szakiskola, Alapfokú Művészeti Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":5537,
								"regio":"Zsadány",
								"name":"Zsadányi Református Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2481,
								"regio":"Velence",
								"name":"Zöldliget Magyar-Angol Két Tanítási Nyelvű Baptista Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2481,
								"regio":"Velence",
								"name":"Zöldliget Magyar-Angol Két Tanítási Nyelvű Baptista Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4485,
								"regio":"Nagyhalász",
								"name":"Csuha Antal Baptista Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4485,
								"regio":"Nagyhalász",
								"name":"Csuha Antal Baptista Általános Iskola Nagyhalász,Arany János utca 9. szám alatti Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3535,
								"regio":"Miskolc",
								"name":"Diósgyőri Szent Ferenc Római Katolikus Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3580,
								"regio":"Tiszaújváros",
								"name":"Kazinczy Ferenc Református Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3734,
								"regio":"Szuhogy",
								"name":"Martinkó András Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5065,
								"regio":"Nagykörű",
								"name":"Petrovay György Katolikus Általános Iskola, Alapfokú Művészeti Iskola, Óvoda"
						});
						this.schoolsListArray.push({
								"zip":5062,
								"regio":"Kőtelek",
								"name":"Petrovay György Katolikus Általános Iskola, Alapfokú Művészeti Iskola, Óvoda -  Szent Gellért Katolikus Általános Iskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3860,
								"regio":"Encs",
								"name":"Szent László Katolikus Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8089,
								"regio":"Vértesacsa",
								"name":"Reményik Sándor Református Általános Iskola és Alapfokú Művészeti Iskola Kazay Endre Német Nemzetiségi Általános Iskolája és Alapfokú Művészeti Iskolája"
						});
						this.schoolsListArray.push({
								"zip":2220,
								"regio":"Vecsés",
								"name":"Petőfi Sándor Római Katolikus Német Nemzetiségi Általános Iskola és Gimnázium "
						});
						this.schoolsListArray.push({
								"zip":3508,
								"regio":"Miskolc",
								"name":"Gárdonyi Géza Katolikus Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":1089,
								"regio":"Budapest",
								"name":"Avicenna International College Magyar-Angol Két Tanítási Nyelvű Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":2800,
								"regio":"Tatabánya",
								"name":"Füzes Utcai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2051,
								"regio":"Biatorbágy",
								"name":"Ritsmann Pál Német Nemzetiségi Általános Iskola "
						});
						this.schoolsListArray.push({
								"zip":4400,
								"regio":"Nyíregyháza",
								"name":"Sója Miklós Görögkatolikus Óvoda és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6100,
								"regio":"Kiskunfélegyháza",
								"name":"Szent Benedek Gimnázium, Szakképző Iskola és Kollégium Kiskunfélegyházi Petőfi Sándor Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":7700,
								"regio":"Mohács",
								"name":"Mohács Park Utcai Katolikus Általános Iskola és Óvoda"
						});
						this.schoolsListArray.push({
								"zip":6351,
								"regio":"Bátya",
								"name":"Bátyai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7834,
								"regio":"Baksa",
								"name":"Baksai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2681,
								"regio":"Galgagyörk",
								"name":"Galgagyörki Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2614,
								"regio":"Penc",
								"name":"Cserhátliget Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3459,
								"regio":"Igrici",
								"name":"Igrici Tompa Mihály Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":8126,
								"regio":"Sárszentágota",
								"name":"Sárszentágotai Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8125,
								"regio":"Sárkeresztúr",
								"name":"Sárkeresztúri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8125,
								"regio":"Sárkeresztúr",
								"name":"Sárkeresztúri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":8125,
								"regio":"Sárkeresztúr",
								"name":"Sárkeresztúri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5747,
								"regio":"Almáskamarás",
								"name":"Károlyi Bernát Nyelvoktató Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5300,
								"regio":"Karcag",
								"name":"Karcagi Arany János Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2834,
								"regio":"Tardos",
								"name":"Baji Szent István Német Nemzetiségi Általános Iskola Fekete Lajos Tardosi Szlovák Nemzetiségi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":8449,
								"regio":"Magyarpolány",
								"name":"Noszlopi Német Nemzetiségi Nyelvoktató Általános Iskola Magyarpolányi Kerek Nap Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6120,
								"regio":"Kiskunmajsa",
								"name":"Kiskunmajsai Arany János Általános Iskola és Egységes Gyógypedagógiai Módszertani Intézmény Móra Ferenc EGYMI"
						});
						this.schoolsListArray.push({
								"zip":5540,
								"regio":"Szarvas",
								"name":"Benka Gyula Evangélikus Angol Két Tanítási Nyelvű Általános Iskola és ÓvodaKossuth Lajos Utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3525,
								"regio":"Miskolc",
								"name":"Fazekas Utcai Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":9463,
								"regio":"Sopronhorpács",
								"name":"Sopronhorpácsi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3129,
								"regio":"Lucfalva",
								"name":"Lucfalvi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2131,
								"regio":"Göd",
								"name":"Huzella Tivadar Két Tanítási Nyelvű Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":1086,
								"regio":"Budapest",
								"name":"Lakatos Menyhért Általános Iskola és Gimnázium"
						});
						this.schoolsListArray.push({
								"zip":7720,
								"regio":"Pécsvárad",
								"name":"Kodolányi János Német Nemzetiségi Általános Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6447,
								"regio":"Felsőszentiván",
								"name":"Bajai Szentistváni Általános Iskola Arany János Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":6448,
								"regio":"Csávoly",
								"name":"Bajai Szentistváni Általános Iskola Csávolyi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3552,
								"regio":"Muhi",
								"name":"Sajószögedi Kölcsey Ferenc Körzeti Általános Iskola és Alapfokú Művészeti Iskola Muhi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":3974,
								"regio":"Ricse",
								"name":"Ricsei II. Rákóczi Ferenc Általános Iskola és Alapfokú Művészeti Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3726,
								"regio":"Zádorfalva",
								"name":"Aggteleki Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9421,
								"regio":"Fertőrákos",
								"name":"Fertőrákosi Általános Iskola és Alapfokú Művészeti Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4031,
								"regio":"Debrecen",
								"name":"Lilla Téri Általános Iskola Nagysándor József Általános Iskolai Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4141,
								"regio":"Furta",
								"name":"Furtai Bessenyei György Általános Iskola Furta Templom u. 10. sz. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":4141,
								"regio":"Furta",
								"name":"Furtai Bessenyei György Általános Iskola Furta Templom utca 3. sz. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":4123,
								"regio":"Hencida",
								"name":"Fekete Borbála Általános Iskola Csere-erdő Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":4123,
								"regio":"Hencida",
								"name":"Fekete Borbála Általános Iskola Hencidai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2944,
								"regio":"Bana",
								"name":"Banai Jókai Mór Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2649,
								"regio":"Dejtár",
								"name":"Drégelypalánki Szondi György Általános Iskola Mikszáth Kálmán Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":2652,
								"regio":"Tereske",
								"name":"Tereskei Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4735,
								"regio":"Szamossályi",
								"name":"Cégénydányádi Általános Iskola Szamossályi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4634,
								"regio":"Aranyosapáti",
								"name":"Papi Kölcsey Ferenc Általános Iskola Aranyosapáti Tagiskolája  Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4632,
								"regio":"Nyírlövő",
								"name":"Papi Kölcsey Ferenc Általános Iskola Nyírlövői Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":4561,
								"regio":"Baktalórántháza",
								"name":"Baktalórántházi Reguly Antal Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4564,
								"regio":"Nyírmada",
								"name":"Patay István Általános Iskola 2. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3381,
								"regio":"Pély",
								"name":"Csete Balázs Általános Iskola Petőfi Sándor Tagiskolája Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5055,
								"regio":"Jászladány",
								"name":"Jászladányi Móra Ferenc Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7165,
								"regio":"Mórágy",
								"name":"Mórágyi Általános Iskola Alkotmány utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":7098,
								"regio":"Magyarkeszi",
								"name":"Iregszemcsei Deák Ferenc Általános Iskola Magyarkeszi Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":7098,
								"regio":"Magyarkeszi",
								"name":"Iregszemcsei Deák Ferenc Általános Iskola Magyarkeszi Tagiskolája Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3728,
								"regio":"Kelemér",
								"name":"Serényi László Általános Iskola Keleméri Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3980,
								"regio":"Sátoraljaújhely",
								"name":"Kazinczy Ferenc Általános Iskola Esze Tamás Tagintézménye Esze Tamás utca 10. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8060,
								"regio":"Mór",
								"name":"Móri Radnóti Miklós Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8053,
								"regio":"Bodajk",
								"name":"Bodajki Általános Iskola Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3933,
								"regio":"Olaszliszka",
								"name":"Olaszliszkai Hegyalja Általános Iskola Szent István utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2518,
								"regio":"Leányvár",
								"name":"Pilisi Általános Iskolák Közössége Leányvár, Erzsébet út 96. sz. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":2518,
								"regio":"Leányvár",
								"name":"Pilisi Általános Iskolák Közössége Leányvár, Erzsébet út 98. sz. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":3800,
								"regio":"Szikszó",
								"name":"ABAKUSZ Szakképző Iskola és Alapfokú Művészeti Iskola"
						});
						this.schoolsListArray.push({
								"zip":6914,
								"regio":"Pitvaros",
								"name":"Pitvarosi Petőfi Sándor Általános Iskola és Alapfokú Művészeti Iskola Kossuth Lajos utca 33-35. alatti telephelye"
						});
						this.schoolsListArray.push({
								"zip":1105,
								"regio":"Budapest",
								"name":"Orchidea Magyar-Angol Két Tanítási Nyelvű Óvoda és Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":6000,
								"regio":"Kecskemét",
								"name":"Kecskeméti Humán Szakképző Iskola és Kollégium"
						});
						this.schoolsListArray.push({
								"zip":7186,
								"regio":"Aparhant",
								"name":"Aparhanti Általános Iskola I. sz. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":8481,
								"regio":"Somlóvásárhely",
								"name":"Somlóvásárhelyi Széchenyi István Általános Iskola Sport utcai telephelye"
						});
						this.schoolsListArray.push({
								"zip":3100,
								"regio":"Salgótarján",
								"name":"Salgótarjáni Általános Iskola és Kollégium József Attila úti Telephely"
						});
						this.schoolsListArray.push({
								"zip":2040,
								"regio":"Budaörs",
								"name":"Mindszenty József Római Katolikus Óvoda és Nyelvoktató Német Nemzetiségi Általános Iskola - Iskola II"
						});
						this.schoolsListArray.push({
								"zip":2000,
								"regio":"Szentendre",
								"name":"Rákóczi F. Gimnázium Szentendre"
						});
						this.schoolsListArray.push({
								"zip":7632,
								"regio":"Pécs",
								"name":"Anikó utca iskola Pécs"
						});
						this.schoolsListArray.push({
								"zip":8041,
								"regio":"Csór",
								"name":"Csóri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2400,
								"regio":"Dunaújváros",
								"name":"Dunaújvárosi Lengyel Nemzetiségi Önkormányzat"
						});
						this.schoolsListArray.push({
								"zip":2521,
								"regio":"Csolnok",
								"name":"Csolnoki Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3077,
								"regio":"Mátraverebély",
								"name":"Dr. Ámbédkar Iskola mátraverebélyi telephelye"
						});
						this.schoolsListArray.push({
								"zip":4334,
								"regio":"Hodász",
								"name":"Dankó Pista Egységes Óvoda-Bölcsőde, Általános Iskola, Szakképző Iskola, Gimnázium, Kollégium és Alapfokú Művészeti Iskola Hodászi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":2064,
								"regio":"Csabdi",
								"name":"Csabdi Petőfi Sándor Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4517,
								"regio":"Gégény",
								"name":"Gégényi Gárdonyi Géza Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4488,
								"regio":"Beszterec",
								"name":"Besztereci Móricz Zsigmond Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9024,
								"regio":"Győr",
								"name":"Győri Kovács Margit Német Nyelvoktató Nemzetiségi Általános Iskola, Alapfokú Művészeti Iskola, Iparművészeti Szakközépiskola és Szakiskola "
						});
						this.schoolsListArray.push({
								"zip":9025,
								"regio":"Győr",
								"name":"Győri Kossuth Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":9025,
								"regio":"Győr",
								"name":"Győri Kossuth Lajos Általános Iskola Márvány Utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":9025,
								"regio":"Győr",
								"name":"Győri Kossuth Lajos Általános Iskola Burcsellás közi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4110,
								"regio":"Biharkeresztes",
								"name":"Biharkeresztesi Bocskai István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4110,
								"regio":"Biharkeresztes",
								"name":"Biharkeresztesi Bocskai István Általános Iskola Széchenyi utcai Telephelye"
						});
						this.schoolsListArray.push({
								"zip":4114,
								"regio":"Bojt",
								"name":"Biharkeresztesi Bocskai István Általános Iskola, Petőfi Sándor Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":4127,
								"regio":"Nagykereki",
								"name":"Biharkeresztesi Bocskai István Általános Iskola Bocskai István Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":4114,
								"regio":"Bojt",
								"name":"Biharkeresztesi Bocskai István Általános Iskola Petőfi Sándor Tagiskolája"
						});
						this.schoolsListArray.push({
								"zip":5700,
								"regio":"Gyula",
								"name":"Gyulai Implom József Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":5700,
								"regio":"Gyula",
								"name":"Gyulai Implom József Általános Iskola 5. Sz. Általános Iskola és Sportiskola Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":4150,
								"regio":"Püspökladány",
								"name":"Petritelepi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4150,
								"regio":"Püspökladány",
								"name":"Petritelepi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":4150,
								"regio":"Püspökladány",
								"name":"Kálvin Téri Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":2852,
								"regio":"Kecskéd",
								"name":"Kecskédi Német Nemzetiségi Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":3458,
								"regio":"Tiszakeszi",
								"name":"Tiszakeszi Széchenyi István Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7551,
								"regio":"Lábod",
								"name":"Kótai Lajos Általános Iskola"
						});
						this.schoolsListArray.push({
								"zip":7545,
								"regio":"Nagykorpád",
								"name":"Kótai Lajos Általános Iskola Nagykorpádi Telephelye"
						});
						this.schoolsListArray.push({
								"zip":6500,
								"regio":"Baja",
								"name":"Magyarországi Németek Általános Művelődési Központja Bajai Telephely"
						});
						this.schoolsListArray.push({
								"zip":7561,
								"regio":"Nagybajom",
								"name":"Bárczi Gusztáv Gyógypedagógiai Módszertani  Intézmény Nagybajomi Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":3187,
								"regio":"Nógrádszakál",
								"name":"Ráday Gedeon Általános Iskola Nógrádszakáli Telephelye"
						});
						this.schoolsListArray.push({
								"zip":3770,
								"regio":"Sajószentpéter",
								"name":"Új Esély Oktatási Központ 008-as Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5510,
								"regio":"Dévaványa",
								"name":"Szegedi Kis István Református Gimnázium, Általános Iskola, Óvoda és Kollégium Szügyi Dániel Tagintézménye Bem József utca 7. Telephelye"
						});
						this.schoolsListArray.push({
								"zip":5510,
								"regio":"Dévaványa",
								"name":"Szegedi Kis István Református Gimnázium, Általános Iskola, Óvoda és Kollégium Szügyi Dániel Tagintézménye"
						});
						this.schoolsListArray.push({
								"zip":2309,
								"regio":"Lórév",
								"name":"Nikola Tesla Szerb Tanítási Nyelvű Óvoda, Általános Iskola, Gimnázium és Kollégium Lórévi Általános Iskolája"
						});
						this.schoolsListArray.push({
								"zip":7621,
								"regio":"Pécs",
								"name":"Kis Tigris Gimnázium, Szakiskola és Szakközépiskola Pécs Telephely"
						});
						this.schoolsListArray.push({
								"zip":3767,
								"regio":"Tornanádaska",
								"name":"Bódvaszilasi Körzeti Általános Iskola Tornanádaskai Tagiskolája"
						});
				}
		}
}

