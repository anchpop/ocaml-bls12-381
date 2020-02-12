(** External definition, must use `Bytes.t` to represent the field elements *)
external ml_bls12_381_fr_is_zero : Bytes.t -> bool
  = "ml_librustc_bls12_381_fr_is_zero"
  [@@noalloc]

external ml_bls12_381_fr_is_one : Bytes.t -> bool
  = "ml_librustc_bls12_381_fr_is_one"
  [@@noalloc]

external ml_bls12_381_fr_zero : Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_zero"
  [@@noalloc]

external ml_bls12_381_fr_one : Bytes.t -> unit = "ml_librustc_bls12_381_fr_one"
  [@@noalloc]

external ml_bls12_381_fr_random : Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_random"
  [@@noalloc]

external ml_bls12_381_fr_add : Bytes.t -> Bytes.t -> Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_add"
  [@@noalloc]

external ml_bls12_381_fr_mul : Bytes.t -> Bytes.t -> Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_mul"
  [@@noalloc]

external ml_bls12_381_fr_unsafe_inverse : Bytes.t -> Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_unsafe_inverse"
  [@@noalloc]

external ml_bls12_381_fr_negate : Bytes.t -> Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_negate"
  [@@noalloc]

external ml_bls12_381_fr_square : Bytes.t -> Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_square"
  [@@noalloc]

external ml_bls12_381_fr_double : Bytes.t -> Bytes.t -> unit
  = "ml_librustc_bls12_381_fr_double"
  [@@noalloc]

external ml_bls12_381_fr_eq : Bytes.t -> Bytes.t -> bool
  = "ml_librustc_bls12_381_fr_eq"
  [@@noalloc]

(** High level (OCaml) definitions/logic *)
let fr_size_bytes = 32

type t = Bytes.t

let to_t (g : Bytes.t) : t = g

let to_bytes g = g

let is_zero g =
  assert (Bytes.length g = fr_size_bytes) ;
  ml_bls12_381_fr_is_zero g

let is_one g =
  assert (Bytes.length g = fr_size_bytes) ;
  ml_bls12_381_fr_is_one g

let zero () =
  let g = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_zero g ;
  to_t g

let one () =
  let g = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_one g ;
  to_t g

let random () =
  let g = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_random g ;
  to_t g

let add x y =
  assert (Bytes.length x = fr_size_bytes) ;
  assert (Bytes.length y = fr_size_bytes) ;
  let g = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_add g x y ;
  to_t g

let mul x y =
  assert (Bytes.length x = fr_size_bytes) ;
  assert (Bytes.length y = fr_size_bytes) ;
  let g = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_mul g x y ;
  to_t g

let inverse g =
  assert (Bytes.length g = fr_size_bytes) ;
  let buffer = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_unsafe_inverse buffer g ;
  to_t buffer

let inverse_opt g =
  assert (Bytes.length g = fr_size_bytes) ;
  if is_zero g then None
  else
    let buffer = Bytes.create fr_size_bytes in
    ml_bls12_381_fr_unsafe_inverse buffer g ;
    Some (to_t buffer)

let negate g =
  assert (Bytes.length g = fr_size_bytes) ;
  let buffer = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_negate buffer g ;
  to_t buffer

let square g =
  assert (Bytes.length g = fr_size_bytes) ;
  let buffer = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_square buffer g ;
  to_t buffer

let double g =
  assert (Bytes.length g = fr_size_bytes) ;
  let buffer = Bytes.create fr_size_bytes in
  ml_bls12_381_fr_double buffer g ;
  to_t buffer

let eq x y =
  (* IMPORTANT: DO NOT USE THE BYTES representation because we use 384 bits
     instead of 381 bits. We trust the binding offered by the library *)
  ml_bls12_381_fr_eq x y

let to_string a = Z.to_string (Z.of_bits (Bytes.to_string a))

let to_z a = Z.of_bits (Bytes.to_string a)

let pow g n =
  let rec inner_pow n acc =
    if Z.equal n Z.zero then acc else inner_pow (Z.pred n) (mul acc g)
  in
  inner_pow n (one ())

(* let of_string s =
 *   let a = Bytes.create fr_size_bytes in
 *   let repr_bytes_z = Z.of_string s in
 *   Bytes.
 *   to_t a *)
