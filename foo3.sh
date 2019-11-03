#!/bin/bash
​
export PRINT_KEYS=0
IFS=$'\n'
​
lookup() { perl ~/lookup/getValues.perl "/da0_data/basemaps/${1}FullP" | tr \; \\n; }
a2c() { ~/lookup/getValues a2c | tr \; \\n; }
c2ta() { lookup c2ta; }
c2f() { lookup c2f; }
c2p() { lookup c2p; }
p2c() { lookup p2c; }
f2c() { lookup f2c; }
a2p() { lookup a2p; }
c2t() { c2ta | sed -n '1~2p'; }
c2a() { c2ta | sed -n '2~2p'; }
p2a() { lookup p2a; }
​
if (( $# )); then
"$@"
exit
fi
		​
apapap=()
		​
		ppp=( 'pandas-dev_pandas' )
		for p in "${ppp[@]}"; do
		aaa=( $(p2a <<<"$p") )
		for a in "${aaa[@]}"; do
		apapap+=( "$a;$p" )
		done
		done
		​
# apapap=( 'Tanner Hobson <thobson125@gmail.com>'\;'player1537_relativity.scad' )
		while (( ${#apapap[@]} )); do
		ap=${apapap[0]}
		apapap=( "${apapap[@]:1}" )
		​
		a=${ap%;*}
		p=${ap#*;}
		​
# printf $'a=%q\n' "$a"
# printf $'p=%q\n' "$p"
		​
# The Author's Commits
		accc_=( $(a2c <<<"$a") )
		unset accc
		declare -A accc
		for ac in "${accc_[@]}"; do
# printf $'  ac=%q\n' "$ac"
		accc[$ac]=1
		done
		​
		pccc_=( $(p2c <<<"$p") )
		unset pccc
		declare -A pccc
		for pc in "${pccc_[@]}"; do
		pccc[$pc]=1
		done
		​
		unset acpc
		declare -A acpc
		for ac in "${!accc[@]}"; do
# printf $'  %s: %d %d\n' "${ac:1:8}" "${accc[$ac]}" "${pccc[$ac]}"
		if (( ! pccc[$ac] )); then continue; fi
		acpc[$ac]=1
		​
# ~/lookup/showCnt commit <<<"$ac"
		done
		​
		ttt=( $(c2t <<<"${!acpc[*]}") )
# printf $'  ttt ='
# printf $'\n    %q' "${ttt[@]}"
# printf $'\n'
		​
		printf $'%s;%s' "$a" "$p"
		printf $';%s' "${ttt[@]}"
		printf $'\n'
		​
# printf $'\n\n\n'

# aaa+=( abc )
		done
