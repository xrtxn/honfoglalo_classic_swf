package com.hurlant.math {
		internal class BarrettReduction implements IReduction {
				private var m:BigInteger;
				
				private var r2:BigInteger;
				
				private var q3:BigInteger;
				
				private var mu:BigInteger;
				
				public function BarrettReduction(m:BigInteger) {
						super();
						this.r2 = new BigInteger();
						this.q3 = new BigInteger();
						BigInteger.ONE.bi_internal::dlShiftTo(2 * m.t,this.r2);
						this.mu = this.r2.divide(m);
						this.m = m;
				}
				
				public function revert(x:BigInteger) : BigInteger {
						return x;
				}
				
				public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger) : void {
						x.bi_internal::multiplyTo(y,r);
						this.reduce(r);
				}
				
				public function sqrTo(x:BigInteger, r:BigInteger) : void {
						x.bi_internal::squareTo(r);
						this.reduce(r);
				}
				
				public function convert(x:BigInteger) : BigInteger {
						var r:BigInteger = null;
						if(x.bi_internal::s < 0 || x.t > 2 * this.m.t) {
								return x.mod(this.m);
						}
						if(x.compareTo(this.m) < 0) {
								return x;
						}
						r = new BigInteger();
						x.bi_internal::copyTo(r);
						this.reduce(r);
						return r;
				}
				
				public function reduce(lx:BigInteger) : void {
						var x:BigInteger = lx as BigInteger;
						x.bi_internal::drShiftTo(this.m.t - 1,this.r2);
						if(x.t > this.m.t + 1) {
								x.t = this.m.t + 1;
								x.bi_internal::clamp();
						}
						this.mu.bi_internal::multiplyUpperTo(this.r2,this.m.t + 1,this.q3);
						this.m.bi_internal::multiplyLowerTo(this.q3,this.m.t + 1,this.r2);
						while(x.compareTo(this.r2) < 0) {
								x.bi_internal::dAddOffset(1,this.m.t + 1);
						}
						x.bi_internal::subTo(this.r2,x);
						while(x.compareTo(this.m) >= 0) {
								x.bi_internal::subTo(this.m,x);
						}
				}
		}
}

