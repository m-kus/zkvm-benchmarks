%builtins range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_secp.signature import get_point_from_x, get_generator_point, div_mod_n, validate_signature_entry
from starkware.cairo.common.cairo_secp.ec import ec_add, ec_mul, ec_negate
from starkware.cairo.common.cairo_secp.ec_point import EcPoint
from starkware.cairo.common.cairo_secp.bigint3 import BigInt3

func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;

    local r: BigInt3 = BigInt3(d0=3184803116103375961606309, d1=1066663865688983139737708, d2=2815961331496131113571805);
    local s: BigInt3 = BigInt3(d0=24589652323421121971338655, d1=53109479434080491875024168, d2=4055118278242668653549483);
    local msg_hash: BigInt3 = BigInt3(d0=47461525434588575839262756, d1=54000683244264190912327806, d2=3396061411302415104372355);
    local pk_x: BigInt3 = BigInt3(d0=22420127244832202239814464, d1=57607228578796163421897055, d2=10971707433206662582489590);
    local pk_v: felt = 1;

    validate_signature_entry(r);
    validate_signature_entry(s);

    let (generator_point: EcPoint) = get_generator_point();
    let (pk_point: EcPoint) = get_point_from_x(x=pk_x, v=pk_v);

    let (u1: BigInt3) = div_mod_n(msg_hash, s);
    let (u2: BigInt3) = div_mod_n(r, s);

    let (p1: EcPoint) = ec_mul(generator_point, u1);
    let (p2: EcPoint) = ec_mul(pk_point, u2);
    let (p3: EcPoint) = ec_add(p1, p2);

    let (p3_x: BigInt3) = div_mod_n(p3.x, BigInt3(d0=1, d1=0, d2=0));
    assert p3_x = r;

    return ();
}