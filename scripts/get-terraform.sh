#!/bin/sh

##
# get-terraform.sh - Download and/or display path to terraform binary
#
# DESCRIPTION:
#   This script will check the system for a terraform binary and display the full
#   path to it.  It can be called from other scripts to find the terraform binary
#   or download it if it is missing.  The terraform binary found will be validated
#   against a list of known SHA 256 checksums as well as its version.
#
# EXAMPLES:
#
#   1. Capture path to terraform binary and then run terraform plan.
#
#      BINARY=$(./get-terraform.sh)
#      $BINARY plan
#
#   2. Download specific version
#
#      ./get-terraform.sh 0.9.8
#
##
[ -n "$1" ] && TERRAFORM_VERSION=$1

# terraform version
MINIMUM_VER=${TERRAFORM_VERSION:-"0.11.11"}
DESIRED_VER=${TERRAFORM_VERSION:-"0.11.11"}

# HashiCorp GPG Key
# https://www.hashicorp.com/security/
HASHICORP_KEY_ID="348FFC4C"
{ HASHICORP_KEY=$(cat); } <<'EOF'
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQENBFMORM0BCADBRyKO1MhCirazOSVwcfTr1xUxjPvfxD3hjUwHtjsOy/bT6p9f
W2mRPfwnq2JB5As+paL3UGDsSRDnK9KAxQb0NNF4+eVhr/EJ18s3wwXXDMjpIifq
fIm2WyH3G+aRLTLPIpscUNKDyxFOUbsmgXAmJ46Re1fn8uKxKRHbfa39aeuEYWFA
3drdL1WoUngvED7f+RnKBK2G6ZEpO+LDovQk19xGjiMTtPJrjMjZJ3QXqPvx5wca
KSZLr4lMTuoTI/ZXyZy5bD4tShiZz6KcyX27cD70q2iRcEZ0poLKHyEIDAi3TM5k
SwbbWBFd5RNPOR0qzrb/0p9ksKK48IIfH2FvABEBAAG0K0hhc2hpQ29ycCBTZWN1
cml0eSA8c2VjdXJpdHlAaGFzaGljb3JwLmNvbT6JATgEEwECACIFAlMORM0CGwMG
CwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEFGFLYc0j/xMyWIIAIPhcVqiQ59n
Jc07gjUX0SWBJAxEG1lKxfzS4Xp+57h2xxTpdotGQ1fZwsihaIqow337YHQI3q0i
SqV534Ms+j/tU7X8sq11xFJIeEVG8PASRCwmryUwghFKPlHETQ8jJ+Y8+1asRydi
psP3B/5Mjhqv/uOK+Vy3zAyIpyDOMtIpOVfjSpCplVRdtSTFWBu9Em7j5I2HMn1w
sJZnJgXKpybpibGiiTtmnFLOwibmprSu04rsnP4ncdC2XRD4wIjoyA+4PKgX3sCO
klEzKryWYBmLkJOMDdo52LttP3279s7XrkLEE7ia0fXa2c12EQ0f0DQ1tGUvyVEW
WmJVccm5bq25AQ0EUw5EzQEIANaPUY04/g7AmYkOMjaCZ6iTp9hB5Rsj/4ee/ln9
wArzRO9+3eejLWh53FoN1rO+su7tiXJA5YAzVy6tuolrqjM8DBztPxdLBbEi4V+j
2tK0dATdBQBHEh3OJApO2UBtcjaZBT31zrG9K55D+CrcgIVEHAKY8Cb4kLBkb5wM
skn+DrASKU0BNIV1qRsxfiUdQHZfSqtp004nrql1lbFMLFEuiY8FZrkkQ9qduixo
mTT6f34/oiY+Jam3zCK7RDN/OjuWheIPGj/Qbx9JuNiwgX6yRj7OE1tjUx6d8g9y
0H1fmLJbb3WZZbuuGFnK6qrE3bGeY8+AWaJAZ37wpWh1p0cAEQEAAYkBHwQYAQIA
CQUCUw5EzQIbDAAKCRBRhS2HNI/8TJntCAClU7TOO/X053eKF1jqNW4A1qpxctVc
z8eTcY8Om5O4f6a/rfxfNFKn9Qyja/OG1xWNobETy7MiMXYjaa8uUx5iFy6kMVaP
0BXJ59NLZjMARGw6lVTYDTIvzqqqwLxgliSDfSnqUhubGwvykANPO+93BBx89MRG
unNoYGXtPlhNFrAsB1VR8+EyKLv2HQtGCPSFBhrjuzH3gxGibNDDdFQLxxuJWepJ
EK1UbTS4ms0NgZ2Uknqn1WRU1Ki7rE4sTy68iZtWpKQXZEJa0IGnuI2sSINGcXCJ
oEIgXTMyCILo34Fa/C6VCm2WBgz9zZO8/rHIiQm1J5zqz0DrDwKBUM9C
=LYpS
-----END PGP PUBLIC KEY BLOCK-----
EOF

# list of approved terraform binaries
{ APPROVED_SHASUMS=$(cat); } <<'EOF'
6f58ab6d53028608d0df664f6499da688d1ee3b23a11b127ecb0c3437d89a862  0.8.0/darwin_amd64/terraform
baad6e8585583e9ad4bbec04ee8e7dab6377edb97c297a3198b92fe0fba0c522  0.8.0/linux_amd64/terraform
2a187442f7306d515b2ae623c0b3f30a8850e8905a66bdd63ef003022f3ffe4e  0.8.1/darwin_amd64/terraform
a10da00a6ec8160dc092fd5eddcc4bd36b3d3866dcee11dd2554c33b3b582ded  0.8.1/linux_amd64/terraform
6364937383f8e02ab15a81874b1e8be78fdb4dc6ffe7f6ec140abf154ee2ca89  0.8.2/darwin_amd64/terraform
f5b582429a5fc5edaebce550816b802bdcc25f0000d87a418340d0f1abdd06d1  0.8.2/linux_amd64/terraform
f79b37cf8e5e188bf513191224b7dbb3e25afa40d90d7a77a86733969a26bbcd  0.8.3/darwin_amd64/terraform
13e7022f8b71d1f4c358bb0293a2d5c9e1604c784a956d1a750e6f19b757a841  0.8.3/linux_amd64/terraform
355e3baf32aad6ef9dc5b8a0f544686f29c4c04bc20a2aad45812d62de097c99  0.8.4/darwin_amd64/terraform
e1dd6699d46604dfbae490e73f12bc8c509994ce4a5a393c38320eef8a785482  0.8.4/linux_amd64/terraform
47a97878ce810772e58b527d112f12ad0952d08e6b482125992199de71dbc4f0  0.8.5/darwin_amd64/terraform
311cee90b7aa4986726064cd117d05158932827c9ece2b2ab09b2174c19c58d1  0.8.5/linux_amd64/terraform
ec065b900a91ee0de7f62fef19acd42f520ed95eec405a40bcb178ef95f5f1df  0.8.6/darwin_amd64/terraform
a5b654132d8512d3341f092b9f66c222315c4b3ca6dc217ed3ff2bdfa9f4a235  0.8.6/linux_amd64/terraform
a214fa0992e058852f0de781034b27a8949e7aa5e1f611650a694c1f0e733827  0.8.7/darwin_amd64/terraform
39cbceb70f30d6a6e17006643b2652c4d1b756f36a1362f5dbd14e7b5e04fc8a  0.8.7/linux_amd64/terraform
5fdd69314ce2bd6a84fba56748d1c09f1a369dec09382138be40bf79d1e5243c  0.8.8/darwin_amd64/terraform
74534b7c1eb3c3d6645727bfc75f578696f798827134be89744870636185b55f  0.8.8/linux_amd64/terraform
02327e74284164404a06373d796354494f5561d6cfaeb5aaf1d29c2a8deb62d1  0.9.0/darwin_amd64/terraform
1b3a880a9d66ff4058ea77786b02feb268ca2a214360584ac5a4869da7f68fa5  0.9.0/linux_amd64/terraform
06680a73034e91a27b2be8fdacc55d63018dd75cf77d68ca3f07486ca90a340f  0.9.1/darwin_amd64/terraform
086ccbde3ac42ef44999be9148ebb4e2383dffeb6ef4be68149c77c01ba1c4b8  0.9.1/linux_amd64/terraform
1ed8c793ffba11af024c69d8d3d88c4274973061fda882fa57db54dfad07726b  0.9.2/darwin_amd64/terraform
01a1786fc1c0cc57f37db7f25173ed93a97a39ca94a2cfea8bb854a43025ef00  0.9.2/linux_amd64/terraform
c794cb78d02eeaf47549b55116cffbfe3ca103a36c9d5de2ad935833d2798885  0.9.3/darwin_amd64/terraform
091aef799349e6486dbe7756d3e5f756ca0d409c92c68f4fee23c29ce72257b0  0.9.3/linux_amd64/terraform
022ce6b8adccdf8a9ab4fd2facac95f9c0d935c3ddec9e4d52a63c2beaf1a51f  0.9.4/darwin_amd64/terraform
75d80e89908e4036fbc558a98bfa03f822ce36026de78066b4fb7e3aa597af20  0.9.4/linux_amd64/terraform
9a27f6794f991e7aff2861bef11c5fe18870cb19724a9baec4f1771bed45d151  0.9.5/darwin_amd64/terraform
69f6eae1e8a0193b47eafc59c651195abd8f729d056b75d5d58135bdba940418  0.9.5/linux_amd64/terraform
0c3128738894c435eee8986675f59662fa9a7377ef281cb750bed8960ee8e2d4  0.9.6/darwin_amd64/terraform
7b48011b78c99f0d558fcfbab0d1ee176dbe99b9a464c64c40cda3197863a5d4  0.9.6/linux_amd64/terraform
12fa288a1eef62b6c17d27fffb0e869bd74f75ec7ef6678fe95c1227a2ed51ec  0.9.7/darwin_amd64/terraform
f49b4a50ecfbd1cf7e9ff17fc21d395aa32d9f624271e23dbb6db36ab6af031a  0.9.7/linux_amd64/terraform
9d7ab3752c9580205dfffea09fe642668395e9de939689219bcdb8a29345d33e  0.9.8/darwin_amd64/terraform
b71ac8a081b58dcc6c7a389efc4b42521724e4e023ee612362125fed5e1669f2  0.9.8/linux_amd64/terraform
dd19742295c94dd363f55c04abfd85623dcd12df99d10ce6ca6339b3677d0fab  0.9.9/darwin_amd64/terraform
f25c95a10925ff8d3705e62587f3858e0291ae97aa8c1454c29e15bb52934c9d  0.9.9/linux_amd64/terraform
c1083d764b08bcff23c052cd16db959bfa6ba8d21ea9a8ebf5ede6c2f31ba129  0.9.10/darwin_amd64/terraform
1dd6af32aab3249672d807e2ec8e4b0b98b35d7e3a173882fe616678043bc6d4  0.9.10/linux_amd64/terraform
8646329e27c0c83d38c8ddcc4ba6e5aa94b07b92e3a1021f1fc3c39b0e17d7c5  0.9.11/darwin_amd64/terraform
413f629fe0e53442d83eda75ef7726d8e4b6d1482b88a86d30ff44ec127cb6b9  0.9.11/linux_amd64/terraform
ca525a15c0c2b1f103a755fb9cd720cd72323e1e4386079e2080fdcb782cd93f  0.10.3/darwin_amd64/terraform
d3a50781e050a88774cd56200d4d6d41244da934f959261207083940a38d719f  0.10.3/linux_amd64/terraform
c836fbd8111210b9c2cc5c7c53460f447684a94fcc8a1abad77a7bbefc6e113b  0.10.4/darwin_amd64/terraform
989af6a28d269ede16ba080e0e6d18f301aebc98f8dd79b152b7a36a0181ab38  0.10.4/linux_amd64/terraform
acac366380fb37186606dee47bc543b1b0f7eb528e9791f81f9eb01a96fda57a  0.10.5/darwin_amd64/terraform
2a6eb328292342c16604d2b08bd65de37f261fe7d5ed966a45fb7375666b19fb  0.10.5/linux_amd64/terraform
2affab50cb10ea25cd492956238b9fecaec21c24fc102eab1fb02efb13606a7e  0.10.6/darwin_amd64/terraform
3cefd18cb470de9498dd1495b12980c6d4e18b9d6bd9c8440df60131a83eb8ab  0.10.6/linux_amd64/terraform
07120e04cb83fdb0f5bec157cf220975e2522ca98137d5cbe836bed392c75923  0.10.7/darwin_amd64/terraform
34ebcc8f20f0d30225f7299886c283d0ab4d12a2f12af90abd58ca41e0ad5990  0.10.7/linux_amd64/terraform
56dbfe7a9972b063abcb6c7be75f7625ddfab98b110f55a42d12df8d63f9f38b  0.10.8/darwin_amd64/terraform
4a60db750d50de106a035e8b77974a227c268e5d06274331bd4e91bcea898617  0.10.8/linux_amd64/terraform
070b6f06f19955d5b538c39b7e487cf34c23099eb528ce556e5cfb9d587cc9ea  0.11.0/darwin_amd64/terraform
8a3384d5fd74d5737bf3b8f0522fb1fc3ce7dd0cf2227dc6a542a76eebfd799b  0.11.0/linux_amd64/terraform
4b0c788a02f8d1cdcee700adb92f1db78bac07837cdf41bc3b2342294765d22e  0.11.1/darwin_amd64/terraform
8930666f7d286a650eb21270fee71ee0f4a7358d397d345768077e79929cf4c9  0.11.1/linux_amd64/terraform
026ef1ab5104c58cc37fe6e02a0643343a80ef7f04af7f311b36bf9de5cd5455  0.11.2/darwin_amd64/terraform
fc27de378be31138ca1b364be4b300a2cf1be3e6f4361b83af2952aaa870f03d  0.11.2/linux_amd64/terraform
ad45f2ca210b4c15b4522d6e8adde3968bdab0b72a2980e5d8ff38704a44fda6  0.11.3/darwin_amd64/terraform
45d460ab71bacf2f3e339be9e6d8ff6c5e6eb90da40b22d6c865b85b1c6ec372  0.11.3/linux_amd64/terraform
30489524bef53786c9ac9d3902d4cf122114025e9cf3fc41776e5e180c4fc6b9  0.11.4/darwin_amd64/terraform
f1b2439641d5d67f7659fe92ee283d6920b3f2b1f52ad4b479f73dcab6d8932c  0.11.4/linux_amd64/terraform
8b933f53dc35f4e23d0164e3a9b6d806cfccd4346f70bedd50ed3f162d0c528c  0.11.5/darwin_amd64/terraform
4a12b3c446db9d4ac3fa234b426a7c543cbe6052d6bb95871020424cbfb59d20  0.11.5/linux_amd64/terraform
ac1529854d6e3b26c8ff9a7a3bf2f46828d966be666c3c43160b9754196ecabd  0.11.6/darwin_amd64/terraform
ab9d8d3a5032026474f9704ad96ba5dbc4d453167e4278ed384b2bbfbe432144  0.11.6/linux_amd64/terraform
e8460143408184b383baba6226d4076887aa774e522b19c84f2d65070c1a1430  0.11.7/darwin_amd64/terraform
00cc2e727e662fb81c789b2b8371d82d6be203ddc76c49232ed9c17b4980949a  0.11.7/linux_amd64/terraform
8d1b2bf36693efe592d53def792248d64b4d1cd7706e94c97ecf553843ca9525  0.11.8/darwin_amd64/terraform
603fc5634c7581b9f70dac8734e2d3fa4c91303cd4b278d93ad9594676847145  0.11.8/linux_amd64/terraform
7b29ce0cfff74d38ff2ef4e4fcb16b5c235be0b2e8d667f162d7029a16460752  0.11.9/darwin_amd64/terraform
f92ce1322f475ba8654f8fe5753815364d5a65f16d3036e5be856bb4f37da2d1  0.11.9/linux_amd64/terraform
ce750dcd783b2390c247bd2637454f46bc9a9d2001eeffcb5bce282861fa922e  0.11.10/darwin_amd64/terraform
1a2862811f51effc9c782c47b1b08b9e6401b953b973dc6f734776df01df2618  0.11.10/linux_amd64/terraform
22c73323cb4481eea051c1cc08f7cad3757c91a47e6126ce6dcdae8d3cd7fafb  0.11.11/darwin_amd64/terraform
7114ae1002b612347525991f6a2525d266d18e2355fca6b12e7ef7c1382ad7d9  0.11.11/linux_amd64/terraform
EOF

die() {
  echo "$(basename $0): $*"
  exit 1
}

# version greater than or equal to
vergte() {
  [ "$1" == "`printf '%s\n' $1 $2 | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr | head -n1`" ]
}

realpath() {
  target=$1
  cwd="$(pwd)"
  cd $(dirname "$target") > /dev/null
  echo $(pwd)/$(basename "$target")
  cd "$cwd"
}

checksum() {
  # file to check
  binary=$1

  # checksum of binary file
  chksum=$($SHASUM_CMD $binary | awk '{ print $1 }')

  # search known checksums
  value=$(echo "$APPROVED_SHASUMS" | awk -v chksum=$chksum -v pat="/$ARCH/terraform$" '$2 ~ pat { if ($1 == chksum) print $2 }')

  # failed to find match
  [ -z "$value" ] && return 1

  # found match
  return 0
}

# os specific
case $(uname -s) in
  Darwin)
    ARCH="darwin_amd64"
    SHASUM_CMD="shasum -a 256"
  ;;
  *)
    ARCH="linux_amd64"
    SHASUM_CMD="sha256sum"
    CURL_OPTS="--tlsv1.2"
  ;;
esac

GET_BINARY=0

# do we have a terraform?
command -v terraform > /dev/null && BINARY=$(command -v terraform)
[ -x "./terraform" ] && BINARY="./terraform"

# check if terraform is missing
[ -z "$BINARY" ] && GET_BINARY=1

# check if this is really terraform
[ $GET_BINARY -eq 0 ] && checksum "$BINARY" || GET_BINARY=1

# check if this terraform meets the minimum version
[ $GET_BINARY -eq 0 ] && vergte $($BINARY --version | head -n 1 | sed -e 's/^Terraform[[:space:]]*v//') $MINIMUM_VER || GET_BINARY=1

# check if this terraform meets the maximum version
[ $GET_BINARY -eq 0 ] && vergte $DESIRED_VER $($BINARY --version | head -n 1 | sed -e 's/^Terraform[[:space:]]*v//') || GET_BINARY=1

# if we have it then show it and leave
[ $GET_BINARY -eq 0 ] && realpath $BINARY && exit 0

# import hashicorp public key
gpg --list-keys $HASHICORP_KEY_ID >/dev/null 2>&1 || echo "$HASHICORP_KEY" | gpg --import 2> /dev/null

# download binary and signature files
curl $CURL_OPTS -OSs https://releases.hashicorp.com/terraform/${DESIRED_VER}/terraform_${DESIRED_VER}_${ARCH}.zip
curl $CURL_OPTS -OSs https://releases.hashicorp.com/terraform/${DESIRED_VER}/terraform_${DESIRED_VER}_SHA256SUMS
curl $CURL_OPTS -OSs https://releases.hashicorp.com/terraform/${DESIRED_VER}/terraform_${DESIRED_VER}_SHA256SUMS.sig

# check for files
[ -e "terraform_${DESIRED_VER}_${ARCH}.zip" ]    || die "not found: terraform_${DESIRED_VER}_${ARCH}.zip"
[ -e "terraform_${DESIRED_VER}_SHA256SUMS"  ]    || die "not found: terraform_${DESIRED_VER}_SHA256SUMS"
[ -e "terraform_${DESIRED_VER}_SHA256SUMS.sig" ] || die "not found: terraform_${DESIRED_VER}_SHA256SUMS.sig"

# verify the signature file is untampered
gpg --verify terraform_${DESIRED_VER}_SHA256SUMS.sig terraform_${DESIRED_VER}_SHA256SUMS 2> /dev/null || die "gpg verify failed: terraform_${DESIRED_VER}_SHA256SUMS"

# grab just the line we want
egrep "\bterraform_${DESIRED_VER}_${ARCH}.zip$" terraform_${DESIRED_VER}_SHA256SUMS > terraform_${DESIRED_VER}_${ARCH}-checksum

# verify the shasum matches
$SHASUM_CMD -c terraform_${DESIRED_VER}_${ARCH}-checksum > /dev/null || die "checksum failed on terraform_${DESIRED_VER}_${ARCH}.zip"

# extract it
unzip -o -q terraform_${DESIRED_VER}_${ARCH}.zip

BINARY="./terraform"

# check it is there
[ -x $BINARY ] || die "not executable: $BINARY"

# check its shasum
checksum $BINARY || die "shasum not in approved list: $BINARY"

# show it
realpath $BINARY

# clean up
rm -f terraform_${DESIRED_VER}_SHA256SUMS terraform_${DESIRED_VER}_SHA256SUMS.sig terraform_${DESIRED_VER}_${ARCH}-checksum terraform_${DESIRED_VER}_${ARCH}.zip
