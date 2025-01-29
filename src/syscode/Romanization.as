package syscode
{
    public class Romanization
    {
        public static function ToLatin(str:String):String
        {
            var tmp:String = str;
            tmp = Romanization.GeorgianToLatin(tmp);
            return Romanization.ArmanianToLatin(tmp);
        }

        public static function GeorgianToLatin(str:String):String
        {
            var idx:* = undefined;
            var cc:* = undefined;
            var sc:* = undefined;
            var ac:int = 0;
            if (str == null)
            {
                return null;
            }
            var translit:Boolean = false;
            for (idx = 0; idx < str.length; idx++)
            {
                cc = str.charCodeAt(idx);
                if (cc >= 4256 && cc <= 4351)
                {
                    translit = true;
                    break;
                }
            }
            if (!translit)
            {
                return str;
            }
            var res:String = "";
            for (idx = 0; idx < str.length; idx++)
            {
                cc = str.charCodeAt(idx);
                sc = 0;
                ac = 0;
                switch (cc)
                {
                    case 4304:
                        sc = 65;
                        break;
                    case 4305:
                        sc = 66;
                        break;
                    case 4306:
                        sc = 71;
                        break;
                    case 4307:
                        sc = 68;
                        break;
                    case 4308:
                        sc = 69;
                        break;
                    case 4309:
                        sc = 86;
                        break;
                    case 4310:
                        sc = 90;
                        break;
                    case 4337:
                        sc = 274;
                        break;
                    case 4311:
                        sc = 84;
                        ac = 39;
                        break;
                    case 4312:
                        sc = 73;
                        break;
                    case 4313:
                        sc = 75;
                        break;
                    case 4314:
                        sc = 76;
                        break;
                    case 4315:
                        sc = 77;
                        break;
                    case 4316:
                        sc = 78;
                        break;
                    case 4338:
                        sc = 89;
                        break;
                    case 4317:
                        sc = 79;
                        break;
                    case 4318:
                        sc = 80;
                        break;
                    case 4319:
                        sc = 381;
                        break;
                    case 4320:
                        sc = 82;
                        break;
                    case 4321:
                        sc = 83;
                        break;
                    case 4322:
                        sc = 84;
                        break;
                    case 4339:
                        sc = 87;
                        break;
                    case 4323:
                        sc = 85;
                        break;
                    case 4343:
                        sc = 0;
                        break;
                    case 4324:
                        sc = 80;
                        ac = 39;
                        break;
                    case 4325:
                        sc = 75;
                        ac = 39;
                        break;
                    case 4326:
                        sc = 7712;
                        break;
                    case 4327:
                        sc = 81;
                        break;
                    case 4344:
                        sc = 0;
                        break;
                    case 4328:
                        sc = 352;
                        break;
                    case 4329:
                        sc = 268;
                        ac = 39;
                        break;
                    case 4330:
                        sc = 67;
                        ac = 39;
                        break;
                    case 4331:
                        sc = 74;
                        break;
                    case 4332:
                        sc = 67;
                        break;
                    case 4333:
                        sc = 268;
                        break;
                    case 4334:
                        sc = 88;
                        break;
                    case 4340:
                        sc = 72;
                        ac = 817;
                        break;
                    case 4335:
                        sc = 74;
                        ac = 780;
                        break;
                    case 4336:
                        sc = 72;
                        break;
                    case 4341:
                        sc = 332;
                        break;
                    case 4342:
                        sc = 70;
                        break;
                    default:
                        sc = cc;
                }
                if (sc > 0)
                {
                    res += String.fromCharCode(sc);
                    if (ac > 0)
                    {
                        res += String.fromCharCode(ac);
                    }
                }
            }
            return res;
        }

        public static function ArmanianToLatin(str:String):String
        {
            var idx:* = undefined;
            var cc:* = undefined;
            var sc:* = undefined;
            var ac:int = 0;
            if (str == null)
            {
                return null;
            }
            var translit:Boolean = false;
            for (idx = 0; idx < str.length; idx++)
            {
                cc = str.charCodeAt(idx);
                if (cc >= 1328 && cc <= 1423)
                {
                    translit = true;
                    break;
                }
            }
            if (!translit)
            {
                return str;
            }
            var res:String = "";
            for (idx = 0; idx < str.length; idx++)
            {
                cc = str.charCodeAt(idx);
                sc = 0;
                ac = 0;
                switch (cc)
                {
                    case 1329:
                        sc = 65;
                        break;
                    case 1377:
                        sc = 97;
                        break;
                    case 1330:
                        sc = 66;
                        break;
                    case 1378:
                        sc = 98;
                        break;
                    case 1331:
                        sc = 71;
                        break;
                    case 1379:
                        sc = 103;
                        break;
                    case 1332:
                        sc = 68;
                        break;
                    case 1380:
                        sc = 100;
                        break;
                    case 1333:
                        sc = 69;
                        break;
                    case 1381:
                        sc = 101;
                        break;
                    case 1334:
                        sc = 90;
                        break;
                    case 1382:
                        sc = 122;
                        break;
                    case 1335:
                        sc = 274;
                        break;
                    case 1383:
                        sc = 275;
                        break;
                    case 1336:
                        sc = 203;
                        break;
                    case 1384:
                        sc = 235;
                        break;
                    case 1337:
                        sc = 84;
                        ac = 39;
                        break;
                    case 1385:
                        sc = 116;
                        ac = 39;
                        break;
                    case 1338:
                        sc = 381;
                        break;
                    case 1386:
                        sc = 382;
                        break;
                    case 1339:
                        sc = 73;
                        break;
                    case 1387:
                        sc = 105;
                        break;
                    case 1340:
                        sc = 76;
                        break;
                    case 1388:
                        sc = 108;
                        break;
                    case 1341:
                        sc = 88;
                        break;
                    case 1389:
                        sc = 120;
                        break;
                    case 1342:
                        sc = 199;
                        break;
                    case 1390:
                        sc = 231;
                        break;
                    case 1343:
                        sc = 75;
                        break;
                    case 1391:
                        sc = 107;
                        break;
                    case 1344:
                        sc = 72;
                        break;
                    case 1392:
                        sc = 104;
                        break;
                    case 1345:
                        sc = 74;
                        break;
                    case 1393:
                        sc = 106;
                        break;
                    case 1346:
                        sc = 288;
                        break;
                    case 1394:
                        sc = 289;
                        break;
                    case 1347:
                        sc = 270;
                        ac = 803;
                        break;
                    case 1395:
                        sc = 269;
                        ac = 803;
                        break;
                    case 1348:
                        sc = 77;
                        break;
                    case 1396:
                        sc = 109;
                        break;
                    case 1349:
                        sc = 89;
                        break;
                    case 1397:
                        sc = 121;
                        break;
                    case 1350:
                        sc = 78;
                        break;
                    case 1398:
                        sc = 110;
                        break;
                    case 1351:
                        sc = 352;
                        break;
                    case 1399:
                        sc = 353;
                        break;
                    case 1352:
                        sc = 79;
                        break;
                    case 1400:
                        sc = 111;
                        break;
                    case 1353:
                        sc = 268;
                        break;
                    case 1401:
                        sc = 269;
                        break;
                    case 1354:
                        sc = 80;
                        break;
                    case 1402:
                        sc = 112;
                        break;
                    case 1355:
                        sc = 308;
                        break;
                    case 1403:
                        sc = 309;
                        break;
                    case 1356:
                        sc = 7768;
                        break;
                    case 1404:
                        sc = 7769;
                        break;
                    case 1357:
                        sc = 83;
                        break;
                    case 1405:
                        sc = 115;
                        break;
                    case 1358:
                        sc = 86;
                        break;
                    case 1406:
                        sc = 118;
                        break;
                    case 1359:
                        sc = 84;
                        break;
                    case 1407:
                        sc = 116;
                        break;
                    case 1360:
                        sc = 82;
                        break;
                    case 1408:
                        sc = 114;
                        break;
                    case 1361:
                        sc = 67;
                        ac = 39;
                        break;
                    case 1409:
                        sc = 99;
                        ac = 39;
                        break;
                    case 1362:
                        sc = 87;
                        break;
                    case 1410:
                        sc = 119;
                        break;
                    case 1363:
                        sc = 80;
                        ac = 39;
                        break;
                    case 1411:
                        sc = 112;
                        ac = 39;
                        break;
                    case 1364:
                        sc = 75;
                        ac = 39;
                        break;
                    case 1412:
                        sc = 107;
                        ac = 39;
                        break;
                    case 1365:
                        sc = 210;
                        break;
                    case 1413:
                        sc = 242;
                        break;
                    case 1366:
                        sc = 70;
                        break;
                    case 1414:
                        sc = 102;
                        break;
                    case 1415:
                        sc = 101;
                        ac = 119;
                        break;
                    default:
                        sc = cc;
                }
                if (sc > 0)
                {
                    res += String.fromCharCode(sc);
                    if (ac > 0)
                    {
                        res += String.fromCharCode(ac);
                    }
                }
            }
            return res;
        }

        public function Romanization()
        {
            super();
        }
    }
}
