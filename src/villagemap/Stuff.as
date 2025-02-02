package villagemap
{
	public class Stuff
	{
		public var farmLevels:Object;

		public var buildingsData:Array;

		public var inventoryItems:Array;

		public function Stuff()
		{
			this.farmLevels = new Object();
			this.buildingsData = new Array();
			this.inventoryItems = new Array();
			super();
			this.buildingsData.push({
						"building": "Castle",
						"booster": "CASTLE",
						"label": "village_castle",
						"x": "21",
						"y": "48",
						"uls": null,
						"size": "7x7",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Blacksmith",
						"booster": "SELHALF",
						"label": "village_blacksmith",
						"x": "26",
						"y": "40",
						"uls": 9,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "Inn",
						"booster": "SELANSW",
						"label": "village_inn",
						"x": "24",
						"y": "52",
						"uls": 10,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "Architect",
						"booster": "FORTRESS",
						"label": "village_architect",
						"x": "28",
						"y": "44",
						"uls": 15,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "General",
						"booster": "SUBJECT",
						"label": "village_general",
						"x": "25",
						"y": "49",
						"uls": 14,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "Wizard",
						"booster": "AIRBORNE",
						"label": "village_wizard",
						"x": "18",
						"y": "35",
						"uls": 13,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "Scientist",
						"booster": "TIPRANG",
						"label": "village_scientist",
						"x": "22",
						"y": "33",
						"uls": 12,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "Petmerchant",
						"booster": "TIPAVER",
						"label": "village_petmerchant",
						"x": "20",
						"y": "29",
						"uls": 11,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "Postoffice",
						"booster": "POSTOFFICE",
						"label": "village_postoffice",
						"x": "21",
						"y": "58",
						"uls": null,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Bank",
						"booster": "BANK",
						"label": "village_bank",
						"x": "22",
						"y": "55",
						"uls": null,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Library",
						"booster": "ATHENEUM",
						"label": "village_library",
						"x": "14",
						"y": "44",
						"uls": 8,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Stonehenge",
						"booster": "CLAN",
						"label": "village_clans",
						"x": "25",
						"y": "28",
						"uls": 0,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Ranklist",
						"booster": "RANKLIST",
						"label": "village_ranklist",
						"x": "18",
						"y": "49",
						"uls": null,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Lobby",
						"booster": "LOBBY",
						"label": "village_lobby",
						"x": "13",
						"y": "34",
						"uls": 4,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Pirate",
						"booster": "SERIES1",
						"label": "village_pirate",
						"x": "30",
						"y": "23",
						"uls": 16,
						"size": "3x3",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "University",
						"booster": "SERIES2",
						"label": "village_university",
						"x": "28",
						"y": "36",
						"uls": 17,
						"size": "4x4",
						"type": "forge"
					});
			this.buildingsData.push({
						"building": "StartTriviador",
						"booster": "START_TRIVIADOR",
						"label": "startgame",
						"x": "16",
						"y": "39",
						"uls": null,
						"size": "4x4",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "FacebookFp",
						"booster": "FACEBOOKFP",
						"label": "",
						"x": "13",
						"y": "64",
						"uls": null,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Camp",
						"booster": "CAMP",
						"label": "",
						"x": "25",
						"y": "59",
						"uls": null,
						"size": "3x3",
						"type": "win"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER1",
						"label": "",
						"x": "23",
						"y": "63",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER2",
						"label": "",
						"x": "28",
						"y": "54",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER3",
						"label": "",
						"x": "29",
						"y": "41",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER4",
						"label": "",
						"x": "22",
						"y": "26",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER5",
						"label": "",
						"x": "16",
						"y": "30",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER6",
						"label": "",
						"x": "11",
						"y": "39",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER7",
						"label": "",
						"x": "11",
						"y": "49",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER8",
						"label": "",
						"x": "18",
						"y": "63",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER9",
						"label": "",
						"x": "25",
						"y": "66",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER10",
						"label": "",
						"x": "29",
						"y": "57",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER11",
						"label": "",
						"x": "31",
						"y": "38",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER12",
						"label": "",
						"x": "23",
						"y": "23",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER13",
						"label": "",
						"x": "14",
						"y": "27",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER14",
						"label": "",
						"x": "10",
						"y": "36",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER15",
						"label": "",
						"x": "10",
						"y": "52",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER16",
						"label": "",
						"x": "17",
						"y": "66",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER17",
						"label": "",
						"x": "26",
						"y": "69",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER18",
						"label": "",
						"x": "31",
						"y": "60",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER19",
						"label": "",
						"x": "32",
						"y": "35",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER20",
						"label": "",
						"x": "25",
						"y": "20",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER21",
						"label": "",
						"x": "13",
						"y": "24",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER22",
						"label": "",
						"x": "8",
						"y": "33",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER23",
						"label": "",
						"x": "15",
						"y": "69",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER24",
						"label": "",
						"x": "28",
						"y": "66",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER25",
						"label": "",
						"x": "29",
						"y": "63",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER26",
						"label": "",
						"x": "31",
						"y": "32",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER27",
						"label": "",
						"x": "28",
						"y": "26",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER28",
						"label": "",
						"x": "26",
						"y": "23",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER29",
						"label": "",
						"x": "11",
						"y": "27",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER30",
						"label": "",
						"x": "10",
						"y": "30",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER31",
						"label": "",
						"x": "18",
						"y": "24",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER32",
						"label": "",
						"x": "30",
						"y": "49",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER33",
						"label": "",
						"x": "16",
						"y": "21",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER34",
						"label": "",
						"x": "32",
						"y": "52",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER35",
						"label": "",
						"x": "19",
						"y": "21",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER36",
						"label": "",
						"x": "32",
						"y": "46",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER37",
						"label": "",
						"x": "15",
						"y": "18",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER38",
						"label": "",
						"x": "33",
						"y": "55",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER39",
						"label": "",
						"x": "21",
						"y": "18",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "Farmer",
						"booster": "FARMER40",
						"label": "",
						"x": "33",
						"y": "43",
						"uls": null,
						"size": "3x3",
						"type": "farm"
					});
			this.buildingsData.push({
						"building": "StatueBadge",
						"booster": "STATUEBADGE_0",
						"label": "",
						"x": "17",
						"y": "53",
						"uls": null,
						"size": "1x1",
						"type": "badgestatue"
					});
			this.buildingsData.push({
						"building": "StatueBadge",
						"booster": "STATUEBADGE_1",
						"label": "",
						"x": "16",
						"y": "56",
						"uls": null,
						"size": "1x1",
						"type": "badgestatue"
					});
			this.buildingsData.push({
						"building": "StatueBadge",
						"booster": "STATUEBADGE_2",
						"label": "",
						"x": "14",
						"y": "59",
						"uls": null,
						"size": "1x1",
						"type": "badgestatue"
					});
			this.buildingsData.push({
						"building": "StatueBadge",
						"booster": "STATUEBADGE_3",
						"label": "",
						"x": "14",
						"y": "52",
						"uls": null,
						"size": "1x1",
						"type": "badgestatue"
					});
			this.buildingsData.push({
						"building": "StatueBadge",
						"booster": "STATUEBADGE_4",
						"label": "",
						"x": "12",
						"y": "55",
						"uls": null,
						"size": "1x1",
						"type": "badgestatue"
					});
			this.buildingsData.push({
						"building": "StatueBadge",
						"booster": "STATUEBADGE_5",
						"label": "",
						"x": "15",
						"y": "49",
						"uls": null,
						"size": "1x1",
						"type": "badgestatue"
					});
			this.buildingsData.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1_64",
						"label": "",
						"x": "28",
						"y": "17",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1_65",
						"label": "",
						"x": "29",
						"y": "73",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood3_1x1",
						"booster": "WOOD3_1X1_66",
						"label": "",
						"x": "33",
						"y": "20",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood1_1x1",
						"booster": "WOOD1_1X1_70",
						"label": "",
						"x": "7",
						"y": "20",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood1_1x1",
						"booster": "WOOD1_1X1_71",
						"label": "",
						"x": "7",
						"y": "13",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood1_1x1",
						"booster": "WOOD1_1X1_72",
						"label": "",
						"x": "8",
						"y": "17",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood4_1x1",
						"booster": "WOOD4_1X1_73",
						"label": "",
						"x": "19",
						"y": "14",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1_74",
						"label": "",
						"x": "13",
						"y": "14",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood4_1x1",
						"booster": "WOOD4_1X1_75",
						"label": "",
						"x": "7",
						"y": "54",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1_76",
						"label": "",
						"x": "32",
						"y": "68",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood4_1x1",
						"booster": "WOOD4_1X1_77",
						"label": "",
						"x": "33",
						"y": "19",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood3_1x1",
						"booster": "WOOD3_1X1_78",
						"label": "",
						"x": "34",
						"y": "20",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1_79",
						"label": "",
						"x": "11",
						"y": "78",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood3_1x1",
						"booster": "WOOD3_1X1_80",
						"label": "",
						"x": "18",
						"y": "16",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1_81",
						"label": "",
						"x": "17",
						"y": "14",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood4_1x1",
						"booster": "WOOD4_1X1_87",
						"label": "",
						"x": "31",
						"y": "74",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.buildingsData.push({
						"building": "Wood3_1x1",
						"booster": "WOOD3_1X1_88",
						"label": "",
						"x": "6",
						"y": "60",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Wood1_1x1",
						"booster": "WOOD1_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Wood2_1x1",
						"booster": "WOOD2_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Wood3_1x1",
						"booster": "WOOD3_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Wood4_1x1",
						"booster": "WOOD4_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Mountain1_2x2",
						"booster": "MOUNTAIN1_2X2",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "2x2",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Mountain1_3x3",
						"booster": "MOUNTAIN1_3X3",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "3x3",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Mountain1_4x4",
						"booster": "MOUNTAIN1_4X4",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "4x4",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Corn1_2x2",
						"booster": "CORN1_2X2",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "2x2",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Path1_1x1",
						"booster": "PATH1_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Path2_1x1",
						"booster": "PATH2_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.inventoryItems.push({
						"building": "Water1_1x1",
						"booster": "WATER1_1X1",
						"label": "",
						"x": "",
						"y": "",
						"uls": null,
						"size": "1x1",
						"type": "environment"
					});
			this.farmLevels.lvl1 = 1;
			this.farmLevels.lvl2 = 2;
			this.farmLevels.lvl3 = 3;
			this.farmLevels.lvl4 = 4;
			this.farmLevels.lvl5 = 5;
			this.farmLevels.lvl6 = 6;
			this.farmLevels.lvl7 = 7;
			this.farmLevels.lvl8 = 8;
			this.farmLevels.lvl9 = 9;
			this.farmLevels.lvl10 = 10;
			this.farmLevels.lvl11 = 11;
			this.farmLevels.lvl12 = 12;
			this.farmLevels.lvl13 = 13;
			this.farmLevels.lvl14 = 14;
			this.farmLevels.lvl15 = 15;
			this.farmLevels.lvl16 = 16;
			this.farmLevels.lvl17 = 17;
			this.farmLevels.lvl18 = 18;
			this.farmLevels.lvl19 = 19;
			this.farmLevels.lvl20 = 20;
			this.farmLevels.lvl21 = 1;
			this.farmLevels.lvl22 = 2;
			this.farmLevels.lvl23 = 3;
			this.farmLevels.lvl24 = 4;
			this.farmLevels.lvl25 = 5;
			this.farmLevels.lvl26 = 6;
			this.farmLevels.lvl27 = 7;
			this.farmLevels.lvl28 = 8;
			this.farmLevels.lvl29 = 9;
			this.farmLevels.lvl30 = 10;
			this.farmLevels.lvl31 = 21;
			this.farmLevels.lvl32 = 22;
			this.farmLevels.lvl33 = 23;
			this.farmLevels.lvl34 = 24;
			this.farmLevels.lvl35 = 25;
			this.farmLevels.lvl36 = 26;
			this.farmLevels.lvl37 = 27;
			this.farmLevels.lvl38 = 28;
			this.farmLevels.lvl39 = 29;
			this.farmLevels.lvl40 = 30;
			this.farmLevels.lvl41 = 11;
			this.farmLevels.lvl42 = 12;
			this.farmLevels.lvl43 = 13;
			this.farmLevels.lvl44 = 14;
			this.farmLevels.lvl45 = 15;
			this.farmLevels.lvl46 = 16;
			this.farmLevels.lvl47 = 17;
			this.farmLevels.lvl48 = 18;
			this.farmLevels.lvl49 = 19;
			this.farmLevels.lvl50 = 20;
			this.farmLevels.lvl51 = 31;
			this.farmLevels.lvl52 = 32;
			this.farmLevels.lvl53 = 33;
			this.farmLevels.lvl54 = 34;
			this.farmLevels.lvl55 = 35;
			this.farmLevels.lvl56 = 36;
			this.farmLevels.lvl57 = 37;
			this.farmLevels.lvl58 = 38;
			this.farmLevels.lvl59 = 39;
			this.farmLevels.lvl60 = 40;
			this.farmLevels.lvl61 = 21;
			this.farmLevels.lvl62 = 22;
			this.farmLevels.lvl63 = 23;
			this.farmLevels.lvl64 = 24;
			this.farmLevels.lvl65 = 25;
			this.farmLevels.lvl66 = 26;
			this.farmLevels.lvl67 = 27;
			this.farmLevels.lvl68 = 28;
			this.farmLevels.lvl69 = 29;
			this.farmLevels.lvl70 = 30;
			this.farmLevels.lvl71 = 1;
			this.farmLevels.lvl72 = 2;
			this.farmLevels.lvl73 = 3;
			this.farmLevels.lvl74 = 4;
			this.farmLevels.lvl75 = 5;
			this.farmLevels.lvl76 = 6;
			this.farmLevels.lvl77 = 7;
			this.farmLevels.lvl78 = 8;
			this.farmLevels.lvl79 = 9;
			this.farmLevels.lvl80 = 10;
			this.farmLevels.lvl81 = 31;
			this.farmLevels.lvl82 = 32;
			this.farmLevels.lvl83 = 33;
			this.farmLevels.lvl84 = 34;
			this.farmLevels.lvl85 = 35;
			this.farmLevels.lvl86 = 36;
			this.farmLevels.lvl87 = 37;
			this.farmLevels.lvl88 = 38;
			this.farmLevels.lvl89 = 39;
			this.farmLevels.lvl90 = 40;
			this.farmLevels.lvl91 = 11;
			this.farmLevels.lvl92 = 12;
			this.farmLevels.lvl93 = 13;
			this.farmLevels.lvl94 = 14;
			this.farmLevels.lvl95 = 15;
			this.farmLevels.lvl96 = 16;
			this.farmLevels.lvl97 = 17;
			this.farmLevels.lvl98 = 18;
			this.farmLevels.lvl99 = 19;
			this.farmLevels.lvl100 = 20;
			this.farmLevels.lvl101 = 1;
			this.farmLevels.lvl102 = 2;
			this.farmLevels.lvl103 = 3;
			this.farmLevels.lvl104 = 4;
			this.farmLevels.lvl105 = 5;
			this.farmLevels.lvl106 = 6;
			this.farmLevels.lvl107 = 7;
			this.farmLevels.lvl108 = 8;
			this.farmLevels.lvl109 = 9;
			this.farmLevels.lvl110 = 10;
			this.farmLevels.lvl111 = 11;
			this.farmLevels.lvl112 = 12;
			this.farmLevels.lvl113 = 13;
			this.farmLevels.lvl114 = 14;
			this.farmLevels.lvl115 = 15;
			this.farmLevels.lvl116 = 16;
			this.farmLevels.lvl117 = 17;
			this.farmLevels.lvl118 = 18;
			this.farmLevels.lvl119 = 19;
			this.farmLevels.lvl120 = 20;
			this.farmLevels.lvl121 = 21;
			this.farmLevels.lvl122 = 22;
			this.farmLevels.lvl123 = 23;
			this.farmLevels.lvl124 = 24;
			this.farmLevels.lvl125 = 25;
			this.farmLevels.lvl126 = 26;
			this.farmLevels.lvl127 = 27;
			this.farmLevels.lvl128 = 28;
			this.farmLevels.lvl129 = 29;
			this.farmLevels.lvl130 = 30;
			this.farmLevels.lvl131 = 31;
			this.farmLevels.lvl132 = 32;
			this.farmLevels.lvl133 = 33;
			this.farmLevels.lvl134 = 34;
			this.farmLevels.lvl135 = 35;
			this.farmLevels.lvl136 = 36;
			this.farmLevels.lvl137 = 37;
			this.farmLevels.lvl138 = 38;
			this.farmLevels.lvl139 = 39;
			this.farmLevels.lvl140 = 40;
			this.farmLevels.lvl141 = 1;
			this.farmLevels.lvl142 = 2;
			this.farmLevels.lvl143 = 3;
			this.farmLevels.lvl144 = 4;
			this.farmLevels.lvl145 = 5;
			this.farmLevels.lvl146 = 6;
			this.farmLevels.lvl147 = 7;
			this.farmLevels.lvl148 = 8;
			this.farmLevels.lvl149 = 9;
			this.farmLevels.lvl150 = 10;
			this.farmLevels.lvl151 = 11;
			this.farmLevels.lvl152 = 12;
			this.farmLevels.lvl153 = 13;
			this.farmLevels.lvl154 = 14;
			this.farmLevels.lvl155 = 15;
			this.farmLevels.lvl156 = 16;
			this.farmLevels.lvl157 = 17;
			this.farmLevels.lvl158 = 18;
			this.farmLevels.lvl159 = 19;
			this.farmLevels.lvl160 = 20;
			this.farmLevels.lvl161 = 21;
			this.farmLevels.lvl162 = 22;
			this.farmLevels.lvl163 = 23;
			this.farmLevels.lvl164 = 24;
			this.farmLevels.lvl165 = 25;
			this.farmLevels.lvl166 = 26;
			this.farmLevels.lvl167 = 27;
			this.farmLevels.lvl168 = 28;
			this.farmLevels.lvl169 = 29;
			this.farmLevels.lvl170 = 30;
			this.farmLevels.lvl171 = 31;
			this.farmLevels.lvl172 = 32;
			this.farmLevels.lvl173 = 33;
			this.farmLevels.lvl174 = 34;
			this.farmLevels.lvl175 = 35;
			this.farmLevels.lvl176 = 36;
			this.farmLevels.lvl177 = 37;
			this.farmLevels.lvl178 = 38;
			this.farmLevels.lvl179 = 39;
			this.farmLevels.lvl180 = 40;
			this.farmLevels.lvl181 = 21;
			this.farmLevels.lvl182 = 22;
			this.farmLevels.lvl183 = 23;
			this.farmLevels.lvl184 = 24;
			this.farmLevels.lvl185 = 25;
			this.farmLevels.lvl186 = 26;
			this.farmLevels.lvl187 = 27;
			this.farmLevels.lvl188 = 28;
			this.farmLevels.lvl189 = 29;
			this.farmLevels.lvl190 = 30;
			this.farmLevels.lvl191 = 31;
			this.farmLevels.lvl192 = 32;
			this.farmLevels.lvl193 = 33;
			this.farmLevels.lvl194 = 34;
			this.farmLevels.lvl195 = 35;
			this.farmLevels.lvl196 = 36;
			this.farmLevels.lvl197 = 37;
			this.farmLevels.lvl198 = 38;
			this.farmLevels.lvl199 = 39;
			this.farmLevels.lvl200 = 40;
		}
	}
}
