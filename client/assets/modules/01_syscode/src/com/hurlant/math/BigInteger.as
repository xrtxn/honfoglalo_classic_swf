package com.hurlant.math {
		import com.hurlant.crypto.prng.Random;
		import com.hurlant.util.Hex;
		import com.hurlant.util.Memory;
		import flash.utils.ByteArray;
		
		use namespace bi_internal;
		
		public class BigInteger {
				public static const DB:int = 30;
				
				public static const DV:int = 1 << DB;
				
				public static const DM:int = DV - 1;
				
				public static const BI_FP:int = 52;
				
				public static const FV:Number = Math.pow(2,BI_FP);
				
				public static const F1:int = BI_FP - DB;
				
				public static const F2:int = 2 * DB - BI_FP;
				
				public static const ZERO:BigInteger = nbv(0);
				
				public static const ONE:BigInteger = nbv(1);
				
				public static const lowprimes:Array = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509];
				
				public static const lplim:int = (1 << 26) / lowprimes[lowprimes.length - 1];
				
				public var t:int;
				
				bi_internal var s:int;
				
				bi_internal var a:Array;
				
				public function BigInteger(value:* = null, radix:int = 0) {
						var array:ByteArray = null;
						var length:int = 0;
						super();
						this.bi_internal::a = new Array();
						if(value is String) {
								value = Hex.toArray(value);
								radix = 0;
						}
						if(value is ByteArray) {
								array = value as ByteArray;
								length = int(radix || array.length - array.position);
								this.bi_internal::fromArray(array,length);
						}
				}
				
				public static function nbv(value:int) : BigInteger {
						var bn:BigInteger = new BigInteger();
						bn.bi_internal::fromInt(value);
						return bn;
				}
				
				public function dispose() : void {
						var r:Random = new Random();
						for(var i:uint = 0; i < this.bi_internal::a.length; i++) {
								this.bi_internal::a[i] = r.nextByte();
								delete this.bi_internal::a[i];
						}
						this.bi_internal::a = null;
						this.t = 0;
						this.bi_internal::s = 0;
						Memory.gc();
				}
				
				public function toString(radix:Number = 16) : String {
						var k:int = 0;
						if(this.bi_internal::s < 0) {
								return "-" + this.negate().toString(radix);
						}
						switch(radix) {
								case 2:
										k = 1;
										break;
								case 4:
										k = 2;
										break;
								case 8:
										k = 3;
										break;
								case 16:
										k = 4;
										break;
								case 32:
										k = 5;
						}
						var km:int = (1 << k) - 1;
						var d:* = 0;
						var m:Boolean = false;
						var r:String = "";
						var i:int = this.t;
						var p:int = DB - i * DB % k;
						if(i-- > 0) {
								if(p < DB && (d = this.bi_internal::a[i] >> p) > 0) {
										m = true;
										r = d.toString(36);
								}
								while(i >= 0) {
										if(p < k) {
												d = (this.bi_internal::a[i] & (1 << p) - 1) << k - p;
												d |= this.bi_internal::a[--i] >> (p = p + (DB - k));
										} else {
												d = this.bi_internal::a[i] >> (p = p - k) & km;
												if(p <= 0) {
														p += DB;
														i--;
												}
										}
										if(d > 0) {
												m = true;
										}
										if(m) {
												r += d.toString(36);
										}
								}
						}
						return m ? r : "0";
				}
				
				public function toArray(array:ByteArray) : uint {
						var k:int = 8;
						var km:int = (1 << 8) - 1;
						var d:* = 0;
						var i:int = this.t;
						var p:int = DB - i * DB % k;
						var m:Boolean = false;
						var c:int = 0;
						if(i-- > 0) {
								if(p < DB && (d = this.bi_internal::a[i] >> p) > 0) {
										m = true;
										array.writeByte(d);
										c++;
								}
								while(i >= 0) {
										if(p < k) {
												d = (this.bi_internal::a[i] & (1 << p) - 1) << k - p;
												d |= this.bi_internal::a[--i] >> (p = p + (DB - k));
										} else {
												d = this.bi_internal::a[i] >> (p = p - k) & km;
												if(p <= 0) {
														p += DB;
														i--;
												}
										}
										if(d > 0) {
												m = true;
										}
										if(m) {
												array.writeByte(d);
												c++;
										}
								}
						}
						return c;
				}
				
				public function valueOf() : Number {
						var coef:Number = 1;
						var value:Number = 0;
						for(var i:uint = 0; i < this.t; i++) {
								value += this.bi_internal::a[i] * coef;
								coef *= DV;
						}
						return value;
				}
				
				public function negate() : BigInteger {
						var r:BigInteger = this.nbi();
						ZERO.bi_internal::subTo(this,r);
						return r;
				}
				
				public function abs() : BigInteger {
						return this.bi_internal::s < 0 ? this.negate() : this;
				}
				
				public function compareTo(v:BigInteger) : int {
						var r:int = this.bi_internal::s - v.bi_internal::s;
						if(r != 0) {
								return r;
						}
						var i:int = this.t;
						r = i - v.t;
						if(r != 0) {
								return r;
						}
						while(--i >= 0) {
								r = this.bi_internal::a[i] - v.bi_internal::a[i];
								if(r != 0) {
										return r;
								}
						}
						return 0;
				}
				
				bi_internal function nbits(x:int) : int {
						var t:int = 0;
						var r:int = 1;
						t = x >>> 16;
						if(t != 0) {
								x = t;
								r += 16;
						}
						t = x >> 8;
						if(t != 0) {
								x = t;
								r += 8;
						}
						t = x >> 4;
						if(t != 0) {
								x = t;
								r += 4;
						}
						t = x >> 2;
						if(t != 0) {
								x = t;
								r += 2;
						}
						t = x >> 1;
						if(t != 0) {
								x = t;
								r += 1;
						}
						return r;
				}
				
				public function bitLength() : int {
						if(this.t <= 0) {
								return 0;
						}
						return DB * (this.t - 1) + this.bi_internal::nbits(this.bi_internal::a[this.t - 1] ^ this.bi_internal::s & DM);
				}
				
				public function mod(v:BigInteger) : BigInteger {
						var r:BigInteger = this.nbi();
						this.abs().bi_internal::divRemTo(v,null,r);
						if(this.bi_internal::s < 0 && r.compareTo(ZERO) > 0) {
								v.bi_internal::subTo(r,r);
						}
						return r;
				}
				
				public function modPowInt(e:int, m:BigInteger) : BigInteger {
						var z:IReduction = null;
						if(e < 256 || m.bi_internal::isEven()) {
								z = new ClassicReduction(m);
						} else {
								z = new MontgomeryReduction(m);
						}
						return this.bi_internal::exp(e,z);
				}
				
				bi_internal function copyTo(r:BigInteger) : void {
						for(var i:int = this.t - 1; i >= 0; i--) {
								r.bi_internal::a[i] = this.bi_internal::a[i];
						}
						r.t = this.t;
						r.bi_internal::s = this.bi_internal::s;
				}
				
				bi_internal function fromInt(value:int) : void {
						this.t = 1;
						this.bi_internal::s = value < 0 ? -1 : 0;
						if(value > 0) {
								this.bi_internal::a[0] = value;
						} else if(value < -1) {
								this.bi_internal::a[0] = value + DV;
						} else {
								this.t = 0;
						}
				}
				
				bi_internal function fromArray(value:ByteArray, length:int) : void {
						var x:int = 0;
						var p:int = int(value.position);
						var i:int = p + length;
						var sh:int = 0;
						var k:int = 8;
						this.t = 0;
						this.bi_internal::s = 0;
						while(--i >= p) {
								x = i < value.length ? int(value[i]) : 0;
								if(sh == 0) {
										var _loc8_:*;
										this.bi_internal::a[_loc8_ = this.t++] = x;
								} else if(sh + k > DB) {
										this.bi_internal::a[this.t - 1] |= (x & (1 << DB - sh) - 1) << sh;
										this.bi_internal::a[_loc8_ = this.t++] = x >> DB - sh;
								} else {
										this.bi_internal::a[this.t - 1] |= x << sh;
								}
								sh += k;
								if(sh >= DB) {
										sh -= DB;
								}
						}
						this.bi_internal::clamp();
						value.position = Math.min(p + length,value.length);
				}
				
				bi_internal function clamp() : void {
						var c:* = this.bi_internal::s & DM;
						while(this.t > 0 && this.bi_internal::a[this.t - 1] == c) {
								--this.t;
						}
				}
				
				bi_internal function dlShiftTo(n:int, r:BigInteger) : void {
						var i:int = 0;
						for(i = this.t - 1; i >= 0; i--) {
								r.bi_internal::a[i + n] = this.bi_internal::a[i];
						}
						for(i = n - 1; i >= 0; i--) {
								r.bi_internal::a[i] = 0;
						}
						r.t = this.t + n;
						r.bi_internal::s = this.bi_internal::s;
				}
				
				bi_internal function drShiftTo(n:int, r:BigInteger) : void {
						var i:int = 0;
						for(i = n; i < this.t; i++) {
								r.bi_internal::a[i - n] = this.bi_internal::a[i];
						}
						r.t = Math.max(this.t - n,0);
						r.bi_internal::s = this.bi_internal::s;
				}
				
				bi_internal function lShiftTo(n:int, r:BigInteger) : void {
						var i:int = 0;
						var bs:int = n % DB;
						var cbs:int = DB - bs;
						var bm:int = (1 << cbs) - 1;
						var ds:int = n / DB;
						var c:* = this.bi_internal::s << bs & DM;
						for(i = this.t - 1; i >= 0; i--) {
								r.bi_internal::a[i + ds + 1] = this.bi_internal::a[i] >> cbs | c;
								c = (this.bi_internal::a[i] & bm) << bs;
						}
						for(i = ds - 1; i >= 0; i--) {
								r.bi_internal::a[i] = 0;
						}
						r.bi_internal::a[ds] = c;
						r.t = this.t + ds + 1;
						r.bi_internal::s = this.bi_internal::s;
						r.bi_internal::clamp();
				}
				
				bi_internal function rShiftTo(n:int, r:BigInteger) : void {
						var i:int = 0;
						r.bi_internal::s = this.bi_internal::s;
						var ds:int = n / DB;
						if(ds >= this.t) {
								r.t = 0;
								return;
						}
						var bs:int = n % DB;
						var cbs:int = DB - bs;
						var bm:int = (1 << bs) - 1;
						r.bi_internal::a[0] = this.bi_internal::a[ds] >> bs;
						for(i = ds + 1; i < this.t; i++) {
								r.bi_internal::a[i - ds - 1] |= (this.bi_internal::a[i] & bm) << cbs;
								r.bi_internal::a[i - ds] = this.bi_internal::a[i] >> bs;
						}
						if(bs > 0) {
								r.bi_internal::a[this.t - ds - 1] |= (this.bi_internal::s & bm) << cbs;
						}
						r.t = this.t - ds;
						r.bi_internal::clamp();
				}
				
				bi_internal function subTo(v:BigInteger, r:BigInteger) : void {
						var i:int = 0;
						var c:* = 0;
						var m:int = Math.min(v.t,this.t);
						while(i < m) {
								c += this.bi_internal::a[i] - v.bi_internal::a[i];
								var _loc6_:*;
								r.bi_internal::a[_loc6_ = i++] = c & DM;
								c >>= DB;
						}
						if(v.t < this.t) {
								c -= v.bi_internal::s;
								while(i < this.t) {
										c += this.bi_internal::a[i];
										r.bi_internal::a[_loc6_ = i++] = c & DM;
										c >>= DB;
								}
								c += this.bi_internal::s;
						} else {
								c += this.bi_internal::s;
								while(i < v.t) {
										c -= v.bi_internal::a[i];
										r.bi_internal::a[_loc6_ = i++] = c & DM;
										c >>= DB;
								}
								c -= v.bi_internal::s;
						}
						r.bi_internal::s = c < 0 ? -1 : 0;
						if(c < -1) {
								r.bi_internal::a[_loc6_ = i++] = DV + c;
						} else if(c > 0) {
								r.bi_internal::a[_loc6_ = i++] = c;
						}
						r.t = i;
						r.bi_internal::clamp();
				}
				
				bi_internal function am(i:int, x:int, w:BigInteger, j:int, c:int, n:int) : int {
						var l:* = 0;
						var h:* = 0;
						var m:int = 0;
						var xl:* = x & 0x7FFF;
						var xh:* = x >> 15;
						while(--n >= 0) {
								l = this.bi_internal::a[i] & 0x7FFF;
								h = this.bi_internal::a[i++] >> 15;
								m = xh * l + h * xl;
								l = xl * l + ((m & 0x7FFF) << 15) + w.bi_internal::a[j] + (c & 0x3FFFFFFF);
								c = (l >>> 30) + (m >>> 15) + xh * h + (c >>> 30);
								var _loc12_:*;
								w.bi_internal::a[_loc12_ = j++] = l & 0x3FFFFFFF;
						}
						return c;
				}
				
				bi_internal function multiplyTo(v:BigInteger, r:BigInteger) : void {
						var x:BigInteger = this.abs();
						var y:BigInteger = v.abs();
						var i:int = x.t;
						r.t = i + y.t;
						while(--i >= 0) {
								r.bi_internal::a[i] = 0;
						}
						for(i = 0; i < y.t; i++) {
								r.bi_internal::a[i + x.t] = x.bi_internal::am(0,y.bi_internal::a[i],r,i,0,x.t);
						}
						r.bi_internal::s = 0;
						r.bi_internal::clamp();
						if(this.bi_internal::s != v.bi_internal::s) {
								ZERO.bi_internal::subTo(r,r);
						}
				}
				
				bi_internal function squareTo(r:BigInteger) : void {
						var c:int = 0;
						var x:BigInteger = this.abs();
						for(var i:int = r.t = 2 * x.t; --i >= 0; ) {
								r.bi_internal::a[i] = 0;
						}
						for(i = 0; i < x.t - 1; i++) {
								c = x.bi_internal::am(i,x.bi_internal::a[i],r,2 * i,0,1);
								if((r.bi_internal::a[i + x.t] = r.bi_internal::a[i + x.t] + x.bi_internal::am(i + 1,2 * x.bi_internal::a[i],r,2 * i + 1,c,x.t - i - 1)) >= DV) {
										r.bi_internal::a[i + x.t] -= DV;
										r.bi_internal::a[i + x.t + 1] = 1;
								}
						}
						if(r.t > 0) {
								r.bi_internal::a[r.t - 1] += x.bi_internal::am(i,x.bi_internal::a[i],r,2 * i,0,1);
						}
						r.bi_internal::s = 0;
						r.bi_internal::clamp();
				}
				
				bi_internal function divRemTo(m:BigInteger, q:BigInteger = null, r:BigInteger = null) : void {
						var pt:BigInteger;
						var y:BigInteger;
						var ts:int;
						var ms:int;
						var nsh:int;
						var ys:int;
						var y0:int;
						var yt:Number;
						var d1:Number;
						var d2:Number;
						var e:Number;
						var i:int;
						var j:int;
						var t:BigInteger;
						var qd:int = 0;
						var pm:BigInteger = m.abs();
						if(pm.t <= 0) {
								return;
						}
						pt = this.abs();
						if(pt.t < pm.t) {
								if(q != null) {
										q.bi_internal::fromInt(0);
								}
								if(r != null) {
										this.bi_internal::copyTo(r);
								}
								return;
						}
						if(r == null) {
								r = this.nbi();
						}
						y = this.nbi();
						ts = this.bi_internal::s;
						ms = m.bi_internal::s;
						nsh = DB - this.bi_internal::nbits(pm.bi_internal::a[pm.t - 1]);
						if(nsh > 0) {
								pm.bi_internal::lShiftTo(nsh,y);
								pt.bi_internal::lShiftTo(nsh,r);
						} else {
								pm.bi_internal::copyTo(y);
								pt.bi_internal::copyTo(r);
						}
						ys = y.t;
						y0 = int(y.bi_internal::a[ys - 1]);
						if(y0 == 0) {
								return;
						}
						yt = y0 * (1 << F1) + (ys > 1 ? y.bi_internal::a[ys - 2] >> F2 : 0);
						d1 = FV / yt;
						d2 = (1 << F1) / yt;
						e = 1 << F2;
						i = r.t;
						j = i - ys;
						t = q == null ? this.nbi() : q;
						y.bi_internal::dlShiftTo(j,t);
						if(r.compareTo(t) >= 0) {
								var _loc5_:*;
								r.bi_internal::a[_loc5_ = r.t++] = 1;
								r.bi_internal::subTo(t,r);
						}
						ONE.bi_internal::dlShiftTo(ys,t);
						for(t.bi_internal::subTo(y,y); y.t < ys; ) {
								y.(++y.t, !!0);
						}
						while(--j >= 0) {
								qd = r.bi_internal::a[--i] == y0 ? DM : int(Number(r.bi_internal::a[i]) * d1 + (Number(r.bi_internal::a[i - 1]) + e) * d2);
								if((r.bi_internal::a[i] = r.bi_internal::a[i] + y.bi_internal::am(0,qd,r,j,0,ys)) < qd) {
										y.bi_internal::dlShiftTo(j,t);
										r.bi_internal::subTo(t,r);
										while(r.bi_internal::a[i] < --qd) {
												r.bi_internal::subTo(t,r);
										}
								}
						}
						if(q != null) {
								r.bi_internal::drShiftTo(ys,q);
								if(ts != ms) {
										ZERO.bi_internal::subTo(q,q);
								}
						}
						r.t = ys;
						r.bi_internal::clamp();
						if(nsh > 0) {
								r.bi_internal::rShiftTo(nsh,r);
						}
						if(ts < 0) {
								ZERO.bi_internal::subTo(r,r);
						}
				}
				
				bi_internal function invDigit() : int {
						if(this.t < 1) {
								return 0;
						}
						var x:int = int(this.bi_internal::a[0]);
						if((x & 1) == 0) {
								return 0;
						}
						var y:* = x & 3;
						y = y * (2 - (x & 0x0F) * y) & 0x0F;
						y = y * (2 - (x & 0xFF) * y) & 0xFF;
						y = y * (2 - ((x & 0xFFFF) * y & 0xFFFF)) & 0xFFFF;
						y = y * (2 - x * y % DV) % DV;
						return y > 0 ? DV - y : int(-y);
				}
				
				bi_internal function isEven() : Boolean {
						return (this.t > 0 ? this.bi_internal::a[0] & 1 : this.bi_internal::s) == 0;
				}
				
				bi_internal function exp(e:int, z:IReduction) : BigInteger {
						var t:BigInteger = null;
						if(e > 4294967295 || e < 1) {
								return ONE;
						}
						var r:BigInteger = this.nbi();
						var r2:BigInteger = this.nbi();
						var g:BigInteger = z.convert(this);
						var i:int = this.bi_internal::nbits(e) - 1;
						g.bi_internal::copyTo(r);
						while(--i >= 0) {
								z.sqrTo(r,r2);
								if((e & 1 << i) > 0) {
										z.mulTo(r2,g,r);
								} else {
										t = r;
										r = r2;
										r2 = t;
								}
						}
						return z.revert(r);
				}
				
				bi_internal function intAt(str:String, index:int) : int {
						return parseInt(str.charAt(index),36);
				}
				
				protected function nbi() : * {
						return new BigInteger();
				}
				
				public function clone() : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bi_internal::copyTo(r);
						return r;
				}
				
				public function intValue() : int {
						if(this.bi_internal::s < 0) {
								if(this.t == 1) {
										return this.bi_internal::a[0] - DV;
								}
								if(this.t == 0) {
										return -1;
								}
						} else {
								if(this.t == 1) {
										return this.bi_internal::a[0];
								}
								if(this.t == 0) {
										return 0;
								}
						}
						return (this.bi_internal::a[1] & (1 << 32 - DB) - 1) << DB | this.bi_internal::a[0];
				}
				
				public function byteValue() : int {
						return this.t == 0 ? this.bi_internal::s : this.bi_internal::a[0] << 24 >> 24;
				}
				
				public function shortValue() : int {
						return this.t == 0 ? this.bi_internal::s : this.bi_internal::a[0] << 16 >> 16;
				}
				
				protected function chunkSize(r:Number) : int {
						return Math.floor(Math.LN2 * DB / Math.log(r));
				}
				
				public function sigNum() : int {
						if(this.bi_internal::s < 0) {
								return -1;
						}
						if(this.t <= 0 || this.t == 1 && this.bi_internal::a[0] <= 0) {
								return 0;
						}
						return 1;
				}
				
				protected function toRadix(b:uint = 10) : String {
						if(this.sigNum() == 0 || b < 2 || b > 32) {
								return "0";
						}
						var cs:int = this.chunkSize(b);
						var a:Number = Math.pow(b,cs);
						var d:BigInteger = nbv(a);
						var y:BigInteger = this.nbi();
						var z:BigInteger = this.nbi();
						var r:String = "";
						this.bi_internal::divRemTo(d,y,z);
						while(y.sigNum() > 0) {
								r = (a + z.intValue()).toString(b).substr(1) + r;
								y.bi_internal::divRemTo(d,y,z);
						}
						return z.intValue().toString(b) + r;
				}
				
				protected function fromRadix(s:String, b:int = 10) : void {
						var x:int = 0;
						this.bi_internal::fromInt(0);
						var cs:int = this.chunkSize(b);
						var d:Number = Math.pow(b,cs);
						var mi:Boolean = false;
						var j:int = 0;
						var w:int = 0;
						for(var i:int = 0; i < s.length; i++) {
								x = this.bi_internal::intAt(s,i);
								if(x < 0) {
										if(s.charAt(i) == "-" && this.sigNum() == 0) {
												mi = true;
										}
								} else {
										w = b * w + x;
										if(++j >= cs) {
												this.bi_internal::dMultiply(d);
												this.bi_internal::dAddOffset(w,0);
												j = 0;
												w = 0;
										}
								}
						}
						if(j > 0) {
								this.bi_internal::dMultiply(Math.pow(b,j));
								this.bi_internal::dAddOffset(w,0);
						}
						if(mi) {
								BigInteger.ZERO.bi_internal::subTo(this,this);
						}
				}
				
				public function toByteArray() : ByteArray {
						var d:* = 0;
						var i:int = this.t;
						var r:ByteArray = new ByteArray();
						r[0] = this.bi_internal::s;
						var p:int = DB - i * DB % 8;
						var k:int = 0;
						if(i-- > 0) {
								if(p < DB && (d = this.bi_internal::a[i] >> p) != (this.bi_internal::s & DM) >> p) {
										var _loc6_:*;
										r[_loc6_ = k++] = d | this.bi_internal::s << DB - p;
								}
								while(i >= 0) {
										if(p < 8) {
												d = (this.bi_internal::a[i] & (1 << p) - 1) << 8 - p;
												d |= this.bi_internal::a[--i] >> (p = p + (DB - 8));
										} else {
												d = this.bi_internal::a[i] >> (p = p - 8) & 0xFF;
												if(p <= 0) {
														p += DB;
														i--;
												}
										}
										if((d & 0x80) != 0) {
												d |= -256;
										}
										if(k == 0 && (this.bi_internal::s & 0x80) != (d & 0x80)) {
												k++;
										}
										if(k > 0 || d != this.bi_internal::s) {
												r[_loc6_ = k++] = d;
										}
								}
						}
						return r;
				}
				
				public function equals(a:BigInteger) : Boolean {
						return this.compareTo(a) == 0;
				}
				
				public function min(a:BigInteger) : BigInteger {
						return this.compareTo(a) < 0 ? this : a;
				}
				
				public function max(a:BigInteger) : BigInteger {
						return this.compareTo(a) > 0 ? this : a;
				}
				
				protected function bitwiseTo(a:BigInteger, op:Function, r:BigInteger) : void {
						var i:int = 0;
						var f:* = 0;
						var m:int = Math.min(a.t,this.t);
						for(i = 0; i < m; i++) {
								r.bi_internal::a[i] = op(this.bi_internal::a[i],a.bi_internal::a[i]);
						}
						if(a.t < this.t) {
								f = a.bi_internal::s & DM;
								for(i = m; i < this.t; i++) {
										r.bi_internal::a[i] = op(this.bi_internal::a[i],f);
								}
								r.t = this.t;
						} else {
								f = this.bi_internal::s & DM;
								for(i = m; i < a.t; i++) {
										r.bi_internal::a[i] = op(f,a.bi_internal::a[i]);
								}
								r.t = a.t;
						}
						r.bi_internal::s = op(this.bi_internal::s,a.bi_internal::s);
						r.bi_internal::clamp();
				}
				
				private function op_and(x:int, y:int) : int {
						return x & y;
				}
				
				public function and(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bitwiseTo(a,this.op_and,r);
						return r;
				}
				
				private function op_or(x:int, y:int) : int {
						return x | y;
				}
				
				public function or(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bitwiseTo(a,this.op_or,r);
						return r;
				}
				
				private function op_xor(x:int, y:int) : int {
						return x ^ y;
				}
				
				public function xor(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bitwiseTo(a,this.op_xor,r);
						return r;
				}
				
				private function op_andnot(x:int, y:int) : int {
						return x & ~y;
				}
				
				public function andNot(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bitwiseTo(a,this.op_andnot,r);
						return r;
				}
				
				public function not() : BigInteger {
						var r:BigInteger = new BigInteger();
						for(var i:int = 0; i < this.t; i++) {
								r[i] = DM & ~this.bi_internal::a[i];
						}
						r.t = this.t;
						r.bi_internal::s = ~this.bi_internal::s;
						return r;
				}
				
				public function shiftLeft(n:int) : BigInteger {
						var r:BigInteger = new BigInteger();
						if(n < 0) {
								this.bi_internal::rShiftTo(-n,r);
						} else {
								this.bi_internal::lShiftTo(n,r);
						}
						return r;
				}
				
				public function shiftRight(n:int) : BigInteger {
						var r:BigInteger = new BigInteger();
						if(n < 0) {
								this.bi_internal::lShiftTo(-n,r);
						} else {
								this.bi_internal::rShiftTo(n,r);
						}
						return r;
				}
				
				private function lbit(x:int) : int {
						if(x == 0) {
								return -1;
						}
						var r:int = 0;
						if((x & 0xFFFF) == 0) {
								x >>= 16;
								r += 16;
						}
						if((x & 0xFF) == 0) {
								x >>= 8;
								r += 8;
						}
						if((x & 0x0F) == 0) {
								x >>= 4;
								r += 4;
						}
						if((x & 3) == 0) {
								x >>= 2;
								r += 2;
						}
						if((x & 1) == 0) {
								r++;
						}
						return r;
				}
				
				public function getLowestSetBit() : int {
						for(var i:int = 0; i < this.t; i++) {
								if(this.bi_internal::a[i] != 0) {
										return i * DB + this.lbit(this.bi_internal::a[i]);
								}
						}
						if(this.bi_internal::s < 0) {
								return this.t * DB;
						}
						return -1;
				}
				
				private function cbit(x:int) : int {
						for(var r:uint = 0; x != 0; ) {
								x &= x - 1;
								r++;
						}
						return r;
				}
				
				public function bitCount() : int {
						var r:int = 0;
						var x:* = this.bi_internal::s & DM;
						for(var i:int = 0; i < this.t; i++) {
								r += this.cbit(this.bi_internal::a[i] ^ x);
						}
						return r;
				}
				
				public function testBit(n:int) : Boolean {
						var j:int = Math.floor(n / DB);
						if(j >= this.t) {
								return this.bi_internal::s != 0;
						}
						return (this.bi_internal::a[j] & 1 << n % DB) != 0;
				}
				
				protected function changeBit(n:int, op:Function) : BigInteger {
						var r:BigInteger = BigInteger.ONE.shiftLeft(n);
						this.bitwiseTo(r,op,r);
						return r;
				}
				
				public function setBit(n:int) : BigInteger {
						return this.changeBit(n,this.op_or);
				}
				
				public function clearBit(n:int) : BigInteger {
						return this.changeBit(n,this.op_andnot);
				}
				
				public function flipBit(n:int) : BigInteger {
						return this.changeBit(n,this.op_xor);
				}
				
				protected function addTo(a:BigInteger, r:BigInteger) : void {
						var i:int = 0;
						var c:* = 0;
						var m:int = Math.min(a.t,this.t);
						while(i < m) {
								c += this.bi_internal::a[i] + a.bi_internal::a[i];
								var _loc6_:*;
								r.bi_internal::a[_loc6_ = i++] = c & DM;
								c >>= DB;
						}
						if(a.t < this.t) {
								c += a.bi_internal::s;
								while(i < this.t) {
										c += this.bi_internal::a[i];
										r.bi_internal::a[_loc6_ = i++] = c & DM;
										c >>= DB;
								}
								c += this.bi_internal::s;
						} else {
								c += this.bi_internal::s;
								while(i < a.t) {
										c += a.bi_internal::a[i];
										r.bi_internal::a[_loc6_ = i++] = c & DM;
										c >>= DB;
								}
								c += a.bi_internal::s;
						}
						r.bi_internal::s = c < 0 ? -1 : 0;
						if(c > 0) {
								r.bi_internal::a[_loc6_ = i++] = c;
						} else if(c < -1) {
								r.bi_internal::a[_loc6_ = i++] = DV + c;
						}
						r.t = i;
						r.bi_internal::clamp();
				}
				
				public function add(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.addTo(a,r);
						return r;
				}
				
				public function subtract(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bi_internal::subTo(a,r);
						return r;
				}
				
				public function multiply(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bi_internal::multiplyTo(a,r);
						return r;
				}
				
				public function divide(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bi_internal::divRemTo(a,r,null);
						return r;
				}
				
				public function remainder(a:BigInteger) : BigInteger {
						var r:BigInteger = new BigInteger();
						this.bi_internal::divRemTo(a,null,r);
						return r;
				}
				
				public function divideAndRemainder(a:BigInteger) : Array {
						var q:BigInteger = new BigInteger();
						var r:BigInteger = new BigInteger();
						this.bi_internal::divRemTo(a,q,r);
						return [q,r];
				}
				
				bi_internal function dMultiply(n:int) : void {
						this.bi_internal::a[this.t] = this.bi_internal::am(0,n - 1,this,0,0,this.t);
						++this.t;
						this.bi_internal::clamp();
				}
				
				bi_internal function dAddOffset(n:int, w:int) : void {
						while(this.t <= w) {
								var _loc3_:* = this.t++;
								this.bi_internal::a[_loc3_] = 0;
						}
						this.bi_internal::a[w] += n;
						while(this.bi_internal::a[w] >= DV) {
								this.bi_internal::a[w] -= DV;
								if(++w >= this.t) {
										_loc3_ = this.t++;
										this.bi_internal::a[_loc3_] = 0;
								}
								++this.bi_internal::a[w];
						}
				}
				
				public function pow(e:int) : BigInteger {
						return this.bi_internal::exp(e,new NullReduction());
				}
				
				bi_internal function multiplyLowerTo(a:BigInteger, n:int, r:BigInteger) : void {
						var j:int = 0;
						var i:int = Math.min(this.t + a.t,n);
						r.bi_internal::s = 0;
						r.t = i;
						while(i > 0) {
								var _loc6_:*;
								r.bi_internal::a[_loc6_ = --i] = 0;
						}
						for(j = r.t - this.t; i < j; i++) {
								r.bi_internal::a[i + this.t] = this.bi_internal::am(0,a.bi_internal::a[i],r,i,0,this.t);
						}
						for(j = Math.min(a.t,n); i < j; i++) {
								this.bi_internal::am(0,a.bi_internal::a[i],r,i,0,n - i);
						}
						r.bi_internal::clamp();
				}
				
				bi_internal function multiplyUpperTo(a:BigInteger, n:int, r:BigInteger) : void {
						n--;
						var i:int = r.t = this.t + a.t - n;
						r.bi_internal::s = 0;
						while(--i >= 0) {
								r.bi_internal::a[i] = 0;
						}
						for(i = Math.max(n - this.t,0); i < a.t; i++) {
								r.bi_internal::a[this.t + i - n] = this.bi_internal::am(n - i,a.bi_internal::a[i],r,0,0,this.t + i - n);
						}
						r.bi_internal::clamp();
						r.bi_internal::drShiftTo(1,r);
				}
				
				public function modPow(e:BigInteger, m:BigInteger) : BigInteger {
						var k:int = 0;
						var z:IReduction = null;
						var w:* = 0;
						var t:BigInteger = null;
						var g2:BigInteger = null;
						var i:int = e.bitLength();
						var r:BigInteger = nbv(1);
						if(i <= 0) {
								return r;
						}
						if(i < 18) {
								k = 1;
						} else if(i < 48) {
								k = 3;
						} else if(i < 144) {
								k = 4;
						} else if(i < 768) {
								k = 5;
						} else {
								k = 6;
						}
						if(i < 8) {
								z = new ClassicReduction(m);
						} else if(m.bi_internal::isEven()) {
								z = new BarrettReduction(m);
						} else {
								z = new MontgomeryReduction(m);
						}
						var g:Array = [];
						var n:int = 3;
						var k1:int = k - 1;
						var km:int = (1 << k) - 1;
						g[1] = z.convert(this);
						if(k > 1) {
								g2 = new BigInteger();
								z.sqrTo(g[1],g2);
								while(n <= km) {
										g[n] = new BigInteger();
										z.mulTo(g2,g[n - 2],g[n]);
										n += 2;
								}
						}
						var j:int = e.t - 1;
						var is1:Boolean = true;
						var r2:BigInteger = new BigInteger();
						i = this.bi_internal::nbits(e.bi_internal::a[j]) - 1;
						while(j >= 0) {
								if(i >= k1) {
										w = e.bi_internal::a[j] >> i - k1 & km;
								} else {
										w = (e.bi_internal::a[j] & (1 << i + 1) - 1) << k1 - i;
										if(j > 0) {
												w |= e.bi_internal::a[j - 1] >> DB + i - k1;
										}
								}
								n = k;
								while((w & 1) == 0) {
										w >>= 1;
										n--;
								}
								i = i - n;
								if(i < 0) {
										i += DB;
										j--;
								}
								if(is1) {
										g[w].copyTo(r);
										is1 = false;
								} else {
										while(n > 1) {
												z.sqrTo(r,r2);
												z.sqrTo(r2,r);
												n -= 2;
										}
										if(n > 0) {
												z.sqrTo(r,r2);
										} else {
												t = r;
												r = r2;
												r2 = t;
										}
										z.mulTo(r2,g[w],r);
								}
								while(j >= 0 && (e.bi_internal::a[j] & 1 << i) == 0) {
										z.sqrTo(r,r2);
										t = r;
										r = r2;
										r2 = t;
										if(--i < 0) {
												i = DB - 1;
												j--;
										}
								}
						}
						return z.revert(r);
				}
				
				public function gcd(a:BigInteger) : BigInteger {
						var t:BigInteger = null;
						var x:BigInteger = this.bi_internal::s < 0 ? this.negate() : this.clone();
						var y:BigInteger = a.bi_internal::s < 0 ? a.negate() : a.clone();
						if(x.compareTo(y) < 0) {
								t = x;
								x = y;
								y = t;
						}
						var i:int = x.getLowestSetBit();
						var g:int = y.getLowestSetBit();
						if(g < 0) {
								return x;
						}
						if(i < g) {
								g = i;
						}
						if(g > 0) {
								x.bi_internal::rShiftTo(g,x);
								y.bi_internal::rShiftTo(g,y);
						}
						while(x.sigNum() > 0) {
								i = x.getLowestSetBit();
								if(i > 0) {
										x.bi_internal::rShiftTo(i,x);
								}
								i = y.getLowestSetBit();
								if(i > 0) {
										y.bi_internal::rShiftTo(i,y);
								}
								if(x.compareTo(y) >= 0) {
										x.bi_internal::subTo(y,x);
										x.bi_internal::rShiftTo(1,x);
								} else {
										y.bi_internal::subTo(x,y);
										y.bi_internal::rShiftTo(1,y);
								}
						}
						if(g > 0) {
								y.bi_internal::lShiftTo(g,y);
						}
						return y;
				}
				
				protected function modInt(n:int) : int {
						var i:int = 0;
						if(n <= 0) {
								return 0;
						}
						var d:int = DV % n;
						var r:int = this.bi_internal::s < 0 ? n - 1 : 0;
						if(this.t > 0) {
								if(d == 0) {
										r = this.bi_internal::a[0] % n;
								} else {
										for(i = this.t - 1; i >= 0; i--) {
												r = (d * r + this.bi_internal::a[i]) % n;
										}
								}
						}
						return r;
				}
				
				public function modInverse(m:BigInteger) : BigInteger {
						var ac:Boolean = m.bi_internal::isEven();
						if(this.bi_internal::isEven() && ac || m.sigNum() == 0) {
								return BigInteger.ZERO;
						}
						var u:BigInteger = m.clone();
						var v:BigInteger = this.clone();
						var a:BigInteger = nbv(1);
						var b:BigInteger = nbv(0);
						var c:BigInteger = nbv(0);
						var d:BigInteger = nbv(1);
						while(u.sigNum() != 0) {
								while(u.bi_internal::isEven()) {
										u.bi_internal::rShiftTo(1,u);
										if(ac) {
												if(!a.bi_internal::isEven() || !b.bi_internal::isEven()) {
														a.addTo(this,a);
														b.bi_internal::subTo(m,b);
												}
												a.bi_internal::rShiftTo(1,a);
										} else if(!b.bi_internal::isEven()) {
												b.bi_internal::subTo(m,b);
										}
										b.bi_internal::rShiftTo(1,b);
								}
								while(v.bi_internal::isEven()) {
										v.bi_internal::rShiftTo(1,v);
										if(ac) {
												if(!c.bi_internal::isEven() || !d.bi_internal::isEven()) {
														c.addTo(this,c);
														d.bi_internal::subTo(m,d);
												}
												c.bi_internal::rShiftTo(1,c);
										} else if(!d.bi_internal::isEven()) {
												d.bi_internal::subTo(m,d);
										}
										d.bi_internal::rShiftTo(1,d);
								}
								if(u.compareTo(v) >= 0) {
										u.bi_internal::subTo(v,u);
										if(ac) {
												a.bi_internal::subTo(c,a);
										}
										b.bi_internal::subTo(d,b);
								} else {
										v.bi_internal::subTo(u,v);
										if(ac) {
												c.bi_internal::subTo(a,c);
										}
										d.bi_internal::subTo(b,d);
								}
						}
						if(v.compareTo(BigInteger.ONE) != 0) {
								return BigInteger.ZERO;
						}
						if(d.compareTo(m) >= 0) {
								return d.subtract(m);
						}
						if(d.sigNum() < 0) {
								d.addTo(m,d);
								if(d.sigNum() < 0) {
										return d.add(m);
								}
								return d;
						}
						return d;
				}
				
				public function isProbablePrime(t:int) : Boolean {
						var i:int = 0;
						var m:int = 0;
						var j:int = 0;
						var x:BigInteger = this.abs();
						if(x.t == 1 && x.bi_internal::a[0] <= lowprimes[lowprimes.length - 1]) {
								for(i = 0; i < lowprimes.length; i++) {
										if(x[0] == lowprimes[i]) {
												return true;
										}
								}
								return false;
						}
						if(x.bi_internal::isEven()) {
								return false;
						}
						i = 1;
						while(i < lowprimes.length) {
								m = int(lowprimes[i]);
								j = i + 1;
								while(j < lowprimes.length && m < lplim) {
										m *= lowprimes[j++];
								}
								m = x.modInt(m);
								while(i < j) {
										if(m % lowprimes[i++] == 0) {
												return false;
										}
								}
						}
						return x.millerRabin(t);
				}
				
				protected function millerRabin(t:int) : Boolean {
						var y:BigInteger = null;
						var j:int = 0;
						var n1:BigInteger = this.subtract(BigInteger.ONE);
						var k:int = n1.getLowestSetBit();
						if(k <= 0) {
								return false;
						}
						var r:BigInteger = n1.shiftRight(k);
						t = t + 1 >> 1;
						if(t > lowprimes.length) {
								t = int(lowprimes.length);
						}
						var a:BigInteger = new BigInteger();
						for(var i:int = 0; i < t; i++) {
								a.bi_internal::fromInt(lowprimes[i]);
								y = a.modPow(r,this);
								if(y.compareTo(BigInteger.ONE) != 0 && y.compareTo(n1) != 0) {
										j = 1;
										while(j++ < k && y.compareTo(n1) != 0) {
												y = y.modPowInt(2,this);
												if(y.compareTo(BigInteger.ONE) == 0) {
														return false;
												}
										}
										if(y.compareTo(n1) != 0) {
												return false;
										}
								}
						}
						return true;
				}
				
				public function primify(bits:int, t:int) : void {
						if(!this.testBit(bits - 1)) {
								this.bitwiseTo(BigInteger.ONE.shiftLeft(bits - 1),this.op_or,this);
						}
						if(this.bi_internal::isEven()) {
								this.bi_internal::dAddOffset(1,0);
						}
						while(!this.isProbablePrime(t)) {
								for(this.bi_internal::dAddOffset(2,0); this.bitLength() > bits; ) {
										this.bi_internal::subTo(BigInteger.ONE.shiftLeft(bits - 1),this);
								}
						}
				}
		}
}

